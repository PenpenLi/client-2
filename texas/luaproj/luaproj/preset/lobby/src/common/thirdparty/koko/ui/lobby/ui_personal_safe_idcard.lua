local data = require("koko.data")
local CC = require("comm.CC")
local web = require("web")

local show_type = 0
local show_pos = cc.p(0,0)

local view = class("kkPersonalSafePhone", kk.view)

local isName = false
local isNumber = false

-- type 如果绑定身份证传1，显示身份证传2
function view:ctor(pos)
    if CC.Player.idcard == nil or CC.Player.idcard == "" then
        show_type = 1
    else
        show_type = 2
    end
    show_pos = pos
    self:setCsbPath("koko/ui/lobby/personal_safe_idcard.csb")
end

function view:onInit(node)
    node:setPosition(show_pos)
    self:createEditBoxUI(node)
    if show_type == 1 then
       --绑定身份证
       self:setupButtons(node)
       local sp = node:findChild("showCard")
       sp:setVisible(false)
    else
       --解除绑定
       local sp = node:findChild("bindIdcard")
       sp:setVisible(false)
       local text = node:findChild("showCard/cardNumText")
       text:setString("身份证号：" .. self:idNumberToFormat(CC.Player.idcard))
    end
end

--================文件内调用（私有）==============--
function view:setupButtons(node)
    --看不清楚按钮
    local reGetButton = node:findChild("bindIdcard/reGetBtn")
    reGetButton:onClick(function()
        self:reObtainCode()
    end)

    --确认绑定
    local bind = node:findChild("bindIdcard/bindBtn")
    bind:onClick(function()
        self:comfirmBindIdcard()
    end)
end

function view:createEditBoxUI(node)
    --验证码
    local codeImage = node:findChild("bindIdcard/codeImage")
    self:loadNetImage(codeImage)

    --真实姓名
    local namePanel = node:findChild("bindIdcard/namePanel")
    --真实姓名输入框
    local editName = kk.edit.createAnyWithParent(namePanel,"editName","请输入真实姓名")
    editName:setPlaceholderFontColor(cc.c4b(133,118,91,255))
    editName:setFontColor(cc.c4b(129,46,3,255))
    editName:registerScriptEditBoxHandler(function(eventname, sender)
        self:editBoxHandle(eventname, sender)
    end)
    editName:setTag(1001)

    local numberPanel = node:findChild("bindIdcard/numberPanel")
    --身份证号输入框
    local editNumber = kk.edit.createAnyWithParent(numberPanel,"editNumber","请输入身份证号")
    editNumber:setPlaceholderFontColor(cc.c4b(133,118,91,255))
    editNumber:setFontColor(cc.c4b(129,46,3,255))
    editNumber:registerScriptEditBoxHandler(function(eventname, sender)
        self:editBoxHandle(eventname, sender)
    end)
    editNumber:setTag(1002)

    local codePanel = node:findChild("bindIdcard/codePanel")
    --验证码输入框
    local editCode = kk.edit.createAnyWithParent(codePanel,"editCode","请输入验证码")
    editCode:setPlaceholderFontColor(cc.c4b(133,118,91,255))
    editCode:setFontColor(cc.c4b(129,46,3,255))
    editCode:registerScriptEditBoxHandler(function(eventname, sender)
        self:editBoxHandle(eventname, sender)
    end)
    editCode:setTag(1003)
end

function view:loadNetImage(image)
    web.bindCodeWithControl(image)
end

--设置输入框右边的提示图案
function view:setupTip(tag, isOk)
    local child = ""
    if tag == 1001 then
        child = "bindIdcard/nameTip"
    else  
        child = "bindIdcard/numTip"  
    end

    local tip = self:getNode():findChild(child)
    if isOk then
        tip:loadTexture("koko/atlas/login/2004.png", 1)
    else
        tip:loadTexture("koko/atlas/login/2003.png", 1)
    end
end

-- 身份证号格式化显示
function view:idNumberToFormat(num)
    if #num >= 8 then
        local pre = string.sub(num, 1, 6)
        local fix = string.sub(num, #num - 1, -1)
        return pre .. "**********" .. fix
    end
    return ""
end

--=================点击响应事件================--
--重新获取验证码
function view:reObtainCode()
    local codeImage = self:getNode():findChild("bindIdcard/codeImage")
    self:loadNetImage(codeImage)
end

--确认绑定
function view:comfirmBindIdcard()
    if not isName then
        kk.msgup.show("请输入正确的名字")
        return
    end

    if not isNumber then
        kk.msgup.show("请输入正确的身份证号")
        return
    end

    local  num = self:getNode():findChild("bindIdcard/numberPanel/editNumber")
    local  name = self:getNode():findChild("bindIdcard/namePanel/editName")
    local  code = self:getNode():findChild("bindIdcard/codePanel/editCode")
    web.sendBindIdnumberReq(num:getText(),name:getText(),code:getText(),CC.Player.uid,CC.Player.appKey,handler(self, self.bindIdnumberCallback))
end

--==================回调事件==================--
--编辑框回调
function view:editBoxHandle(eventname, sender)
    if eventname == "ended" then
        if sender:getTag() == 1001 then 
            local  tip = self:getNode():findChild("bindIdcard/nameTip")
            tip:setVisible(true)
            --真实姓名编辑框
            if #sender:getText() == 0 then
                self:setupTip(1001, false)
                kk.msgup.show("请输入真实姓名")
                isName = false
                return
            end

            if not CC.Check:RealName(sender:getText()) then 
                self:setupTip(1001, false)
                kk.msgup.show("请正确输入真实姓名")
                isName = false
                return 
            end

            self:setupTip(1001, true)
            isName = true
        elseif sender:getTag() == 1002 then
            --身份证编辑框
            local numTip = self:getNode():findChild("bindIdcard/numTip")
            numTip:setVisible(true)
            if #sender:getText() == 0 then
                self:setupTip(1002, false)
                kk.msgup.show("请输入身份证号码")
                isNumber = false
                return
            end
    
            if not CC.Check:IDCard(sender:getText()) then 
                self:setupTip(1002, false)
                kk.msgup.show("身份证号码有误，请重新输入")
                isNumber = false
                return 
            end
    
            self:setupTip(1002, true)
            isNumber = true
        end
    end
end

--绑定回调
function  view:bindIdnumberCallback(t)
    if t.success == true then
        kk.msgbox.showOk("绑定成功")
        CC.Player.idcard = self:getNode():findChild("bindIdcard/numberPanel/editNumber"):getText()
        local sp = self:getNode():findChild("showCard")
        sp:setVisible(true)
        local text = self:getNode():findChild("showCard/cardNumText")
        text:setString("身份证号：" .. self:idNumberToFormat(CC.Player.idcard))
        local sp1 = self:getNode():findChild("bindIdcard")
        sp1:setVisible(false)
        return
    end
    kk.msgup.show(t.message)
end

return view