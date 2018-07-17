
local ctrl = createView("", "fruit/UILogic/Game/FruitFallLayer.csb", nil)

function ctrl:show(present_id)
    self.PresentId = present_id
    self:setZOrder(10)
    return self:create()
end

function ctrl:onInit(node)
    local timer_key = "fruit.fall.add"
    local elapse = 0
    node:schedule(function(dt)
        elapse = elapse + dt
        if elapse > Config.FruitFallTime then
            node:unschedule(timer_key)
        else
            self:addFall()
        end
    end, 0.05, timer_key)

    node:scheduleOnce(handler(self, self.destroy), Config.FruitFallTime + 2, "fruit.fall.removeself")
    sound.playBigRewardEffect()
end

function ctrl:addFall()
    local sz = GetScene():getContentSize()
    local x = math.random(-sz.width / 2, sz.width / 2)
    g_Require("fruit/ui_fruit_fall"):show(self.PresentId, x)
end

return ctrl
