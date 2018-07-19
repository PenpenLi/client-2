
local _G = _G
local view = import(".view")

module("comm.kk.msgup")

cls = _G.class("kk.msgup", view)

function show(text)
    showEx(nil, "koko/ui/common/msgup.csb", text)
end

function showEx(parent, csb, text)
    local obj = cls:create(csb, text)
    obj:install(parent)
    return obj
end

function cls:ctor(csb, text)
    self:setCsbPath(csb)
    self.text = text
    self:setZOrder(503)
end

function cls:onInit(node)
    node:findChild("txtMsg"):setString(self.text)
    local action = _G.cc.CSLoader:createTimeline(self:getCsbPath())
    action:gotoFrameAndPlay(0, false)
    action:setLastFrameCallFunc(function() 
		self:close()
	end)
    node:runAction(action)
end
