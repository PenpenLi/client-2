local data = require("koko.data")
local CC = require "comm.CC"
local ui_recharge_list = require("koko.ui.lobby.ui_recharge_list").ui_recharge_list

local ctrl = class("kkShop", kk.view)
function ctrl:ctor()
    self:setCsbPath("koko/ui/lobby/shop.csb")
    self:setAnimation(kk.animScale:create())
end

function ctrl:onInit(node)
    self.currentPage = 1

    local panNode = node:findChild("panel")
    self.scrllView1 = panNode:findChild("panel1/scrollView1")
    self.scrllView2 = panNode:findChild("panel1/scrollView2")
    self.scrllView3 = panNode:findChild("panel1/scrollView3")
    panNode:findChild("btnRecord"):onClick(handler(self, self.onRecord), 1.03) 
    panNode:findChild("left_bar1"):onClick(function() self:showPage(1) end)
    panNode:findChild("left_bar2"):onClick(function() self:showPage(2) end)
    panNode:findChild("left_bar3"):onClick(function() self:showPage(3) end)
    panNode:findChild("bgGold/goldGroup/btnAddGold"):onClick(function()
        kk.uimgr.load("koko.ui.lobby.ui_recharge")
        kk.uimgr.call("kkRecharge", "showPage", 2)
    end)
    panNode:findChild("bgGold/goldGroup/btnAddGold"):setVisible(false)
    
    panNode:findChild("bgGold/diamondGroup/btnAddGold"):onClick(function()
        kk.uimgr.load("koko.ui.lobby.ui_recharge")
        kk.uimgr.call("kkRecharge", "showPage", 1)
    end)
    panNode:findChild("bgGold/diamondGroup/btnAddGold"):setVisible(false)
    panNode:findChild("close"):onClick(mkfunc(kk.uimgr.unload, self))
    self:refreshGold()
    self:refreshScrollView()
    self:showPage(1)
    
    kk.event.addListener(node, E.EVENTS.gold_changed, handler(self, self.refreshGold))
    kk.event.addListener(node, E.EVENTS.diamond_changed, handler(self, self.refreshGold))
    kk.event.addListener(node, E.EVENTS.ticked_changed, handler(self, self.refreshGold))
end

function ctrl:showPage(index)
    self.currentPage = index
    for i = 1, 3 do
        local node = self:getNode():findChild("panel/left_bar"..i)
        node:ignoreContentAdaptWithSize(true)
        if i == index then
            node:loadTexture("koko/atlas/all_common/title/0002.png", 1)
        else
            node:loadTexture("koko/atlas/all_common/title/0001.png", 1)
        end
        local txt = node:findChild("text")
        txt:setPositionX(node:getContentSize().width/2)  
    end
    self.scrllView1:setVisible(index == 1)
    self.scrllView2:setVisible(index == 2)
    self.scrllView3:setVisible(index == 3)
end
function ctrl:HideBar(bHideBar)
    self:getNode():findChild("panel/left_bar1"):setVisible(bHideBar)
    self:getNode():findChild("panel/left_bar2"):setVisible(bHideBar)
    self:getNode():findChild("panel/left_bar3"):setVisible(bHideBar)
end
function ctrl:refreshScrollView(tParam)
    local imagePath = {  --BuyType 2：券   1：k豆  0：钻石 
    "koko/atlas/shop/2003.png",
    "koko/atlas/lobby/1011.png",}
    imagePath[0] = "koko/atlas/lobby/1030.png"

    local signPath = {  -- 0 正常 1热卖 2打折  3礼包
    "koko/atlas/shop/2057.png",
    "koko/atlas/shop/2061.png",
    "koko/atlas/shop/2060.png",}

    local tVal = CC.PlayerMgr.Shop
    self.tXX = tVal:getDataByType("ShopXX")
    self.tDJ = tVal:getDataByType("ShopDJ")
    self.tLP = tVal:getDataByType("ShopLP")
    self.childPath = {}
    if not tVal.bExit then return end

    local kScroll_xx = CC.ScrollView:Create{Node = self:getNode():findChild("panel/panel1/scrollView1")}
    CC.Node:Array{Node = kScroll_xx.kNode:findChild("item1"), X = _G.math.ceil(#self.tXX/2) , Y = 2, XD = 278, YD = 190}
    kScroll_xx:Fix({Left = 2, Keep = true})

    for i = 1, _G.math.ceil(#self.tXX/2)*2 do
        local item = self:getNode():findChild("panel/panel1/scrollView1/item"..i)
        if i <= #self.tXX then
            local t = self.tXX[i]
            item:findChild("headIco"):loadTexture(_G.kk.util.isExitPathOnPlist(t.ico) and t.ico or "koko/atlas/shop/2043.png", 1)
            item:findChild("sign"):loadTexture(signPath[t.sign == 0 and 1 or t.sign], 1)
            item:findChild("sign"):setVisible(t.sign ~= 0)
            item:findChild("text1"):setString(t.name)
            local price = _G.string.split(t.price, ",")
            item:findChild("frame3/image"):loadTexture(imagePath[_G.tonumber(price[2])], 1)
            item:findChild("frame3/text"):setString(price[3])
            --local give = _G.string.split(t.give, ",")
            item:findChild("frame2/image"):loadTexture(imagePath[_G.tonumber(t.give.iID)], 1)
            item:findChild("frame2/text"):setString(t.give.iCount)
            item:findChild("days"):setString(t.validday .. "天")
            item:setTag(t.pid)
            item:onClick(handler(self, self.onBuy), 1.01)
            self.childPath[t.pid] = "panel/panel1/scrollView1/item"..i
        else
            item:removeFromParent()
        end
    end

    for i = 2, 3 do
        local tData = self.tDJ
        if i == 3 then tData = self.tLP end
        local lineNum = math.ceil(#tData/2)
        if #tData <= 10 then
            lineNum = 5
        end
        if #tData < 5 then
            lineNum = 4
        end
        local kScroll = CC.ScrollView:Create{Node = self:getNode():findChild("panel/panel1/scrollView"..i)}
        CC.Node:Array{Node = kScroll.kNode:findChild("item1"), X = lineNum, Y = 2, XD = 190, YD = 190}
        kScroll:Fix({Left = 2, Keep = true})

        for j = 1, lineNum*2 do
            local item = self:getNode():findChild("panel/panel1/scrollView".. i .."/item"..j)
            if j <= #tData then
                local t = tData[j]
                item:findChild("image1"):loadTexture(_G.kk.util.isExitPathOnPlist(t.ico) and t.ico or "koko/atlas/shop/2043.png", 1)
                item:findChild("text"):setString(t.name)
                item:findChild("sign"):loadTexture(signPath[t.sign == 0 and 1 or t.sign], 1)
                item:findChild("sign"):setVisible(t.sign ~= 0)
                item:findChild("maxBuy"):setString(string.format("您今日还可购买1/%s", t.dayLimit))
                item:findChild("maxBuy"):setVisible(tonumber(t.dayLimit) ~= 0)
                local price = _G.string.split(t.price, ",")
                item:findChild("frame2/image"):loadTexture(imagePath[_G.tonumber(price[2])], 1)
                item:findChild("frame2/text"):setString(price[2] == "2" and tonumber(price[3])/100 or price[3])
                item:setTag(t.pid)
                item:onClick(handler(self, self.onBuy), 1.03)
                self.childPath[t.pid] = "panel/panel1/scrollView".. i .."/item"..j
            else
                item:removeFromParent()
            end
        end
    end
    local tList1 = CC.PlayerMgr.Shop.ShopBuyNum
    for k, v in pairs(tList1) do
        local tList2 = CC.PlayerMgr.Shop.ShopList[v.pid]
        local node = self:getNode():findChild(self.childPath[v.pid])
        if node and node:findChild("maxBuy") then
            node:findChild("maxBuy"):setString(string.format("您今日还可购买%d/%s", v.num, tList2.dayLimit))
        end
    end
end
function ctrl:RefreshScreen(tVal)
    local tList = CC.PlayerMgr.Shop.ShopList[tVal.pid_]
    local node = self:getNode():findChild(self.childPath[tVal.pid_])
    if node and tList then
        node:findChild("maxBuy"):setString(string.format("您今日还可购买%d/%s", tVal.num_, tList.dayLimit))
    end
end
function ctrl:onRecord()
    CC.UIMgr:Load(ui_recharge_list)
    CC.UIMgr:Call("ui_recharge_list", {iType = "商城"})
end
--  购买
function ctrl:onBuy(sender)
    local tVal = CC.PlayerMgr.Shop

    local tInfo = CC.PlayerMgr.Shop.ShopList[tonumber(sender:getTag())]
    local tPrice = _G.string.split(tInfo.price, ",")
    local bOK = false
    if tPrice[2] and tPrice[2] == "2" then
		bOK = CC.Sample.Check:Ticket(tonumber(tPrice[3]), true)
	elseif tPrice[2] and tPrice[2] == "1" then
		bOK = CC.Sample.Check:KB(tonumber(tPrice[3]), true)
	elseif tPrice[2] and tPrice[2] == "0" then
        bOK = CC.Sample.Check:Diamond(tonumber(tPrice[3]), true)
    else
	end
    if not bOK then return end

    if self.currentPage == 1 then
        local index = CC.String:GetIndex(sender:getName())
        local price = _G.string.split(self.tXX[index].price, ",")
        -- local str = "是否确认支付".. price[3] .. "钻石,购买头像".. self.tXX[index].name
        -- local function callback(is_ok)
        --     if is_ok then
        --         --  支付
        --         CC.proto2.sendBuyItemReq(self.tXX[index].pid, 1, "", function(errcode, errmsg)
        --             if errcode ~= 1 then
        --                 kk.msgup.show(errmsg)
        --             else
        --                 kk.uimgr.load("koko.ui.lobby.ui_shop_buy_success", "", self.tXX[index].pid, 1)
        --                 kk.uimgr.unload(self)
        --             end
        --         end)
        --     end
        -- end
        -- kk.msgbox.showOkCancel(str, callback)
        kk.uimgr.load("koko.ui.lobby.ui_shop_gift", "", self.tXX[index].pid)
    else
        local path = "koko.ui.lobby.ui_shop_gift"
        local i = CC.String:GetIndex(sender:getName())
        local tdata = self.tDJ
        if self.currentPage == 3 then 
            tdata = self.tLP 
        end
        local price = _G.string.split(tdata[i].price, ",")
        if string.find(tdata[i].name, "话费券") then    
            if tonumber(price[3]) > CC.Player.ticket then kk.msgup.show("您的奖券不足") return end
            path = "koko.ui.lobby.ui_shop_huafei"
        end
        kk.uimgr.load(path, "", tdata[i].pid)
    end
end

function ctrl:refreshGold()
    local node = self:getNode():findChild("panel")
    node:findChild("bgGold/goldGroup/goldBg/txtGold"):setString(CC.Player.gold)
    node:findChild("bgGold/diamondGroup/diamondBg/txtDiamond"):setString(CC.Player.diamond)
    local txtContent = kk.util.convertMoneyToRmb(CC.Player.ticket)
    node:findChild("bgGold/ticketGroup/ticketBg/txtTicket"):setString(txtContent)
end
return ctrl