
local ctrl = createView("", "fruit/UICommon/Reconnect.csb", nil)

function ctrl:show()
    self.CancelHandler = nil
    self.TimeoutHandler = nil
    self.Clock = 0
    self:setZOrder(100)
    return self:create()
end

function ctrl:setCancelHandler(func)
    self.CancelHandler = func
end
function ctrl:setTimeoutHandler(func)
    self.TimeoutHandler = func
end

function ctrl:onInit(node)
    local action = cc.CSLoader:createTimeline(self:getCsb())
    node:runAction(action)
    action:gotoFrameAndPlay(0, true)

    node:findChild("btnCancel"):onClick(handler(self, self.onCancelClicked))

    self.Clock = os.clock()
    node:schedule(handler(self, self.onTimer), 0, "reconnect.timer")
end

function ctrl:onCancelClicked(sender)
    TryInvoke(self.CancelHandler)
end

function ctrl:onTimer(dt)
    local elapse = os.clock() - self.Clock
    if elapse >= Config.ReconnectTimeout then
        self:getNode():unschedule("reconnect.timer")
        TryInvoke(self.TimeoutHandler)
    end
end


return ctrl