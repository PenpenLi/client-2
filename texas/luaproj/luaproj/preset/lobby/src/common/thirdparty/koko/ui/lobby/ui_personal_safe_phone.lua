local data = require("koko.data")
local CC = require("comm.CC")
local web = require("web")

local show_type = 0
local show_pos = cc.p(0,0)

local secondCount = 60

local isPhone = false
local isBindCode = false 
local isReleaseCode = false

local bind_phone_edit = nil
local bind_code_edit = nil
local bind_second_txt = nil
local bind_code_btn = nil
local release_code_edit = nil
local release_second_txt = nil
local release_code_btn = nil

local view = class("kkPersonalSafePhone", kk.view)

--============生命周期============
function view:ctor(pos)
    if #CC.Player.secMobile ~= 0 then
        show_type = 2
    else
        show_type = 1    
    end
    show_pos = pos
    self:setCsbPath("koko/ui/lobby/personal_safe_phone.csb")
end

function view:onInit(node)
    --加入编辑框
    self:createEditBoxs(node)
    --按钮事件设置
    self:buttonsSetup(node)

    node:setPosition(show_pos)
    if show_type == 1 then
       --绑定手机
       local sp = node:findChild("releasePhone")
       sp:setVisible(false)
    else
       --解除绑定
       local sp = node:findChild("bindPhone")
       sp:setVisible(false)
       local phoneTxt = node:findChild("releasePhone/phoneTxt")
       if #CC.Player.secMobile ~= 0 then
           phoneTxt:setString(self:phoneToFormat(CC.Player.secMobile))
       else
           phoneTxt:setString("")    
       end
    end
end

function view:onDestroy()
   bind_phone_edit = nil
   bind_code_edit = nil
   bind_second_txt = nil
   bind_code_btn = nil
   release_code_edit = nil
   release_second_txt = nil
   release_code_btn = nil
end

--============文件内调用（私有）============
-- 创建编辑框
function view:createEditBoxs(node)
    --手机号码输入框的占位容器
    local phonePanel = node:findChild("bindPhone/phonePanel")
    --手机号码输入框
    bind_phone_edit = kk.edit.createNumberWithParent(phonePanel, "editPhone", "请输入手机号码")
    bind_phone_edit:setPlaceholderFontColor(cc.c4b(133,118,91,255))
    bind_phone_edit:setFontColor(cc.c4b(129,46,3,255))
    bind_phone_edit:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editboxHandle(eventname,sender) 
    end) 
    bind_phone_edit:setTag(1001)

    --验证码输入框的占位容器
    local codePanel1 = node:findChild("bindPhone/codePanel1")
    --验证码（绑定）输入框
    bind_code_edit = kk.edit.createNumberWithParent(codePanel1, "codeEdit1", "请输入验证码")
    bind_code_edit:setPlaceholderFontColor(cc.c4b(133,118,91,255))
    bind_code_edit:setFontColor(cc.c4b(129,46,3,255))
    bind_code_edit:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editboxHandle(eventname,sender) 
    end) 
    bind_code_edit:setTag(1002)

    --验证码输入框占位容器
    local codePanel2 =  node:findChild("releasePhone/codePanel2")
    --验证码（解除）输入框
    release_code_edit = kk.edit.createNumberWithParent(codePanel2, "codeEdit2", "请输入验证码")
    release_code_edit:setPlaceholderFontColor(cc.c4b(133,118,91,255))
    release_code_edit:setFontColor(cc.c4b(129,46,3,255))
    release_code_edit:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editboxHandle(eventname,sender) 
    end) 
    release_code_edit:setTag(1003)
end

function view:buttonsSetup(node)
    --获取验证码按钮(绑定)
    bind_code_btn = node:findChild("bindPhone/codeButton1")
    bind_second_txt = node:findChild("bindPhone/timeCountTxt")
    bind_code_btn:onClick(function()
        self:reqForGetValidateCode(bind_code_btn, bind_second_txt, bind_phone_edit)
    end)
    
    --确定绑定按钮
    local bindButton = node:findChild("bindPhone/cfmBindButton")
    bindButton:onClick(function()
        self:comfirmBindPhone()
    end)
    
    -- 获取验证码按钮(解绑手机)
    release_code_btn = node:findChild("releasePhone/getCodeBtn")
    release_second_txt = node:findChild("releasePhone/secondCountTxt")
    release_code_btn:onClick(function()
        self:reqForGetValidateCode(release_code_btn, release_second_txt, nil)
    end)

    --确定解绑手机
    local releaseButton = node:findChild("releasePhone/releaseButton")
    releaseButton:onClick(function()
        self:releasePhone()
    end)
end

-- 判断手机号码
function view:matchPhoneNumber(number)
    return string.match(number, "[1][3,4,5,7,8]%d%d%d%d%d%d%d%d%d") == number;
end

-- 验证验证码
function view:matchValidateCode(code)
    local fmt = (string.match(code, "%d+") == code)
    local lenght = #code == 6
    return (fmt and lenght)
end

-- 手机格式化显示
function view:phoneToFormat(phone)
    if #phone ~= 0 then
        local pre = string.sub(phone, 1, 3)
        local fix = string.sub(phone, #phone - 1, -1)
        return pre .. "******" .. fix
    end
    return ""
end

-- 设置输入框右边的提示图案
function view:setupTip(tag, isOk)
    local child = ""
    if tag == 1001 then
        child = "bindPhone/bindPhoneTip"
    elseif tag == 1002 then
        child = "bindPhone/bindCodeTip"
    else  
        child = "releasePhone/releaseCodeTip"  
    end

    local tip = self:getNode():findChild(child)
    if isOk then
        tip:loadTexture("koko/atlas/login/2004.png", 1)
    else
        tip:loadTexture("koko/atlas/login/2003.png", 1)
    end
end

--=================点击事件=================--
-- 获取验证码
function view:reqForGetValidateCode(btn, txt, edit)
    secondCount = 60
    local phone = show_type == 1 and edit:getText() or CC.Player.secMobile

    if self:matchPhoneNumber(phone) ~= true then
       kk.msgup.show("请输入正确的手机号码")
       return
    end

    web.sendPhoneCodeReq(phone, handler(self,self.requestValidateCodeCallback))
    btn:loadTexture("koko/atlas/login/2009.png", 1)
    btn:setTouchEnabled(false)
    txt:setVisible(true)
    txt:setString("60")
    local timerKey = show_type == 1 and "bindTimer" or "releaseTimer"
    local callback = show_type == 1 and self.timerCountdownForBind or self.timerCountdownForRelease
    txt:schedule(handler(self, callback), 1, timerKey)
end


-- 确定绑定
function view:comfirmBindPhone()
    local phoneBox = self:getNode():findChild("bindPhone/phonePanel/editPhone")
    local codeBox = self:getNode():findChild("bindPhone/codePanel1/codeEdit1")
   
    if isPhone == false then
        kk.msgup.show("请输入正确的手机号")
        return
    end

    if isBindCode == false then
        kk.msgup.show("验证码格式错误")
        return
    end
    local appKey = CC.Player.appKey
    local uid = CC.Player.uid
    web.sendBindPhoneReq(phoneBox:getText(), codeBox:getText(), appKey, uid, handler(self, self.requestPhoneCallback))
end

-- 解绑手机
function view:releasePhone()
    local codeBox = self:getNode():findChild("releasePhone/codePanel2/codeEdit2")
    if isReleaseCode ~= true then
        kk.msgup.show("验证码格式错误")
        return
    end
    web.sendReleasePhoneReq(codeBox:getText(), CC.Player.appKey, CC.Player.secMobile, CC.Player.uid, handler(self,self.requestReleasePhoneCallback))
end

--==============回调方法============--
-- 绑定手机定时器回调
function view:timerCountdownForBind(dt)
    secondCount = secondCount - 1
    if secondCount <= 0 then
       --倒计时结束
       bind_code_btn:loadTexture("koko/atlas/all_common/button/3014.png", 1)
       bind_second_txt:setVisible(false)
       bind_code_btn:setTouchEnabled(true)
       secondCount = 60
       bind_second_txt:unschedule("countTimer")
    else
        if secondCount < 10 then
            bind_second_txt:setString("0" .. tostring(secondCount))
        else
            bind_second_txt:setString(tostring(secondCount))
        end    
    end
end

-- 解绑手机定时器回调
function view:timerCountdownForRelease(dt)
    secondCount = secondCount - 1
    if secondCount <= 0 then
       --倒计时结束
       release_code_btn:loadTexture("koko/atlas/all_common/button/3014.png", 1)
       release_second_txt:setVisible(false)
       release_code_btn:setTouchEnabled(true)
       secondCount = 60
       release_second_txt:unschedule("countTimer")
    else
        if secondCount < 10 then
            release_second_txt:setString("0".. tostring(secondCount))
        else
            release_second_txt:setString(tostring(secondCount))
        end    
    end
end

-- 输入框输入回调
function view:editboxHandle(eventname,sender) 
    if eventname == "ended" then
        if sender:getTag() == 1001 then 
            local tip = self:getNode():findChild("bindPhone/bindPhoneTip")
            tip:setVisible(true)
            if #sender:getText() == 0 then
                self:setupTip(1001,false)
                kk.msgup.show("请填写11位手机号")
                isPhone = false
                return 
            end 

            if self:matchPhoneNumber(sender:getText()) ~= true then 
                self:setupTip(1001,false)
                kk.msgup.show("请输入正确的手机号")
                isPhone = false
                return
            end

            isPhone = true
            self:setupTip(1001,true) 
            return 
        end 

        if sender:getTag() == 1002 then
            local tip = self:getNode():findChild("bindPhone/bindCodeTip")
            tip:setVisible(true)
            if #sender:getText() == 0 then
                isBindCode = false
                kk.msgup.show("请输入验证码")
                self:setupTip(1002,false)
                return 
            end 

            if self:matchValidateCode(sender:getText()) ~= true then
                isBindCode = false
                kk.msgup.show("验证码格式错误")
                self:setupTip(1002,false)
                return 
            end 

            isBindCode = true
            self:setupTip(1002,true)
            return 
        end 

        if sender:getTag() == 1003 then
            local tip = self:getNode():findChild("releasePhone/releaseCodeTip")
            tip:setVisible(true)
                if #sender:getText() == 0 then
                isReleaseCode = false
                kk.msgup.show("请输入验证码")
                self:setupTip(1003,false)
                return 
            end 

            if self:matchValidateCode(sender:getText()) ~= true then
                isReleaseCode = false
                kk.msgup.show("验证码格式错误")
                self:setupTip(1003,false)
                return 
            end 

            isReleaseCode = true
            self:setupTip(1003,true)
            return 
        end
    end 
end

-- 获取验证码网络请求回调
function view:requestValidateCodeCallback(t)
    if t.success then
        --请求成功
        kk.msgup.show("验证码已发送")
        return
    end
    kk.msgup.show(t.message)
end

-- 绑定手机号码请求回调
function view:requestPhoneCallback(t)
    if t.success then
        --请求成功
        kk.msgbox.showOk("绑定手机成功")
        show_type = 2
        secondCount = 0
        self:timerCountdownForBind()
        bind_second_txt:unschedule("bindTimer")
        local bdSp = self:getNode():findChild("bindPhone")
        CC.Player.secMobile = bind_phone_edit:getText()
        kk.event.dispatch(E.EVENTS.phone_changed, bind_phone_edit:getText())
        bdSp:setVisible(false)
        local reSp = self:getNode():findChild("releasePhone")
        local phoneTxt = reSp:findChild("phoneTxt")
        phoneTxt:setString(self:phoneToFormat(bind_phone_edit:getText()))
        reSp:setVisible(true)
        release_code_edit:setText("")
        return
    end
    kk.msgup.show(t.message)
end

-- 解绑手机请求回调
function view:requestReleasePhoneCallback(t)
    if t.success then
        kk.msgbox.showOk("解绑手机成功")
        CC.Player.secMobile = ""
        kk.event.dispatch(E.EVENTS.phone_changed, "")
        show_type = 1
        secondCount = 0
        self:timerCountdownForRelease()
        release_second_txt:unschedule("releaseTimer")
        local bdSp = self:getNode():findChild("bindPhone")
        local reSp = self:getNode():findChild("releasePhone")
        reSp:setVisible(false)
        bdSp:setVisible(true)
        bind_phone_edit:setText("")
        bind_code_edit:setText("")
        return
    end
    kk.msgup.show(t.message)
end

return view