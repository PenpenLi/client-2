
local ctrl = createView("Game/center/Center", "fruit/UILogic/Game/Rotation.csb", nil)

function ctrl:show(rotate_num)
    self.RotateNum = rotate_num
    return self:create()
end

function ctrl:onInit(node)
    local n = 0 --当前特效播放次数
    local csb = self:getCsb()
    local action = cc.CSLoader:createTimeline(csb)
    node:runAction(action)
    action:gotoFrameAndPlay(0, true)
    action:setLastFrameCallFunc(function()
        n = n + 1
        if n >= self.RotateNum then
            self:destroy()
            node:removeFromParent()
        end
    end)
end

return ctrl
