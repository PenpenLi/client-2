local GameConfig = require("app.common.GameConfig")
local ControllerScene = require("app.controllers.ControllerScene")

local ControllerBase = class("ControllerBase", ControllerScene)

function ControllerBase:ctor()
	ControllerBase.super.ctor(self)

    APP:setObject(self.__cname, self)
    
    self._views = {}

    --消息队列
    self._msgQueue = {}
    self:onUpdate(function (dt)
        self:update(dt)
    end)
	self.evt2123 = addListener(self, "SCRIPT_ERROR", handler(self, self.OnScriptError))

	printLog("clean", self.__cname..":ctor()");
	
end

function ControllerBase:onDelete()
	removeListener(self.evt2123);
	self.onExitCalled = true;
	self:hideWaiting();

	if APP:getCurrentController() == self then
		APP:resetController();
	end
	printLog("clean", self.__cname..":onDelete()");
end

function ControllerBase:OnScriptError(msg)
    local desc = APP.GD.LANG.UI_SCRIPT_ERROR;
    self:hideWaiting();
    self:showAlertScriptError({desc = desc..msg});
end

function ControllerBase:update(dt)
    self:handleMessage(dt)
end

-- 子类需要使用update功能时通过override onRefresh
function ControllerBase:onRefresh(dt)
    -- body
end

function ControllerBase:pushMessage(msg)
    table.insert(self._msgQueue, msg)
end

function ControllerBase:handleMessage(dt)
    if self._msgBlocked == true then return end
    if #self._msgQueue == 0 then return end

    local msg = self._msgQueue[1]
    table.remove(self._msgQueue, 1)
    msg.handler(msg.payload)
end

function ControllerBase:onEnter()
    
end

function ControllerBase:onExit()

end

function ControllerBase:showWaiting()
	if  ControllerBase._waitingNode then
		ControllerBase._waitingNode:release();
	end

    ControllerBase._waitingNode = APP:createView("common.WaitingNode", {autoClose = 1})
        :move(0, 0)
        :addTo(self)
    ControllerBase._waitingNode:setName("common.WaitingNode")
    ControllerBase._waitingNode:setLocalZOrder(GameConfig.Z_Waiting);
	ControllerBase._waitingNode:retain();
end

function ControllerBase:hideWaiting()
    if ControllerBase._waitingNode then
        ControllerBase._waitingNode:removeSelf()
		ControllerBase._waitingNode:release();
    end
    ControllerBase._waitingNode = nil
end

function ControllerBase:showAlertOKCancel(options)
    self.alert = APP:createView("common.AlertOKCancel", options)
        :move(0, 0)
        :addTo(self)
    self.alert:setLocalZOrder(GameConfig.Z_Alert)
    self.alert:actionEnter()
end

function ControllerBase:showAlertOK(options)
    self.alert = APP:createView("common.AlertOK", options)
        :move(0, 0)
        :addTo(self)
    self.alert:setLocalZOrder(GameConfig.Z_Alert)
    self.alert:actionEnter()
end

function ControllerBase:showAlertScriptError(options)
    self.alert = APP:createView("common.AlertScriptError", options)
        :move(0, 0)
        :addTo(self)
    self.alert:setLocalZOrder(GameConfig.Z_Alert)
    self.alert:actionEnter()
end


function ControllerBase:showAlert(alertView)
    alertView:move(0, 0)
        :addTo(self)
    alertView:setLocalZOrder(GameConfig.Z_Alert)
    alertView:actionEnter()
end

function ControllerBase:showBrowser(options, container)
    self.browser = APP:createView("common.SimpleBrowser", options)
        :move(0, 0)
        :addTo(container)
end

return ControllerBase