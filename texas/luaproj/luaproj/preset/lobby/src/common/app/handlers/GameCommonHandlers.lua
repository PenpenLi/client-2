local CMD = require("app.net.CMD")
local ErrorCode = require("app.net.ErrorCode")
local GameConfig = require("app.common.GameConfig")
local PlayerList = g_Require("app.models.PlayerList")
local GameRoom = require("app.models.GameRoom")
local GameCommonHandlers = {}

function GameCommonHandlers.active()
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_COMMOM_REPLY, 1, GameCommonHandlers.CommonReply, "GameCommonHandlers.CommonReply");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_USER_LOGIN_RESP, 1,  GameCommonHandlers.handleAuthResponse, "GameCommonHandlers.handleAuthResponse");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.SERVER_PARAMETERS, 1,  GameCommonHandlers.handleServerParameters, "GameCommonHandlers.handleServerParameters");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_PLAYER_DATA, 1, GameCommonHandlers.handlePlayerDataNotify, "GameCommonHandlers.handlePlayerDataNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_SYNC_ITEM, 1, GameCommonHandlers.handleSyncItemNotify, "GameCommonHandlers.handleSyncItemNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_CURRENCY_CHANGE, 1, GameCommonHandlers.handleCurrencyChangeNotify, "GameCommonHandlers.handleCurrencyChangeNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_PLAYER_HINT_NOTIFY, 1, GameCommonHandlers.handlePlayerHintNotify, "GameCommonHandlers.handlePlayerHintNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_PLAYER_SEAT_NOTIFY, 1, GameCommonHandlers.handlePlayerSeatNotify, "GameCommonHandlers.handlePlayerSeatNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_PLAYER_IS_READY_NOTIFY, 1, GameCommonHandlers.handlePlayerIsReadyNotify, "GameCommonHandlers.handlePlayerIsReadyNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_PLAYER_LEAVE_NOTIFY, 1, GameCommonHandlers.handlePlayerLeaveNotify, "GameCommonHandlers.handlePlayerLeaveNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_DEPOSIT_CHANGE2_NOTIFY, 1, GameCommonHandlers.handleDepositChange2Notify, "GameCommonHandlers.handleDepositChange2Notify");
	SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_CREATE_ROOM_RET, 1, GameCommonHandlers.createRoomRet, "GameCommonHandlers.createRoomRet");
	SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_IS_IN_GAME, 1, GameCommonHandlers.isInGame, "GameCommonHandlers.isInGame");
	SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_RANK_RESULT, 1, GameCommonHandlers.handleRankInfo, "GameCommonHandlers.handleRankInfo");
end

function GameCommonHandlers.deactive()
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_COMMOM_REPLY, 1, nil,"GameCommonHandlers.CommonReply");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_USER_LOGIN_RESP, 1, nil, "GameCommonHandlers.handleAuthResponse");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.SERVER_PARAMETERS, 1, nil, "GameCommonHandlers.handleServerParameters");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_PLAYER_DATA, 1, nil, "GameCommonHandlers.handlePlayerDataNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_SYNC_ITEM, 1, nil, "GameCommonHandlers.handleSyncItemNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_CURRENCY_CHANGE, 1, nil, "GameCommonHandlers.handleCurrencyChangeNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_PLAYER_HINT_NOTIFY, 1, nil, "GameCommonHandlers.handlePlayerHintNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_PLAYER_SEAT_NOTIFY, 1, nil, "GameCommonHandlers.handlePlayerSeatNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_PLAYER_IS_READY_NOTIFY, 1, nil, "GameCommonHandlers.handlePlayerIsReadyNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_PLAYER_LEAVE_NOTIFY, 1, nil, "GameCommonHandlers.handlePlayerLeaveNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_DEPOSIT_CHANGE2_NOTIFY, 1, nil, "GameCommonHandlers.handleDepositChange2Notify");
	SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_CREATE_ROOM_RET, 1, nil, "GameCommonHandlers.createRoomRet");
	SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_IS_IN_GAME, 1, nil, "GameCommonHandlers.isInGame");
	SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_RANK_RESULT, 1, nil, "GameCommonHandlers.handleRankInfo");
end


function GameCommonHandlers.CommonReply(content)
	local LANG =APP.GD.LANG
    local cmd = tonumber(content.rp_cmd_)
    local err = tonumber(content.err_)
    if cmd == CMD.GAME_USER_LOGIN_GAME_REQ then
		if err ~= ErrorCode.error_success then
		    dispatchCustomEvent("COMMON_ERROR", LANG.ERR_LOGIN_GAME_FAILED);
		end
	elseif cmd == CMD.GAME_PLAYER_LEAVE_REQ then
		if err == ErrorCode.error_success then
			APP.GD.room_id = 0;
			APP:ActiveCtrl("HomeController");
		else
			APP:getCurrentController():showAlertOK({desc = LANG.ERR_CANNOT_LEAVE_ROOM})
		end
	elseif cmd == CMD.GAME_PLAYER_STANDUP then
		if err == -1 then
			APP:getCurrentController():showAlertOK({desc = LANG.ERR_CANNOT_STANDUP1 })
		elseif err == -2 then
			APP:getCurrentController():showAlertOK({desc = LANG.ERR_CANNOT_STANDUP2 })
		end
	elseif cmd == CMD.GAME_ENTER_GAME_REQ then
		if err ~= ErrorCode.error_success then
		    dispatchCustomEvent("COMMON_ERROR", LANG.ERR[cmd][err]);
		end
	elseif cmd == CMD.GAME_CREATE_ROOM then
		APP:getCurrentController():showAlertOK({desc = LANG.ERR[cmd][err]})
	end
end

function GameCommonHandlers.handleAuthResponse(content)
	printLog("a", "游戏登录成功.", content.ip_, content.port_);

	local gameUser =APP.GD.GameUser
	gameUser:setInfo(content)
	
	APP.GD.SameAccountLogin = false;
end

function GameCommonHandlers.isInGame(content)
	--进入普通场
	if content.roomid_ == 0 then
		APP.gc:enterRoom(tonumber(content.data_), 0);
	elseif content.roomid_ == 2 then
		APP.gc:EnterPrivateRoom(tonumber(content.data_), 0);
	elseif content.roomid_ == 1 then
		--进入比赛场
	end
end

function GameCommonHandlers.createRoomRet(content)
	printLog("a", "房间创建成功. roomid" .. content.roomid_);
	dispatchCustomEvent("ROOM_CREATE_SUCC", content);
end

function GameCommonHandlers.handleServerParameters(content)
	-- 房间列表
	if tonumber(content.enter_scene_) == 0 then
		local roomList = APP.GD.room_list;
		table.insert(roomList, {
			id = tonumber(content.id_),
			balance_with = tonumber(content.balance_with_),     --结算货币的ID
			banker_set = tonumber(content.banker_set_),         --抢庄保证金
			bet_set = tonumber(content.bet_set_),               --最小压注金额
			enter_cap = tonumber(content.enter_cap_),           --进入场次的最低货币限制
			enter_cap_top = tonumber(content.enter_cap_top),    --进入场次的最低货币限制
			enter_scene = tonumber(content.enter_scene_),       --是否进入场次信息。1是，0服务器参数，2， 开始 3服务器参数配置结束
			params = content.params_,
			sequence_1 = tonumber(content.sequence_1_)
		})
	-- 进入的场的配置信息
	elseif tonumber(content.enter_scene_) == 1 then
		local room = GameRoom.new()
		room:setServerData(content)
		APP.GD.chang_id = tonumber(content.id_)
		APP.GD.game_room = room
	end
end

function GameCommonHandlers.handlePlayerHintNotify(content)
	if content.hint_type_ == "1" then
		local MsgTakeover = require("app.handlers.MsgTakeoverOnEntering")
		MsgTakeover.active();
		local players = PlayerList.new()
		APP.GD.room_players = players
		APP.GD.room_id = tonumber(content.roomid_)
	end
end

function GameCommonHandlers.handlePlayerSeatNotify(content)
	local room_id = APP.GD.room_id
	if room_id ~= tonumber(content.roomid_) then
		printInfo("收到其他房间的消息")
		return
	end

	local players = APP.GD.room_players
	players:addPlayer(content)

	if APP:getCurrentController().playerSeat then
		APP:getCurrentController():playerSeat(content.uid_)
	end

end

function GameCommonHandlers.handlePlayerIsReadyNotify(content)
	local room_id = APP.GD.room_id
	if room_id ~= tonumber(content.roomid_) then
		printInfo("收到其他房间的消息")
		return
	end

	local players = APP.GD.room_players
	players:setPlayerReady(content.uid_, true, content)

	if APP:getCurrentController().playerReady then
		APP:getCurrentController():playerReady(tonumber(content.uid_))
	end
end

function GameCommonHandlers.handlePlayerLeaveNotify(content)
    local room_id = APP.GD.room_id
    if room_id ~= tonumber(content.roomid_) then
        return
    end

    local gameUser =APP.GD.GameUser
    --如果转为观察者
    if tonumber(content.why_) == 10 then
        gameUser.is_observer_ = 1;
	else
		gameUser.is_observer_ = 0;
    end

    -- 删除玩家
    local players = APP.GD.room_players
    local delPlayer = players:getPlayerByPos(tonumber(content.pos_))
    if APP:getCurrentController().playerLeave  then
        APP:getCurrentController():playerLeave(delPlayer, tonumber(content.why_))
    end
	players:deletePlayerByPos(tonumber(content.pos_))
end

-----------------------同步玩家信息的几个消息--------------------------------

-- 玩家信息
function GameCommonHandlers.handlePlayerDataNotify(content)
	local gameUser =APP.GD.GameUser
    gameUser:setInfoExt(content)
end

-- 同步玩家信息
function GameCommonHandlers.handleSyncItemNotify(content)
	local gameUser =APP.GD.GameUser
    gameUser:setItem(tonumber(content.item_id_), tonumber(content.count_))

    if APP:isObjectExists("ViewHome") then
    	APP:getObject("ViewHome"):updateUserInfo()
    end
    if APP:isObjectExists("ViewPersonal") then
    	APP:getObject("ViewPersonal"):updateUserInfo()
    end
end

-- 登陆游戏服务器立即收到，游戏中金币变化也会收到
function GameCommonHandlers.handleCurrencyChangeNotify(content)
    local gameUser =APP.GD.GameUser
    gameUser:updateGold(tonumber(content.credits_))
    if tonumber(content.why_) == 5 then
       	APP.GD.is_gold_exchanged = true
		printLog("a", "GameCommonHandlers curreny trade complete.")
    end
    if APP:isObjectExists("ViewHome") then
    	APP:getObject("ViewHome"):updateUserInfo()
    end
    if APP:isObjectExists("ViewPersonal") then
    	APP:getObject("ViewPersonal"):updateUserInfo()
    end
end

-- 携带金币，游戏中输赢后，金币改变
function GameCommonHandlers.handleDepositChange2Notify(content)
    local players = APP.GD.room_players
    local player = players:getPlayerByPos(tonumber(content.pos_))
    if player then
        player.display_type = tonumber(content.display_type_)
        player.credits = tonumber(content.credits_)
        if APP:getCurrentController().updatePlayerGold then
        	APP:getCurrentController():updatePlayerGold(player.uid, tonumber(content.credits_))
        end
    end
end

--排行榜 
function GameCommonHandlers.handleRankInfo(content)
    
    printLog("a","============================handleRankInfo")
    dump(content)
    local rankData = {
    
        uname = content.uname_, --昵称
        head_ico = content.head_ico_, --头像
        headframe_id  =content.headframe_id_, --
        rank_type = content.rank_type_, --排行榜类型
        tag = content.tag_,  --0新的开始 1后序数据
        data = content.data_ --排行数据

    }

   
   APP.hc:ViewRankUpData(rankData)-- :ViewRankUpData(rankData)
 
end
-----------------------------------------------------------------------------

return GameCommonHandlers