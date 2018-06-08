local CMD = require("app.net.CMD")
local ErrorCode = require("app.net.ErrorCode")
local GameConfig = require("app.common.GameConfig")

local AccountServerHandlers = {}

function saveAccount()
    --保存为上次登录信息
    if string.sub(APP.GD.accinfo.account, 1, 5) == "GUEST" then
        cc.UserDefault:getInstance():setStringForKey("guest_account", APP.GD.accinfo.account);
    else 
        cc.UserDefault:getInstance():setStringForKey("user_account", APP.GD.accinfo.account);
    end
    cc.UserDefault:getInstance():flush();
end

function AccountServerHandlers.active()
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_ACCOUNTSERVER, CMD.ACCOUNT_COMMOM_REPLY, 1,
        AccountServerHandlers.CommonReply);

    SOCKET_HANDLERS.registerHandler(GameConfig.ID_ACCOUNTSERVER, CMD.ACCOUNT_USER_LOGIN_RESP, 1,
        AccountServerHandlers.handleAuthResponse);

    SOCKET_HANDLERS.registerHandler(GameConfig.ID_ACCOUNTSERVER, CMD.ACCOUNT_GET_GAME_COORDINATE_RESP, 1,
        AccountServerHandlers.handleGetCoordinateServerResponse);
end

function AccountServerHandlers.CommonReply(content)
    local LANG =APP.GD.LANG
    local cmd = tonumber(content.rp_cmd_)
    local err = tonumber(content.err_)
    if cmd == CMD.ACCOUNT_USER_LOGIN_REQ then
        -- 认证失败
        if err ~= ErrorCode.error_success then
            dispatchCustomEvent("COMMON_ERROR", LANG.ERR_ACCOUNT_OR_PWD);
        end
    elseif cmd == CMD.ACCOUNT_REGISTER then
        if err ~= 0 then
            dispatchCustomEvent("COMMON_ERROR", LANG.ERR[cmd][err]);
        else
            APP.lc:autoLogin();
        end 
    elseif cmd == CMD.ACCOUNT_GET_GAME_COORDINATE_REQ then
        if err ~= ErrorCode.error_success then
            dispatchCustomEvent("COMMON_ERROR", LANG.ERR_CANNOT_FIND_COOR);
        end
    end
end

function AccountServerHandlers.handleAuthResponse(content)
    local user = APP:getObject("User")
    user:setInfo(content)
    saveAccount();
    APP:switchServer(gameid_);
end

function AccountServerHandlers.handleGetCoordinateServerResponse(content)

	APP.GD.connect_coordinate_options = {
		ip = content.ip_,
		port = tonumber(content.port_)
	}

    printLog("a", "coor server getted: %s, %d", content.ip_, tonumber(content.port_));
	APP:command("LoginCoordinateCommand")
end

return AccountServerHandlers