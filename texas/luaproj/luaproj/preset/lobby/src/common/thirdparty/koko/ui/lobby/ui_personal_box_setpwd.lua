local data = require("koko.data")
local CC = require("comm.CC")

local ctrl = class("kkPersonalBoxSetpwd", kk.view)

local show_type = 1
local isPwd = false
local isCfm = false
local isCode = false
local secondCount = 60

--type表示要展示的类型 1表示未设置密码 2表示找回密码
function ctrl:ctor(type)
    self:setCsbPath("koko/ui/lobby/personal_box_setpwd.csb")
    show_type = type
end

function ctrl:onInit(node)
    local phone = node:findChild("panel/phone")
    phone:setString(self:phoneToFormat(CC.Player.secMobile))
    self:createEditboxs(node)
    self:setupButtons(node)
    local  star = node:findChild("panel/starTip")
    local  txt  = node:findChild("panel/txtTip")
    if show_type == 1 then
    else
        star:setVisible(false)
        txt:setVisible(false)
    end
end

--==============公有方法==============--
--刷新手机显示
function ctrl:refreshPhoneInfo()
    local phone = self:getNode():findChild("panel/phone")
    phone:setString(self:phoneToFormat(CC.Player.secMobile))
end

--==============内部调用（私有）==============--
--手机格式化显示
function ctrl:phoneToFormat(phone)
    if #phone ~= 0 then
        local pre = string.sub(phone, 1, 3)
        local fix = string.sub(phone, #phone - 1, -1)
        return pre .. "******" .. fix
    end
    return ""
end

-- 验证验证码
function ctrl:matchValidateCode(code)
    local fmt = (string.match(code,"%d+") == code)
    local lenght = #code == 6
    return (fmt and lenght)
end

--创建输入框
function ctrl:createEditboxs(node)
    --金库密码编辑框
    local pwdPanel = node:findChild("panel/pwdPanel")
    local editPwd = kk.edit.createPasswordWithParent(pwdPanel, "editPwd", "请输入6-12位数字或字母")
    editPwd:setPlaceholderFontColor(cc.c4b(133, 118, 91, 255))
    editPwd:setFontColor(cc.c4b(129, 46, 3, 255))
    editPwd:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editboxHandle(eventname,sender) 
    end) 
    editPwd:setTag(1001)

    --确认密码编辑
    local cfmPanel = node:findChild("panel/cfmPanel")
    local editCfm = kk.edit.createPasswordWithParent(cfmPanel, "editCfm", "请再一次输入密码")
    editCfm:setPlaceholderFontColor(cc.c4b(133, 118, 91, 255))
    editCfm:setFontColor(cc.c4b(129, 46, 3, 255))
    editCfm:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editboxHandle(eventname,sender) 
    end) 
    editCfm:setTag(1002)

    --验证码编辑框
    local codePanel = node:findChild("panel/codePanel")
    local editCode = kk.edit.createAnyWithParent(codePanel, "editCode", "请输入验证码")
    editCode:setPlaceholderFontColor(cc.c4b(133, 118, 91, 255))
    editCode:setFontColor(cc.c4b(129, 46, 3, 255))
    editCode:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editboxHandle(eventname,sender) 
    end) 
    editCode:setTag(1003) 
end

--设置按钮
function ctrl:setupButtons(node)
    local getCodeBtn = node:findChild("panel/codeBtn")
    getCodeBtn:onClick(function()
        self:getValidateCode()
    end)

    local cfmBtn = node:findChild("panel/cfmBtn")
    cfmBtn:onClick(function()
        self:cfmToSend()
    end)
end

--设置输入框右边的提示图案
function ctrl:setupTip(tag, isOk)
    local child = ""
    if tag == 1001 then
        child = "panel/pwdTip"
    elseif tag == 1002 then
        child = "panel/cfmTip"
    else  
        child = "panel/codeTip"  
    end

    local tip = self:getNode():findChild(child)
    if isOk then
        tip:loadTexture("koko/atlas/login/2004.png", 1)
    else
        tip:loadTexture("koko/atlas/login/2003.png", 1)
    end
end

--==============点击响应=============--
--获取验证码
function ctrl:getValidateCode()
    secondCount = 60
    local codeBtn = self:getNode():findChild("panel/codeBtn")
    local txt = self:getNode():findChild("panel/secTxt")
    txt:setVisible(true)
    txt:setString("60")
    codeBtn:loadTexture("koko/atlas/login/2009.png", 1)
    codeBtn:setTouchEnabled(false)
    web.sendPhoneCodeReq(CC.Player.secMobile,handler(self,self.getValidateCodeCallback))
    txt:schedule(handler(self, self.timeCountdown), 1, "countTimer")
end

--确认修改
function ctrl:cfmToSend()
    if not isPwd then
        kk.msgup.show("请正确输入密码，6-12位数字或字母")
        return
    end

    if not isCfm then
        kk.msgup.show("两次输入密码不一致，请重新输入")
        return
    end

    if not isCode then
        kk.msgup.show("验证码格式错误")
        return
    end
    local pwd = self:getNode():findChild("panel/pwdPanel/editPwd")
    local code = self:getNode():findChild("panel/codePanel/editCode")
    web.sendSetBoxPwdReq(pwd:getText(),CC.Player.secMobile,code:getText(), CC.Player.uid,CC.Player.appKey,handler(self,self.cfmToSendCallback))
end

--==============回调事件=============--
--编辑框回调
function ctrl:editboxHandle(eventname,sender)
    if eventname == "ended" then
        if sender:getTag() == 1001 then
            local tip = self:getNode():findChild("panel/pwdTip")
            tip:setVisible(true)
            --新密码输入框(输入密码为空)
            if #sender:getText() == 0 then
                kk.msgup.show("请输入密码")
                self:setupTip(1001,false)
                isPwd = false 
                return
            end
            --新密码输入格式错误
            if CC.Check:Password(sender:getText()) ~= true then
                kk.msgup.show("请正确输入密码，6-12位数字或字母")
                self:setupTip(1001,false)
                isPwd = false
                return
            end

            isPwd = true
            self:setupTip(1001,true)
            return 
        end

        if sender:getTag() == 1002 then
            local tip = self:getNode():findChild("panel/cfmTip")
            tip:setVisible(true)
            --确认密码输入框
            if #sender:getText() == 0 then
                kk.msgup.show("请再输入一次密码进行确认")
                self:setupTip(1002,false)
                isCfm = false
                return
            end

            if sender:getText() ~= self:getNode():findChild("panel/pwdPanel/editPwd"):getText() then
                kk.msgup.show("两次密码不一致")
                self:setupTip(1002,false)
                isCfm = false 
                return
            end

            isCfm = true 
            self:setupTip(1002,true)
            return 
        end

        if sender:getTag() == 1003 then
            local tip = self:getNode():findChild("panel/codeTip")
            tip:setVisible(true)
            if #sender:getText() == 0 then
                kk.msgup.show("请输入验证码")
                self:setupTip(1003,false)
                isCode = false 
                return 
            end

            if self:matchValidateCode(sender:getText()) == false then
                kk.msgup.show("验证码格式错误，请重新输入")
                self:setupTip(1003,false)
                isCode = false 
                return 
            end

            isCode = true 
            self:setupTip(1003,true)
            return 
        end
    end
end

--定时器回调
function ctrl:timeCountdown(dt)
    local codeBtn = self:getNode():findChild("panel/codeBtn")
    local txt = self:getNode():findChild("panel/secTxt")
    secondCount = secondCount - 1
    if secondCount <= 0 then
        txt:unschedule("countTimer")
        txt:setVisible(false)
        codeBtn:loadTexture("koko/atlas/all_common/button/3014.png", 1)
        codeBtn:setTouchEnabled(true)
    else
        txt:setString((secondCount > 10 and tostring(secondCount)) or "0" .. tostring(secondCount))    
    end
end

--获取验证码请求回调
function ctrl:getValidateCodeCallback(t)
    if t.success == true then
        kk.msgup.show("验证码已发送")
        return 
    end
    kk.msgup.show(t.message)    
end

--确认修改请求回调
function ctrl:cfmToSendCallback(t)
    if t.success then
        kk.msgup.show("修改成功")
        local pwd = self:getNode():findChild("panel/pwdPanel/editPwd")
        CC.Player.bankPsw = pwd:getText()
        require("koko.ui.lobby.ui_personal_box"):create():install(self:getNode())
        return
    end
    kk.msgup.show(t.message)
end

return ctrl