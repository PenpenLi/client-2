local CMD = require("app.net.CMD")

local LoginCoordinateCommand = {}

-- 这里处理登陆协同服务器的操作：
-- 1、连接协同服务器
-- 2、认证

function LoginCoordinateCommand.execute()
	LoginCoordinateCommand.connect()
end

function LoginCoordinateCommand.connect()
    local connect_coordinate_options = APP.GD:getConnectCoordinateOptions()
    local host = connect_coordinate_options.ip
    local port = connect_coordinate_options.port

    SOCKET_MANAGER.connectToCoordinateServer(host, port, function()
        APP.GD.ping_handle_coordinate = scheduler.scheduleGlobal(function()
           local len = SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_PING, {})
		   if (not len) or len ~= 0 then
				scheduler.unscheduleGlobal(APP.GD.ping_handle_coordinate);
				
				local ccl = APP:getCurrentController();
				if ccl then
					ccl:showWaiting();
				end

				APP:ActiveCtrl("LoginController", true);
				if not APP.GD.SameAccountLogin then
					if not APP.lc:doAutoLogin() then
						APP.lc:showAlertOK({desc = APP.GD.LANG.TIP_SAME_ACCOUNT_LOGIN, okCallback = function()
							APP:ApplyPreloadCtrl();
						end})
					end
				else
					APP.lc:showAlertOK({desc = APP.GD.LANG.TIP_SAME_ACCOUNT_LOGIN})
				end
				
		   end
        end, 2)

        LoginCoordinateCommand.login()
    end)
end

function LoginCoordinateCommand.login()
    local user = APP:getObject("User")

    local data = {
        uid_ = user.uid,
        sn_ = user.sequence,
        token_ = user.token,
        device_ = device.platform,
    }
    -- dump(data, "req info")
    SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_USER_LOGIN_COORDINATE_REQ, data)
end

function LoginCoordinateCommand.findPrivateRoom(gameid, roomid)
    local data = {
        gameid_ = gameid,
        roomid_ = roomid,
        psw_ = "",
    }
    SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_ENTER_PRIVATE_ROOM, data)
end

return LoginCoordinateCommand