
local CC = require "comm.CC"

local ctrl = class("kkShopBuySuccess", kk.view)

function ctrl:ctor(id, count)
    self:setCsbPath("koko/ui/lobby/shop_buy_success.csb")
    self:setAnimation(kk.animScale:create())
    self.shopLineName = CC.PlayerMgr.Shop.ShopList[id]
    self.count = count
end

function ctrl:onInit(node)
    local imagePath = {  --BuyType 2：券   1：k豆  0：钻石 
    {path = "koko/atlas/shop/2003.png", name = "k豆"},
    {path = "koko/atlas/lobby/1011.png", name = "奖券"},}
    imagePath[0] = {path = "koko/atlas/lobby/1030.png", name = "钻石"}

    local path = self.shopLineName.ico or "koko/atlas/head_ico/1.png"
    local num = self.count
    local name = self.shopLineName.name
    if self.shopLineName.type == "ShopXX" then
        path = imagePath[self.shopLineName.give.iID].path
        num = self.shopLineName.give.iCount * self.count
        name = imagePath[self.shopLineName.give.iID].name
    end
    node:findChild("panel/frame/image"):loadTexture(path, 1)
    node:findChild("panel/text1"):setString(string.format("X %d", num))
    node:findChild("panel/text2"):setString(name)
    node:findChild("panel/btnConfirm"):onClick(mkfunc(kk.uimgr.unload, self))
end

return ctrl
