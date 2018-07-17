
local ctrl = createView("Loading/progress/layer/effnode", "fruit/UICommon/LoadingEffect.csb", nil)

function ctrl:show()
    return self:create()
end

function ctrl:onInit(node)
    local action = cc.CSLoader:createTimeline(self:getCsb())
    node:runAction(action)
    action:gotoFrameAndPlay(0, true)
end

return ctrl
