local data = require("koko.data")
local proto2 = require("koko.proto2")
local CC = require "comm.CC"

local ctrl = class("kkShopKD", kk.view)

function ctrl:ctor(id)
    self:setCsbPath("koko/ui/lobby/shop_kd.csb")
    self:setAnimation(kk.animScale:create())
    self.shopItemName = CC.Excel.Shop_KD[id]
end

function ctrl:onInit(node)
    local str = string.format("是否确定支付%d钻石，购买%sk豆？", self.shopItemName.Price, self.shopItemName.Name)
    node:findChild("panel/image"):loadTexture(self.shopItemName.Icon, 1)
    node:findChild("panel/text"):setString(str)
    node:findChild("panel/close"):onClick(mkfunc(kk.uimgr.unload, self))
    node:findChild("panel/btnconfirm"):onClick(handler(self, self.onConfirm))
end

function ctrl:onConfirm()
    --发送购买协议
    proto2.sendBuyGoldReq(self.shopItemName.Price, function(errcode, errmsg)
        kk.msgup.show(errmsg)
        kk.uimgr.unload(self)
    end)
end

return ctrl