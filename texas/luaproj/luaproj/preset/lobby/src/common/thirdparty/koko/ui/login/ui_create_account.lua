local data = require("koko.data")
local CC = require("comm.CC")

local ctrl = class("kkCreateCount", kk.view)

function ctrl:ctor()
    self:setCsbPath("koko/ui/login/create_account.csb")
    self.TimerKey = "clockTimer"
    self.Count = 60
    self:setAnimation(kk.animScale:create())
end

function ctrl:onInit(node)
    self.editStatus = {}
    self:editInit(node)
    --注册按钮事件
    node:findChild("panel/btnGetCode"):onClick(handler(self, self.onGetCode))
    node:findChild("panel/btnRegister"):onClick(handler(self, self.onRegister))
    node:findChild("panel/close"):onClick(mkfunc(kk.uimgr.unload, self))
    node:findChild("panel/btnGetCode"):setEnableEx(false)
    node:findChild("panel/btnRegister"):setEnableEx(false)
end

function ctrl:editInit(node)
    -- 用户名
    local account = node:findChild("panel/account")
    local editAccount = kk.edit.createAny(account:getContentSize(), "请输入6-12位数字加字母")
    editAccount:setName("editAccount")
    editAccount:setPlaceholderFontColor(cc.c3b(0x85, 0x76, 0x5b))
    editAccount:registerScriptEditBoxHandler(handler(self, self.editAccountHandle))
    account:addChild(editAccount)

    -- 密码
    local password = node:findChild("panel/password")
    local editPassword = kk.edit.createPassword(password:getContentSize(), "请输入6-12位数字或字母")
    editPassword:setName("editPassword")
    editPassword:setPlaceholderFontColor(cc.c3b(0x85, 0x76, 0x5b))
    editPassword:registerScriptEditBoxHandler(handler(self, self.editPasswordHandle))
    password:addChild(editPassword)

    -- 确认密码
    local againPassword = node:findChild("panel/againPassword")
    local editAgainPassword = kk.edit.createPassword(againPassword:getContentSize(), "请再输入一次密码")
    editAgainPassword:setName("editAgainPassword")
    editAgainPassword:setPlaceholderFontColor(cc.c3b(0x85, 0x76, 0x5b))
    editAgainPassword:registerScriptEditBoxHandler(handler(self, self.editAgainPasswordHandle))
    againPassword:addChild(editAgainPassword)

    -- 手机号
    local phoneNum = node:findChild("panel/phoneNum")
    local editPhoneNum = kk.edit.createNumber(phoneNum:getContentSize(), "请输入您的手机号")
    editPhoneNum:setName("editPhoneNum")
    editPhoneNum:setPlaceholderFontColor(cc.c3b(0x85, 0x76, 0x5b))
    editPhoneNum:registerScriptEditBoxHandler(handler(self, self.editPhoneNumHandle))
    phoneNum:addChild(editPhoneNum)

    --验证码
    local secureCode = node:findChild("panel/secureCode")
    local editSecureCode = kk.edit.createNumber(secureCode:getContentSize(), "请输入验证码")
    editSecureCode:setName("editSecureCode")
    editSecureCode:setPlaceholderFontColor(cc.c3b(0x85, 0x76, 0x5b))
    editSecureCode:registerScriptEditBoxHandler(handler(self, self.editSecureCodeHandle))
    secureCode:addChild(editSecureCode)
end

function ctrl:onGetCode(sender)
    local textPhoneNum = self:getNode():findChild("panel/phoneNum/editPhoneNum"):getText()
    web.sendPhoneCodeReq(textPhoneNum, function(t)
        if not t.success then
            kk.msgbox.showOk(t.message, function(t)
            end)
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

function ctrl:onRegister(sender)
    local node = self:getNode()
    local txtAccount = node:findChild("panel/account/editAccount"):getText()
    local txtPassword = node:findChild("panel/password/editPassword"):getText()
    local txtAgainPassword = node:findChild("panel/againPassword/editAgainPassword"):getText()
    local textPhoneNum = node:findChild("panel/phoneNum/editPhoneNum"):getText()
    local textSecureCode = node:findChild("panel/secureCode/editSecureCode"):getText()
    web.sendRegisterReq(txtAccount, txtPassword, textPhoneNum, textSecureCode, handler(self, self.saveAccount))
end

function ctrl:saveAccount(t)
    local message = t.message
    local is_succee = t.success
    if is_succee then
        local result = t.data.result
        local name = result.nickname
        local acc = result.uname
        local pass = result.pwd
        local uid = result.uid
        data.entryCache:addAccountEntry(uid, name, acc, pass)
        kk.uimgr.unload(self)
        kk.uimgr.call("kkLogin", "setLoginEntry", uid)
        kk.uimgr.call("kkLogin", "onBtnBeginClicked")
    else
        kk.msgup.show(t.message) 
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
        self:getNode():findChild("panel/btnRegister"):setEnableEx(true)
    else
        self:getNode():findChild("panel/btnRegister"):setEnableEx(false)
    end    
end    
function ctrl:editAccountHandle(eventname, sender)
    if eventname == "ended" then
        local text = self:getNode():findChild("panel/account/editAccount"):getText()
        local errnode = self:getNode():findChild("panel/err1")
        if text == "" then
            self:refreshErrnode(errnode, false)
            kk.msgup.show("请输入账号")
            self.editStatus[1] = false
            self:addRegisterHandle()
            return 
        end
        local isOk = self:regMatch1(text)
        if not isOk then
            kk.msgup.show("账号不符合要求，请输入6-12位字母加数字")
            self:refreshErrnode(errnode, isOk)
            self.editStatus[1] = false
            self:addRegisterHandle()
            return
        end
        if isOk then
            web.sendCheckUnameReq(text, function(t)
                if t.success then
                    isOk = true
                    self.editStatus[1] = true
                else
                    isOk = false
                    self.editStatus[1] = false
                end
                kk.msgup.show(t.message)
                self:refreshErrnode(errnode, isOk)
                self:addRegisterHandle()
            end)
        end
    end
end

function ctrl:editPasswordHandle(eventname, sender)
    if eventname == "ended" then
        local text = self:getNode():findChild("panel/password/editPassword"):getText()
        local text1 = self:getNode():findChild("panel/againPassword/editAgainPassword"):getText()
        local errnode1 = self:getNode():findChild("panel/err3")
        local errnode = self:getNode():findChild("panel/err2")
        if text == "" then
            kk.msgup.show("请输入密码")
            self.editStatus[2] = false
            self:refreshErrnode(errnode, false)
            self:addRegisterHandle()
            return 
        end
        local isOk = self:regMatch2(text)
        if not isOk then
            kk.msgup.show("请正确输入密码，6-12位数字或字母")
            self.editStatus[2] = false
            self:refreshErrnode(errnode, isOk)
            self:addRegisterHandle()
            return
        end
        if text1 ~= "" and text ~= text1 then
            kk.msgup.show("两次密码不一致，请重新输入")
            self.editStatus[3] = false
            self:refreshErrnode(errnode1, false)
            self:addRegisterHandle()
        end
        if text1 ~= "" and text == text1 then
            self.editStatus[3] = true
            self:refreshErrnode(errnode1, true)
            self:addRegisterHandle()
        end   
        self.editStatus[2] = true
        self:refreshErrnode(errnode, isOk)
        self:addRegisterHandle()
    end
end

function ctrl:editAgainPasswordHandle(eventname, sender)
    if eventname == "ended" then
        local text = self:getNode():findChild("panel/againPassword/editAgainPassword"):getText()
        local text1 = self:getNode():findChild("panel/password/editPassword"):getText()
        local errnode = self:getNode():findChild("panel/err3")
        if text == "" then
            kk.msgup.show("请再输入一次密码进行确认")
            self.editStatus[3] = false
            self:refreshErrnode(errnode, false)
            self:addRegisterHandle()
            return 
        end
        local isOk = self:regMatch2(text)
        isOk = text == text1
        if not isOk then
            kk.msgup.show("两次密码不一致，请重新输入")
            self:refreshErrnode(errnode, isOk)
            self.editStatus[3] = false
            self:addRegisterHandle()
            return
        end
        self.editStatus[3] = true
        self:refreshErrnode(errnode, isOk)
        self:addRegisterHandle()
    end
end

function ctrl:editPhoneNumHandle(eventname, sender)
    if eventname == "ended" then
        local text = self:getNode():findChild("panel/phoneNum/editPhoneNum"):getText()
        local errnode = self:getNode():findChild("panel/err4")
        if text == "" then
            kk.msgup.show("请填写11位手机号")
            self.editStatus[4] = false
            self:refreshErrnode(errnode, false)
            self:addRegisterHandle()
            return 
        end
        local isOk = self:regMatch4(text)
        if not isOk then
            kk.msgup.show("请输入正确的手机号")
            self.editStatus[4] = false
            self:refreshErrnode(errnode, false)
            self:addRegisterHandle()
            return 
        end
        self.editStatus[4] = true
        self:refreshErrnode(errnode, isOk)
        self:addRegisterHandle()
    end
end

function ctrl:editSecureCodeHandle(eventname, sender)
    if eventname == "ended" then
        local text = self:getNode():findChild("panel/secureCode/editSecureCode"):getText()
        local errnode = self:getNode():findChild("panel/err5")
        if text == "" then
            kk.msgup.show("请输入验证码")
            self.editStatus[5] = false
            self:refreshErrnode(errnode, false)
            self:addRegisterHandle()
            return 
        end
        local isOk = self:regMatch5(text)
        if not isOk then
            kk.msgup.show("验证码格式错误请重新输入")
            self.editStatus[5] = false
            self:refreshErrnode(errnode, false)
            self:addRegisterHandle()
            return 
        end
        self.editStatus[5] = true
        self:refreshErrnode(errnode, isOk)
        self:addRegisterHandle()
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

function ctrl:regMatch1(text)
    local bok,err = CC.Check:Account(text)
    return bok
end

function ctrl:regMatch4(text)
    local bok,err = CC.Check:Phone(text)
    return bok
end

function ctrl:regMatch5(text)
    if text or text ~= "" then
        return true
    end
    return false
end

function ctrl:regMatch2(text)
    local bok,err = CC.Check:Password(text)
    return bok
end

return ctrl