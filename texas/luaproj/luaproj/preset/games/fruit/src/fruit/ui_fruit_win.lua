
local ctrl = createView("Game/center/Center", "fruit/UILogic/Game/FruitWin.csb", nil)

function ctrl:show(present_id)
    self.PresentId = present_id
    return self:create()
end

function ctrl:onInit(node)
    local frame_path = self:getImagePath(self.PresentId)
    node:findChild("fruit1"):setSpriteFrame(frame_path)
    node:findChild("fruit2"):setSpriteFrame(frame_path)

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
