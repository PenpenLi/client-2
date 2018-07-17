
local t = {}

function t:create(left_time)
    self.LeftTime = tonumber(left_time)
    self.Clock = os.clock()
    return self
end

function t:getLeftTime()
    local elapse = os.clock() - self.Clock
    return math.floor(self.LeftTime - elapse)
end

return t
