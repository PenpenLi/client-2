local utils = require("utils")
local UIHelper = require("app.common.UIHelper")
local SoundUtils = require("app.common.SoundUtils")
local CMD = require("app.net.CMD")
local ViewCard = require("app.views.texaspoker.ViewCard")
local TexasPokerConfig = require("app.models.TexasPokerConfig")
local ResItemWidget = require("app.views.common.ResItemWidget")

local ViewRoom = class("ViewRoom", cc.mvc.ViewBase)

ViewRoom.SIDE_POOL_TAG = 1000
ViewRoom.MAIN_POOL_POS = cc.p(375,875)

local maxset = 6

function ViewRoom:ctor(isPrivate)
	ViewRoom.super.ctor(self)
	self.myCards = {}
	self.publicCards = {}
	self.sidePools = {}

	self.csbnode = cc.CSLoader:createNode("cocostudio/game/GameViewLayer.csb")
	self.csbnode:addTo(self)
	
	self.mypos = 0;--相对起始位置,默认为从0开始

	self.text_BasePool = UIHelper.seekNodeByName(self.csbnode, "Text_Pool")

    self.mainPool =  self:createSidePoolItem("cocostudio/game/image/bet_main.png")
                          :addTo(self)
                          :hide()
    self.mainPool:setPosition(ViewRoom.MAIN_POOL_POS)

--	self.text_MainPoolBG = UIHelper.seekNodeByName(self.csbnode, "Image_Pool_1")
--	self.text_MainPool = UIHelper.seekNodeByName(self.csbnode, "AtlasLabel_Pool_1")

	self.text_BlindBet = UIHelper.seekNodeByName(self.csbnode, "Text_BlindBet")

	self.btn_Giveup = UIHelper.seekNodeByName(self.csbnode, "Button_Giveup")

	self.btn_Giveway = UIHelper.seekNodeByName(self.csbnode, "Button_Giveway")
	self.btn_Follow = UIHelper.seekNodeByName(self.csbnode, "Button_Follow")
	self.btn_AllIn_Right = UIHelper.seekNodeByName(self.csbnode, "Button_AllIn_Right")

	self.btn_BetIn = UIHelper.seekNodeByName(self.csbnode, "Button_BetIn")
	self.btn_AddBet = UIHelper.seekNodeByName(self.csbnode, "Button_AddBet")
	self.btn_AllIn_Top = UIHelper.seekNodeByName(self.csbnode, "Button_AllIn_Top")

	self.btn_Giveup:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			self:onOperateButtonClicked(TexasPokerConfig.ACTION_GIVEUP, 0)
		end
	end)

	self.btn_Giveway:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			self:onOperateButtonClicked(TexasPokerConfig.ACTION_GIVEWAY, 0)
		end
	end)

	self.btn_Follow:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			local room = APP.GD.game_room
			self:onOperateButtonClicked(nil, room.max_bet)
		end
	end)

	self.btn_AllIn_Right:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
		    local player = APP.gc:getMe();
            if player then
			    self:onOperateButtonClicked(nil, player.credits)
            end
		end
	end)

	self.btn_BetIn:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP:getCurrentController():showAddBetLayer(1)
		end
	end)

	self.btn_AddBet:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP:getCurrentController():showAddBetLayer(2)
		end
	end)

	self.btn_AllIn_Top:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			local player = APP.gc:getMe();
            if player then
		    	self:onOperateButtonClicked(nil, player.credits)
            end
		end
	end)

	self.btn_Bet_3_1 = UIHelper.seekNodeByName(self.csbnode, "Button_Bet_3_1")
	self.btn_Bet_2_1 = UIHelper.seekNodeByName(self.csbnode, "Button_Bet_2_1")
	self.btn_Bet_3_2 = UIHelper.seekNodeByName(self.csbnode, "Button_Bet_3_2")
	self.btn_Bet_1 = UIHelper.seekNodeByName(self.csbnode, "Button_Bet_1")
	local room = APP.GD.game_room;
	self.btn_Bet_3_1:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			self:onOperateButtonClicked(nil, math.floor(room.base_pool / 3))
		end
	end)

	self.btn_Bet_2_1:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			self:onOperateButtonClicked(nil, math.floor(room.base_pool / 2))
		end
	end)

	self.btn_Bet_3_2:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			self:onOperateButtonClicked(nil, math.floor(room.base_pool / 3 * 2))
		end
	end)

	self.btn_Bet_1:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			self:onOperateButtonClicked(nil, room.base_pool)
		end
	end)


	local uiop = UIHelper.seekNodeByName(self.csbnode, "TakeOperation")
	-- 牌型
	self.img_CardType = UIHelper.seekNodeByName(uiop, "Image_CardType")
	
	self:hideOperateButtons()
	-- menu
	self.btn_Menu = UIHelper.seekNodeByName(self.csbnode, "Button_Menu")
	self.btn_Menu:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP:getCurrentController():showMenuLayer()
		end
	end)

	self.btn_Mession = UIHelper.seekNodeByName(self.csbnode, "Button_Mission")
	self.btn_Mession:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP:getCurrentController():showMissionLayer()
		end
	end)

	self.btn_MakeupBet = UIHelper.seekNodeByName(self.csbnode, "Button_MakeupBet")
	self.btn_MakeupBet:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP:getCurrentController():showMakeupBetLayer()
		end
	end)

	self.btn_Chat = UIHelper.seekNodeByName(self.csbnode, "Button_Chat")
	self.btn_Chat:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP:getCurrentController():showChatLayer()
		end
	end)

	self.playersUI = {};
	for i = 1, maxset do
		self:newPlayerUI(i)
	end
end


function ViewRoom:newPlayerUI(clipos)
	local uip = UIHelper.seekNodeByName(self.csbnode, "Players");
	local p = UIHelper.seekNodeByName(uip, "P" .. tostring(clipos))
	self.playersUI[clipos] = APP:createView("texaspoker.ViewPlayer", clipos);
	self.playersUI[clipos]:addTo(p)
	return self.playersUI[clipos]
end

function ViewRoom:onEnter()
	ViewRoom.super.onEnter(self)
end

function ViewRoom:getPlayerView(uid)
	for i = 1, maxset do
		local pp = self.playersUI[i];
		if pp and pp.uid == uid then 
			return pp;
		end
	end
end

--content
--int				roomid_;
--std::string		uid_;	//谁
--std::string		head_ico_;
--int				headframe_id_;
--std::string		uname_;
--int				pos_;//坐在哪个位置
--int				iid_;
--int				lv_;
function ViewRoom:playerSit(content)
	--如果是玩家自己坐下去了
	if content.uid == APP.GD.GameUser.uid then 
		printLog("a", "i sit %d, %s, will reset seat", content.pos, content.uid, APP.GD.GameUser.uid)
		self.mypos = content.pos;
		self:resetSeat(content);
		APP.GD.GameUser.is_observer_ = 0;

		for i = 1, maxset do
			self.playersUI[i]:setSitVisible(false);
		end

		return self.playersUI[1]
	else 
		printLog("a", "player sit %d, %s, myuid = %s", content.pos, content.uid, APP.GD.GameUser.uid)
		local clipos = self:getClientPos(content.pos);
		local uip = self.playersUI[clipos];
		uip:setUser(content);

		local container = UIHelper.seekNodeByName(self.csbnode, "Players");
		--准备动画事宜
		local placeholder = UIHelper.seekNodeByName(container, "P" .. tostring(clipos)..tostring(clipos));
		local pclone = uip:clone();
		pclone:addTo(container);
		pclone:setPosition(placeholder:getPosition());

		local ptto = container:convertToNodeSpace(uip:getParent():convertToWorldSpace(cc.p(uip:getPosition())));
		--准备播放面板动画，先隐藏面板
		uip:setVisible(false);
		local a1 = cc.EaseOut:create(cc.MoveTo:create(0.25, ptto),3);
		local a2 = cc.Sequence:create(cc.DelayTime:create(0.3), a1, cc.CallFunc:create(function()
			pclone:removeSelf();
			uip:setVisible(true);
		end));

		pclone:runAction(a2)
		return self.playersUI[clipos];
	end

end
function ViewRoom:leaveSeat(serverpos)
	if serverpos < 0 then
		--如果变为观察者
		if APP.GD.GameUser.is_observer_ then
			for i = 1, maxset do
				self.playersUI[i]:setSitVisible(true);
			end
		end
	else
		local player = APP.GD.room_players:getPlayerByPos(serverpos);
		local clipos = self:getClientPos(serverpos);
		local uip = self.playersUI[clipos];

		local container = UIHelper.seekNodeByName(self.csbnode, "Players");
		--玩家面板飞走
		local placeholder = UIHelper.seekNodeByName(container, "P" .. tostring(clipos) .. tostring(clipos))
		local anim = uip:clone();
		anim:addTo(container);
		local ptto = container:convertToNodeSpace(uip:getParent():convertToWorldSpace(cc.p(uip:getPosition())));
		anim:setPosition(ptto);

		local act = cc.Sequence:create(cc.EaseIn:create(cc.MoveTo:create(0.25, cc.p(placeholder:getPosition())) ,3),
		cc.RemoveSelf:create());
		anim:runAction(act);

		uip:setUser(nil)
		--如果是玩家自己离开坐位了
		if player and player.uid == APP.GD.GameUser.uid then
			self:hideOperateButtons();
			self:clearMyCard();
			
			--如果变为观察者
			if APP.GD.GameUser.is_observer_ then
				for i = 1, maxset do
					self.playersUI[i]:setSitVisible(true);
				end
			end
		end
	end

	printLog("a", "player leave %d, clipos = %s", serverpos, clipos)
end

function ViewRoom:resetSeat(myseat)
	for i = 1, maxset do
		self.playersUI[i]:setUser(nil)
	end

	for k, v in pairs(APP.GD.room_players.players) do
		local clipos = self:getClientPos(v.pos);
		self.playersUI[clipos]:setUser(v);
	end
end

function ViewRoom:getClientPos(others_pos)
	return (((others_pos - self.mypos) + maxset) % maxset) + 1
end

function ViewRoom:getServerPos(clipos)
	return ((clipos - 1) + self.mypos) % maxset;
end

function ViewRoom:sitDown(clipos)
	local spos = self:getServerPos(clipos);
	local data = {
		to_pos = spos;
	}
	SOCKET_MANAGER.sendToGameServer(CMD.GAME_PLAYER_SITDOWN, data);
end

function ViewRoom:onExit()
	ViewRoom.super.onExit(self)
end

function ViewRoom:updateBasePool(pool)
	self.text_BasePool:setString("底池:"..utils.convertNumberShort(pool))
end

function ViewRoom:setMainPoolStatus(show, pool)
	if show then
		local str, unit = utils.convertNumberShort(tonumber(pool))
		self.mainPool:setVisible(true)
		self.mainPool:setString(str)
	else
		self.mainPool:setVisible(false)
	end
end

function ViewRoom:setSidePoolStatus(id, show, pool)
	if not self.sidePools[id] then
		return
	end
	if show then
		local str, unit = utils.convertNumberShort(tonumber(pool))
		self.sidePools[id]:setVisible(true)
--		local poolNumber = self.sidePools[id]:getChildByTag(ViewRoom.SIDE_POOL_TAG)
        local poolNumber = self.sidePools[id]
		poolNumber:setString(str)
	else
		self.sidePools[id]:setVisible(false)
	end
end

function ViewRoom:getMainPoolIconPos()
    local parent = self.mainPool:getResIcon():getParent()
    local pos = parent:convertToWorldSpace(cc.p(self.mainPool:getResIcon():getPosition()))
    return pos.x + 22 ,pos.y
--	return ViewRoom.MAIN_POOL_POS.x - 60, ViewRoom.MAIN_POOL_POS.y
end

function ViewRoom:getSidePoolIconPos(id)
	if self.sidePools[id] then
        local parent = self.sidePools[id]:getResIcon():getParent()
        local pos = parent:convertToWorldSpace(cc.p(self.sidePools[id]:getResIcon():getPosition()))
        return pos.x + 22, pos.y
	end
end

-- 显示边池
function ViewRoom:addSidePool(id, pool, isAction)

	printInfo("addSidePool:%d,pool:%s", id, pool)
	if self.sidePools[id] then
		self:updateSidePool(id, pool)
		return
	end

	local str = utils.convertNumberShort(tonumber(pool))



    local sideItem = self:createSidePoolItem("cocostudio/game/image/bet_side.png")
		:addTo(self)
		:hide()
        sideItem:setBgAnchor(cc.p(0,0.5))
    sideItem:setTag(ViewRoom.SIDE_POOL_TAG)
	sideItem:setString(str)


    local mainPosX = ViewRoom.MAIN_POOL_POS.x
	local mainPosY = ViewRoom.MAIN_POOL_POS.y
	local posx = 0
	local posy = 0

	local width = 220 
	-- 已经有几个边池
	local count = self:getSidePoolCount()
	if count == 0 then
		posx = mainPosX - width
		posy = mainPosY
	elseif count == 1 then
		posx = mainPosX + width  - sideItem:getBgSize().width
		posy = mainPosY
	else
		local start = count - 2
		local row = math.floor(start / 3) + 1
		posx = mainPosX - (1 - (start - (row - 1) * 3)) * width
		posy = mainPosY - row * 50
	end

    sideItem:setPosition(posx, posy)
    self.sidePools[id] = sideItem

    if isAction then
	    APP:getObject("ViewActions"):actionMainPoolToSide(cc.p(posx - 60, posy), function()
	    	sideItem:show()
	    end)
	else
		sideItem:show()
	end
end

function ViewRoom:createSidePoolItem(iconPngPath)
    local resItem = ResItemWidget:create(40,false)

    resItem:setBgTexture("cocostudio/game/image/zhujiemian_choumatoumingdi.png")
    resItem:setBgSize(cc.size(140, 34))

    resItem:setResTexture(iconPngPath)
    resItem:setResIconSize(cc.size(34,34))
    resItem:getResIcon():setPositionPercent(cc.p(0,0.45))
--    resItem
    local font = resItem:getFont()
    font:setFntFile("cocostudio/game/image/zhujiemian_choumadishuzi-export.fnt")

    return resItem
end

function ViewRoom:getSidePoolCount()
	local count = 0
	for _, sidePool in pairs(self.sidePools) do
		count = count + 1
	end
	return count
end

function ViewRoom:updateSidePool(id, pool)
	if self.sidePools[id] then
		local str = utils.convertNumberShort(tonumber(pool))
--		local poolNumber = self.sidePools[id]:getChildByTag(ViewRoom.SIDE_POOL_TAG)
        local poolNumber = self.sidePools[id]
		poolNumber:setString(str)
		dump(str, "updateSidePool")
	end
end

function ViewRoom:hideSidePools()
	for _, sidePool in pairs(self.sidePools) do
		sidePool:removeSelf()
	end
	self.sidePools = {}
end

function ViewRoom:updateBlindBet(bigBet)
	self.text_BlindBet:setString(string.format("<新手场>%d/%d", bigBet / 2, bigBet))
end

function ViewRoom:hideOperateButtons()
	self.btn_Giveup:setVisible(false)

	self.btn_Giveway:setVisible(false)
	self.btn_Follow:setVisible(false)
	self.btn_AllIn_Right:setVisible(false)

	self.btn_BetIn:setVisible(false)
	self.btn_AddBet:setVisible(false)
	self.btn_AllIn_Top:setVisible(false)
	
	self.btn_Bet_3_1:setVisible(false)
	self.btn_Bet_2_1:setVisible(false)
	self.btn_Bet_3_2:setVisible(false)
	self.btn_Bet_1:setVisible(false)
	self.img_CardType:setVisible(false);
end

-- 显示玩家自己操作的按钮
-- "弃牌,让牌,跟注,加注,下注"｛0,1,1,0,0｝1表示操作可用
-- allin是总是显示的
function ViewRoom:showOperateButtons(op_str)
	printInfo("showOperateButtons:%s", op_str)
	local ops = string.split(op_str, ",")
	if ops[1] == "1" then
		self.btn_Giveup:setVisible(true)
	end
	if ops[2] == "1" then
		self.btn_Giveway:setVisible(true)
	end
	if ops[3] == "1" then
		self.btn_Follow:setVisible(true)
		local room = APP.GD:getGameRoom()
		local text = self.btn_Follow:getChildByName("Text_Follow")
		text:setString(utils.convertNumberShort(room.max_bet))
	end
	if ops[4] == "1" then
		self.btn_AddBet:setVisible(true)
	end
	if ops[5] == "1" then
		self.btn_BetIn:setVisible(true)
	end

	-- 显示了跟注，不显示加注和下注的情况才会显示上面的allin
	if ops[3] == "1" and ops[4] ~= "1" and ops[5] ~= "1" then
		self.btn_AllIn_Top:setVisible(true)
	end
	-- 显示了弃牌，不能跟注和让牌的时候才显示右边的allin
	if ops[1] == "1" and ops[2] ~= "1" and ops[3] ~= "1" then
		self.btn_AllIn_Right:setVisible(true)
	end
	local room = APP.GD.game_room;
	if ops[4] == "1" or ops[5] == "1" then

		local players = APP.GD.room_players;
    	local mePlayer = players:getPlayerByUid(APP.GD.GameUser.uid)
        if not mePlayer then return end;

		local basePool = room.base_pool
		if mePlayer.credits > basePool / 3 then
			self.btn_Bet_3_1:setVisible(true)
		end
		if mePlayer.credits > basePool / 2 then
			self.btn_Bet_2_1:setVisible(true)
		end
		if mePlayer.credits > basePool / 3 * 2 then
			self.btn_Bet_3_2:setVisible(true)
		end
		if mePlayer.credits > basePool then
			self.btn_Bet_1:setVisible(true)
		end
	end

end

-- 向服务端发送数据
function ViewRoom:onOperateButtonClicked(op, value)
	self:hideOperateButtons()
    local mePlayer =  APP.gc:getMe();
    if not mePlayer then return end;
	local room = APP.GD.game_room;
    -- 这里根据value判断是那种操作
	if op ~= TexasPokerConfig.ACTION_GIVEWAY and op ~= TexasPokerConfig.ACTION_GIVEUP then
		if value >= mePlayer.credits then
			op = TexasPokerConfig.ACTION_ALLIN
		elseif room.max_bet == 0 then
			op = TexasPokerConfig.ACTION_BETIN
		elseif value == room.max_bet then
			op = TexasPokerConfig.ACTION_FOLLOW
		elseif value > room.max_bet and value < mePlayer.credits then
			op = TexasPokerConfig.ACTION_ADD
		else
			printInfo("invalide operate op:%s, value:%s", tostring(op), tostring(value))
			return
		end
	end

    local data = {
        op_ = op,
        value_ = value,
        opkey_ = mePlayer.opkey,
    }

    SOCKET_MANAGER.sendToGameServer(CMD.TEXASPOKER_TAKE_OP_REQ, data)
end

-- 给自己发牌
function ViewRoom:dealCardToMe(cardsData, isTurn)
	if #self.myCards > 0 then
		return
	end
	for i = 1, #cardsData do
		local data = tonumber(cardsData[i])
		local card = ViewCard.new(data, isTurn);
		card:addTo(UIHelper.seekNodeByName(self.csbnode, "mycard" .. tostring(i)))
		card:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.6),
  			cc.CallFunc:create(function ()
				SoundUtils.playFanpai(1)
  				if isTurn then
	  				card:actionTurn()
	  			end
  			end)
		))
		card.data = data
		table.insert(self.myCards, card)
	end
end

function ViewRoom:clearMyCard()
	for _, card in pairs(self.myCards) do
		card:removeSelf()
	end
	self.myCards = {}
end

-- 设置我的牌变灰
function ViewRoom:setMyCardGray()
	local mePlayer =  APP.gc:getMe();
    if not mePlayer then return end;
	for _, card in pairs(self.myCards) do
		if not mePlayer:isInBestCard(card.data) then
			card:toGray()
		end
	end
end

-- 发公共牌
function ViewRoom:dealPublicCard(cardsData, isTurn)
	local ii = 0;
	for i = #self.publicCards + 1, #cardsData do
		local data = tonumber(cardsData[i])
		local card = ViewCard.new(data, isTurn)
		--card:align(display.LEFT_BOTTOM, 0, 0)
		card:addTo(UIHelper.seekNodeByName(self.csbnode, "pubcard" .. tostring(i)))
		card:runAction(cc.Sequence:create(
  			cc.DelayTime:create(ii * 0.4),
  			cc.CallFunc:create(function ()
  				if isTurn then
					SoundUtils.playFanpai(1);
	  				card:actionTurn()
	  			end
  			end)
		))
		card.data = data
		ii = ii + 1;
		table.insert(self.publicCards, card)
	end
end

function ViewRoom:clearPublicCard()
	for _, card in pairs(self.publicCards) do
		card:removeSelf()
	end
	self.publicCards = {}
end

-- 设置公共牌变灰，uid是赢家的uid
function ViewRoom:setPublicCardColorGray(uid)
    local players = APP.GD.room_players
    local player = players:getPlayerByUid(uid)
    for _, card in pairs(self.publicCards) do
		if not player:isInBestCard(card.data) then
			card:toGray()
		end
	end
end

function ViewRoom:clearPublicCardColor()
	for _, card in pairs(self.publicCards) do
		card:toWhite()
	end
end

function ViewRoom:clear()
	self:clearMyCard()
    self:clearPublicCard()
    self:updateBasePool(0)
    self:setMainPoolStatus(false)
    self:hideSidePools()
end

return ViewRoom