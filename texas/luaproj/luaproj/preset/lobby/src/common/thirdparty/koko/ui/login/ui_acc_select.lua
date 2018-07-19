
local _G = _G
local CC = require("comm.CC")

local ctrl = class("kkAccSelect", kk.view)

function ctrl:ctor(tVal)
    self:setCsbPath("koko/ui/login/acc_select.csb")
    self:setAnimation(kk.animScale:create())
    self.choos = tVal or {}
    self.pageCount = math.ceil(#self.choos/6)
    self.ipageCurIdx = 0
end

function ctrl:onInit(node)
    local panel = node:findChild("panel")
    local pv = panel:findChild("PageView")
    for i = 1, self.pageCount do
        local layout = ccui.Layout:create()
        layout:setContentSize(pv:getContentSize())
        layout:setName("layPage".. i - 1)
        layout:setClippingEnabled(true)
        self:createItem(layout, i)
        pv:addPage(layout)
    end
    pv:addEventListener(handler(self, self.onPageChanged))

    panel:findChild("btnLeft"):onClick(handler(self, self.btnChangePage1))
    panel:findChild("btnRight"):onClick(handler(self, self.btnChangePage2))
    self:Refresh()
end
function ctrl:Refresh()
    local panel = self:getNode():findChild("panel")
    panel:findChild("PageView"):scrollToPage(self.ipageCurIdx)
    panel:findChild("btnLeft"):setVisible(self.ipageCurIdx ~= 0)
    panel:findChild("btnRight"):setVisible(self.ipageCurIdx ~= self.pageCount - 1)
end

function ctrl:createItem(parent, n)
    local sz = self:getNode():findChild("panel/PageView"):getContentSize()
    local w, h = sz.width, sz.height
    local flg = 1
    for i = (n - 1) * 6 + 1, #self.choos do
        if flg > 6 then
            return
        end
        local layout = ccui.Layout:create()
        layout:setName("layItem"..flg)
        layout:setTag(i)
        layout:setContentSize(cc.size(105, 120))
        layout:setBackGroundColorType(LAYOUT_COLOR_SOLID)
        layout:setBackGroundColor(cc.c3b(0xC8, 0xB4, 0x9E))
        layout:setBackGroundColorOpacity(100)
        layout:setAnchorPoint(0.5,0.5)
        local posx = w/3 * (flg > 3 and flg - 3 or flg) - w/6
        local posy = h/2 + (flg > 3 and -h/4 or h/4) + 10
        layout:setPosition(cc.p(posx, posy))

        local head = ccui.ImageView:create()
        local headId = tonumber(self.choos[i].headpic_name) or 0
        head:loadTexture("koko/atlas/head_ico/"..headId..".png", 1)
        head:setAnchorPoint(0.5, 0.5)
        head:setScale(0.75)
        head:setName("head")
        head:setPosition(cc.p(52, 56))
        layout:addChild(head)

        local hint = ccui.ImageView:create()
        hint:loadTexture(self.choos[i].STATUS == "1" and "koko/atlas/common/2004.png" or "koko/atlas/common/2005.png", 1)
        hint:setAnchorPoint(0, 1)
        hint:setName("hint")
        hint:setPosition(cc.p(0, 120))
        layout:addChild(hint)

        --名称
        local name = cc.Label:create()
        local ttf = {}
        ttf.fontFilePath = "font/system.ttf"
        ttf.fontSize = 16
        name:setTTFConfig(ttf)
        name:setAnchorPoint(0.5, 0.5)
        name:setName("name")
        name:setString(self.choos[i].nickname)
        name:setTextColor(cc.c3b(0x81, 0x2e, 0x03))
        name:setPosition(cc.p(50, -10))

        layout:onClick(handler(self, self.onLogin), 1.03)
        layout:addChild(name)
        parent:addChild(layout)
        flg = flg + 1
    end
end
function ctrl:onPageChanged(sender)
    local idx = sender:getCurrentPageIndex()
    self.ipageCurIdx = idx
    self:Refresh()
end
function ctrl:btnChangePage1(sender)
    local idx = self:getNode():findChild("panel/PageView"):getCurrentPageIndex()
    self.ipageCurIdx = idx - 1
    self:Refresh()
end
function ctrl:btnChangePage2(sender)
    local idx = self:getNode():findChild("panel/PageView"):getCurrentPageIndex()
    self.ipageCurIdx = idx + 1
    self:Refresh()
end
function ctrl:onLogin(sender)
    local data = self.choos[sender:getTag()]
    if data and data.STATUS == "1" then
        CC.LoginMgr.Accountlogin(data.iid, data.pwd)
    else
        kk.uimgr.load("koko.ui.login.ui_acc_login", "", data.iid, data.pwd)
        kk.uimgr.unload(self)
    end
end

return ctrl