local data = require("koko.data")
local CC = require("comm.CC")

local secondCount = 60
local show_pos = cc.p(0,0)

local isNew = false
local isCfm = false
local isCode = false 

local view = class("kkPersonalSafePsw", kk.view)

--=============生命周期============
function view:ctor(pos)
    show_pos = pos
    self:setCsbPath("koko/ui/lobby/personal_safe_psw.csb")
end

function view:onInit(node)
    node:setPosition(show_pos)
    self:createEditBoxUI(node)
    self:buttonsSetup(node)
    local phoneTxt = node:findChild("setPassword/phoneTxt")
    phoneTxt:setString(self:phoneToFormat(CC.Player.secMobile))
    kk.event.addListener(node, E.EVENTS.phone_changed, handler(self, self.refreshphone))
end

function view:refreshphone(t)
    self:getNode():findChild("setPassword/phoneTxt"):setString(self:phoneToFormat(t))
end    
--==============文件内部调用（私有）================
--创建输入框
function view:createEditBoxUI(node)
    --新密码
    local newPanel = node:findChild("setPassword/newPanel")
    --新密码输入框
    local editNew = kk.edit.createPasswordWithParent(newPanel,"editNew","请输入6-12位数字或字母")
    editNew:setPlaceholderFontColor(cc.c4b(133,118,91,255))
    editNew:setFontColor(cc.c4b(129,46,3,255))
    editNew:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editboxHandle(eventname,sender) 
    end) 
    editNew:setTag(1001)

    local comfirmPanel = node:findChild("setPassword/comfirmPanel")
    --确认密码输入框
    local editComfirm = kk.edit.createPasswordWithParent(comfirmPanel,"editComfirm","请再输入一次密码")
    editComfirm:setPlaceholderFontColor(cc.c4b(133,118,91,255))
    editComfirm:setFontColor(cc.c4b(129,46,3,255))
    editComfirm:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editboxHandle(eventname,sender) 
    end) 
    editComfirm:setTag(1002)

    local codePanel = node:findChild("setPassword/codePanel")
    --验证码输入框
    local editCode = kk.edit.createNumberWithParent(codePanel,"editCode","请输入验证码")
    editCode:setPlaceholderFontColor(cc.c4b(133,118,91,255))
    editCode:setFontColor(cc.c4b(129,46,3,255))
    editCode:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editboxHandle(eventname,sender) 
    end) 
    editCode:setTag(1003)
end

--设置按钮
function view:buttonsSetup(node)
    --获取验证码
    local codeBtn = node:findChild("setPassword/codeBtn")
    codeBtn:onClick(function()
        self:getValidateCode()
    end)

    --确认修改
    local cfmBtn = node:findChild("setPassword/cfmBtn")
    cfmBtn:onClick(function()
        self:comfirmModify()
    end)
end

--设置输入框右边的提示图案
function view:setupTip(tag, isOk)
    local child = ""
    if tag == 1001 then
        child = "setPassword/newTip"
    elseif tag == 1002 then
        child = "setPassword/cfmTip"
    else  
        child = "setPassword/codeTip"  
    end

    local tip = self:getNode():findChild(child)
    if isOk then
        tip:loadTexture("koko/atlas/login/2004.png", 1)
    else
        tip:loadTexture("koko/atlas/login/2003.png", 1)
    end
end

-- 验证验证码
function view:matchValidateCode(code)
    local fmt = (string.match(code,"%d+") == code)
    local lenght = #code == 6
    return (fmt and lenght)
end

--手机格式化显示
function view:phoneToFormat(phone)
    if #phone ~= 0 then
        local pre = string.sub(phone, 1, 3)
        local fix = string.sub(phone, #phone - 1, -1)
        return pre .. "******" .. fix
    end
    return ""
end

--=============点击事件=============
--获取验证码
function view:getValidateCode()
    if not CC.Player.secMobile or CC.Player.secMobile == "" then
        kk.msgup.show("请先绑定手机号")
        return
    end
    web.sendPhoneCodeReq(CC.Player.secMobile,handler(self,self.getValidateCodeCallback))
end

--确定修改
function view:comfirmModify()
    local new_box = self:getNode():findChild("setPassword/newPanel/editNew")
    local code_box = self:getNode():findChild("setPassword/codePanel/editCode")
    if isNew ~= true then
        kk.msgup.show("请正确输入密码，6-12位数字或字母")
        return 
    end 

    if isCfm ~= true then
        kk.msgup.show("两次密码不一致，请重新输入")
        return 
    end 

    if isCode ~= true then 
        kk.msgup.show("验证码格式错误")
        return
    end 
    
    ----***********cid()**********------此处cid写死了，后面要更改
    web.sendModifyPwdReq(CC.Player.appKey, CC.Player.uname, CC.Player.secMobile, new_box:getText(), "74e0159df1c97d590014fd6c9fb32bc2", code_box:getText(), handler(self,self.comfirmCallback))
end

--=============回调事件=============
--定时器回调
function view:timeCountdown(dt)
    local codeBtn = self:getNode():findChild("setPassword/codeBtn")
    local txt = self:getNode():findChild("setPassword/secTxt")
    secondCount = secondCount - 1
    if secondCount <= 0 then
        txt:setVisible(false)
        codeBtn:loadTexture("koko/atlas/all_common/button/3014.png", 1)
        codeBtn:setTouchEnabled(true)
    else
        txt:setString((secondCount > 10 and tostring(secondCount)) or "0" .. tostring(secondCount))    
    end
end

--编辑框回调
function view:editboxHandle(eventname,sender)
   if eventname == "ended" then
       if sender:getTag() == 1001 then
           local tip = self:getNode():findChild("setPassword/newTip")
           tip:setVisible(true)
           --新密码输入框(输入密码为空)
           if #sender:getText() == 0 then
               kk.msgup.show("请输入密码")
               self:setupTip(1001,false)
               isNew = false 
               return
           end
          --新密码输入格式错误
           if CC.Check:Password(sender:getText()) ~= true then
               kk.msgup.show("请正确输入密码，6-12位数字或字母")
               self:setupTip(1001,false)
               isNew = false
               return
           end

           isNew = true
           self:setupTip(1001,true)
           return 
       end

       if sender:getTag() == 1002 then
           local tip = self:getNode():findChild("setPassword/cfmTip")
           tip:setVisible(true)
           --确认密码输入框
           if #sender:getText() == 0 then
               kk.msgup.show("请再输入一次密码进行确认")
               self:setupTip(1002,false)
               isCfm = false
               return
           end

           if sender:getText() ~= self:getNode():findChild("setPassword/newPanel/editNew"):getText() then
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
           local tip = self:getNode():findChild("setPassword/codeTip")
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

--获取验证码请求回调
function view:getValidateCodeCallback(t)
    if t.success == true then
        secondCount = 60
        local codeBtn = self:getNode():findChild("setPassword/codeBtn")
        local txt = self:getNode():findChild("setPassword/secTxt")
        txt:setVisible(true)
        txt:setString("60")
        codeBtn:loadTexture("koko/atlas/login/2009.png", 1)
        codeBtn:setTouchEnabled(false)
        txt:schedule(handler(self, self.timeCountdown), 1, "countTimer")
        
        kk.msgup.show("验证码已发送")
        return 
    end
    kk.msgup.show(t.message)
end

--确认修改请求回调
function view:comfirmCallback(t)
    if t.success == true then
        kk.msgbox.showOk("修改成功")
        CC.Player:setPlayerselfInfo(t.data.result)
        
        local codeBtn = self:getNode():findChild("setPassword/codeBtn")
        local txt = self:getNode():findChild("setPassword/secTxt")
        txt:setVisible(false)
        codeBtn:loadTexture("koko/atlas/all_common/button/3014.png", 1)
        codeBtn:setTouchEnabled(true)
        txt:unschedule("countTimer")
        return
    end
    kk.msgup.show(t.message)
end
return view