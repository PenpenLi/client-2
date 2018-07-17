
local ctrl = createView("", "fruit/UILogic/Game/BtnSelect.csb", nil)

function ctrl:show(parent_path)
    self:setParent(parent_path)
    return self:create()
end

function ctrl:onInit(node)
    local action = cc.CSLoader:createTimeline(self:getCsb())
    node:runAction(action)
    action:gotoFrameAndPlay(0, true)
end

return ctrl

