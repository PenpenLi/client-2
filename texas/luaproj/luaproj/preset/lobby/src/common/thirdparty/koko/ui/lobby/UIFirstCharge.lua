
local _G = _G
local CC = require ("comm.CC")
local UIGift = require ("koko.ui.lobby.UIGift").UIGift
module "koko.ui.lobby.UIFirstCharge"

UIFirstCharge = CC.UI:Create{
    Path = "koko/ui/lobby/first_charge.csb",
    Key = "UIFirstCharge",
    NE_ITEM = 5,
}

function UIFirstCharge:Load()
    CC.PlayerMgr.FirstChargeGift:Sync()
    C("close"):Click("onClose")
    C("confirm"):Click("onConfirm")
    C("btnGotoCharge"):Click("onGotoCharge")
end

function UIFirstCharge:Refresh()
    local fg = CC.PlayerMgr.FirstChargeGift
    local tData = fg.tData
    if #tData ~= 0 then
        C("price"):Text(tData[1].koko_key)
        C("number"):Text(tData[1].bao_value)

        local layText1 = C("layout1"):C("text1"):Nine()
        local layPrice1 = C("layout1"):C("price"):Nine()
        local layText21 = C("layout1"):C("text2"):Nine()
        layText1:Attach(6, layPrice1, 4)
        layPrice1:Attach(6, layText21, 4)
        local w1 = layText1.W + layPrice1.W + layText21.W
        local h1 = layText21.H
        C("layout1"):Node():setContentSize(_G.cc.size(w1, h1))

        local layText2 = C("layout2"):C("text1"):Nine()
        local layNumber2 = C("layout2"):C("number"):Nine()
        local layText22 = C("layout2"):C("text2"):Nine()
        layText2:Attach(6, layNumber2, 4)
        layNumber2:Attach(6, layText22, 4)
        local w2 = layText2.W + layNumber2.W + layText22.W
        local h2 = layText22.H
        C("layout2"):Node():setContentSize(_G.cc.size(w2, h2))

        local tValue = tData[1].koko_value
        local iCount = #tValue
        for i=1, self.NE_ITEM do
            local kC = C("rItem"..i)
            if i <= iCount then
                local tItem = CC.ItemMgr.Item:Create(tValue[i].prizeId)
                tItem.iNum = tValue[i].prizeCoun
                kC:Component():Set(tItem)
                C("pg".. iCount .. "_" .. i):Nine():Attach(5, kC:Nine(), 5)
            else
                kC:Hide()
            end
        end

        local status = CC.PlayerMgr.FirstChargeGift:getBaoStatus()
        C("confirm"):Visible(status == "false")   -- 领取按钮
        C("btnGotoCharge"):Visible(status == "")  -- 充值按钮
    end
end
function UIFirstCharge:onConfirm(sender)
    local function callback(t)
        if t.success then
            local str = CC.PlayerMgr.FirstChargeGift:getOneBaoInfo()
            local tItem = CC.ItemMgr.Manager:CreateItems(str)
            CC.UIMgr:Load(UIGift)
            CC.UIMgr:Call("UIGift", {Open = true, kKey = "FirstChargeGift", tItem = tItem})

            CC.PlayerMgr.FirstChargeGift:deleteOne()
            CC.UIMgr:Unload(self)
        else
            _G.kk.msgup.show("领取首充礼包失败：".. t.message)
        end
    end

    local id = CC.PlayerMgr.FirstChargeGift:getBaoId()
    if id then
        CC.Web.sendGetFirstRechargeGiftReq(id, callback)
    end
end
function UIFirstCharge:onGotoCharge(sender)
    CC.Sample.Recharge:Diamond()
    CC.UIMgr:Unload(self)
    CC.PlayerMgr.FirstChargeGift:setOpenType(0)
end
function UIFirstCharge:onClose()
    local fg = CC.PlayerMgr.FirstChargeGift
    CC.UIMgr:Unload(self)
    if fg:getOpenType() == 1 then
        CC.Sample.Recharge:Diamond()
        fg:setOpenType(0)
    end
end