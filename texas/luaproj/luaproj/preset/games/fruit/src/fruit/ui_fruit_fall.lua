
local ctrl = createView("FruitFallLayer", "fruit/UILogic/Game/FruitFall.csb", nil)

function ctrl:show(present_id, posx)
    self.PresentId = present_id
    self.PosX = posx
    return self:create()
end

function ctrl:onInit(node)
    local path = self:getImagePath(self.PresentId)
    node:findChild("fruit"):setSpriteFrame(path)
    node:setPositionX(self.PosX)

    local csb = self:getCsb()
    local action = cc.CSLoader:createTimeline(csb)
    node:runAction(action)
    action:gotoFrameAndPlay(0, false)
    action:setLastFrameCallFunc(function()
        node:removeFromParent()
    end)
end

function ctrl:getImagePath(id)
    return (id >= 1 and id <= 8) and string.format("fruit/atlas/Game/img%02d.png", 20 + id - 1) or ""
end


return ctrl

