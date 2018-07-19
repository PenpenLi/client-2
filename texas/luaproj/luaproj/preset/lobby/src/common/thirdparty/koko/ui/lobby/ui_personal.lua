local _G = _G
local CC = require "comm.CC"
local data = require("koko.data")
local UIPersonalInfo = require("koko.ui.lobby.UIPersonal").UIPersonalInfo

local ctrl = class("kkPersonal", kk.view)

function ctrl:ctor()
    self:setCsbPath("koko/ui/lobby/personal.csb")
    self:setAnimation(kk.animScale:create())
    CC.UIMgr:Load(UIPersonalInfo)
end
function ctrl:onDestroy()
    kk.uimgr.unload(self.safe)
    kk.uimgr.unload(self.box)
    CC.UIMgr:Unload(UIPersonalInfo)
end

function ctrl:onInit(node)
    node:findChild("panel/btnClose"):onClick(mkfunc(kk.uimgr.unload, self))
    node:findChild("panel/btnPage1"):onClick(function() self:onPageClicked(1) end)
    node:findChild("panel/btnPage2"):onClick(function() self:onPageClicked(2) end)
    node:findChild("panel/btnPage3"):onClick(function() self:onPageClicked(3) end)

    local main = node:findChild("panel/main")
    self.safe = kk.uimgr.load("koko.ui.lobby.ui_personal_safe", main)
    if CC.Player.bankPsw == nil or CC.Player.bankPsw == "" then
        --尚未设置保险箱密码
        self.box = kk.uimgr.load("koko.ui.lobby.ui_personal_box_setpwd", main, 1)
        self.type_index = 0
    else
        self.box = kk.uimgr.load("koko.ui.lobby.ui_personal_box", main)
        self.type_index = 1
    end
    CC.UIMgr:Do("UIPersonalInfo","SetParent", main)
    local kUIInfo = CC.UIMgr:Get("UIPersonalInfo")
    if kUIInfo then
        kUIInfo.kNode:setPosition(_G.cc.p(0, 0))
    end
    self:_showPage(1)
end

function ctrl:onPageClicked(tag)
    if tag == 3 then
        if CC.Player.secMobile == nil or CC.Player.secMobile == "" then
            kk.msgbox.showOkCancel("您当前的账号尚未绑定安全手机，请绑定安全手机后使用", function(is_ok)
                if is_ok then
                    self:_showPage(2)
                    self.safe:refreshLeftBoxUI(1)
                end
            end, 0, "PersonalSafeBox")
            return
        end
    end
    self:_showPage(tag)
end

function ctrl:_showPage(idx)
    local cfg = 
    {
        [false] = "koko/atlas/all_common/title/0001.png",
        [true] = "koko/atlas/all_common/title/0002.png",
    }
    local panel = self:getNode():findChild("panel")
    local btn1 = panel:findChild("btnPage1")
    local btn2 = panel:findChild("btnPage2")
    local btn3 = panel:findChild("btnPage3")
    local txt1 = btn1:findChild("txt")
    local txt2 = btn2:findChild("txt")
    local txt3 = btn3:findChild("txt")
    btn1:ignoreContentAdaptWithSize(true)
    btn2:ignoreContentAdaptWithSize(true)
    btn3:ignoreContentAdaptWithSize(true)
    btn1:loadTexture(cfg[idx == 1], 1)
    btn2:loadTexture(cfg[idx == 2], 1)
    btn3:loadTexture(cfg[idx == 3], 1)
    txt1:setPositionX(btn1:getContentSize().width / 2)
    txt2:setPositionX(btn2:getContentSize().width / 2)
    txt3:setPositionX(btn3:getContentSize().width / 2)

    CC.UIMgr:Do("UIPersonalInfo","SetVisible", idx == 1)
    self.safe:setVisible(idx == 2)
    self.box:setVisible(idx == 3)
    if self.type_index == 0 then
        self.box:refreshPhoneInfo()
    end
end

return ctrl
