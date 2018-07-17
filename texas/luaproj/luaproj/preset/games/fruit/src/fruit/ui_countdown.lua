
local ctrl = createView("Game/center", "fruit/UILogic/Game/Countdown.csb", nil)

function ctrl:show()
    self.TimerKey = "countdown.timer"
    self.IsTimerStart = false
    return self:create()
end

function ctrl:onInit(node)
    node:findChild("left"):setVisible(false)
    node:findChild("center"):setVisible(false)
end

function ctrl:resetTimer(state, left_time)
    local node = self:getNode()
    if not node then
        return
    end

    self.State = state
    self.LeftTime = left_time

    local left = node:findChild("left")
    local center = node:findChild("center")
    if state == 1 then
        left:setVisible(true)
        left:findChild("info"):setSpriteFrame("fruit/atlas/Countdown/img03.png")
        self:refresh(state, left_time)
        self:startTimer()
    elseif state == 2 then
        left:setVisible(false)
        center:setVisible(false)
        self:stopTimer()
    elseif state == 3 then
        left:setVisible(true)
        left:findChild("info"):setSpriteFrame("fruit/atlas/Countdown/img05.png")
        self:refresh(state, left_time)
        self:startTimer()
    end
end

function ctrl:startTimer()
    if self.IsTimerStart then
        return
    end

    local node = self:getNode()
    if node then
        node:schedule(handler(self, self.onTimer), 1, self.TimerKey)
        self.IsTimerStart = true
    end
end

function ctrl:stopTimer()
    if not self.IsTimerStart then
        return
    end

    self.IsTimerStart = false
    local node = self:getNode()
    if node then
        node:unschedule(self.TimerKey)
    end
end

function ctrl:onTimer()
    self.LeftTime = self.LeftTime - 1
    if self.LeftTime <= 0 then
        self:stopTimer()
    else
        self:refresh(self.State, self.LeftTime)
    end
end

function ctrl:refresh(state, left_time)
    local node = self:getNode()
    if node then
        local left = node:findChild("left")
        local center = node:findChild("center")
        left:findChild("num"):setString(tostring(left_time))
        if state == 1 and left_time <= 5 then
            center:setVisible(true)
            center:findChild("num"):setString(tostring(left_time))
        else
            center:setVisible(false)
        end
    end
end



return ctrl
