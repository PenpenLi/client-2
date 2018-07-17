
local ctrl = createView("Game/top", "fruit/UILogic/Game/TopBar.csb", nil)

function ctrl:show()
    return self:create()
end

function ctrl:onInit(node)
    node:findChild("btnExit"):onClick(handler(self, self.onClickedExit))

    node:findChild("btnSetting"):onClick(setting.show)
end

function ctrl:onClickedExit()
    msgbox.showOkCancel("确定退出游戏吗？", function(ok)
        if ok then
            APP:exitGame();
        end
    end)
end

return ctrl


