require("cocos.framework.init")
local GameConfig = require("app.core.GameConfig");
local GD = require("app.models.GlobalStatus");
local homeCtrlcls = nil;
local loginCtrlcls = nil; 
local gameCtrlcls = nil;
local CMD = require("app.net.CMD")
local vcp = require("app.common.VersionCompare")
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
end

function MyApp:resetController()
    self.lc = nil;
    self.hc = nil;
    self.gc = nil;
end

function MyApp:run()
	--local chk = check_version("games/texas/", );
    self:ActiveCtrl("LoginController");
	self.tid1 = scheduler.scheduleGlobal(function()
		self:CheckVersion("texas", "lobby/", "http://poker.game577.com/game_update/texas/")
		scheduler.unscheduleGlobal(self.tid1)
	end, 0.1);
end

function	MyApp:CheckVersion(exe, localp, remotep)
	if not GameConfig.EnableUpdate then return end;

	local oldlocalp = localp;
	localp = "lobby/" .. GameConfig.SAVEAS
	APP.lc:showWaiting();
	local chk = vcp:check_version(exe, localp, remotep);
	--没有新版本
	if chk == 6 then
		APP.lc:hideWaiting();
	--有新版本
	elseif chk == 5 then
		local st, prog, progmax;
		vcp:install_update();
		self.cor_182331 = 0;
		self.sh1 = scheduler.scheduleGlobal(function()
			local vw = APP.lc._waitingNode;
			local st, prog, progmax = vcp:query_version_status();

			if self.cor_182331 == 0 then
				if vcp:is_working() == 1 then
					local txt = APP.GD.LANG.VCP[st];
					if not txt then txt = "" end
					if st == 2 then
						vw:updateProgress(txt, prog, progmax);
					else
						vw:updateProgress(txt, 0, 0);
					end
				else
					printLog("a", "vcp is not working, st = %d", st);
					self.cor_182331 = 1;
				end
			elseif self.cor_182331 == 1 then
				printLog("a", "is over.", st);
				--成功
				if st == 7 then
					--更新成功,刷新资源和脚本路径,避免还是加载到assets里的旧资源
					switchContex(oldlocalp);

				--仍然存在旧版本
				elseif st == 8 then
					APP:getCurrentController():showAlertOK({desc = APP.GD.LANG.ERR_VERSION_COMPARE_OLDVERSION_REMAINS});
				else
					APP:getCurrentController():showAlertOK({desc = APP.GD.LANG.ERR_VERSION_COMPARE_FAILED});
				end
				APP.lc:hideWaiting();
				scheduler.unscheduleGlobal(self.sh1);
			end
			printLog("a", "vcp is working:st = %d", st);
		end, 0.1);
		
	--版本对比失败	
	elseif chk ~= 0 then
		APP.lc:hideWaiting();
		APP:getCurrentController():showAlertOK({desc = APP.GD.LANG.ERR_VERSION_COMPARE_FAILED});
	end
end

function MyApp:addListener(node, evtName, callback)
    local evt = cc.EventListenerCustom:create(evtName,
    function(e)
        callback(_G.unpack(e.param));
    end);

    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    dispatcher:addEventListenerWithSceneGraphPriority(evt, node)
    return evt
end

--移除事件
function MyApp:removeListener(evt)
	local dispatcher = cc.Director:getInstance():getEventDispatcher();
    dispatcher:removeEventListener(evt);
end

function MyApp:dispatchCustomEvent(evtName, ...)
    local e = cc.EventCustom:new(evtName)
    e.param = {...}
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    dispatcher:dispatchEvent(e)
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
