local data = require("koko.data")
local CC = require("comm.CC")

local ctrl = class("kkPersonalBoxTreasury", kk.view)

local isSaveK = false
local isTakeK = false
local isSaveD = false
local isTakeD = false 

--=================生命周期===============--
function ctrl:ctor()
    self:setCsbPath("koko/ui/lobby/personal_box_treasury.csb")
end

function ctrl:onInit(node)
    self:refreshData(node)
    self:createEditBoxs(node)
    self:setupButtons(node)

    kk.event.addListener(node, E.EVENTS.gold_changed, function(num)
        node:findChild("panel/cK"):setString(tostring(num))
    end)
    kk.event.addListener(node, E.EVENTS.bank_gold_changed, function(num)
        node:findChild("panel/tK"):setString(tostring(num))
    end)
    kk.event.addListener(node, E.EVENTS.diamond_changed, function(num)
        node:findChild("panel/cD"):setString(tostring(num))
    end)
    kk.event.addListener(node, E.EVENTS.bank_diamond_changed, function(num)
        node:findChild("panel/tD"):setString(tostring(num))
    end)
end

--================私有（文件内调用）=============--
--刷新数值显示
function ctrl:refreshData()
        --当前账号k豆
    local node = self:getNode()
    local cK = node:findChild("panel/cK")
    cK:setString(CC.Player.gold)
    --金库里的k豆
    local tK = node:findChild("panel/tK")
    tK:setString(CC.Player.bankGold)
    --当前账号钻石
    local cD = node:findChild("panel/cD")
    cD:setString(CC.Player.diamond)
    --金库钻石
    local tD = node:findChild("panel/tD")
    tD:setString(CC.Player.bankDiamond)
end

--创建输入框
function ctrl:createEditBoxs(node)
    --存入k豆数量编辑框
    local saveKPanel = node:findChild("panel/saveK")
    local saveK = kk.edit.createNumberWithParent(saveKPanel, "saveK", "请输入需要存入的数额")
    saveK:setPlaceholderFontColor(cc.c4b(133, 118, 91, 255))
    saveK:setFontColor(cc.c4b(129, 46, 3, 255))
    saveK:registerScriptEditBoxHandler(function(eventname, sender) 
        self:editboxHandle(eventname, sender) 
    end) 
    saveK:setTag(1001)

    --取出k豆数量编辑框
    local takeKPanel = node:findChild("panel/takeK")
    local takeK = kk.edit.createNumberWithParent(takeKPanel, "takeK", "请输入需要取出的数额")
    takeK:setPlaceholderFontColor(cc.c4b(133, 118, 91, 255))
    takeK:setFontColor(cc.c4b(129, 46, 3, 255))
    takeK:registerScriptEditBoxHandler(function(eventname, sender) 
        self:editboxHandle(eventname, sender) 
    end) 
    takeK:setTag(1002)

    --存入钻石的编辑框
    local saveDPanel = node:findChild("panel/saveD")
    local saveD = kk.edit.createNumberWithParent(saveDPanel, "saveD", "请输入需要存入的数额")
    saveD:setPlaceholderFontColor(cc.c4b(133, 118, 91, 255))
    saveD:setFontColor(cc.c4b(129, 46, 3, 255))
    saveD:registerScriptEditBoxHandler(function(eventname, sender) 
        self:editboxHandle(eventname, sender) 
    end) 
    saveD:setTag(1003)

    --取出钻石的编辑框
    local takeDPanel = node:findChild("panel/takeD")
    local takeD = kk.edit.createNumberWithParent(takeDPanel, "takeD", "请输入需要取出的数额")
    takeD:setPlaceholderFontColor(cc.c4b(133, 118, 91, 255))
    takeD:setFontColor(cc.c4b(129, 46, 3, 255))
    takeD:registerScriptEditBoxHandler(function(eventname, sender) 
        self:editboxHandle(eventname, sender) 
    end) 
    takeD:setTag(1004)
end

--设置按钮
function ctrl:setupButtons(node)
    --k豆存入
    local saveK = node:findChild("panel/saveKBtn")
    saveK:onClick(function()
        self:saveKbean()
    end, nil,nil, nil, nil, 1)

    --k豆取出
    local takeK = node:findChild("panel/takeKBtn")
    takeK:onClick(function()
        self:takeKbean()
    end, nil,nil, nil, nil, 1)

    --存入钻石
    local saveD = node:findChild("panel/saveDBtn")
    saveD:onClick(function()
        self:saveDiamond()
    end, nil,nil, nil, nil, 1)

    --取出钻石
    local takeD = node:findChild("panel/takeDBtn")
    takeD:onClick(function()
        self:takeDiamond()
    end, nil,nil, nil, nil, 1)

end

--设置输入框右边的提示图案
function ctrl:setupTip(tag, isOk)
    local child = ""
    if tag == 1001 then
        child = "panel/tipK1"
    elseif tag == 1002 then
        child = "panel/tipK2"
    elseif tag == 1003 then 
        child = "panel/tipD1"
    else
        child = "panel/tipD2"      
    end

    local tip = self:getNode():findChild(child)
    if isOk then
        tip:loadTexture("koko/atlas/login/2004.png", 1)
    else
        tip:loadTexture("koko/atlas/login/2003.png", 1)
    end
end

--更变数据
function ctrl:changeData(type)
    local c = 0
    local t = 0
    if type == 1 or type == 2 then
        c = tonumber(CC.Player.gold)
        t = tonumber(CC.Player.bankGold)
        local count = 0
        if type == 1 then
            local txt = self:getNode():findChild("panel/saveK/saveK")
            local tip = self:getNode():findChild("panel/tipK1")
            count = tonumber(txt:getText())
            isSaveK = false
            txt:setText("")
            tip:setVisible(false)
        else
            local txt = self:getNode():findChild("panel/takeK/takeK")
            local tip = self:getNode():findChild("panel/tipK2")
            count = - tonumber(txt:getText()) 
            isTakeK = false
            txt:setText("")
            tip:setVisible(false)  
        end

        CC.Player:setPropertyByItemID(1, c - count)
        CC.Player:setPropertyByItemID(5, t + count)
    else
        c = tonumber(CC.Player.diamond)
        t = tonumber(CC.Player.bankDiamond)
        local count = 0
        if type == 3 then
            local txt = self:getNode():findChild("panel/saveD/saveD")
            local tip = self:getNode():findChild("panel/tipD1")
            count = tonumber(txt:getText())
            txt:setText("")
            isSaveD = false
            tip:setVisible(false)
        else
            local txt = self:getNode():findChild("panel/takeD/takeD")
            local tip = self:getNode():findChild("panel/tipD2")
            count = - tonumber(txt:getText())
            isTakeD = false
            txt:setText("")
            tip:setVisible(false)    
        end  

        CC.Player:setPropertyByItemID(0, c - count)
        CC.Player:setPropertyByItemID(4, t + count)
    end

    self:refreshData(self:getNode())
end

--=============点击响应事件=============--
--存入k豆
function ctrl:saveKbean()
    if not isSaveK then
        kk.msgup.show("数额有误，请检查")
        return
    end
    
    kk.waiting.show()
    local count = self:getNode():findChild("panel/saveK/saveK"):getText()
    web.saveToBankReq(CC.Player.appKey, CC.Player.uid, count, "1", handler(self,self.saveKbeanCallback))
end

--取出k豆
function ctrl:takeKbean()
    if not isTakeK then
        kk.msgup.show("数额有误，请检查")
        return
    end

    kk.waiting.show()
    local count = self:getNode():findChild("panel/takeK/takeK"):getText()
    web.takeFromBankReq(CC.Player.appKey, CC.Player.uid, count, "1", handler(self,self.takeKbeanCallback))
end

--存入钻石
function ctrl:saveDiamond()
    if not isSaveD then
        kk.msgup.show("数额有误，请检查")
        return
    end

    kk.waiting.show()
    local count = self:getNode():findChild("panel/saveD/saveD"):getText()
    web.saveToBankReq(CC.Player.appKey, CC.Player.uid, count, "0", handler(self,self.saveDiamondCallback))
end

--取出钻石
function ctrl:takeDiamond()
    if not isTakeD then
        kk.msgup.show("数额有误，请检查")
        return
    end

    kk.waiting.show()
    local count = self:getNode():findChild("panel/takeD/takeD"):getText()
    web.takeFromBankReq(CC.Player.appKey, CC.Player.uid, count, "0", handler(self,self.takeDiamondCallback))
end

--==============回调事件=============--
--输入框回调
function ctrl:editboxHandle(eventname, sender)
    if eventname == "ended" then
        if sender:getTag() == 1001 then
            local tip = self:getNode():findChild("panel/tipK1")
            tip:setVisible(true)

            if sender:getText() == "" or sender:getText() == nil then
                self:setupTip(1001, false)
                isSaveK = false
                return
            end 

            local firstC = string.sub(sender:getText(), 1, 1)
            if #sender:getText() > 12 or firstC == "0" then
                self:setupTip(1001, false)
                kk.msgup.show("请输入正确的数额")
                isSaveK = false
                return
            end 

            local str_num = sender:getText()
            local num = tonumber(str_num)
            local cK = tonumber(CC.Player.gold)

            if num > cK then
                self:setupTip(1001, false)
                kk.msgup.show("不可大于当前拥有K豆")
                isSaveK = false
                return 
            end 

            self:setupTip(1001, true)
            isSaveK = true
            return
        end

        if sender:getTag() == 1002 then
            local tip = self:getNode():findChild("panel/tipK2")
            tip:setVisible(true)

            if sender:getText() == "" or sender:getText() == nil then
                self:setupTip(1002, false)
                isTakeK = false
                return
            end 

            local firstC = string.sub(sender:getText(), 1, 1)
            if #sender:getText() > 12 or firstC == "0" then
                self:setupTip(1002, false)
                kk.msgup.show("请输入正确的数额")
                isTakeK = false
                return
            end 

            local str_num = sender:getText()
            local num = tonumber(str_num)
            local cK = tonumber(CC.Player.bankGold)

            if num > cK then
                self:setupTip(1002, false)
                kk.msgup.show("不可大于当前金库K豆")
                isTakeK = false
                return 
            end 

            self:setupTip(1002, true)
            isTakeK = true
            return
        end 

        if sender:getTag() == 1003 then
            local tip = self:getNode():findChild("panel/tipD1")
            tip:setVisible(true)

            if sender:getText() == "" or sender:getText() == nil then
                self:setupTip(1003, false)
                isSaveD = false
                return
            end 

            local firstC = string.sub(sender:getText(), 1, 1)
            if #sender:getText() > 12 or firstC == "0" then
                self:setupTip(1003, false)
                kk.msgup.show("请输入正确的数额")
                isSaveD = false
                return
            end 

            local str_num = sender:getText()
            local num = tonumber(str_num)
            local cK = tonumber(CC.Player.diamond)

            if num > cK then
                self:setupTip(1003, false)
                kk.msgup.show("不可大于当前拥有钻石")
                isSaveD = false
                return 
            end 

            self:setupTip(1003, true)
            isSaveD = true
            return
        end  

         if sender:getTag() == 1004 then
            local tip = self:getNode():findChild("panel/tipD2")
            tip:setVisible(true)

            if sender:getText() == "" or sender:getText() == nil then
                self:setupTip(1004, false)
                isTakeD = false
                return
            end 

            local firstC = string.sub(sender:getText(), 1, 1)
            if #sender:getText() > 12 or firstC == "0" then
                self:setupTip(1004, false)
                kk.msgup.show("请输入正确的数额")
                isTakeD = false
                return
            end 

            local str_num = sender:getText()
            local num = tonumber(str_num)
            local cK = tonumber(CC.Player.bankDiamond)

            if num > cK then
                self:setupTip(1004, false)
                kk.msgup.show("不可大于当前金库钻石")
                isTakeD = false
                return 
            end 

            self:setupTip(1004, true)
            isTakeD = true
            return
        end                            
    end
end

--存入k豆请求回调
function ctrl:saveKbeanCallback(t)
    kk.waiting.close()
    if t.success then
        self:changeData(1)    
        kk.msgup.show("操作成功")
        return
    end

    kk.msgup.show(t.message)
end

--取出k豆请求回调
function ctrl:takeKbeanCallback(t)
    kk.waiting.close()
    if t.success then
        self:changeData(2)
        kk.msgup.show("操作成功")
        return
    end

    kk.msgup.show(t.message)
end

--存入钻石请求回调
function ctrl:saveDiamondCallback(t)
    kk.waiting.close()
  if t.success then
        self:changeData(3)
        kk.msgup.show("操作成功")
        return
    end

    kk.msgup.show(t.message)
end

--取出钻石请求回调
function ctrl:takeDiamondCallback(t)
    kk.waiting.close()
      if t.success then
        self:changeData(4)
        kk.msgup.show("操作成功")
        return
    end

    kk.msgup.show(t.message)
end

return ctrl