
local ctrl = createView("", "fruit/UILogic/Game/Balance.csb", createScaleAnimation())

function ctrl:show(pay, actual_win)
    self.Pay = pay
    self.ActualWin = actual_win
    return self:create()
end

function ctrl:onInit(node)
    self:refreshUI()
    node:findChild("panel/btnClose"):onClick(handler(self, self.destroy))

    if self.ActualWin > 0 then
        sound.playWinEffect()
    elseif self.Pay > 0 then
        sound.playLoseEffect()
    end
    --[[
    node:scheduleOnce(function()
        self:destroy()
    end, 10, "Banlance.AutoClose")
    ]]
end

function ctrl:refresh(pay, actual_win)
    self.Pay = pay
    self.ActualWin = actual_win
    self:refreshUI()
end

function ctrl:refreshUI()
    local node = self:getNode()
    if node then
        node:findChild("panel/txtValue1"):setString(tostring(self.Pay))
        node:findChild("panel/txtValue2"):setString(tostring(self.ActualWin))
        local isWin = self.ActualWin - self.Pay
        local txtValue3 = node:findChild("panel/txtValue3")
        if isWin < 0 then
            txtValue3:findChild("jinahao"):setVisible(true)
        else
            txtValue3:findChild("jinahao"):setVisible(false)
        end
        txtValue3:setString(tostring(isWin))
    end
end

return ctrl
