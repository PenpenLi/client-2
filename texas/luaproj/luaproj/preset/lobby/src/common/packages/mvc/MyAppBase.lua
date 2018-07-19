require "cocos.framework.init"
local GameList = require("app.models.GameList");
local GD = require("app.models.GlobalStatus");
local socket = require "socket"
local MyAppBase = class("MyAppBase", cc.mvc.AppBase)
local CMD = require("app.net.CMD")
local GameConfig = require("app.common.GameConfig");

local env = GameConfig.getSocketEnv()

---全局变量都定义在外面，不要在函数里随意写，这样不利于别人看代码
APP = nil;

function MyAppBase:ctor()
    MyAppBase.super.ctor(self)
	self.lc = nil;
    self.hc = nil;
    self.gc = nil;

	APP = self;
	self.GD = GD.new();

	self.currentController = nil;
end

function MyAppBase:dtor()
	self:resetController();
end

function MyAppBase:resetController()
	if self.currentController then
		self.currentController:release();
		self.currentController = nil;
	end
	self.lc = nil;
    self.hc = nil;
    self.gc = nil;
end

function MyAppBase:run()
	--预加载登录界面场景但不应用
    self:ActiveCtrl("LoginController", true);
	self.evtg3312 = addListener(nil, "COMMON_ERROR", handler(self, self.doAutoLoginError));
	
	--先自动登录，如果不成功，显示登录界面
	if not self.lc:doAutoLogin() then
		self:ApplyPreloadCtrl()
	end
end

function MyAppBase:doAutoLoginError(err)
	self:getCurrentController():hideWaiting();
	self:getCurrentController():showAlertOK({desc = err});	
	self:ApplyPreloadCtrl()
end

function MyAppBase:ActiveCtrl(ctrl, preload)
    self:resetController();
	if ctrl == "HomeController" then
		local lobbyCtrlcls = g_Require("app.controllers.HomeController")
		self.hc = lobbyCtrlcls.new("HomeController");
		self:setCurrentController(self.hc);
	elseif ctrl == "GameController" then
        local gameCtrlcls = g_Require("app.controllers.GameController")
        self.gc = gameCtrlcls.new("gameCtrl");
		self:setCurrentController(self.gc);
   elseif ctrl == "LoginController" then
        loginCtrlcls = require("app.controllers.LoginController")
        self.lc = loginCtrlcls.new("loginCtrl");
		self:setCurrentController(self.lc);
    end

	printLog("a", "ActiveCtrl %s", ctrl);

	if not preload then
	    self:ApplyPreloadCtrl()
	end
end

function MyAppBase:switchServer(gameid)
    SOCKET_MANAGER.closeToCoordinateServer();
    SOCKET_MANAGER.closeToGameServer();
    SOCKET_MANAGER.connectToAccountServer(env.host, env.port);
	APP.GD:resetGameData()
    local data = {
    	gameid_ = gameid
	}
    SOCKET_MANAGER.sendToAccountServer(CMD.ACCOUNT_GET_GAME_COORDINATE_REQ, data)
end


--某游戏退出，清理工作在这里执行
function MyAppBase:exitGame(isForce)
	SOCKET_MANAGER.closeToCoordinateServer();
    SOCKET_MANAGER.closeToGameServer();
    SOCKET_MANAGER.closeToAccountServer();

	--如果是单发,则显示登录界面
	if GameConfig.Standalone then
		self:ActiveCtrl("LoginController");
	--如果不是单发，则退回大厅
	else
		startGame(defaultGame());
	end
end

function MyAppBase:ApplyPreloadCtrl()
	if self.evtg3312 then
		removeListener(self.evtg3312)
	end
	display.runScene(self.currentController)
end

function MyAppBase:getCurrentController()
    return self.currentController
end

function MyAppBase:setCurrentController(controller)
	
	if self.currentController then
		self:resetController();
	end

	if controller then
		self.currentController = controller;
		self.currentController:retain();
	end
end

function MyAppBase:onEnterBackground()
    printInfo("a", "onEnterBackground")
	cc.Director:getInstance():pause()
    self.pauseTimestamp = socket.gettime()
end

function MyAppBase:onEnterForeground()
    printInfo("a","onEnterForeground")
	cc.Director:getInstance():resume()
end

return MyAppBase
