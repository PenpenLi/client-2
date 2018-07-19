
local cls = class("comm.clock")

function cls:ctor(leftTime)
    self.leftTime = leftTime
    self.tick = os.clock()
end

function cls:getLeftTime()
    local elapse = os.clock() - self.tick
    return math.floor(self.leftTime - elapse)
end

return cls
