local data = require("koko.data")
local proto2 = require("koko.proto2")
local CC = require "comm.CC"

local ctrl = class("kkShopGift", kk.view)

function ctrl:ctor(id)
    id = id or name
    self.name = name
    self.id = id
    self:setCsbPath("koko/ui/lobby/shop_gift.csb")
    self:setAnimation(kk.animScale:create())
    -- self.IconCount = 1
    -- self.shopLineName = CC.Excel.Shop[id]
    self.IconCount = 1
    self.shopLineName = CC.PlayerMgr.Shop.ShopList[id]
    local p = _G.string.split(self.shopLineName.price, ",")
    self.price = tonumber(p[2]) == 2 and tonumber(p[3])/100 or tonumber(p[3])
    self.buytype = tonumber(p[2])
end

function ctrl:onInit(node)
    local imagePath = {  --BuyType 2：券   1：k豆  0：钻石
    "koko/atlas/shop/2003.png",
    "koko/atlas/lobby/1011.png",
    }
    imagePath[0] = "koko/atlas/lobby/1030.png"
    local panel = node:findChild("panel/panel1")
    panel:findChild("image2"):loadTexture(_G.kk.util.isExitPathOnPlist(self.shopLineName.ico) and self.shopLineName.ico or "koko/atlas/shop/2043.png", 1)
    node:findChild("panel/textTip"):setString(self.shopLineName.describe)
    node:findChild("panel/textTip"):getVirtualRenderer():setLineSpacing(0)
    panel:findChild("text1"):setString(self.shopLineName.name)
    panel:findChild("image4"):loadTexture(imagePath[self.buytype], 1)
    panel:findChild("price"):setString(self.price)
    node:findChild("panel/image4"):loadTexture(imagePath[self.buytype], 1)
    self.inputEdit = kk.edit.createNumberWithParent(node:findChild("panel/input"), "inputTxt", "1")
    self.inputEdit:registerScriptEditBoxHandler(function(eventname,sender) self:editboxHandle(eventname,sender) end)
    self.inputEdit:setText(1)
    node:findChild("panel/btnmax"):onClick(handler(self, self.onMax))
    node:findChild("panel/btnconfirm"):onClick(handler(self, self.onConfirm))
    node:findChild("panel/close"):onClick(mkfunc(kk.uimgr.unload, self))
    self:RefreshTotalMoney()
    if self.id == 907 then
        node:findChild("panel/btnmax"):setVisible(false)
        self.inputEdit:setEnabled(false)
    end    
end

function ctrl:getTotalMoney()
    local totalMoney = tonumber(CC.Player.ticket)/100
    if self.buytype == 1 then
        totalMoney = tonumber(CC.Player.gold)
    elseif self.buytype == 0 then
        totalMoney = tonumber(CC.Player.diamond)
    end
    return totalMoney
end
function ctrl:RefreshTotalMoney()
    local panel = self:getNode():findChild("panel")
    local total = panel:findChild("total")

    self.IconCount = tonumber(self.inputEdit:getText())
    if not self.IconCount or self.IconCount <= 0 or math.floor(self.IconCount) ~= self.IconCount then
        total:setString(0)
        return
    end
    
    local n = self.IconCount * self.price
    total:setString(n)
end

function ctrl:onMax()
    local node = self:getNode()
    if node then
        local totalMoney = self:getTotalMoney()
        local num = math.floor(totalMoney/self.price)
        num = num > 9999 and 9999 or num
        num = num >= 1 and num or 1
        node:findChild("panel/input/inputTxt"):setText(num)
        node:findChild("panel/total"):setString(tostring(self.price * num))
    end
end

function ctrl:onConfirm()
    local excel = {
        {"您的K豆不足，去商店逛逛吧！", 2},
        {"您的券不足，去游戏场玩玩吧!", 2},
    }
    excel[0] = {"您的钻石不足，去商店逛逛吧！", 1}
    self.IconCount = tonumber(self.inputEdit:getText())
    if not self.IconCount or self.IconCount <= 0 then
        kk.msgup.show("亲，您输入的数值非法，请重新输入")
        return
    elseif math.floor(self.IconCount) ~= self.IconCount then
        kk.msgup.show("亲，您输入的数值非法，请重新输入")
        return
    elseif self.IconCount > 9999 then
        kk.msgup.show("亲，您输入的数值超过了9999，请重新输入")
        return
    end
    local n = self.IconCount * self.price
    local totalMoney = self:getTotalMoney()
    if n > totalMoney then
        kk.msgbox.showOkCancel(excel[self.buytype][1], function(t)
            if t then
                kk.uimgr.unload(self)
                if self.buytype == 2 then return end
                kk.uimgr.load("koko.ui.lobby.ui_recharge")
                kk.uimgr.call("kkRecharge", "showPage", excel[self.buytype][2])
            end    
        end)
        return   
    end
    --发送购买协议
    proto2.sendBuyItemReq(self.shopLineName.pid, self.IconCount, "", function(errcode, errmsg)
        if errcode ~= 1 then
            kk.msgup.show(errmsg)
        else
            kk.uimgr.load("koko.ui.lobby.ui_shop_buy_success", "", self.id, self.IconCount)
        end
        kk.uimgr.unload(self)
    end)
end

function ctrl:editboxHandle(eventname, sender)
    if eventname == "return" then
       
    elseif eventname == "began" then

    elseif eventname == "changed" then
        self:RefreshTotalMoney()
    elseif eventname == "ended" then

    end
end

return ctrl