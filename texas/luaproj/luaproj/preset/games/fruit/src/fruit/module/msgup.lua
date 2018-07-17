
local ctrl = createView("", "fruit/UICommon/MsgUp.csb", nil)

function ctrl:show(text)
    self.Text = text
    self:setZOrder(200)
    return self:create()
end

function ctrl:onInit(node)
    node:findChild("txtMsg"):setString(self.Text)

    local action = cc.CSLoader:createTimeline(self:getCsb())
    node:runAction(action)
    action:gotoFrameAndPlay(0, false)
    action:setLastFrameCallFunc(function()
        self:destroy()
        node:removeFromParent()
    end)
end

return ctrl

