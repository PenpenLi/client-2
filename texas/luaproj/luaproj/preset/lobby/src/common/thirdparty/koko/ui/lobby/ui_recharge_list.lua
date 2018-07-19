-----------------------------------------------------------------------------------
-- 充值记录列表  2017.10.13
-- By zyq
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
local data = require("koko.data")
module "koko.ui.lobby.ui_recharge_list"
-----------------------------------------------------------------------------------
ui_recharge_list = CC.UI:Create{
	Path = "koko/ui/lobby/recharge_list.csb",
    Key = "ui_recharge_list",
    
    MAX_NUM = 1000,
    PAGE_SIZE = 20,
}

function ui_recharge_list:Load()
    self.t.iPage = 0
    self.t.tList = {}
    self.t.iCurMax = 0
    self.t.kSwitchMore = CC.Switch()
    self:More()
    C("close"):Close()
    self:RegClick("panel/btnBack", self.OnBack)
    C("btnBack"):Hide()
    C("scrollView"):Event(_G.SCROLLVIEW_EVENT_SCROLL_TO_BOTTOM, "OnScrollBottom")
end

function ui_recharge_list:More()
    if self.t.iType and self.t.kSwitchMore:TryOn() then
        local iCur = #self.t.tList
        _G.ccerr("recharge:More()")
        if iCur >= self.MAX_NUM or iCur ~= self.t.iCurMax then
            return
        end
        self.t.iPage = self.t.iPage + 1
        local function callback(t)
            if not self.kNode then return end
            if t.success then
                local status = {
                    ["1"] ="付款成功",
                    ["2"] = "处理中",
                    ["3"] = "付款成功但加币失败",
                    ["4"] = "付款成功加币成功",
                }
                status["0"] = "失败"
                local shop_status = {
                    ["1"] = "待处理",
                    ["2"] = "失败",
                }
                shop_status["0"] = "成功"
                local tData = t.data.result
                self.t.iCurMax = tData.page*self.PAGE_SIZE
                for i, v in _G.ipairs(tData.result) do
                    if self.t.iType == "充值" then
                        self.t.tList[iCur + i] = {Name = v.RECHARGE_TYPE == "0" and "钻石" or "k豆", Time = _G.string.sub(v.RECHARGE_DATE, 1, 10), Num = v.AMOUNT, Status = status[v.STATUS], Remark = v.REMARK}
                    elseif self.t.iType == "商城" then
                        self.t.tList[iCur + i] = {Name = v.name, Time = _G.string.sub(v.create_time, 1, 10), Num = v.goods_num, Status = shop_status[v.status], Remark = v.remark}
                    end
                end
                _G.cclog("充值记录第%d页", tData.page)
                self.t.kSwitchMore:TryOff()
                self:Refresh()
            else
                _G.cclog(t.message)
            end
        end
        if self.t.iType == "充值" then
            CC.Web.sendRechargeRecordReq(self.t.iPage, self.PAGE_SIZE, callback)
        elseif self.t.iType == "商城" then
            CC.Web.sendShopBuyRecordReq(self.t.iPage, self.PAGE_SIZE, callback)
        end
    end
end    
function ui_recharge_list:Refresh()
    local sv = C("scrollView")
    if self.t.tList and #self.t.tList ~= 0 then
        sv:Show()
        local Max = #self.t.tList
        CC.Node:Array{Node = C("item1"):Node(), Y = Max, XD = 0, YD = 48, Keep = true}
        for k, v in _G.ipairs(self.t.tList) do
            local item = C("item"..k)
            item:C("text1"):Text(v.Name)
            item:C("text2"):Text(v.Time)
            item:C("text3"):Text(v.Num)
            item:C("text4"):Text(v.Status)
            item:C("text5"):Text(v.Remark)
        end
        sv:Scroll():Fix{Keep = true} 
    else
        sv:Hide()
    end
end
function ui_recharge_list:OnScrollBottom()
    _G.kk.timer.delayOnce(0.5, CC.Function(self, self.More))
end
function ui_recharge_list:Call(tVal)
    self.t.iType = tVal.iType or "充值"
    local pngPath = {
        [true] = "koko/atlas/all_common/title/t5656.png",
        [false] = "koko/atlas/all_common/title/t5656.png", -- 商城
    }
    C("title"):Image(pngPath[self.t.iType == "充值"])
    self:More()
end    
function ui_recharge_list:OnBack()
    CC.UIMgr:Unload(self)
end