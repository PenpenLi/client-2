
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
function LoginController:ctor()
    LoginController.super.ctor(self)
    UIHelper.cacheCards()
    UIHelper.cacheHeads()
	cc.SpriteFrameCache:getInstance():addSpriteFrames("effect/nv_1.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("effect/nv_2.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("effect/nv_3.plist")

	self:addChild(APP:createView("login.ViewLogin", self))

    cmdStart:execute();
 
    addListener(self, "COMMON_ERROR", handler(self, self.loginError));
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

	-- SoundUtils.playMusic()

end

function LoginController:onExit()
	LoginController.super.onExit(self)
    removeListener();
	-- SoundUtils.unloadGameSound()
end

return LoginController