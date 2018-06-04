--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require("app.handlers.SocketHandlers")
local GameConfig = require("app.core.GameConfig")
local CMD = require("app.net.CMD")
local LANG =APP.GD.LANG
local gameCMD = require("app.commands.LoginTexasPokerCommand");

local SwitchGameServerHandlers = {}
function SwitchGameServerHandlers.active(purpose)
	printLog("a", "SwitchGameServerHandlers active ")
	SwitchGameServerHandlers.purpose = purpose;
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_COMMOM_REPLY, 2, SwitchGameServerHandlers.CommonReplyGame);
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_USER_LOGIN_RESP, 2, SwitchGameServerHandlers.handleAuthResponse);
	SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_CURRENCY_CHANGE, 2, SwitchGameServerHandlers.handleCurrencyChangeNotify);
	SOCKET_HANDLERS.registerHandler(GameConfig.ID_COORDINATESERVER, CMD.COORDINATE_ENTER_PRIVATE_ROOM_RET, 2, SwitchGameServerHandlers.handleEnterPrivateRoom);
	
end

function SwitchGameServerHandlers.deactive()
	printLog("a", "SwitchGameServerHandlers deactive")
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_COMMOM_REPLY, 2, nil);
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_USER_LOGIN_RESP, 2, nil);
	SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.GAME_CURRENCY_CHANGE, 2, nil);
	SOCKET_HANDLERS.registerHandler(GameConfig.ID_COORDINATESERVER, CMD.COORDINATE_ENTER_PRIVATE_ROOM_RET, 2, nil);
end

-- 登陆游戏服务器立即收到，游戏中金币变化也会收到
function SwitchGameServerHandlers.handleCurrencyChangeNotify(content)

    local gameUser = APP.GD.GameUser;
    gameUser:updateGold(tonumber(content.credits_))
    if tonumber(content.why_) == 5 then
		printLog("a", "SwitchGameServerHandlers curreny trade complete.")
        APP.GD.is_gold_exchanged = true
		SwitchGameServerHandlers.deactive();
		APP.hc:hideWaiting();
		--如果切换服务器是为了进入房间,则进入
		if SwitchGameServerHandlers.purpose.purpose == "joinroom" then
			APP.hc:enterRoom(tonumber(SwitchGameServerHandlers.purpose.roomId), 0)
		end
    end
    if APP:isObjectExists("ViewHome") then
    	APP:getObject("ViewHome"):updateUserInfo()
    end
    if APP:isObjectExists("ViewPersonal") then
    	APP:getObject("ViewPersonal"):updateUserInfo()
    end
end

function SwitchGameServerHandlers.CommonReplyGame(content)
	printLog("a", "SwitchGameServerHandlers CommonReplyGame.")
    local cmd = tonumber(content.rp_cmd_)
    local err = tonumber(content.err_)
    if cmd == CMD.GAME_USER_LOGIN_GAME_REQ then
		if err ~= ErrorCode.error_success then
			APP:dispatchCustomEvent("COMMON_ERROR", LANG.ERR_LOGIN_GAME_FAILED);
		end
    end;
end

--接管消息处理但不做任何操作
function SwitchGameServerHandlers.handleAuthResponse(content)

end

function SwitchGameServerHandlers.handleEnterPrivateRoom(content)
	printLog("a", "handleEnterPrivateRoom ret=" .. content.succ_)

    local bContent = content.content_
    if tonumber(content.succ_) == 0 then
		SOCKET_MANAGER:closeToGameServer();

		APP.GD.connect_game_options = {
			ip = content.ip_,
			port = tonumber(content.port_)
		}

		gameCMD.execute();
	else 
		SwitchGameServerHandlers.handleAuthResponse({});
		APP.hc:showAlertOK({desc = LANG.ERR_CANNOT_FIND_ROOM});
    end
end 

return SwitchGameServerHandlers
--endregion
