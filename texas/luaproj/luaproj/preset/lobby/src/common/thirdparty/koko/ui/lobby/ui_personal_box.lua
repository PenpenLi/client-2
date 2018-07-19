local data = require("koko.data")
local CC = require("comm.CC")

local ctrl = class("kkPersonalBox", kk.view)

local isPwd = false

function ctrl:ctor()
    self:setCsbPath("koko/ui/lobby/personal_box.csb")
end

function ctrl:onInit(node)
    --金库输入框的占位容器
    local pwdPanel = node:findChild("panel/pwdPanel")
    --金库密码输入框
    local editPwd = kk.edit.createPasswordWithParent(pwdPanel, "editPwd", "请输入6-12位数字或字母")
    editPwd:setPlaceholderFontColor(cc.c4b(133,118,91,255))
    editPwd:setFontColor(cc.c4b(129,46,3,255))
    editPwd:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editboxHandle(eventname,sender) 
    end) 
    editPwd:setTag(1001)

    --进入金库
    local enterButton = node:findChild("panel/enterTreasury")
    enterButton:onClick(function()
        self:enterTeasury()
    end)

    --忘记密码
    local forgetPwd = node:findChild("panel/forgetPwd")
    forgetPwd:onClick(function()
        self:forgetPwd()
    end)

    --说明框间距改为0
    node:findChild("panel/Text_2"):getVirtualRenderer():setLineSpacing(0)
end

--============文件内部调用（私有）===========--
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

--============点击响应事件===========--
--进入金库
function ctrl:enterTeasury()
   if not isPwd then
       kk.msgup.show("密码格式错误")
       return
   end
   local pwd = self:getNode():findChild("panel/pwdPanel/editPwd")
   web.sendEnterTreasuryReq(pwd:getText(), CC.Player.uid, CC.Player.appKey, handler(self,self.sendEnterTreasuryCallback))
end

--忘记密码
function ctrl:forgetPwd()
    require("koko.ui.lobby.ui_personal_box_setpwd"):create(2):install(self:getNode())
end

--============回调===========--
--输入框回调
function ctrl:editboxHandle(eventname, sender)
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
    end
end

--进入金库请求回调
function ctrl:sendEnterTreasuryCallback(t)
    if t.success then
        kk.msgup.show("操作成功")
        for key, value in pairs(t.data) do
            ccwrn("key == " .. tostring(key) .. "<---------->" .. "value == " .. tostring(value))
        end
        require("koko.ui.lobby.ui_personal_box_treasury"):create():install(self:getNode())
        return 
    end
    kk.msgup.show(t.message)
end

return ctrl
