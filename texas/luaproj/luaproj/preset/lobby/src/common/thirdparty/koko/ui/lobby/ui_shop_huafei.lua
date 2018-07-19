local proto2 = require("koko.proto2")
local CC = require("comm.CC")

local ctrl = class("kkShopHuaFei", kk.view)

function ctrl:ctor(id)
    self:setCsbPath("koko/ui/lobby/shop_huafei.csb")
    self:setAnimation(kk.animScale:create())
    self.id = id
end

function ctrl:onInit(node)
    self:onInitEdit(node)
    node:findChild("panel/reGetBtn"):onClick(function() self:refreshCodeImage() end)
    node:findChild("panel/btnConfirm"):onClick(handler(self, self.onConfirm))
    node:findChild("panel/close"):onClick(mkfunc(kk.uimgr.unload, self))
end

function ctrl:onInitEdit(node)
    -- 手机号
    local phoneNum = node:findChild("panel/phone")
    local editPhoneNum = kk.edit.createNumber(phoneNum:getContentSize(), "")
    editPhoneNum:setName("editPhoneNum")
    editPhoneNum:setPlaceholderFontColor(cc.c3b(0x85, 0x76, 0x5b))
--    editPhoneNum:registerScriptEditBoxHandler(handler(self, self.editPhoneNumHandle))
    phoneNum:addChild(editPhoneNum)
    -- 确认手机号
    local againPhone = node:findChild("panel/againPhone")
    local editagainPhone = kk.edit.createNumber(againPhone:getContentSize(), "")
    editagainPhone:setName("editagainPhone")
    editagainPhone:setPlaceholderFontColor(cc.c3b(0x85, 0x76, 0x5b))
    -- editagainPhone:registerScriptEditBoxHandler(handler(self, self.editagainPhoneHandle))
    againPhone:addChild(editagainPhone)
    --验证码输入框
    local secureCode = node:findChild("panel/secureCode")
    local editSecureCode = kk.edit.createAny(secureCode:getContentSize(), "请输入验证码")
    editSecureCode:setName("editSecureCode")
    editSecureCode:setPlaceholderFontColor(cc.c3b(0x85, 0x76, 0x5b))
    secureCode:addChild(editSecureCode)

    self:refreshCodeImage()
end

--刷新验证码图片
function ctrl:refreshCodeImage()
    local codeImage = self:getNode():findChild("panel/codeImage")
    require("web").bindCodeWithControl(codeImage)
end

-- function ctrl:editPhoneNumHandle(eventname, sender)
--     if eventname == "ended" then
--         local text = self:getNode():findChild("panel/phone/editPhoneNum"):getText()
--         if text == "" then return end
--         local isOk = CC.Check:Phone(text)
--         if not isOk then
--             kk.msgup.show("手机号码不符合规则！")
--         end
--     end
-- end
-- function ctrl:editagainPhoneHandle(eventname, sender)
--     if eventname == "ended" then
--         local text = self:getNode():findChild("panel/againPhone/editagainPhone"):getText()
--         if text == "" then return end
--         local isOk = CC.Check:Phone(text)
--         if not isOk then
--             kk.msgup.show("手机号码不符合规则！")
--         end
--     end
-- end
-- 确认按钮
function ctrl:onConfirm()
    local text = self:getNode():findChild("panel/phone/editPhoneNum"):getText()
    if text == "" then return end
    local isOk = CC.Check:Phone(text)
    if not isOk then
        kk.msgup.show("手机号码不符合规则！")
        return
    end
    local text1 = self:getNode():findChild("panel/againPhone/editagainPhone"):getText()
    if text1 == "" then return end
    local isOk = CC.Check:Phone(text1)
    if not isOk then
        kk.msgup.show("手机号码不符合规则！")
        return
    end
    if text ~= text1 then 
        kk.msgup.show("两个手机号码不匹配!")
        return
    end
    local code = self:getNode():findChild("panel/secureCode/editSecureCode"):getText()
    local function callback(errcode, errmsg)
        if errcode == 1 then
            kk.msgup.show("话费购买成功!")
            kk.uimgr.unload(self)
        else
            kk.msgup.show(errmsg)
        end    
    end
    local function callback_code(t)
        if t.success then
            --发送购买协议
            local id = self.id
            proto2.sendBuyItemReq(id, 1, text, callback)
        else
            kk.msgup.show(t.message)
        end
    end
    --发送验证码请求
    require("web").sendVerifyCode(code, callback_code)
end

return ctrl