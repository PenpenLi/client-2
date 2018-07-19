
local data = require("koko.data")
local proto2 = require("koko.proto2")
local CC = require "comm.CC"

local ui_recharge_list = require("koko.ui.lobby.ui_recharge_list").ui_recharge_list
local ui_vip_privilege = require("koko.ui.lobby.ui_vip_privilege").ui_vip_privilege

local richtxtPosition = 
{
    [true] = cc.p(-273, -250),
    [false] = cc.p(-273, -250)
}
local ctrl = class("kkRecharge", kk.view)
function ctrl:ctor()
    self:setCsbPath("koko/ui/lobby/recharge.csb")
    self:setAnimation(kk.animScale:create())
end

function ctrl:onInit(node)
    local panNode = node:findChild("panel/panel1")
    self.scrllView1 = panNode:findChild("panel1/scrollView1")
    self.scrllView2 = panNode:findChild("panel1/scrollView2")
    self.currentPage = 1
    self.payRate = CC.PlayerMgr.RechargeList.toKbean
    if platform_isios() then
        self.payRate = 6000
    end

    panNode:findChild("btnRecord"):onClick(handler(self, self.onRecord), 1.03)
    panNode:findChild("btnLook"):onClick(handler(self, self.onLook), 1.03)
    --panNode:findChild("left_bar1"):setVisible(false)
    --panNode:findChild("left_bar2"):setVisible(false)
    --panNode:findChild("close"):onClick(function() kk.uimgr.unload(self) end)
    --panNode:findChild("panel1/scrollView1"):setScrollBarEnabled(false)
    self:initPanel1(node)
    --self:refreshScrollView(1)
    --self:initSlid()
    --self.scrllView1:setVisible(true)
    --self.scrllView2:setVisible(false)

    self.iosUrl = CC.Config.webUrl .. "mobile/iosiap/setIap.htm"
    --kk.event.addListener(node, E.EVENTS.gold_changed, handler(self, self.refreshGold))
    if CC.Version and CC.Version.Gov then
        self:CCVersion()
    end
end

function ctrl:initPanel1(node)
    local panNode = node:findChild("panel/panel1")
    -- panNode:findChild("btnRecord"):onClick(handler(self, self.onRecord), 1.03)
    -- panNode:findChild("btnLook"):onClick(handler(self, self.onLook), 1.03)
    --panNode:findChild("left_bar1"):onClick(function() self:showPage(1) end)
    --panNode:findChild("left_bar2"):onClick(function() self:showPage(2) end)
    panNode:findChild("left_bar1"):setVisible(false)
    panNode:findChild("left_bar2"):setVisible(false)
    panNode:findChild("close"):onClick(function() kk.uimgr.unload(self) end)
    panNode:findChild("panel1/scrollView1"):setScrollBarEnabled(false)
    panNode:findChild("panel1/scrollView2"):setScrollBarEnabled(false)
    -- panNode:setVisible(true)
    -- --self:refreshGold()

    --初始化panel1里的ScrollView
    self:refreshScrollView(1)
    self:refreshScrollView(2)
    -- --初始化滑块
    --self:initSlid()
    self:showPage(1)
    self:bShow(false)
    if node:findChild("rtxt") then
        node:findChild("rtxt"):setVisible(false)
    end
end

function ctrl:showPage(index)
    -- self.currentPage = index
    -- for i = 1, 2 do
    --     local node = self:getNode():findChild("panel/panel1/left_bar"..i)
    --     node:ignoreContentAdaptWithSize(true)
    --     if i == index then
    --         node:loadTexture("koko/atlas/all_common/title/0002.png", 1)
    --     else
    --         node:loadTexture("koko/atlas/all_common/title/0001.png", 1)
    --     end
    --     if i ~= 2 then
    --         local txt = node:findChild("text")
    --         txt:setPositionX(node:getContentSize().width/2)
    --     else
    --         local txt1 = node:findChild("text1")
    --         local txt2 = node:findChild("text2")
    --         txt1:setPositionX(node:getContentSize().width/2)
    --         txt2:setPositionX(node:getContentSize().width/2)
    --     end    
    -- end
    -- self.scrllView1:setVisible(index == 1)
    -- self.scrllView2:setVisible(index == 2)
    self.scrllView1:setVisible(true)
end

-- 刷新/初始化 钻石/K豆滚动容器
function ctrl:refreshScrollView(index)
    local vipLevel = CC.Player.vipLevel
    local Itemtbl = CC.Excel.Shop_ZS
    local sv = self.scrllView1
    if index == 2 then
        Itemtbl = CC.Excel.Shop_KD
        sv = self.scrllView2
    end
    
    local lineNum = math.ceil(Itemtbl:Count()/2)
    local kScroll = CC.ScrollView:Create{Node = sv}
    CC.Node:Array{Node = kScroll.kNode:findChild("item1"), X = lineNum, Y = 2, XD = 200, YD = 200}
    kScroll:Fix{Left = 10}

    local count = sv:getChildrenCount()
    for i = 1, count do
        local imageNode = sv:findChild("item"..i.."/image1")
        local numNode = sv:findChild("item"..i.."/text1")
        local priceNode = sv:findChild("item"..i.."/text2")
        local hotNode = sv:findChild("item"..i.."/hot")
        local addgiveNode = sv:findChild("item"..i.."/addgive")
        if i <= Itemtbl:Count() then
            sv:findChild("item"..i):setTag(i)
            sv:findChild("item"..i):onClick(handler(self, self.onBuy), 1.03)
            local kData = Itemtbl:At(i)
            imageNode:loadTexture(kData.Icon, 1)
            local payRate = index == 1 and self.payRate or 1
            numNode:setString(tostring(kData.Price * payRate))
            local str = ""
            if index == 1 then
                --str = string.format("%d.0元", kData.Price)
                str = string.format("%d元", kData.Price)
            else
                str = string.format("%d", kData.Price)
            end
            priceNode:setString(str)
            --热卖
            hotNode:setVisible(kData.Hot)
            --多送
            if kData.AddGive then
                addgiveNode:findChild("text"):setString("多送"..kData.AddGive.."%")
            else
                addgiveNode:setVisible(false)    
            end
            addgiveNode:setVisible(false) 
            if kData.BuyVIP and  vipLevel <= kData.BuyVIP then
                sv:findChild("item"..i):setVisible(false)
            end
        else
            sv:findChild("item"..i):removeFromParent()
        end
    end
end

function ctrl:setVipVisible(f)
    local panNode = self:getNode():findChild("panel/panel1")
    panNode:findChild("slid"):setVisible(f)
    panNode:findChild("image1"):setVisible(f)
    panNode:findChild("image2"):setVisible(f)
    panNode:findChild("vipleft"):setVisible(f)
    panNode:findChild("vipright"):setVisible(f)
end
function ctrl:initSlid()
    if CC.LoginMgr.tData.PLATFORM ~= "embed" then
        local vipValue = CC.Player.vipValue
        if vipValue == 0 then
            local rtxt = ccui.RichText:createWithXML("<font face='font/system.ttf' size='20'><font color='#FF0000' size='30'>首充</font><font color='#812E03'>任意数量钻石，将获得</font><img src='koko/atlas/shop/2010.png'/><font color='#FF0000'>100</font><font color='#812E03'>奖励！</font></font>",{})
            rtxt:setName("rtxt")
            rtxt:setAnchorPoint(cc.p(0.5, 0.5))
            rtxt:setPosition(cc.p(-60, -262))
            local panNode = self:getNode():findChild("panel/panel1")
            panNode:addChild(rtxt)
            self:setVipVisible(false)
        else
            self:refreshSlid(vipValue)
        end
    else
        self:bShow(false)
    end    
end
function ctrl:bShow(b)
    local panel = self:getNode():findChild("panel/panel1")
    panel:findChild("icon1"):setVisible(b)
    panel:findChild("slid"):setVisible(b)
    panel:findChild("icon2"):setVisible(b)
    panel:findChild("btnLook"):setVisible(b)
    panel:findChild("image1"):setVisible(b)
    panel:findChild("image2"):setVisible(b)
    panel:findChild("vipleft"):setVisible(b)
    panel:findChild("vipright"):setVisible(b)
    panel:findChild("btnRecord"):setVisible(b)
end
-- 设置滑块进度
function ctrl:refreshSlid(n)
    local vipLevel = CC.Player.vipLevel
    local vipLimit = CC.Player.vipLimit

    if not self:getNode() then return end
    self:setVipVisible(true)
    if self:getNode():findChild("panel/panel1/rtxt") then
        self:getNode():findChild("panel/panel1/rtxt"):removeFromParent()
    end

    local rate = self:vipRate()
    local node = self:getNode():findChild("panel/panel1/slid/loadingBar")
    node:setPercent(rate)

    local vipPos = {
        [true] = cc.p(-288.54, -285.62),
        [false] = cc.p(-264.54, -285.62)
    }
    local imgPos = {
        [true] = cc.p(-304.76, -271.07),
        [false] = cc.p(-286, -271.07)
    }
    local nextVipLevel = vipLevel >= vipLimit and vipLevel or vipLevel + 1
    local vipleft = self:getNode():findChild("panel/panel1/vipleft")
    local vipright = self:getNode():findChild("panel/panel1/vipright")
    local image1 = self:getNode():findChild("panel/panel1/image1")
    vipleft:setString(vipLevel)
    vipright:setString(nextVipLevel)
    vipleft:setPosition(vipPos[vipLevel >= 10])
    image1:setPosition(imgPos[vipLevel >= 10])
end
function ctrl:vipRate()
    local vipExcel = CC.Excel.VipList
    local vipLevel = CC.Player.vipLevel
    local vipLimit = CC.Player.vipLimit
    if vipLevel >= vipLimit then
        return 100
    else
        local MinExp = vipLevel == 0 and 0 or vipExcel[vipLevel].MinExp
        local n1 = CC.Player.vipValue - MinExp
        local n2 = vipExcel[vipLevel + 1].MinExp - MinExp
        return n1/n2*100
    end    
end
function ctrl:onRecord()
    CC.UIMgr:Load(ui_recharge_list)
    CC.UIMgr:Call("ui_recharge_list", {iType = "充值"})
end

function ctrl:onBuy(sender)
    local i = sender:getTag()
    if self.currentPage == 1 then
        if platform_iswin32() then
            self:Recharge()
        elseif platform_isandroid() then
            kk.uimgr.load("koko.ui.lobby.ui_shop_zs", self:getNode(), CC.Excel.Shop_ZS:At(i).ID)
        elseif platform_isios() then
            if type(is_appmall) == "function" and is_appmall() then
                self:RechargeIos(i)
            else
                kk.uimgr.load("koko.ui.lobby.ui_shop_zs", self:getNode(), CC.Excel.Shop_ZS:At(i).ID)
            end
        end    
    elseif self.currentPage == 2 then
        local diamondNum = tonumber(CC.Excel.Shop_KD[i].Price)
        local currentDiamondNum = tonumber(CC.Player.diamond)
        if diamondNum <= currentDiamondNum then
            kk.uimgr.load("koko.ui.lobby.ui_shop_kd", self:getNode(), CC.Excel.Shop_KD:At(i).ID)
        else
            self.buyGoldNum = diamondNum
            self:diamondNotEnough(i)
        end 
    end
end

function ctrl:onLook()
    CC.UIMgr:Load(ui_vip_privilege)
    kk.uimgr.unload(self)
end
--购买k豆时  钻石不够  处理函数
function ctrl:diamondNotEnough(i)
    local function exit_func(is_ok)
        if is_ok then
            self:showPage(1)
        end
    end
    local str = string.format("你的钻石不足，现在去充值吧!", CC.Excel.Shop_KD[i].Name)
    kk.msgbox.showOkCancel(str, exit_func)
end

-- function ctrl:refreshGold()
--     local node = self:getNode():findChild("panel/panel1/kcount/count")
--     node:setString(CC.Player.gold)
-- end

--win32充值
function ctrl:Recharge()
    local uid = CC.Player.uid
    if platform_isandroid() or platform_isios() then
        --charge(uid, 0, 0)
    else
        if envir_gettable().PHWND then
            local tbl = {msgtype = 1}
            hwnd_copy_data(json.encode(tbl))
        else
            if string.sub(uid, 1, 4) == "koko" then
                uid = string.sub(uid, 5)
            end
            local token = CC.Player.token
            local sn = CC.Player.sequence
            local params = string.format("?uid=%s&token=%s&et=%s", uid, token, sn)
            local url = config.rechargeUrl..params
            callweb(url)
        end
    end  
end
--ios充值
function ctrl:RechargeIos(id)
    local paynum = CC.Excel.Shop_ZS:At(id).Price
    web.sendRechargeZSReq(CC.Player.uid, CC.Player.appKey, paynum, "IosChatPay", false, function(t)
        ccerr("充值买钻石订单____t = %s", json.encode(t))
        if t.success then
            local str = string.format("你是否要支付%d元购买%d钻石？", paynum, paynum*self.payRate)
            local function exit_func(is_ok)
                if is_ok then
                    kk.waiting.show("正在充值")
                    charge_ios(id - 1, json.encode(t), self.iosUrl, CC.Config.envirFlag ,function(state, error_msg)
                        ccerr("ios充值买钻石订单详情____state = %s_____error_msg = %s", state, error_msg)
                        kk.waiting.close()
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
                end
            end
            kk.msgbox.showOkCancel(str, exit_func)
        else
            kk.msgup.show(t.message)
        end
    end) 
end

function ctrl:CCVersion()
    local node = self:getNode():findChild("panel/panel1")
    self:bShow(false)
    if node:findChild("rtxt") then
        node:findChild("rtxt"):setVisible(false)
    end
    local sv = node:findChild("panel1/scrollView1")
    local Itemtbl = CC.Excel.Shop_KD
    for i = 1, sv:getChildrenCount() do
        sv:findChild("item".. i):onClick(function()
            kk.msgbox.showOk("目前暂时无法购买")
        end)
        sv:findChild("item".. i.."/image1"):loadTexture(Itemtbl[i].Icon, 1)
    end
end
return ctrl