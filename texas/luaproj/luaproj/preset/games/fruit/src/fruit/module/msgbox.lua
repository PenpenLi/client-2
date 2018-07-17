
local box = createView("", "fruit/UICommon/MsgBox.csb", createScaleAnimation())

function box:showOk(text, callback, showCloseButton)
    self.Text = text
    self.Callback = callback
    self.IsOkCancel = false
    self.Result = nil
    self.ShowCloseButton = not not showCloseButton
    self:setZOrder(502)
    return self:create()
end

function box:showOkCancel(text, callback, showCloseButton)
    self.Text = text
    self.Callback = callback
    self.IsOkCancel = true  
    self.Result = nil
    self.ShowCloseButton = not not showCloseButton
    self:setZOrder(502)
    return self:create()
end

function box:onInit(node)
    node:findChild("panel/txtInfo"):setString(self.Text)
    local btnConfirm = node:findChild("panel/btnConfirm")
    local btnCancel = node:findChild("panel/btnCancel")
    local btnOk = node:findChild("panel/btnOk")
    local btnClose = node:findChild("panel/btnClose")

    if self.IsOkCancel then
        btnOk:onClick(function()
            self.Result = true
            self:destroy()
        end)
        btnCancel:onClick(function()
            self.Result = false
            self:destroy()
        end)
        btnOk:setVisible(true)
        btnCancel:setVisible(true)
        btnConfirm:setVisible(false)
        btnClose:setVisible(self.ShowCloseButton)
    else
        btnConfirm:onClick(function()
            self:destroy()
        end)
        btnClose:onClick(function()
            self.Callback = function() end 
            self:destroy()
        end)
        btnConfirm:setVisible(true)
        btnOk:setVisible(false)
        btnCancel:setVisible(false)
        btnClose:setVisible(self.ShowCloseButton)
    end
end

function box:onEnter()
    sound.playMsgBoxEffect()
end

function box:onPostExit()
    TryInvoke(self.Callback, self.Result)
end

return box
