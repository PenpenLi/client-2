
local ControllerBase = require("app.controllers.ControllerBase")
local AlertOK = require("app.views.common.AlertOK")
local GameConfig = require("app.common.GameConfig")
local SoundUtils = require("app.common.SoundUtils")

local ViewCard = require("app.views.texaspoker.ViewCard")
local ViewPlayer = require("app.views.texaspoker.ViewPlayer")
local UIHelper = require("app.common.UIHelper")
local cmdLogin = require("app.commands.LoginAccountCommand")
local cmdStart = require("app.commands.StartCommand")


local LoginController = class("LoginController", ControllerBase)
function LoginController:ctor(autoLogin)
    LoginController.super.ctor(self)
    UIHelper.cacheCards()

	self.loginView = APP:createView("login.ViewLogin", self, autoLogin)
	self:addChild(self.loginView)

    cmdStart:execute();
 
    self.evt = addListener(self, "COMMON_ERROR", handler(self, self.loginError));
end

function LoginController:doAutoLogin()
	local lastuse = cc.UserDefault:getInstance():getStringForKey("lastuse");
	if lastuse == "0" then
		local acc = cc.UserDefault:getInstance():getStringForKey("guest_account");
		if acc then
			self.loginView:guestLogin();
			return true;
		end
	elseif lastuse == "1" then
		local acc = cc.UserDefault:getInstance():getStringForKey("user_account");
		local psw = cc.UserDefault:getInstance():getStringForKey("user_psw");
		if acc then
			self.loginView:accountLogin(acc, psw);
			return true;
		end
	end

	return false;
end

function LoginController:netKeepAlive()
   cmdLogin.connect();
end

function LoginController:netSendLogin(login_options)
    self:netKeepAlive();
    APP.GD.accinfo = login_options;
    if cmdLogin.login(login_options) == 0 then
        self:showWaiting();
    else
        dispatchCustomEvent("COMMON_ERROR", APP.GD.LANG.ERR_SOCKET_CONNECT);
    end;
end

function LoginController:netSendRegister(register_options)
    self:netKeepAlive();
    cmdLogin.register(register_options);
end

function LoginController:netSendCode(mobile)
    self:netKeepAlive();
    cmdLogin.sendcode(mobile);
end

function LoginController:loginSucc()
    self:hideWaiting();
end

function LoginController:loginError(desc)
    self:hideWaiting();
    self:showAlertOK({desc = desc});
end

function LoginController:autoLogin()
    self:netSendLogin(APP.GD.accinfo);
end

function LoginController:onEnter()
	print("LoginController:onEnter")
	LoginController.super.onEnter(self)

	SoundUtils.playMusic()

end

function LoginController:onExit()
	LoginController.super.onExit(self)
    removeListener(self.evt);
	SoundUtils.unloadGameSound()
end

return LoginController