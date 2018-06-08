local GameConfig = require("app.common.GameConfig")

local ControllerBase = class("ControllerBase", function(name, params)
    return display.newScene(name, params);
end)

function ControllerBase:ctor()
    APP:setObject(self.__cname, self)
    
    self._views = {}
    self:enableNodeEvents()
    self._msgBlocked = false

    --消息队列
    self._msgQueue = {}
    self:onUpdate(function (dt)
        self:update(dt)
    end)
	addListener(self, "SCRIPT_ERROR", handler(self, self.OnScriptError))
end

function ControllerBase:OnScriptError()
	printLog("a", "ControllerBase:OnScriptError1");
    local desc = APP.GD.LANG.UI_SCRIPT_ERROR;
    self:hideWaiting();
	printLog("a", "ControllerBase:OnScriptError2");
    self:showAlertOK({desc = desc});
end

function ControllerBase:update(dt)
    self:handleMessage(dt)
end

-- 子类需要使用update功能时通过override onRefresh
function ControllerBase:onRefresh(dt)
    -- body
end

function ControllerBase:blockMessage()
    self._msgBlocked = true
end

function ControllerBase:unblockMessage()
    self._msgBlocked = false
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
    if not self._waitingNode then
        self._waitingNode = APP:createView("common.WaitingNode")
            :move(0, 0)
            :addTo(self)
        self._waitingNode:setName("common.WaitingNode")
        self._waitingNode:setLocalZOrder(GameConfig.Z_Waiting)
    end
end

function ControllerBase:showBlankWaiting()
    if not self._waitingNode then
        self._waitingNode = APP:createView("common.WaitingNode", {blank = true})
            :move(0, 0)
            :addTo(self)
        self._waitingNode:setName("common.WaitingNode")
        self._waitingNode:setLocalZOrder(GameConfig.Z_Waiting)
    end
end

function ControllerBase:hideWaiting()
    local waitNode = self:getChildByName("common.WaitingNode")
    if waitNode then
        waitNode:removeSelf()
    end
    self._waitingNode = nil
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

function ControllerBase:showAlert(alertView)
    alertView:move(0, 0)
        :addTo(self)
    alertView:setLocalZOrder(GameConfig.Z_Alert)
    alertView:actionEnter()
end

function ControllerBase:showBrowser(options)
    self.browser = APP:createView("common.SimpleBrowser", options)
        :move(0, 0)
        :addTo(self)
    self.browser:setLocalZOrder(GameConfig.Z_GameTop)
end

return ControllerBase