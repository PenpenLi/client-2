
local CC = require("comm.CC")
local web = require("web")
local entryCache = require("koko.data").entryCache
local config = require("config")
local LoginMgr = require("LoginMgr")

local ctrl = class("kkAccLogin", kk.view)

function ctrl:ctor(iid, pwd)
    self:setCsbPath("koko/ui/login/acc_login.csb")
    self:setAnimation(kk.animScale:create())
    self.iid = iid
    self.pwd = pwd
end

function ctrl:onInit(node)
    self.editStatus = {}
    local panel = node:findChild("panel")
    panel:findChild("btnConfirm"):onClick(handler(self, self.onBtnConfirmClicked))
    panel:findChild("btnConfirm"):setEnableEx(false)
    panel:findChild("btnClose"):onClick(mkfunc(kk.uimgr.unload, self))
    panel:findChild("btnForgetPwd"):onClick(handler(self, self.onBetForgetPwdClicked))
    local editAccount = kk.edit.createAnyWithParent(panel:findChild("imgAcc"), "accEdit", "请输入您的账号/ID/邮箱/手机")
    editAccount:registerScriptEditBoxHandler(handler(self, self.editAccountHandle))

    local editPassword = kk.edit.createPasswordWithParent(panel:findChild("imgPwd"), "pwdEdit", "请输入您的密码")
    editPassword:registerScriptEditBoxHandler(handler(self, self.editPasswordHandle))
    self:setAccAndPwd()
end

function ctrl:onBtnConfirmClicked(sender)
    local panel = self:getNode():findChild("panel")
    local txtAccEdit = panel:findChild("imgAcc/accEdit"):getText()
    local txtPwdEdit = panel:findChild("imgPwd/pwdEdit"):getText()

    CC.LoginMgr.Accountlogin(txtAccEdit, txtPwdEdit)
    kk.uimgr.unload(self)
    kk.waiting.show("")
end

function ctrl:onBetForgetPwdClicked(sender)
    kk.uimgr.load("koko.ui.login.ui_forget_pwd")
end

function ctrl:setAccAndPwd()
    local panel = self:getNode():findChild("panel")
    if config.Account and config.Account ~= "" and config.Passward and config.Passward ~= "" then
        panel:findChild("imgAcc/accEdit"):setText(config.Account)
        panel:findChild("imgPwd/pwdEdit"):setText(config.Passward)
    end
    if self.iid and self.pwd then
        panel:findChild("imgAcc/accEdit"):setText(self.iid)
        panel:findChild("imgPwd/pwdEdit"):setText(self.pwd)
        self:editErr(self:getNode():findChild("panel/err1"), 1, true, "")
    end
end
-- 添加注册按钮事件
function ctrl:addRegisterHandle()
    local n = 0
    for i = 1, 2 do
        if self.editStatus[i] then
            n = n + 1
        end
    end
    if n == 2 then
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
        local text = self:getNode():findChild("panel/imgAcc/accEdit"):getText()
        local errnode = self:getNode():findChild("panel/err1")
        if text == "" then
            self:editErr(errnode, 1, false, "请输入账号或手机号")
            return 
        end
        -- local isOk = CC.Check:Account(text)
        -- if not isOk then
        --     self:editErr(errnode, 1, false, "输入不符合要求，请重新输入")
        --     return 
        -- end
        self:editErr(errnode, 1, true, "")
    end
end

function ctrl:editPasswordHandle(eventname, sender)
    if eventname == "ended" then
        local text = self:getNode():findChild("panel/imgPwd/pwdEdit"):getText()
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
        self:editErr(errnode, 2, true, "")
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