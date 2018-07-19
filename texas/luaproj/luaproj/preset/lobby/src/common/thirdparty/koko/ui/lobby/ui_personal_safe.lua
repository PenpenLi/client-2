local data = require("koko.data")
local CC = require("comm.CC")

--左边框按钮类型
local bindPhone = 1
local bindEmail = 2
local bindIdcard = 3
local pswManage = 4

--按钮状态
local btn_selected = 12
local btn_normal = 11

-- 按钮当前选定
local type = 1

-- 右框控件数组
local  boxArray = {}

--各种右框内容
local phone_box = nil 
local email_box = nil 
local idcard_box = nil
local psw_box = nil

local ctrl = class("kkPersonalSafe", kk.view)

--===========生命周期============--
function ctrl:ctor()
    self:setCsbPath("koko/ui/lobby/personal_safe.csb")
end

function ctrl:onInit(node)
    local bindPhoneBtn = node:findChild("panel/bindPhoneBtn")
    bindPhoneBtn:onClick(function()
        return self:buttonClickedAction(bindPhone)
    end)
    bindPhoneBtn:ignoreContentAdaptWithSize(true)

    local bindEmailBtn = node:findChild("panel/bindEmailBtn")
    bindEmailBtn:onClick(function()
        return self:buttonClickedAction(bindEmail)
    end)
    bindEmailBtn:ignoreContentAdaptWithSize(true)

    local bindIdcardBtn = node:findChild("panel/bindIdcardBtn")
    bindIdcardBtn:onClick(function()
        return self:buttonClickedAction(bindIdcard)
    end)
    bindIdcardBtn:ignoreContentAdaptWithSize(true)

    local pswManageBtn = node:findChild("panel/pswManageBtn")
    pswManageBtn:onClick(function()
        return self:buttonClickedAction(pswManage)
    end)
    pswManageBtn:ignoreContentAdaptWithSize(true)

    local contentSp = self:getNode():findChild("content")
    local posX = contentSp:getPositionX()
    local posY = contentSp:getPositionY()

    phone_box = require("koko.ui.lobby.ui_personal_safe_phone"):create(cc.p(posX,posY)):install(self:getNode())
    email_box = require("koko.ui.lobby.ui_personal_safe_email"):create(cc.p(posX,posY)):install(self:getNode())
    idcard_box = require("koko.ui.lobby.ui_personal_safe_idcard"):create(cc.p(posX,posY)):install(self:getNode())
    psw_box = require("koko.ui.lobby.ui_personal_safe_psw"):create(cc.p(posX,posY)):install(self:getNode())

  --[[ if CC.Player.partyName == "wx" or CC.Player.partyName == "qq" then
        pswManageBtn:setVisible(false)
   end
  ]]--
  
    table.insert(boxArray,phone_box)
    table.insert(boxArray,email_box)
    table.insert(boxArray,idcard_box)
    table.insert(boxArray,psw_box)

    self:refreshLeftBoxUI()
end

function ctrl:onDestroy()
    boxArray = {}
    type = 1
    phone_box = nil 
    email_box = nil 
    idcard_box = nil
    psw_box = nil
end

--===========点击事件==========--
function ctrl:buttonClickedAction(btn_type)
    if btn_type == 4 and (CC.Player.secMobile == nil or CC.Player.secMobile == "") then
        kk.msgbox.showOkCancel("请先绑定手机！", function(is_ok)
            if is_ok then
                type = 1
                self:refreshLeftBoxUI()
            end
        end, 0, "PersonalSafeBox")
        return
    end

    type = btn_type
    self:refreshLeftBoxUI()
end

--===========文件内调用（私有方法）==========--
--刷新UI
function ctrl:refreshLeftBoxUI(n)
    type = n or type
    for i=1, #boxArray do
        boxArray[i]:getNode():setVisible(false)
    end
    boxArray[type]:getNode():setVisible(true)

    local typeArray = {"bindPhoneBtn","bindEmailBtn","bindIdcardBtn","pswManageBtn"}
    local node = self:getNode():findChild("panel")
    for i=1,4 do
        local btn = node:findChild(typeArray[i])
        if i == type then
            --当前选定的按钮
            btn:loadTexture(self:getImagePathWithBtnType(i,btn_selected),1)
        else
            --失去焦点的按钮 
            btn:loadTexture(self:getImagePathWithBtnType(i,btn_normal),1)   
        end
    end
end
--返回文件路径名
function ctrl:getImagePathWithBtnType(btn_type,state)
    local name = ""
    if state == btn_selected then
        name = "koko/atlas/all_common/button/left.png"    
    else
        name = "koko/atlas/all_common/button/left_selet.png" 
    end
    return name
end

return ctrl
