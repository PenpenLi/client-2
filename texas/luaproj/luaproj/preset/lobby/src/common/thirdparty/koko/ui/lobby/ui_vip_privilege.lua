
local _G = _G
local CC = require "comm.CC"
module "koko.ui.lobby.ui_vip_privilege"

ui_vip_privilege = CC.UI:Create{
    Path = "koko/ui/lobby/vip_privilege.csb",
    Key = "ui_vip_privilege",
    iCurrentVipPage = 0,
}

function ui_vip_privilege:Load()
    self:initPageView()
    self:RegClose("panel/close")
    self:RegClick("panel//btnRechrage", self.onRechrage)
    self:RegClick("panel/btnLeft", self.btnLeftClicked)
    self:RegClick("panel/btnRight", self.btnRightClicked)
    self:RegClick("panel/btnToTask", self.onToTask)
    self.iCurrentVipPage = CC.Player.vipLevel == 0 and 0 or CC.Player.vipLevel - 1
    self.t.isOneLoad = true

    _G.kk.event.addListener(C(""):Node(), _G.E.EVENTS.vip_value_changed, _G.handler(self, self.Refresh))
end
--  刷新PageView
function ui_vip_privilege:Refresh(tVal)
    local vipLevel = CC.Player.vipLevel
    local vipLimit = CC.Player.vipLimit
    C("btnRight"):Visible(self.iCurrentVipPage ~= vipLimit - 1)
    C("btnLeft"):Visible(self.iCurrentVipPage ~= 0)
    local panNode = self:Child("panel/pageView")
    if tVal == nil then
        local x = CC.Player.vipLevel == 0 and 1 or CC.Player.vipLevel
        C("titleText"):Text(_G.tostring(x))
        if not self.t.isOneLoad then
            panNode:scrollToPage(self.iCurrentVipPage, 1)
        else 
            panNode:setCurrentPageIndex(self.iCurrentVipPage)
            self.t.isOneLoad = false
        end
        
        local rate = self:vipRate()
        C("loadingBar"):Node():setPercent(rate*100)
        
        local needexp = self:needExp()
        local nextVipLevel = vipLevel >= vipLimit and vipLevel or vipLevel + 1
        local str = _G.string.format("再获得%d成长值即可升级到VIP%d", needexp, nextVipLevel)
        C("text2"):Text(str)

        C("vipLeft"):Text(vipLevel)
        C("vipRight"):Text(nextVipLevel)
        C("slidBg"):Nine():Attach(4, C("vipLeft"):Nine(), 6)
        C("vipLeft"):Nine():Attach(4, C("imageLeft"):Nine(), 6)
    elseif tVal.switchPage then
        C("titleText"):Text(_G.tostring(self.iCurrentVipPage + 1))
        panNode:scrollToPage(self.iCurrentVipPage, 1)
    end    
end
function ui_vip_privilege:vipRate()
    local vipExcel = CC.Excel.VipList
    local vipLevel = CC.Player.vipLevel
    local vipLimit = CC.Player.vipLimit
    if vipLevel >= vipLimit then
        return 1
    else
        local MinExp = vipLevel == 0 and 0 or vipExcel[vipLevel].MinExp
        local n1 = CC.Player.vipValue - MinExp
        local n2 = vipExcel[vipLevel + 1].MinExp - MinExp
        return n1/n2
    end    
end
function ui_vip_privilege:needExp()
    local vipExcel = CC.Excel.VipList
    local vipLevel = CC.Player.vipLevel
    local vipLimit = CC.Player.vipLimit
    if vipLevel >= vipLimit then
        return 1
    else
        return vipExcel[vipLevel + 1].MinExp - CC.Player.vipValue
    end    
end 

function ui_vip_privilege:initPageView()
    local vipLimit = CC.Player.vipLimit
    local panNode = self:Child("panel/pageView")
    local sz = panNode:getContentSize()
    
    for i = 1, vipLimit do
        local item = _G.ccui.Layout:create()
        item:setName("layPage")
        item:setContentSize(sz)

        local vipXMLstr = self:setXMLStr(i)
        local rtxt = _G.ccui.RichText:createWithXML(vipXMLstr,{})
        rtxt:setName("rtxt")
        rtxt:setAnchorPoint(_G.cc.p(0, 1))
        rtxt:setPosition(_G.cc.p(0, sz.height - 20))
        item:addChild(rtxt)
        panNode:addPage(item)
    end
    panNode:addEventListener(_G.handler(self, self.onPageChanged))
end

function ui_vip_privilege:setXMLStr(i)
    local tStr = {}
    local strHead = "<font face='font/system.ttf' size='18' color='#FFFFFF'>"
    local strBack = "</font>"
    local vipList = CC.Excel.VipList:At(i)
    if vipList.HeadIcon then
        _G.table.insert(tStr, _G.string.format("、尊贵VIP%d头像边框<br/>", vipList.HeadIcon))
    end
    if vipList.LuckNum then
        _G.table.insert(tStr, _G.string.format("、幸运转盘次数%d次<br/>", vipList.LuckNum))
    end 
    if vipList.SignAward then
        _G.table.insert(tStr, _G.string.format("、每日签到奖励%d倍<br/>", vipList.SignAward))
    end
    if vipList.unlockBuy then
        _G.table.insert(tStr, _G.string.format("、解锁<font color='#FF0000'>购买</font>礼物：%s<br/>", vipList.unlockBuy))
    end
    if vipList.unlockGive then
        _G.table.insert(tStr, _G.string.format("、解锁<font color='#FF0000'>赠送</font>礼物：%s<br/>", vipList.unlockGive))
    end
    -- if vipList.PayRateAdd then
    --     _G.table.insert(tStr, _G.string.format("、充值额外赠送%d%%<br/>", vipList.PayRateAdd * 100))
    -- end
    if vipList.GiftLimit then
        _G.table.insert(tStr, _G.string.format("、每日送礼上限%d万K豆<br/>", vipList.GiftLimit))
    end
    if i == 7 then
        _G.table.insert(tStr, "、开放斗地主-尊贵场")
    end
    if i == 8 then
        _G.table.insert(tStr, "、开放斗地主-皇家场")
    end
    local vipstr = strHead
    for k, v in _G.ipairs(tStr) do
        vipstr = vipstr .. k .. v
    end
    vipstr = vipstr .. strBack
    return vipstr
end

function ui_vip_privilege:onPageChanged(sender)
    local idx = sender:getCurrentPageIndex()
    self.iCurrentVipPage = idx
    self:Refresh({switchPage = true})
end

function ui_vip_privilege:btnLeftClicked(sender)
    self.iCurrentVipPage = self.iCurrentVipPage - 1
    self:Refresh({switchPage = true})
end

function ui_vip_privilege:btnRightClicked(sender)
    self.iCurrentVipPage = self.iCurrentVipPage + 1
    self:Refresh({switchPage = true})
end
--  去充值按钮
function ui_vip_privilege:onRechrage()
    _G.kk.uimgr.load("koko.ui.lobby.ui_recharge")
    _G.kk.uimgr.call("kkRecharge", "showPage", 1)
end
--  去任务
function ui_vip_privilege:onToTask()
end