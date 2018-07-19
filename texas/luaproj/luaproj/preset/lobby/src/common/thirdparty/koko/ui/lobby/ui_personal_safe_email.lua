local data = require("koko.data")
local CC = require("comm.CC")

local secondCount = 60
local show_type = 0
local show_pos = cc.p(0, 0)

local bind_email_edit = nil
local bind_code_edit = nil
local bind_code_btn = nil
local bind_btn_txt = nil
local release_code_edit = nil
local release_code_btn = nil
local release_btn_txt = nil

local view = class("kkPersonalSafeEmail", kk.view)

--================生命周期================
function view:ctor(pos)
    if #CC.Player.email ~= 0 then
        show_type = 2
    else
        show_type = 1    
    end
    show_pos = pos
    self:setCsbPath("koko/ui/lobby/personal_safe_email.csb")
end

function view:onInit(node)
    self:createEditBoxs(node)
    self:buttonsSetup(node)
    node:setPosition(show_pos)
    if show_type == 1 then
       --绑定邮箱
       local sp = node:findChild("releaseEmail")
       sp:setVisible(false)
    else
       --解除绑定
       local sp = node:findChild("bindEmail")
       sp:setVisible(false)
       local email_label = node:findChild("releaseEmail/emailLabel")
       email_label:setString(self:emailToFormat(CC.Player.email))
    end
end

function view:onDestroy()
    bind_email_edit = nil
    bind_code_edit = nil
    bind_code_btn = nil
    bind_btn_txt = nil
    release_code_edit = nil
    release_code_btn = nil
    release_btn_txt = nil
end

--=================文件内调用（私有）=================
--创建输入框
function view:createEditBoxs(node)
    --邮箱输入框的占位容器
    local emailPanel = node:findChild("bindEmail/emailPanel")
    --邮箱输入框
    bind_email_edit = kk.edit.createAnyWithParent(emailPanel, "editEmail", "请输入您的邮箱")
    bind_email_edit:setPlaceholderFontColor(cc.c4b(133, 118, 91, 255))
    bind_email_edit:setFontColor(cc.c4b(129, 46, 3, 255))
    bind_email_edit:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editboxHandle(eventname,sender) 
    end) 
    bind_email_edit:setTag(1001)

    --验证码输入框的占位容器
    local codePanel1 = node:findChild("bindEmail/codePanel1")
    --验证码（绑定）输入框
    bind_code_edit = kk.edit.createNumberWithParent(codePanel1, "codeEdit1", "请输入验证码")
    bind_code_edit:setPlaceholderFontColor(cc.c4b(133, 118, 91, 255))
    bind_code_edit:setFontColor(cc.c4b(129, 46, 3, 255))
    bind_code_edit:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editboxHandle(eventname,sender) 
    end) 
    bind_code_edit:setTag(1002)
    
    --验证码输入框占位容器
    local codePanel2 =  node:findChild("releaseEmail/codePanel2")
    --验证码（解除）输入框
    release_code_edit = kk.edit.createNumberWithParent(codePanel2, "codeEdit2", "请输入验证码")
    release_code_edit:setPlaceholderFontColor(cc.c4b(133, 118, 91, 255))
    release_code_edit:setFontColor(cc.c4b(129, 46, 3, 255))
    release_code_edit:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editboxHandle(eventname,sender) 
    end) 
    release_code_edit:setTag(1003)
end

--按钮设置
function view:buttonsSetup(node)
    --确定绑定按钮
    local bindEmailButton = node:findChild("bindEmail/cfmBtn")
    bindEmailButton:onClick(function()
        self:comfirmBindEmail()
    end)

    --获取验证码按钮（绑定邮箱）
    bind_code_btn = node:findChild("bindEmail/bindCodeBtn")
    bind_btn_txt = node:findChild("bindEmail/secondTxt")
    bind_code_btn:onClick(function()
        self:reqForGetValidateCode(bind_code_btn, bind_btn_txt, bind_email_edit)
    end)

    --解除绑定
    local releaseEmailButton = node:findChild("releaseEmail/releaseBtn")
    releaseEmailButton:onClick(function()
        self:releaseEmail()
    end)

    --获取验证码按钮（解绑邮箱）
    release_code_btn = node:findChild("releaseEmail/releaseCodeBtn")
    release_btn_txt = node:findChild("releaseEmail/secondTxt")
    release_code_btn:onClick(function()
        self:reqForGetValidateCode(release_code_btn, release_btn_txt, nil)
    end)
end

-- 验证验证码
function view:matchValidateCode(code)
    local fmt = (string.match(code,"%d+") == code)
    local lenght = #code == 6
    return (fmt and lenght)
end

-- 验证邮箱格式
function view:matchEmail(str)
    if string.len(str or "") < 6 then return false end
    local b,e = string.find(str or "", '@')
    local bstr = ""
    local estr = ""
    if b then
        bstr = string.sub(str, 1, b-1)
        estr = string.sub(str, e+1, -1)
    else
        return false
    end

    -- check the string before '@'
    local p1,p2 = string.find(bstr, "[%w_]+")
    if (p1 ~= 1) or (p2 ~= string.len(bstr)) then return false end
    
    -- check the string after '@'
    if string.find(estr, "^[%.]+") then return false end
    if string.find(estr, "%.[%.]+") then return false end
    if string.find(estr, "@") then return false end
    if string.find(estr, "[%.]+$") then return false end

    _,count = string.gsub(estr, "%.", "")
    if (count < 1 ) or (count > 3) then
        return false
    end
    return true
end

-- 邮箱格式化显示
function view:emailToFormat(email)
    local email_strs = string.split(email, "@")
    local email_pre = email_strs[1]
    if #email_pre > 3 then
        return string.sub(email_pre, 1, #email_pre - 3) .. "***" .. email_strs[2]
    else
        return "***" .. email_strs[2]
    end 
end

--================点击响应事件================
-- 确定绑定
function view:comfirmBindEmail()
    if self:matchEmail(bind_email_edit:getText()) ~= true then
        kk.msgup.show("邮箱格式错误")
        return
    end
    if self:matchValidateCode(bind_code_edit:getText()) ~= true then
        kk.msgup.show("验证码格式错误")
        return
    end

    web.sendBindEmailReq(bind_email_edit:getText(), bind_code_edit:getText(), CC.Player.uid,CC.Player.appKey, handler(self,self.bindEmailCallback))
end

--解除绑定
function view:releaseEmail()
    if self:matchValidateCode(release_code_edit:getText()) ~= true then
        kk.msgup.show("验证码格式错误")
        return
    end

    web.sendReleaseEmailReq(CC.Player.email, release_code_edit:getText(), CC.Player.uid, CC.Player.appKey, handler(self,self.releaseEmailCallback))
end

-- 获取验证码
function view:reqForGetValidateCode(btn, txt, edit)
    secondCount = 60
    local email = show_type == 1 and edit:getText() or CC.Player.email

    if self:matchEmail(email) ~= true then
       kk.msgup.show("邮箱格式错误")
       return
    end

    web.sendEmailCodeReq(email, CC.Player.appKey, handler(self,self.getCodeCallback))
    btn:loadTexture("koko/atlas/login/2009.png", 1)
    btn:setTouchEnabled(false)
    txt:setVisible(true)
    txt:setString("60")
    local timerKey = show_type == 1 and "bindTimer" or "releaseTimer"
    local callback = show_type == 1 and self.timeCountdownForBind or self.timeCountdownForRelease
    txt:schedule(handler(self, callback), 1, timerKey)
end

--设置输入框右边的提示图案
function view:setupTip(tag, isOk)
    local child = ""
    if tag == 1001 then
        child = "bindEmail/bindTip"
    elseif tag == 1002 then
        child = "bindEmail/bindCodeTip"
    else  
        child = "releaseEmail/releaseCodeTip"  
    end

    local tip = self:getNode():findChild(child)
    if isOk then
        tip:loadTexture("koko/atlas/login/2004.png", 1)
    else
        tip:loadTexture("koko/atlas/login/2003.png", 1)
    end
end

--================回调事件================
-- 绑定的时候定时器回调
function view:timeCountdownForBind(dt)
    secondCount = secondCount - 1

    if secondCount <= 0 then
       --倒计时结束
       bind_btn_txt:setVisible(false)
       bind_code_btn:setTouchEnabled(true)
       bind_code_btn:loadTexture("koko/atlas/all_common/button/3014.png", 1)
    else
        bind_btn_txt:setString((secondCount >= 10 and tostring(secondCount)) or "0" .. tostring(secondCount))   
    end
end

-- 解绑的时候定时器回调
function view:timeCountdownForRelease(dt)
    secondCount = secondCount - 1

     if secondCount <= 0 then
        --倒计时结束
        release_btn_txt:setVisible(false)
        release_code_btn:setTouchEnabled(true)
        release_code_btn:loadTexture("koko/atlas/all_common/button/3014.png", 1)
    else
        release_btn_txt:setString((secondCount >= 10 and tostring(secondCount)) or "0" .. tostring(secondCount))   
    end
end

--输入框输入回调
function view:editboxHandle(eventname,sender) 
    if eventname == "ended" then
        if sender:getTag() == 1001 then 
            local tip = self:getNode():findChild("bindEmail/bindTip")
            tip:setVisible(true)
            if #sender:getText() == 0 then
                self:setupTip(1001,false)
                kk.msgup.show("请输入邮箱地址")
                return 
            end 

            if self:matchEmail(sender:getText()) ~= true then 
                self:setupTip(1001,false)
                kk.msgup.show("邮箱地址不符合要求，请重新输入")
                return
            end

            self:setupTip(1001,true) 
            return 
        end 

        if sender:getTag() == 1002 then
            local tip = self:getNode():findChild("bindEmail/bindCodeTip")
            tip:setVisible(true)
            if #sender:getText() == 0 then
                kk.msgup.show("请输入验证码")
                self:setupTip(1002,false)
                return 
            end 

            if self:matchValidateCode(sender:getText()) ~= true then
                kk.msgup.show("验证码格式错误")
                self:setupTip(1002,false)
                return 
            end 

            self:setupTip(1002,true)
            return 
        end 

        if sender:getTag() == 1003 then
            local tip = self:getNode():findChild("releaseEmail/releaseCodeTip")
            tip:setVisible(true)
                if #sender:getText() == 0 then
                kk.msgup.show("请输入验证码")
                self:setupTip(1003,false)
                return 
            end 

            if self:matchValidateCode(sender:getText()) ~= true then
                kk.msgup.show("验证码格式错误")
                self:setupTip(1003,false)
                return 
            end 

            self:setupTip(1003,true)
            return 
        end
    end 
end 

--获取验证码回调
function view:getCodeCallback(t)
    if t.success == true then
        kk.msgup.show("验证码已发送")
        return
    end
    kk.msgup.show(t.message)
end

--绑定邮箱请求回调
function view:bindEmailCallback(t)
    if t.success == true then
        kk.msgbox.showOk("邮箱绑定成功")
        local bind = self:getNode():findChild("bindEmail")
        bind:setVisible(false)
        show_type = 2
        secondCount = 0
        self:timeCountdownForBind()
        bind_btn_txt:unschedule("bindTimer")
        local eLabel = self:getNode():findChild("releaseEmail/emailLabel")
        eLabel:setString(self:emailToFormat(bind_email_edit:getText()))
        CC.Player.email = bind_email_edit:getText()
        local release = self:getNode():findChild("releaseEmail")
        release:setVisible(true)
        bind_email_edit:setText("")
        bind_code_edit:setText("")
        return 
    end
    kk.msgup.show(t.message)
end

--解绑邮箱回调
function view:releaseEmailCallback(t)
    if t.success == true then
        kk.msgbox.showOk("邮箱解绑成功")
        CC.Player.email = ""
        show_type = 1
        secondCount = 0
        self:timeCountdownForRelease()
        release_btn_txt:unschedule("releaseTimer")
        local release = self:getNode():findChild("releaseEmail")
        release:setVisible(false)
        local cBox = release:findChild("codePanel2/codeEdit2")
        cBox:setText("")
        local bind = self:getNode():findChild("bindEmail")
        bind:setVisible(true)
        return
    end
    kk.msgup.show(t.message)
end

return view