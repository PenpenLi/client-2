
local _G = _G
local view = import(".view")

module("comm.kk.waiting")

cls = _G.class("kk.waiting", view)

local obj = nil

function show(msg)
    showEx(nil, msg)
end

function showEx(root, msg)
    if obj then
        obj:setString(msg or "")
    else
        obj = cls:create(msg or "")
        obj:install(root)
        _G.cclog("[waiting] show waiting: __%s", msg)
    end
end

function close()
    if obj then
        obj:close()
        obj = nil
        _G.cclog("[waiting] close waiting.")
    end
end

function isVisible()
    return obj ~= nil
end

-------------------------------------------------------------
--私有接口，禁止调用

function cls:ctor(msg)
    self:setCsbPath("koko/ui/common/waiting.csb")
    self.message = msg
end

function cls:onInit(node)
    node:findChild("txtTip"):setString(self.message)
    local csb = self:getCsbPath()
    local action = _G.cc.CSLoader:createTimeline(csb)
    action:gotoFrameAndPlay(0, true)
    node:runAction(action)
end

function cls:setString(msg)
    local node = self:getNode()
    if node then
        self.message = msg
        node:findChild("txtTip"):setString(msg)
    end
end
