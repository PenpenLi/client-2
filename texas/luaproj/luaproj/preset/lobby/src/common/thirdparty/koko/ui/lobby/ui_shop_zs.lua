local data = require("koko.data")
local CC = require "comm.CC"

local ctrl = class("kkShopZS", kk.view)

function ctrl:ctor(id)
    self:setCsbPath("koko/ui/lobby/shop_zs.csb")
    self:setAnimation(kk.animScale:create())
    self.shopItemName = CC.Excel.Shop_ZS[id]
    self.id = id
end

function ctrl:onInit(node)
    node:findChild("panel/text1"):setString(string.format("支付金额：%d.0元", self.shopItemName.Price))
    kk.edit.createNumberWithParent(node:findChild("panel/input"), "inputTxt", "推广人账号")
    node:findChild("panel/image1"):onClick(handler(self, self.onZFBRecharge))
    node:findChild("panel/image2"):onClick(handler(self, self.onWXRecharge))
    node:findChild("panel/btnconfirm"):onClick(handler(self, self.onConfirm))
    node:findChild("panel/close"):onClick(mkfunc(kk.uimgr.unload, self))
    self.payType = 1
end

function ctrl:onZFBRecharge(sender)
    self.payType = 1
    sender:findChild("image"):setVisible(true)
    self:getNode():findChild("panel/image2/image"):setVisible(false)
end
function ctrl:onWXRecharge(sender)
    self.payType = 2
    sender:findChild("image"):setVisible(true)
    self:getNode():findChild("panel/image1/image"):setVisible(false)
end

function ctrl:onConfirm(sender)
    self:Recharge()
end

--充值
function ctrl:Recharge()
    if platform_iswin32() then
        local uid = CC.Player.uid
        if platform_isandroid() or platform_isios() then
            --charge(uid, 0, 0)
        else
            if string.sub(uid, 1, 4) == "koko" then
                uid = string.sub(uid, 5)
            end
            local token = CC.Player.token
            local sn = CC.Player.sequence
            if callweb then
                local params = string.format("?uid=%s&token=%s&et=%s", uid, token, sn)
                local url = CC.Config.rechargeUrl..params
                callweb(url)
            else
                local params = string.format("?uid=%s^&token=%s^&et=%s", uid, token, sn)
                local url = CC.Config.rechargeUrl..params
                os.execute("start "..url)
            end
        end
    else
        local paynum = self.shopItemName.Price
        local methodCode = self.payType == 1 and "alipay" or "WeChatPay"
        web.sendRechargeZSReq(CC.Player.uid, CC.Player.appKey, paynum, methodCode, false, function(t)
            ccerr("充值买钻石订单___payType = %s____t = %s", methodCode, json.encode(t))
            if t.success then
                charge(self.payType, json.encode(t), function(state, error_msg)
                    ccerr("充值买钻石订单详情____state = %s_____error_msg = %s", state, error_msg)
                    local txt = {
                        ["8000"] = "正在处理中，支付结果未知",
                        ["4000"] = "订单支付失败",
                        ["5000"] = "重复请求",
                        ["6001"] = "用户中途取消",
                        ["6002"] = "网络连接错误",
                        ["6004"] = "支付结果未知，请查询商户订单列表中订单的支付状态",
                    }
                    if state == 1 then
                        kk.msgup.show("充值成功")
                    else
                        local str = error_msg
                        if txt[error_msg] ~= "" and txt[error_msg] ~= nil then
                            str = txt[error_msg]
                        end
                        kk.msgup.show(str)
                    end
                end)
            else
                kk.msgup.show(t.message)
            end
        end)
    end    
end

return ctrl