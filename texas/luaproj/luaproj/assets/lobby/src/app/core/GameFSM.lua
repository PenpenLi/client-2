local CMD = require("app.net.CMD")
local GameFSM = {}

-- 事件
-- 进入游戏
GameFSM.E_START = "start"
-- 认证
GameFSM.E_AUTH = "auth"
-- 登录
GameFSM.E_DOAUTH = "doauth"
-- 认证完成
GameFSM.E_AUTHED = "authed"
-- 连接失败
GameFSM.E_AUTHFAILED = "auth_failed"
-- 退出登陆
GameFSM.E_LOGOUT = "logout"

-- 游戏状态
-- 初始状态
GameFSM.S_NONE = "none"
-- 首页，未连接socket
GameFSM.S_LOADING = "loading"
-- 开始连接socket
GameFSM.S_AUTHING = "authing"
-- 连接socket，并且登陆成功
GameFSM.S_AUTHED = "authed"

GameFSM.Current = GameFSM.S_NONE

function GameFSM.init()
	FSM = GameFSM
end

function GameFSM.doEvent(event, args)
	if event == GameFSM.E_START then
		GameFSM.on_Start(event, args)
		GameFSM.onChangeState(GameFSM.S_LOADING)
	elseif event == GameFSM.E_AUTH then
		GameFSM.on_auth(event, args)
    elseif event == GameFSM.E_DOAUTH then
		GameFSM.do_auth(event, args)
		GameFSM.onChangeState(GameFSM.S_AUTHING)
	elseif event == GameFSM.E_AUTHED then
		GameFSM.on_authed(event, args)
		GameFSM.onChangeState(GameFSM.S_AUTHED)
	elseif event == GameFSM.E_AUTHFAILED then
		GameFSM.on_auth_failed(event, args)
		GameFSM.onChangeState(GameFSM.S_LOADING)
	elseif event == GameFSM.E_LOGOUT then
		GameFSM.on_logout(event, args)
		GameFSM.onChangeState(GameFSM.S_LOADING)
	else
		printInfo("[GameFSM] unknow event:%s", tostring(event))
	end
end

function GameFSM.onChangeState(state)
	printInfo("[GameFSM] change state: [%s] -> [%s]", tostring(GameFSM.Current), state)
	GameFSM.Current = state
end

function GameFSM.on_Start(event, args)
	APP:command("StartCommand")
	APP:enterScene("LoginScene")
end

function GameFSM.on_auth(event, args)
	APP:command("LoginAccountCommand") 
end

function GameFSM.do_auth(event, args)
	APP:getCurrentController():showWaiting()
	APP:command("LoginAccountCommand", "login", args);
end

function GameFSM.on_authed(event, args)
	APP:getCurrentController():hideWaiting()

    APP.GD.is_logined = true,

	APP:enterScene("HomeScene")
end

function GameFSM.on_auth_failed(event, args)
	APP:getCurrentController():hideWaiting()
	local desc = "登陆失败！"
	if args and args.desc then
		desc = args.desc
	end
	APP:getCurrentController():showAlertOK({
        desc = desc
    })
end

function GameFSM.on_logout(event, args)
	APP:command("LogoutCommand")

    APP.GD.is_logined = false

	if not APP:isObjectExists("LoginController") then
		APP:enterScene("LoginScene")
	end
end

return GameFSM