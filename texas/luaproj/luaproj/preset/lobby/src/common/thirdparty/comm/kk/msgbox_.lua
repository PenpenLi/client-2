
local _G = _G
local CC = require("comm.CC")
local clsAnim = import(".anim_scale")
local view = import(".view")

module("comm.kk.msgbox_")

cls = _G.class("kk.msgbox", view)

function showOk(parent, csb, text, callback, time, key)
    local obj = cls:create(csb, text, true, false, callback, time, key)
    obj.hasBox = parent:findChild("msgbox") ~= nil
    obj:install(parent)
    return obj
end

function showOkCancel(parent, csb, text, callback, time, key)
    local obj = cls:create(csb, text, false, true, callback, time, key)
    obj.hasBox = parent:findChild("msgbox") ~= nil
    obj:install(parent)
    return obj
end

function showNull(parent, csb, text, callback, time, key)
    local obj = cls:create(csb, text, false, false, callback, time, key)
    obj.hasBox = parent:findChild("msgbox") ~= nil
    obj:install(parent)
    return obj
end

function cls:ctor(csb, text, isOk, isOkCancel, callback, time, key)
    self:setCsbPath(csb)
    self.text = text
    self.isOk = isOk
    self.isOkCancel = isOkCancel
    self.callback = callback
    self.time = time or 0
    self.Path = self:Excel(key)
    self:setZOrder(502)
    self:setAnimation(clsAnim:create())
end

function cls:onInit(node)
    if _G.type(self.text) ~= "string" then
        _G.ccwrn("msgbox_err:" .. _G.debug.traceback())
    end
    _G.ccwrn("msgbox_flip:" .. _G.tostring(self.text))
    node:findChild("panel/txtInfo"):setString(_G.tostring(self.text))
    local btnConfirm = node:findChild("panel/btnConfirm")
    local btnCancel = node:findChild("panel/btnCancel")
    local btnOk = node:findChild("panel/btnOk")
    local txtTimeTip = node:findChild("panel/txtTimeTip")
    txtTimeTip:setVisible(false)
    if self.isOkCancel then
        btnOk:onClick(function()
            self.result = true
            self:close()
        end)
        btnCancel:onClick(function()
            self.result = false
            self:close()
        end)
        btnOk:setVisible(true)
        btnCancel:setVisible(true)
        btnConfirm:setVisible(false)
        if self.Path then
            btnOk:loadTexture(self.Path.Ok, 1)
            btnCancel:loadTexture(self.Path.Cancel, 1)
        end
    elseif self.isOk then
        btnConfirm:onClick(function()
            self:close()
        end)
        btnConfirm:setVisible(true)
        btnOk:setVisible(false)
        btnCancel:setVisible(false)
        if self.Path then
            btnConfirm:loadTexture(self.Path.Confirm, 1)
        end
    else
        btnConfirm:setVisible(false)
        btnOk:setVisible(false)
        btnCancel:setVisible(false)
    end

     if self.time > 0 then
        txtTimeTip:setVisible(true)
        self:_refreshUI()
        node:schedule(_G.handler(self, self.onTimer), 1, "msgbox.timer")
    else
        txtTimeTip:setVisible(false)
    end

    if self.hasBox then
        node:findChild("layer"):setVisible(false)
    end
end

function cls:onTimer(dt)
    self.time = self.time - dt
    self:_refreshUI()
    if self.time <= 0 then
       self:close()
    end
end

function cls:_refreshUI()
    local node = self:getNode()
    local txtTimeTip = node:findChild("panel/txtTimeTip")
    txtTimeTip:setString(_G.string.format("界面将在 %d 秒内关闭", _G.math.round(self.time)))
end

function cls:onDestroy()
    if _G.type(self.callback) == "function" then
        self.callback(self.result)
    end
end
function cls:Excel(key)
    local tExcel = CC.Excel.Msgbox
    for i = 1, tExcel:Count() do
        local t = tExcel:At(i)
        if t.Key == key then
            return t.Path
        end
    end
end