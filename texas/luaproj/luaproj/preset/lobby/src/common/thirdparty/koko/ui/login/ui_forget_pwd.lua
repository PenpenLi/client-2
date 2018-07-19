local CC = require("comm.CC")
local web = require("web")

local ctrl = class("kkForgetPwd", kk.view)

function ctrl:ctor()
    self.isCanFindPwd = false
    self.isSendCodeReq = false
    self:setCsbPath("koko/ui/login/forget_pwd.csb")
    self:setAnimation(kk.animScale:create())
end

function ctrl:onInit(node)
    self.editStatus = {}
    self.TimerKey = "clockTimer"
    local panel = node:findChild("panel")
    local editAccount = kk.edit.createAnyWithParent(panel:findChild("img1"), "txtEdit1", "请输入要找回密码的账号")
    editAccount:registerScriptEditBoxHandler(handler(self, self.editAccountHandle))
  
    local editPassword = kk.edit.createPasswordWithParent(panel:findChild("img2"), "txtEdit2", "请输入6-12位数字或字母")
    editPassword:registerScriptEditBoxHandler(handler(self, self.editPasswordHandle))
    
    local editAgainPassword = kk.edit.createPasswordWithParent(panel:findChild("img3"), "txtEdit3", "请再输入一次密码")
    editAgainPassword:registerScriptEditBoxHandler(handler(self, self.editAgainPasswordHandle))
    
    local editPhoneNum = kk.edit.createNumberWithParent(panel:findChild("img4"), "txtEdit4", "请输入您的手机号")
    editPhoneNum:registerScriptEditBoxHandler(handler(self, self.editPhoneNumHandle))
    
    local editSecureCode = kk.edit.createNumberWithParent(panel:findChild("img5"), "txtEdit5", "请输入验证码")
    editSecureCode:registerScriptEditBoxHandler(handler(self, self.editSecureCodeHandle))

    panel:findChild("btnClose"):onClick(mkfunc(kk.uimgr.unload, self))
    panel:findChild("btnConfirm"):onClick(handler(self, self.onBtnConfirmClicked))
    panel:findChild("btnGetCode"):onClick(handler(self, self.onBtnGetCode))
    panel:findChild("btnConfirm"):setEnableEx(false)
    panel:findChild("btnGetCode"):setEnableEx(false)
end

function ctrl:onBtnConfirmClicked(sender)
    local node = self:getNode()
    local txtAccount = node:findChild("panel/img1/txtEdit1"):getText()
    local txtPassword = node:findChild("panel/img2/txtEdit2"):getText()
    local txtAgainPassword = node:findChild("panel/img3/txtEdit3"):getText()
    local textPhoneNum = node:findChild("panel/img4/txtEdit4"):getText()
    local textSecureCode = node:findChild("panel/img5/txtEdit5"):getText()
    web.sendChangePwdReq(txtAccount, txtPassword, textPhoneNum, textSecureCode, function(t)
        if t.success then
            kk.msgbox.showOk("密码找回成功", function(t)
                kk.uimgr.unload(self)
            end)
        else
            kk.msgup.show(t.message)
        end
    end)
end

function ctrl:onBtnGetCode(sender)
    local phoneNum = self:getNode():findChild("panel/img4/txtEdit4"):getText()
    web.sendPhoneCodeReq(phoneNum, function(t)
        self.isSendCodeReq = true
        if not t.success then
            kk.msgup.show(t.message)
        else
            sender:loadTexture("koko/atlas/login/2009.png", 1)
            sender:setTouchEnabled(false)
            self:showTime()
        end
    end)
end
function ctrl:showTime()
    self.Count = 60
    local node = self:getNode()    
    node:findChild("panel/txtTime"):setString("60")
    node:findChild("panel/txtTime"):setVisible(true)
    node:findChild("panel/txtTime"):schedule(handler(self, self.onTimer), 1, self.TimerKey)
end

function ctrl:onTimer(dt)
    self.Count = self.Count - 1
    local node = self:getNode()
    local timeNode = node:findChild("panel/txtTime")
    local sendNode = node:findChild("panel/btnGetCode")
    if self.Count <= 0 then
        timeNode:unschedule(self.TimerKey)
        timeNode:setVisible(false)
        sendNode:loadTexture("koko/atlas/all_common/button/3014.png", 1)
        sendNode:setTouchEnabled(true)
    end
    if self.Count >= 10 then
        timeNode:setString(tostring(self.Count))
    else
        timeNode:setString("0"..tostring(self.Count))
    end    
end
-- 添加注册按钮事件
function ctrl:addRegisterHandle()
    local n = 0
    for i = 1, 4 do
        if self.editStatus[i] then
            n = n + 1
        end
    end
    if n == 4 then
        self:getNode():findChild("panel/btnGetCode"):setEnableEx(true)
    else
        self:getNode():findChild("panel/btnGetCode"):setEnableEx(false)
    end
    if self.editStatus[5] then n = n + 1 end
    if n == 5 then
        self:getNode():findChild("panel/btnConfirm"):setEnableEx(true)
    else
        self:getNode():findChild("panel/btnConfirm"):setEnableEx(false)
    end    
end
function ctrl:editErr(node, id, isOk, str)
    self:refreshErrnode(node, isOk)
    kk.msgup.show(str)
    self.editStatus[id] = isOk
    self:addRegisterHandle()
end    
function ctrl:editAccountHandle(eventname, sender)
    if eventname == "ended" then
        local text = self:getNode():findChild("panel/img1/txtEdit1"):getText()
        local errnode = self:getNode():findChild("panel/err1")
        if text == "" then
            self:editErr(errnode, 1, false, "请输入账号")
            return 
        end
        -- local isOk = CC.Check:Account(text)
        -- if not isOk then
        --     self:editErr(errnode, 1, false, "账号不符合要求，请重新输入")
        --     return 
        -- end
        self:editErr(errnode, 1, true, "")
    end
end

function ctrl:editPasswordHandle(eventname, sender)
    if eventname == "ended" then
        local text = self:getNode():findChild("panel/img2/txtEdit2"):getText()
        local text1 = self:getNode():findChild("panel/img3/txtEdit3"):getText()
        local errnode1 = self:getNode():findChild("panel/err3")
        local errnode = self:getNode():findChild("panel/err2")
        if text == "" then
            self:editErr(errnode, 2, false, "请输入密码")
            return 
        end
        local isOk = CC.Check:Password(text)
        if not isOk then
            self:editErr(errnode, 2, false, "请正确输入密码，6-12位数字或字母")
            return
        end
        if text1 ~= "" and text ~= text1 then
            self:editErr(errnode1, 3, false, "两次密码不一致，请重新输入")
        end
        if text1 ~= "" and text == text1 then
            self:editErr(errnode, 3, true, "")
        end
        self:editErr(errnode, 2, true, "")
    end
end

function ctrl:editAgainPasswordHandle(eventname, sender)
    if eventname == "ended" then
        local text = self:getNode():findChild("panel/img2/txtEdit2"):getText()
        local text1 = self:getNode():findChild("panel/img3/txtEdit3"):getText()
        local errnode = self:getNode():findChild("panel/err3")
        if text1 == "" then
            self:editErr(errnode, 3, false, "请再输入一次密码进行确认")
            return 
        end
        local isOk = CC.Check:Password(text)
        isOk = text == text1
        if not isOk then
            self:editErr(errnode, 3, false, "两次密码不一致，请重新输入")
            return 
        end
        self:editErr(errnode, 3, true, "")
    end
end

function ctrl:editPhoneNumHandle(eventname, sender)
    if eventname == "ended" then
        local text = self:getNode():findChild("panel/img4/txtEdit4"):getText()
        local errnode = self:getNode():findChild("panel/err4")
        if text == "" then
            self:editErr(errnode, 4, false, "请填写11位手机号")
            return
        end
        local isOk = CC.Check:Phone(text)
        if not isOk then
            self:editErr(errnode, 4, false, "请输入正确的手机号")
            return
        end
        self:editErr(errnode, 4, true, "")
    end
end

function ctrl:editSecureCodeHandle(eventname, sender)
    if eventname == "ended" then
        local text = self:getNode():findChild("panel/img5/txtEdit5"):getText()
        local errnode = self:getNode():findChild("panel/err5")
        local isOk = true
        if text == "" then
            self:editErr(errnode, 5, false, "请输入验证码")
            return
        end
        self:editErr(errnode, 5, true, "")
    end
end

function ctrl:refreshErrnode(errnode, isOk)
    errnode:setVisible(true)
    if isOk then
        errnode:loadTexture("koko/atlas/login/2004.png", 1)
    else
        errnode:loadTexture("koko/atlas/login/2003.png", 1)
    end
end

return ctrl