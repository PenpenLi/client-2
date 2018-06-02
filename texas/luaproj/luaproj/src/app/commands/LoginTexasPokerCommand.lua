local CMD = require("app.net.CMD")

local LoginTexasPokerCommand = {}

-- 这里处理登陆游戏服务器的操作：
-- 1、连接游戏服务器
-- 2、认证

function LoginTexasPokerCommand.execute()
	LoginTexasPokerCommand.connect()
end

function LoginTexasPokerCommand.connect()
    local connect_game_options = APP.GD.connect_game_options
    local host = connect_game_options.ip
    local port = connect_game_options.port

    SOCKET_MANAGER.connectToGameServer(host, port, function()
        local handle = scheduler.scheduleGlobal(function()
           local len = SOCKET_MANAGER.sendToGameServer(CMD.GAME_PING, {})
		   if (not len) or len ~= 0 then
				SOCKET_MANAGER.coordinateSocket:close();
				printLog("net", "ping game server failed.");
				scheduler.unscheduleGlobal(APP.GD.ping_handle_game);
		   end
        end, 2)
        APP.GD.ping_handle_game = handle
        LoginTexasPokerCommand.login()
    end)
end

function LoginTexasPokerCommand.login()
    -- printInfo("LoginTexasPokerCommand.login()")
    local user = APP:getObject("User")

    local data = {
        uid_ = user.uid,
        iid_ = user.iid,
        uname_ = user.nickname,
        vip_lv_ = user.vip_level,
        sn_ = tostring(user.sequence),
        url_sign_ = user.token,

        -- 非必需
        head_ico_ = user.head_ico,
        headframe_id_ = user.headframe_id,
        platform_ = "koko",
       
    }
    -- dump(data, "req info")
    SOCKET_MANAGER.sendToGameServer(CMD.GAME_USER_LOGIN_GAME_REQ, data)
end

return LoginTexasPokerCommand