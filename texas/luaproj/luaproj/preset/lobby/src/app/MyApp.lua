require("cocos.framework.init")
local GameConfig = require("app.common.GameConfig");
local GD = require("app.models.GlobalStatus");
local homeCtrlcls = nil;
local loginCtrlcls = nil; 
local gameCtrlcls = nil;
local CMD = require("app.net.CMD")
local vcp = require("bootstart/VersionCompare")
---全局变量都定义在外面，不要在函数里随意写，这样不利于别人看代码
APP = nil

local socket = require "socket"

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    self.objects_ = {}
    self.lc = nil;
    self.hc = nil;
    self.gc = nil;
    self.currentController = nil;
	self.GD = GD.new();
    APP = self--不要隐式定义全局变量
    --设置日志显示级别
    log_filter["a"] = 1;
    log_filter["dump"] = 1;
	log_filter["net"] = 1;
	log_filter["b"] = 0;
end

function MyApp:resetController()
    self.lc = nil;
    self.hc = nil;
    self.gc = nil;
end
local pathWritable = cc.FileUtils:getInstance():getWritablePath();
function MyApp:run()
    self:ActiveCtrl("LoginController");
end

function MyApp:ActiveCtrl(ctrl, preload)
    self:resetController();
    if ctrl == "HomeController" then
        if not homeCtrlcls then
            homeCtrlcls = require("app.controllers.HomeController")
        end

		self.ins = homeCtrlcls.new("homeCtrl");
        self.hc = self.ins;

    elseif ctrl == "TexasPokerController" then
        if not gameCtrlcls then
            gameCtrlcls = require("app.controllers.TexasPokerController")
        end

        self.ins = gameCtrlcls.new("gameCtrl");
        self.gc = self.ins;
    elseif ctrl == "LoginController" then
        if not loginCtrlcls then
            loginCtrlcls = require("app.controllers.LoginController")
        end

        self.ins = loginCtrlcls.new("loginCtrl");
        self.lc = self.ins;
    end

	printLog("a", "ActiveCtrl %s", ctrl);
	self:setCurrentController(self.ins);

	if not preload then
	    self:ApplyPreloadCtrl()
	end
end

function MyApp:ApplyPreloadCtrl()
	 display.runScene(self.ins)
end

function MyApp:switchServer(gameid)
    SOCKET_MANAGER:closeToCoordinateServer();
    SOCKET_MANAGER:closeToGameServer();
    SOCKET_MANAGER:connectToAccountServer();
	APP.GD:resetGameData()
    local data = {
    	gameid_ = GameConfig.GameID
	}
    SOCKET_MANAGER.sendToAccountServer(CMD.ACCOUNT_GET_GAME_COORDINATE_REQ, data)
end

function MyApp:removeObject(id)
    printInfo("[APP] removeObject: %s", id)
    if self:isObjectExists(id) then
        self.objects_[id] = nil
    end
end

function MyApp:setObject(id, object)
    printInfo("[APP] setObject: %s", id)
    self.objects_[id] = object
end

function MyApp:getObject(id)
    assert(self.objects_[id] ~= nil, string.format("MyApp:getObject() - id \"%s\" not exists", id))
    return self.objects_[id]
end

function MyApp:isObjectExists(id)
    return self.objects_[id] ~= nil
end

function MyApp:getCurrentController()
    return self.currentController
end

function MyApp:setCurrentController(controller)
    self.currentController = controller;
end

function MyApp:onEnterBackground()
    printInfo("a", "onEnterBackground")
	cc.Director:getInstance():pause()
    self.pauseTimestamp = socket.gettime()
end

function MyApp:onEnterForeground()
    printInfo("a","onEnterForeground")
	cc.Director:getInstance():resume()
end

return MyApp
