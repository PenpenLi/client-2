
local ctrl = createView("Game/bottom", "fruit/UILogic/Game/bottomBar.csb", nil)
local CC = require("comm.CC")
function ctrl:show()
    return self:create()
end

function ctrl:onInit(node)
    node:findChild("head/btnAddGold"):onClick(handler(self, self.onClickedAddGold), nil, nil, nil, nil, 0)
    for i=1,5 do
        node:findChild("btn"..i):onClick(handler(self, self.onClickedBet), nil, nil, nil, nil, 0)
    end
    node:findChild("btnRepeat"):onClick(handler(self, self.onClickedRepeat), nil, nil, nil, nil, 0)

    for i=1,5 do
        local c = g_Require("fruit/ui_btnselect"):show("Game/bottom/BottomBar/btn"..i)
        c:getNode():setVisible(false)
    end
    CC.PlayerMgr.IconBack:Image({Icon = node:findChild("head/headfore"), Back = node:findChild("head/headback")})
end

function ctrl:setRepeatCallback(callback)
    self.RepeatCallback = callback
end

function ctrl:onClickedAddGold(sender)
    Platform.Recharge()
end

function ctrl:onClickedBet(sender)
    local node = sender:getParent()
    local idx = tonumber(string.sub(sender:getName(), -1, -1))
    for i=1,5 do
        node:findChild("btn"..i):findChild("BtnSelect"):setVisible(i == idx)
    end

    self.SelectIndex = idx
    TryInvoke(self.SelectBetCallback, idx)
end

function ctrl:onClickedRepeat(sender)
    TryInvoke(self.RepeatCallback)
end

--desc:隐藏所有投注特效
function ctrl:resetBet(is_auto_select)
    local node = self:getNode()
    if node then
        local idx = self.SelectIndex or 1
        for i=1,5 do
            if is_auto_select then
                node:findChild("btn"..i):findChild("BtnSelect"):setVisible(idx == i)
                if idx == i then
                    TryInvoke(self.SelectBetCallback, idx)
                end
            else
                node:findChild("btn"..i):findChild("BtnSelect"):setVisible(false)
            end
        end
    end
end

--desc:设置选择投注回调
--@callback     回调函数
function ctrl:setSelectBetCallback(callback)
    self.SelectBetCallback = callback
end

--desc:设置玩家昵称
--@name     昵称
function ctrl:refreshNickName(name)
    local node = self:getNode()
    if node then
        node:findChild("head/txtName"):setString(name)
    end
end

function ctrl:refresIId(IID)
    local node = self:getNode()
    if node then
        node:findChild("head/txtIId"):setString(string.format("ID:%s", IID))
    end
end

--desc:设置玩家K豆数量
--@gold     K豆数量
function ctrl:refreshGold(gold)
    local node = self:getNode()
    if node then
        node:findChild("head/txtGold"):setString(gold)
    end
end

--desc:设置layer是否可见
function ctrl:setLayerVisible(is_visible)
    local node = self:getNode()
    if node then
        node:findChild("layer"):setVisible(is_visible)
    end
end

function ctrl:setRepeatEnable(is_enable)
    local btnRepeat = self:getNode():findChild("btnRepeat")
    btnRepeat:setColor(is_enable and cc.c4b(255,255,255,255) or cc.c4b(128,128,128,255))
    btnRepeat:setTouchEnabled(is_enable)
end

return ctrl
