
local data = require("koko.data")
local proto2 = require("koko.proto2")
local CC = require "comm.CC"
local UIEverydayLogin = require("koko.ui.lobby.UIEverydayLogin").UIEverydayLogin
local UIInvite = require("koko.ui.lobby.UIInvite").UIInvite

local ctrl = class("kkLimitTimeActive", kk.view)

local _optionHeight = 81
local _interval = 2
local _count = 5

local tList = {
    {Name = "参与有奖", Seq = 1, Path = "koko/atlas/activity/2054.png", Act = "activity1", RedPointID = 1, Show = false},
    {Name = "充值返利", Seq = 1, Path = "koko/atlas/activity/2055.png", Act = "activity2", RedPointID = 2, Show = false},
    {Name = "签到领奖", Seq = 1, Path = "koko/atlas/activity/2056.png", Act = "activity3", RedPointID = 3, Show = true},
    {Name = "兑换返利", Seq = 1, Path = "koko/atlas/activity/2057.png", Act = "activity4", RedPointID = 4, Show = false},
    {Name = "分享送礼", Seq = 1, Path = "koko/atlas/activity/2058.png", Act = "activity5", RedPointID = 5, Show = false},
    {Name = "兑换码活动", Seq = 1, Path = "koko/atlas/activity/2059.png", Act = "activity6", RedPointID = 6, Show = false},
    {Name = "幸运转盘", Seq = 1, Path = "koko/atlas/activity/2060.png", Act = "activity7", RedPointID = 7, Show = false},
    {Name = "好运金蛋", Seq = 1, Path = "koko/atlas/activity/2063.png", Act = "activity8", RedPointID = 8, Show = false},
}

function ctrl:ctor()
    self:setCsbPath("koko/ui/lobby/limit_time_active.csb")
    self:setAnimation(kk.animScale:create())
end

function ctrl:onInit(node)
    self.tList = {}
    for k, v in ipairs(tList) do
        if v.Show then
            table.insert(self.tList, v)
        end
    end
    table.sort(self.tList, function(a, b)
        return a.Seq < b.Seq
    end)
    self.scrollView = node:findChild("panel1/scrollView")
    self:refresh(self.scrollView)
    self:refreshRedPoint()
    self:initAct1(node)
    self:initAct2(node)
    self:initAct3(node)
    self:initAct4(node)
    self:initAct5(node)
    self:initAct6(node)
    self:initAct7(node)
    self:initAct8(node)

    for i = 1, #tList do
        node:findChild("panel2/"..tList[i].Act):setVisible(tList[i].Show)
    end
    self:onSwitchActive(node:findChild("panel1/scrollView/btn1"))
end

function ctrl:refresh(sv)
    local sv = self:getNode():findChild("panel1/scrollView")
    local kScroll = CC.ScrollView:Create{Node = sv}
    CC.Node:Array{Node = kScroll.kNode:findChild("btn1"), X = 1 , Y = #self.tList, XD = 0, YD = 80}
    kScroll:Fix({Left = 2, Keep = true})

    for i = 1, #self.tList do
        sv:findChild("btn"..i.."/text"):loadTexture(self.tList[i].Path, 1)
        sv:findChild("btn"..i):onClick(handler(self, self.onSwitchActive), 1.02)
        sv:findChild("btn"..i):setVisible(self.tList[i].Show)
    end
 end
--  刷新小红点
function ctrl:refreshRedPoint()
    local loginInfo = CC.PlayerMgr.Activity
    for i = 1, #self.tList do
        local redNode = self:getNode():findChild("panel1/scrollView/btn"..i.."/iRedPoint")
        redNode:setVisible(loginInfo.tActive[self.tList[i].RedPointID])
    end
end
function ctrl:onSwitchActive(sender)
    local btnx = sender:getName()
    local index = tonumber(string.sub(btnx, 4))
    local node = self:getNode():findChild("panel2")
    for i = 1, #self.tList do
        local tt = self.tList[i]
        if i == index then
            self.scrollView:findChild("btn"..i):loadTexture("koko/atlas/all_common/button/left.png", 1)
            node:findChild(tt.Act):setVisible(true)
            if tt.RedPointID ~= 3 then
                CC.PlayerMgr.Activity:ChangeActiveRedState(tt.RedPointID, false)
            end
        else
            self.scrollView:findChild("btn"..i):loadTexture("koko/atlas/all_common/button/left_selet.png", 1)
            node:findChild(tt.Act):setVisible(false)
        end
    end
end
function ctrl:refreshTicket()
    local ticketNode = self:getNode():findChild("panel2/activity1/text2")
    ticketNode:setString(kk.util.convertMoneyToRmb(CC.Player.ticket))
end
-------------- 活动1  参与有奖
function ctrl:initAct1(node)
    kk.event.addListener(node, E.EVENTS.ticked_changed, handler(self, self.refreshTicket))
    self:refreshTicket()
    local act1 = node:findChild("panel2/activity1")
    local node1 = act1:findChild("image3")
    local node2 = act1:findChild("image4")
    local btnLeft = node1:findChild("image2")
    local btnRight = node2:findChild("image2")
    btnLeft:setTag(1)
    btnRight:setTag(2)
    btnLeft:onClick(handler(self, self.onBuy))
    btnRight:onClick(handler(self, self.onBuy))
    self:setLotteries()
end
function ctrl:refreshAct1(idx, iVal)  -- iVal:0 激活状态  1：禁用
    local node
    cclog("kkLimitTimeActive:refreshAct1 idx = %d__ival = %d", idx, iVal)
    if idx == 1 then
        node = self:getNode():findChild("panel2/activity1/image3/image2")
    else
        node = self:getNode():findChild("panel2/activity1/image4/image2")
    end    
    if iVal == 1 then
        node:setEnabled(false)
        node:findChild("text"):setString("已兑换")
        node:findChild("text"):setTextColor(cc.c4b(0xFF, 0x00, 0x00, 0xFF))   
    end
end
function ctrl:onBuy(sender)
    local tag = sender:getTag()
    local function callback(iError)
        if iError == 1 then
            self:refreshAct1(tag, 1)
        elseif iError == 13 then
            kk.msgup.show("已经购买了，不能再次购买")
        else
            kk.msgup.show("购买出错")
        end    
    end    
    local excel = CC.Excel.Activity
    local price = tonumber(sender:findChild("text"):getString()) * 100
    local ticket = CC.Player.ticket
    if ticket < price then
        kk.msgup.show("亲，您的奖券不足！")
        return 
    end
    --发送协议
    proto2.sendActivityBuyReq(excel[tag].ID, 1, callback)
end
function ctrl:setLotteries()
    local name = CC.Excel.Activity
    for i = 1, 2 do
        local kData = name:At(i)
        local node = self:getNode():findChild("panel2/activity1/image"..i+2)
        node:findChild("image1"):loadTexture(kData.Icon, 1)
        node:findChild("text1"):setString(kData.Name)
        node:findChild("image2/text"):setString(tostring(kData.Price))
    end    
end
-------------- 活动2  充值返利 ok
function ctrl:initAct2(node)
    local act2 = node:findChild("panel2/activity2/btnPay")
    act2:onClick(function()
        kk.uimgr.load("koko.ui.lobby.ui_recharge")
        kk.uimgr.unload("kkActivity")
    end)
end
-------------- 活动3  签到有奖
function ctrl:initAct3(node)
    local act3 = node:findChild("panel2/activity3/btnSign")
    act3:onClick(function() 
        CC.UIMgr:Load(UIEverydayLogin)
        kk.uimgr.unload("kkActivity")
    end)
end
-------------- 活动4  兑换大返利 ok
function ctrl:initAct4(node)
    local act4 = node:findChild("panel2/activity4/btnExchange")
    act4:onClick(function()
        kk.uimgr.load("koko.ui.lobby.ui_recharge")
        kk.uimgr.call("kkRecharge", "showPage", 2)
        kk.uimgr:unload("kkActivity")
    end)
end
-------------- 活动5  分享送豪礼
function ctrl:initAct5(node)
    local act5 = node:findChild("panel2/activity5/btnInvite")
    act5:onClick(function()
        CC.UIMgr:Load(UIInvite)
        kk.uimgr.unload("kkActivity")
    end)
end
-------------- 活动6  兑换大返利
function ctrl:initAct6(node)
    local act6 = node:findChild("panel2/activity6")
    local inputNode = act6:findChild("input")
    local txtNode = kk.edit.createAnyWithParent(inputNode, "inputTxt", "        请输入兑换码...")
    txtNode:setPlaceholderFontColor(cc.c3b(0x85, 0x76, 0x5b))

    act6:findChild("btn1"):onClick(handler(self, self.onExchange), 1.03)
end
function ctrl:onExchange()
end
-------------- 活动7  幸运转转
function ctrl:initAct7(node)
    local act7 = node:findChild("panel2/activity7/btnLuck")
    act7:onClick(function()
    
    end)
end
-------------- 活动8  砸金蛋
function ctrl:initAct8(node)
    local act8 = node:findChild("panel2/activity8/btnJoin")
    act8:onClick(function()
        local url = CC.Config.webUrl .. "mobile/activity/hitThEeggActivity.htm?uid=" .. CC.Player.uid
        callweb(url, "", false, CC.Player.uid)
    end)
end
return ctrl