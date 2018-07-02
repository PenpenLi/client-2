local utils = require("utils")
local SoundUtils = require("app.common.SoundUtils")
local GameConfig = require("app.common.GameConfig")
local CMD = require("app.net.CMD")
local UIHelper = require("app.common.UIHelper")
local ViewPlayer = require("app.views.texaspoker.ViewPlayer")
local TexasPokerConfig = require("app.models.TexasPokerConfig")

local ControllerBase = require("app.controllers.ControllerBase")

local TexasPokerController = class("TexasPokerController", ControllerBase)
local turnRecorder = class("turnRecorder")

function turnRecorder:ctor()
	self.uid = "";
	self.bet = 0;
	self.win = 0;
	self.nickName = ""
	self.headIco = ""
end

function TexasPokerController:ctor()
    TexasPokerController.super.ctor(self)

	cc.SpriteFrameCache:getInstance():addSpriteFrames("effect/youwin_sp.plist");
	cc.SpriteFrameCache:getInstance():addSpriteFrames("effect/allin_sp.plist")
	
    self:enableNodeEvents()
    self.playerViews = {}
	self.lastScore = {}
	self.allScore = {}

    -- 动画层
    self:addChild(APP:createView("texaspoker.ViewActions"), GameConfig.Z_GameTop)

    self.viewRoom = APP:createView("texaspoker.ViewRoom")
    self:addChild(self.viewRoom)

    local room = APP.GD.game_room

    self.viewRoom:updateBasePool(room.base_pool)
    self.viewRoom:updateBlindBet(room.bet_set)

    -- 恢复主池
    local main_pool, main_id = room:getMainPool()
    if main_pool and main_pool > 0 then
        self.viewRoom:setMainPoolStatus(true, main_pool)
    end

    -- 恢复边池
    for id, sidePool in pairs(room.pools) do
        if id ~= main_id then
            self.viewRoom:addSidePool(id,sidePool)
        end
    end

    -- 玩家
    local players = APP.GD:getRoomPlayers()
    for _, player in pairs(players.players) do
        self:addViewPlayer(player, true)
    end

    -- 恢复公共牌
    if room.cards and room.cards ~= "" then
        local cards_str = string.split(room.cards, ",")
        local cards = {}
        for i = 1, #cards_str do
            table.insert(cards, tonumber(cards_str[i]))
        end
        self.viewRoom:dealPublicCard(cards, false)
    end
    
    -- 恢复自己的手牌
    local gameUser =APP.GD.GameUser
    local mePlayer = players:getPlayerByUid(gameUser.uid)
    if mePlayer then
        if mePlayer.cards and mePlayer.cards ~= "" then
            local cards_str = string.split(mePlayer.cards, ",")
            local cards = {}
            for i = 1, #cards_str do
                table.insert(cards, tonumber(cards_str[i]))
            end
            self.viewRoom:dealCardToMe(cards, false)
        end
        -- 恢复自己的操作按钮
        if mePlayer.valid_op and mePlayer.valid_op ~= "" then
            self.viewRoom:showOperateButtons(mePlayer.valid_op)
        end
    end
	self:enterChannel();
end

function TexasPokerController:onEnter()
	print("TexasPokerController:onEnter")
	TexasPokerController.super.onEnter(self)
end

function TexasPokerController:onExit()
	self:leaveChannel();
	TexasPokerController.super.onExit(self)
end

function TexasPokerController:getPlayer(uid)
    local players = APP.GD.room_players
    return players:getPlayerByUid(uid)
end

function TexasPokerController:getMe()
    local gameUser =APP.GD.GameUser
    return self:getPlayer(gameUser.uid);
end

function TexasPokerController:showAddBetLayer(mul)
    local room = APP.GD.game_room;
    local mePlayer = self:getMe();
    if mePlayer then
        self:addChild(APP:createView("texaspoker.ViewAddBet", mul * room.max_bet, mePlayer.credits))
    end
end

function TexasPokerController:showMenuLayer()
    self:addChild(APP:createView("texaspoker.ViewMenu"), GameConfig.Z_GamePop)
end

function TexasPokerController:showCardTypeLayer()
    self:addChild(APP:createView("texaspoker.ViewCardType"), GameConfig.Z_GamePop)
end

function TexasPokerController:showGameSettingLayer()
    self:addChild(APP:createView("home.ViewSetting"), GameConfig.Z_GamePop)
end

function TexasPokerController:showPlayerInfoLayer(uid)
    self:addChild(APP:createView("texaspoker.ViewPlayerInfo", uid), GameConfig.Z_GamePop)
end

function TexasPokerController:showMissionLayer()
    self:addChild(APP:createView("texaspoker.ViewGameMission"), GameConfig.Z_GamePop)
end

function TexasPokerController:showLastGameLayer()
    self:addChild(APP:createView("texaspoker.viewGameRecord"), GameConfig.Z_GamePop)
end

function TexasPokerController:showMakeupBetLayer()
    self:addChild(APP:createView("texaspoker.ViewMakeupBet"), GameConfig.Z_GamePop)
end

function TexasPokerController:showChatLayer()
    local chatLayer = self:getChildByName("texaspoker.ViewChat")
    if chatLayer == nil then 
        chatLayer = APP:createView("texaspoker.ViewChat")
        chatLayer:setName("texaspoker.ViewChat")
        self:addChild(chatLayer, GameConfig.Z_GamePop)
    else
        chatLayer:actionEnter()
        chatLayer:setVisible(true)
    end
end

function TexasPokerController:getPlayerPostion(uid)
	local pv = self.viewRoom:getPlayerView(uid)
	if pv then
		pv = pv:getParent()
		return cc.p(pv:getPositionX(), pv:getPositionY());
	end
end

function TexasPokerController:addViewPlayer(player, init)
    local vw = self.viewRoom:playerSit(player, init)
	if not vw then
		printLog("a", "addViewPlayer with vw = nil, uid = %s", player.uid);
	else
		self.playerViews[player.uid] =  vw;
	end
end

----------------------------------游戏相关---------------------------------------------------------
function TexasPokerController:changeStatus()
    print("TexasPokerController:changeStatus")
    local room = APP.GD.game_room
    local players = APP.GD.room_players

    if room.status == TexasPokerConfig.STATUS_DEAL_ROUND_1 or
        room.status == TexasPokerConfig.STATUS_DEAL_ROUND_2 or 
        room.status == TexasPokerConfig.STATUS_DEAL_ROUND_3 or 
        room.status == TexasPokerConfig.STATUS_DEAL_ROUND_4 then

        for _, playerView in pairs(self.playerViews) do
            playerView:setOperateViewStatus(false)
        end

        room:updateMaxBet(0)
    end

    if room.status == TexasPokerConfig.STATUS_DEAL_ROUND_2 or 
        room.status == TexasPokerConfig.STATUS_DEAL_ROUND_3 or 
        room.status == TexasPokerConfig.STATUS_DEAL_ROUND_4 then
        SOCKET_MANAGER.pauseGameServer(1.0)
    end

    if room.status == TexasPokerConfig.SATUS_WAITE_START then
        self:newTurnStart()
	elseif room.status == TexasPokerConfig.STATUS_VOTE_BANKER then
		SoundUtils.playEffect(SoundUtils.GameSound.NEWTURN);
    end
end

function TexasPokerController:newTurnStart()
	local room = APP.GD.game_room
    local players = APP.GD.room_players
	
	room:clear()
    -- 清除数据
    for _, player in pairs(players.players) do
        player:clear()
    end
    for _, playerView in pairs(self.playerViews) do
        playerView:clear()
    end
    self.viewRoom:clear()
	self.allScore = self.lastScore;
	self.lastScore = {}
end

--玩家被选定为庄家
function TexasPokerController:promoteBanker( content )
    print("TexasPokerController:promoteBanker")
    local playerView = self.playerViews[content.uid_]
	--由于服务器庄家是不清的，所以这里要自己清掉
	for _, playerView in pairs(self.playerViews) do
		 playerView:setBankerStatus(false)
	end
    playerView:setBankerStatus(true)
end

--要求玩家采取操作
function TexasPokerController:pleaseTakeop( content )
    print("要求玩家采取操作TexasPokerController:pleaseTakeop")

    local players = APP.GD.room_players
    local player = players:getPlayerByUid(content.uid_)
    local playerView = self.playerViews[content.uid_]

    if player and playerView then
        player.valid_op = content.valid_op_
        player.opkey = content.opkey_
        player.time_left = tonumber(content.time_left_)

        playerView:setTimerStatus(true, tonumber(content.time_left_))
        playerView:setOperateViewStatus(false)
    end

    local gameUser = APP.GD.GameUser
    if content.uid_ == gameUser.uid then
        self.viewRoom:showOperateButtons(content.valid_op_)
    end
end

-- 玩家底牌，游戏结束时，也会收到。
-- 游戏结束时，先保存数据，在结算时，显示牌。
function TexasPokerController:playerCards( content )
    print("TexasPokerController:playerCards")

    local players = APP.GD.room_players
    local player = players:getPlayerByUid(content.uid_)
    local playerView = self.playerViews[content.uid_]
	
	if not self.lastScore[content.uid_] then
		local sc = turnRecorder.new();
		sc.uid = content.uid_;
		sc.nickName = player.uname;
		sc.headIco = player.head_pic;
		self.lastScore[content.uid_] = sc;
	end
	
	if player and playerView then
        local room = APP.GD:getGameRoom()
        if room.status ~= TexasPokerConfig.STATUS_BALANCE then
            playerView:setDealedCardStatus(true, true)
        end
        local gameUser =APP.GD.GameUser
        if not player.isbalance and content.uid_ == gameUser.uid then
            local cards_str = string.split(content.cards_, ",")
            local cards = {}
            for i = 1, #cards_str do
                table.insert(cards, tonumber(cards_str[i]))
            end
            self.viewRoom:dealCardToMe(cards, true)
        end
    end
end

--公共牌
function TexasPokerController:publicCards( content )
    print("TexasPokerController:publicCards")
    local cards_str = string.split(content.cards_, ",")
    local cards = {}
    for i = 1, #cards_str do
        table.insert(cards, tonumber(cards_str[i]))
    end
    self.viewRoom:dealPublicCard(cards, true)
end

--广播玩家采取了什么操作
function TexasPokerController:playerOption( content )
    print("TexasPokerController:playerOption")

    local players = APP.GD.room_players
    local player = players:getPlayerByUid(content.uid_)
    local playerView = self.playerViews[content.uid_]

    if player and playerView then
        playerView:setTimerStatus(false, 0)
        if tonumber(content.action_) ~= TexasPokerConfig.ACTION_NONE then
            playerView:setOperateViewStatus(true, tonumber(content.action_))
        end
        if tonumber(content.action_) >= TexasPokerConfig.ACTION_FOLLOW then
            playerView:setBet(true, tonumber(content.setbet_), true)
			local sc = self.lastScore[content.uid_]
			if sc then
				sc.bet = sc.bet + tonumber(content.setbet_);
			end
        elseif tonumber(content.action_) == TexasPokerConfig.ACTION_GIVEUP then
            playerView:setDealedCardStatus(false, true)
        end
    end

    local gameUser =APP.GD.GameUser
    if content.uid_ == gameUser.uid then
        self.viewRoom:hideOperateButtons()
        if APP:isObjectExists("ViewAddBet") then
            APP:getObject("ViewAddBet"):removeSelf()
        end
    end
	local gender = 0;
    if tonumber(content.action_) == TexasPokerConfig.ACTION_GIVEWAY then
        SoundUtils.playSound(gender, SoundUtils.GameSound.PASS)
    elseif tonumber(content.action_) == TexasPokerConfig.ACTION_GIVEUP then
        SoundUtils.playSound(gender, SoundUtils.GameSound.DISCARD)
    elseif tonumber(content.action_) == TexasPokerConfig.ACTION_FOLLOW then
        SoundUtils.playSound(gender, SoundUtils.GameSound.Follow)
    elseif tonumber(content.action_) == TexasPokerConfig.ACTION_ADD then
        SoundUtils.playSound(gender, SoundUtils.GameSound.PLUSCHIP)
    elseif tonumber(content.action_) == TexasPokerConfig.ACTION_ALLIN then
        SoundUtils.playSound(gender, SoundUtils.GameSound.ALLIN)
    elseif tonumber(content.action_) == TexasPokerConfig.ACTION_BETIN then
        SoundUtils.playSound(gender, SoundUtils.GameSound.PLUSCHIP)
    end

	if	tonumber(content.action_) == TexasPokerConfig.ACTION_FOLLOW or 
		tonumber(content.action_) == TexasPokerConfig.ACTION_ADD or
		tonumber(content.action_) == TexasPokerConfig.ACTION_ALLIN or
		tonumber(content.action_) == TexasPokerConfig.ACTION_BETIN then
		self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),
		 cc.CallFunc:create(function() SoundUtils.playEffect(SoundUtils.GameSound.BET) end)))

	elseif tonumber(content.action_) == TexasPokerConfig.ACTION_SMALLBET or
		tonumber(content.action_) == TexasPokerConfig.ACTION_BIGBET then
		SoundUtils.playEffect(SoundUtils.GameSound.BET)

	elseif tonumber(content.action_) == TexasPokerConfig.ACTION_GIVEWAY then
		self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),
		 cc.CallFunc:create(function() SoundUtils.playEffect(SoundUtils.GameSound.PASSEFF) end)))

	elseif tonumber(content.action_) == TexasPokerConfig.ACTION_GIVEUP then
		self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),
		 cc.CallFunc:create(function() SoundUtils.playEffect(SoundUtils.GameSound.FOLDEFF) end)))
	end
end

--最佳牌型
function TexasPokerController:bestPlan(uid, content)
    print("TexasPokerController:bestPlan")

    local gameUser =APP.GD.GameUser
    local players = APP.GD.room_players;
    local player = players:getPlayerByUid(uid)

    local playerView = self.playerViews[uid]
	
    if (not tobool(content.isbalance_)) and gameUser.uid == uid then
        self.viewRoom.img_CardType:loadTexture(string.format("cocostudio/game/image/card_type_%s.png", content.csf_val_))
		self.viewRoom.img_CardType:setVisible(true)
    end
end

-- 底池变化
-- 这里id为1和2时要注意
function TexasPokerController:poolChange(pool_id)
    print("TexasPokerController:poolChange")

    local room = APP.GD.game_room
    if pool_id == 0 then
        self.viewRoom:updateBasePool(room.base_pool)
    elseif pool_id == 1 then
        if room.pools[2] == nil then
            local pool_value = room.pools[1]
            -- 动画
            for _, playerView in pairs(self.playerViews) do
                if playerView and playerView:isBeted() then
                    playerView:setBet(false,0)
                    playerView:hideBetAction(function()
                        self.viewRoom:setMainPoolStatus(true, pool_value)
                    end)
                end
            end
        else
        end
    elseif pool_id == 2 then
        -- id为2的变为主池，id为1的变成边池？？？
        local main_pool_value = room.pools[2]
        if main_pool_value > 0 then
            -- 动画
            for _, playerView in pairs(self.playerViews) do
                if playerView and playerView:isBeted() then
                    playerView:setBet(false,0)
                    playerView:hideBetAction(function()
                        self.viewRoom:setMainPoolStatus(true, main_pool_value)
                        local side_pool_value = room.pools[1]
                        if side_pool_value and side_pool_value > 0 then
                            self.viewRoom:addSidePool(1, side_pool_value, true)
                        end
                    end)
                end
            end
        end
    else
        if room.pools[pool_id] > 0 then
            scheduler.performWithDelayGlobal(function ()
                self.viewRoom:addSidePool(pool_id, room.pools[pool_id], true)
            end,0.5)
        end
    end

end

--比赛结果
function TexasPokerController:matchResult(content)
    print("TexasPokerController:matchResult")
    local players = APP.GD.room_players
    local room = APP.GD.game_room
    local gameUser =APP.GD.GameUser

    if tonumber(content.wins_) > 0 then
        SOCKET_MANAGER.pauseGameServer(3.5)

        local player = players:getPlayerByUid(content.uid_)
        local mePlayer = players:getPlayerByUid(gameUser.uid)

        local playerView = self.playerViews[content.uid_]
        playerView:setCardTypeStatus(true, player.csf_val)
        if content.uid_ ~= gameUser.uid then
            playerView:showCardsToOther()
        else
            self.viewRoom:setMyCardGray()
        end
        self.viewRoom:clearPublicCardColor()
        self.viewRoom:setPublicCardColorGray(content.uid_)
		
		self.lastScore[content.uid_].win = self.lastScore[content.uid_].win + tonumber(content.wins_);

		local gender = 0;
        local typeValue = player.csf_val
        if typeValue == 1 then
            SoundUtils.playSound(gender, SoundUtils.GameSound.STRAIGHTFLUSH)
        elseif typeValue == 2 then
            SoundUtils.playSound(gender, SoundUtils.GameSound.FOURA)
        elseif typeValue == 3 then
            SoundUtils.playSound(gender, SoundUtils.GameSound.LAGENARIA)
        elseif typeValue == 4 then
            SoundUtils.playSound(gender, SoundUtils.GameSound.FLUSH)
        elseif typeValue == 5 then
            SoundUtils.playSound(gender, SoundUtils.GameSound.STRAIGHT)
        elseif typeValue == 6 then
            SoundUtils.playSound(gender, SoundUtils.GameSound.THREEA)
        elseif typeValue == 7 then
            SoundUtils.playSound(gender, SoundUtils.GameSound.TWOPAIRS)
        elseif typeValue == 8 then
            SoundUtils.playSound(gender, SoundUtils.GameSound.PAIR)
        elseif typeValue == 9 then
            SoundUtils.playSound(gender, SoundUtils.GameSound.SCATTER)
        end

        dump(room.take_pools, "=================room.take_pools===========")
        -- 飞筹码到玩家
        self.sch1 = scheduler.performWithDelayGlobal(function ()
            local main_pool, main_id = room:getMainPool()
            local tpool = room.take_pools[content.uid_]
			if not tpool then return end;
            for _, p in pairs(tpool) do
                -- 主池飞筹码
                if p.id == main_id then
                    self.viewRoom:setMainPoolStatus(true, room.pools[main_id])
                    APP:getObject("ViewActions"):actionMainPoolToPlayer(content.uid_, function()
                        -- dump(room.pools)
                        -- printInfo("main id:%d, main pool :%d, wins:%d", main_id, main_pool, tonumber(content.wins_))
                        room.pools[main_id] = main_pool - p.count
                        -- printInfo("------------gam end-------main pool----:%d", room.pools[main_id])
                        if room.pools[main_id] <= 0 then
                            self.viewRoom:setMainPoolStatus(false)
                        else
                            self.viewRoom:setMainPoolStatus(true, room.pools[main_id])
                        end

                    end)
                else    -- 边池飞筹码
                    APP:getObject("ViewActions"):actionSidePoolToPlayer(p.id, content.uid_, function()
                        -- dump(room.pools)
                        -- printInfo("main id:%d, main pool :%d, wins:%d", main_id, main_pool, tonumber(content.wins_))
                        room.pools[p.id] = room.pools[p.id] - p.count
                        -- printInfo("------------gam end-------main pool----:%d", room.pools[main_id])
                        if room.pools[p.id] <= 0 then
                            self.viewRoom:setSidePoolStatus(p.id, false)
                        else
                            self.viewRoom:setSidePoolStatus(p.id, true, room.pools[p.id])
                        end
                    end)
                end
            end

            self.sch1 = nil;
        end, 1.0)

       self.sch2 = scheduler.performWithDelayGlobal(function ()
            SoundUtils.playSound(0, SoundUtils.GameSound.WIN)
			            
            local pos = self:getPlayerPostion(content.uid_)
			if not pos then return end;

			local str = utils.convertNumberShort(tonumber(content.wins_))
			local winText = ccui.TextBMFont:create()
            winText:setFntFile("cocostudio/game/image/zhujiemian_niyingshuzi-export.fnt")
			winText:setString("+"..str);
            winText:addTo(self, GameConfig.Z_UI)
            winText:move(pos)

			local a2 = cc.Sequence:create(cc.ScaleTo:create(0.15, 3.0), cc.ScaleTo:create(0.15, 1.0))
			local a3 = cc.Spawn:create(cc.MoveTo:create(0.5, cc.p(pos.x, pos.y + 150)), cc.FadeOut:create(0.5))
            winText:runAction(
                cc.Sequence:create(
                    a2,
                    cc.DelayTime:create(1),
					a3,
                    cc.RemoveSelf:create()
                ))

			if content.uid_ == gameUser.uid then
				local a1 = UIHelper.seekNodeByName(self.viewRoom, "youWin");
				UIHelper.newAnimation(18, a1, function(i) return string.format("QY_Win_01_%05d.png", i) end, nil, true);
            end
			self.sch2 = nil;
        end, 1.5)

    end
    
end

-- 更新金币
function TexasPokerController:updatePlayerGold(uid, gold)
    if self.playerViews[uid] then
        self.playerViews[uid]:updateGold(gold)
    end
end

----------------------------------玩家相关---------------------------------------------------------

--玩家坐到位置
function TexasPokerController:playerSeat( uid )
	local player = APP.GD.room_players:getPlayerByUid(uid);
    self:addViewPlayer(player)
end

--玩家离开房间
function TexasPokerController:playerLeave( delPlayer )
	if not delPlayer then
		self.viewRoom:leaveSeat(-1);
	else
		local player = self.playerViews[delPlayer.uid]
		self.viewRoom:leaveSeat(delPlayer.pos);
		self.playerViews[delPlayer.uid] = nil;
	end
end

--站起来
function TexasPokerController:standUp()
	local data = {}
	SOCKET_MANAGER.sendToGameServer(CMD.GAME_PLAYER_STANDUP, data)
end

function TexasPokerController:sitDown(clipos)
	self.viewRoom:sitDown(clipos);
end

function TexasPokerController:enterChannel()
	self.CHNSN = math.random(1, 9999999);
	self.CHNID = bit.blshift(GameConfig.GameID, 24);
	self.CHNID = bit.bor(self.CHNID, APP.GD:getRoomId())
	local data = {
		sn_ = self.CHNSN,
		channel_ = self.CHNID;
	}
	SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_JOIN_CHANNEL, data)
end

function TexasPokerController:leaveChannel()
	local data = {
		sn_ = self.CHNSN,
		channel_ = self.CHNID
	}
	SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_LEAVE_CHANNEL, data)
end

function TexasPokerController:chat(content)
	local data = {
		channel_ = self.CHNID,
		to_ = "",
		content_ = content
	}
	SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_CHAT, data)
end

function TexasPokerController:onEnter()
	TexasPokerController.super.onEnter(self)
end

function TexasPokerController:onExit()
	TexasPokerController.super.onExit(self)
	if self.sch1 then 
		scheduler.unscheduleGlobal(self.sch1)
	end

	if self.sch2 then 
		scheduler.unscheduleGlobal(self.sch2)
	end
end
return TexasPokerController