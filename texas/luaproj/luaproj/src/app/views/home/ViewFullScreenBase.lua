local UIHelper = require("app.common.UIHelper")

local ViewFullScreenBase = class("ViewFullScreenBase", cc.mvc.ViewBase)

function ViewFullScreenBase:ctor()
	ViewFullScreenBase.super.ctor(self)

	local csbnode = cc.CSLoader:createNode("cocostudio/home/FullScreenBaseLayer.csb")
    csbnode:addTo(self)
end

function ViewFullScreenBase:onEnter()
	ViewFullScreenBase.super.onEnter(self)
end

function ViewFullScreenBase:onExit()
	ViewFullScreenBase.super.onExit(self)
end


return ViewFullScreenBase