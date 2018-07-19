local data = require("koko.data")

local ctrl = class("kkSwitchAccount", kk.view)

function ctrl:ctor()
    self:setCsbPath("koko/ui/login/switch_account.csb")
    self:setAnimation(kk.animScale:create())
    self.onBtnOkClickHandler = nil
end

local _svItemWidth = 356
local _svItemHeight = 47

function ctrl:onInit(node)
    self.currentIndex = 1
    self.tbl = {}
    self.accountScroll = node:findChild("panel/ScrollView1")
    self.accountScroll:setScrollBarEnabled(false)
    self:refresh(self.accountScroll)

    node:findChild("panel/btnOk"):onClick(handler(self, self.onOk))
    node:findChild("panel/close"):onClick(mkfunc(kk.uimgr.unload, self))
end

function ctrl:refresh(sv)
    local count = data.entryCache:count()
    local minHeight = sv:getContentSize().height
    sv:setInnerContainerSize(cc.size(_svItemWidth, math.max(minHeight, count * _svItemHeight)))
    self.tbl = data.entryCache:getDataTable()
    for i = 1, #self.tbl do
        local item = self:createItemInfo(self.tbl[i], i)
        if i == 1 and self.tbl[1].logintime == 0 then
            item:findChild("recentplay"):setVisible(false)
        end
        self:addToItemView(sv, item)
    end
    self.currentIndex = 1
end

function ctrl:addToItemView(sv, item)
    local count = sv:getChildrenCount()
    local sz = sv:getInnerContainerSize()
    local pos = cc.p(0, sz.height - (count + 1) * _svItemHeight)
    item:setAnchorPoint(0, 0)
    item:setPosition(pos)
    item:onClick(handler(self, self.switchItem), 1)
    sv:addChild(item)
end

function ctrl:switchItem(sender)
    local name = sender:getName()
    local i = tonumber(string.sub(name, 5))
    self.currentIndex = i

    local parentNode = sender:getParent()
    for i = 1, #self.tbl do
        local node = parentNode:findChild("item"..i)
        if node:getName() == sender:getName() then
            node:findChild("back"):setSpriteFrame("koko/atlas/login/2006.png")
            node:findChild("remove"):setVisible(true)
        else
            node:findChild("back"):setSpriteFrame("koko/atlas/login/2005.png")
            node:findChild("remove"):setVisible(false)  
        end    
    end
end

function ctrl:createItemInfo(tbl, i)
    local item = ccui.Layout:create()
    item:setName("item"..i)
    item:setAnchorPoint(0, 0)
    item:setContentSize(cc.size(_svItemWidth, _svItemHeight))

    --背景
    local back = cc.Sprite:create()
    if i == 1 then
        back:setSpriteFrame("koko/atlas/login/2006.png")
    else 
        back:setSpriteFrame("koko/atlas/login/2005.png")
    end       
    back:setAnchorPoint(0, 0)
    back:setName("back")
    back:setPosition(cc.p(0, 0))
    item:addChild(back)

    --名字
    local name = cc.Label:create()
    local ttf = {}
    ttf.fontFilePath = "font/system.ttf"
    ttf.fontSize = 20
    name:setTTFConfig(ttf)
    name:setAnchorPoint(0, 0)
    name:setName("name")
    name:setString(tbl.name)
    name:setTextColor(cc.c3b(0x81, 0x2e, 0x03))
    name:setPosition(cc.p(140, _svItemHeight / 4 + 3))
    item:addChild(name)
    
    --最近使用
    if i == 1 then
        local recentplay = cc.Label:create()
        local ttf = {}
        ttf.fontFilePath = "font/system.ttf"
        ttf.fontSize = 16
        recentplay:setTTFConfig(ttf)
        recentplay:setAnchorPoint(0, 0)
        recentplay:setName("recentplay")
        recentplay:setString("最近使用")
        recentplay:setTextColor(cc.c3b(0x85, 0x76, 0x5b))
        recentplay:setPosition(cc.p(250, _svItemHeight / 4 + 3))
        item:addChild(recentplay)
    end

    --删除
    local remove = ccui.ImageView:create()
    remove:loadTexture("koko/atlas/login/2003.png", 1)
    remove:setAnchorPoint(0, 0)
    remove:setName("remove")
    remove:setTag(i)
    remove:setPosition(cc.p(320, _svItemHeight / 4 - 2))
    if i == 1 then
        remove:setVisible(true)
    else
        remove:setVisible(false)    
    end
    remove:onClick(handler(self, self.removeItem), 1.1)
    item:addChild(remove)

    return item
end

function ctrl:removeItem(sender)
    local function exit_func(is_ok)
        if is_ok then
            local n = sender:getTag()
            data.entryCache:removeEntryByUid(self.tbl[n].uid)
            self.accountScroll:removeAllChildren()
            self:refresh(self.accountScroll)
            self.currentIndex = 1
            kk.uimgr.call("kkLogin", "setLoginEntry", #self.tbl ~= 0 and self.tbl[1].uid)
        end
    end
    kk.msgbox.showOkCancel("确定删除账号信息吗?", exit_func)
end

function ctrl:onOk(sender)
    local uid = ""
    if #self.tbl >= self.currentIndex then
        uid = self.tbl[self.currentIndex].uid
    end

    kk.uimgr.call("kkLogin", "setLoginEntry", uid)
    kk.uimgr.unload(self)
end

return ctrl