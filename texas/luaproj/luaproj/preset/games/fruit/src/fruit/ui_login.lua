
local ctrl = createView("", "fruit/UILogic/Login/Login.csb", nil)

function ctrl:show()
    cpn.login = self
    return self:create()
end

function ctrl:onInit(node)
    --用户名
    local panelAccount = node:findChild("panelKoko/panelAccount")
    local editAccount = ccui.EditBox:create(panelAccount:getContentSize(), "")
    editAccount:setName("editAccount")
    editAccount:setAnchorPoint(cc.p(0,0))
    editAccount:setReturnType(1)
    editAccount:setInputMode(6)
    editAccount:setPlaceholderFontColor(cc.c3b(128,128,128))
    editAccount:setPlaceholderFontSize(25)
    editAccount:setFontSize(25)
    editAccount:setPlaceHolder("请输入用户名")
    editAccount:setPlaceholderFontColor(cc.c4b(255, 255, 255, 128))
    if Config.DefaultAccount then
        editAccount:setText(Config.DefaultAccount)
    end
    editAccount:setTouchEnabled(true)
    panelAccount:addChild(editAccount)

    --密码
    local panelPassword = node:findChild("panelKoko/panelPassword")
    local editPassword = ccui.EditBox:create(panelPassword:getContentSize(), "")
    editPassword:setName("editPassword")
    editPassword:setAnchorPoint(cc.p(0,0))
    editPassword:setReturnType(1)
    editPassword:setInputFlag(0)
    editPassword:setInputMode(6)
    editPassword:setPlaceholderFontColor(cc.c3b(128,128,128))
    editPassword:setPlaceholderFontSize(25)
    editPassword:setFontSize(25)
    editPassword:setPlaceHolder("请输入密码")
    editPassword:setPlaceholderFontColor(cc.c4b(255, 255, 255, 128))
    if Config.DefaultPassword then
        editPassword:setText(Config.DefaultPassword)
    end
    panelPassword:addChild(editPassword)

    --注册按钮事件
    node:findChild("panelKoko/btnRegister"):onClick(handler(self, self.onRegister))
    node:findChild("panelKoko/btnLogin"):onClick(handler(self, self.onLogin))
end

function ctrl:onExit()
    if cpn.login == self then
        cpn.login = nil
    end
end

function ctrl:onRegister(sender)
    cclog("touched register!")
end

function ctrl:onLogin(sender)    
    local panel = sender:getParent()
    local editAccount = panel:findChild("panelAccount/editAccount")
    local editPassword = panel:findChild("panelPassword/editPassword")
    
    local account = editAccount:getText()
    local password = editPassword:getText()
    
    if account == "" then
        msgbox.showOk("请输入账号！")
        return
    end
    
    if password == "" then
        msgbox.showOk("请输入密码！")
        return
    end
    
    Game.Account = account
    Game.Password = password
    Platform.LoginByAccountPassword(account, password)
end

return ctrl