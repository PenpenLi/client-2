local UIHelper = require("app.common.UIHelper")
local LeftBaseLayer = require("app.views.common.LeftBaseLayer")
local ViewMakeupBet = class("ViewMakeupBet", LeftBaseLayer)

function ViewMakeupBet:ctor()
	ViewMakeupBet.super.ctor(self)

	local csbnode = cc.CSLoader:createNode("cocostudio/game/MakeupLayer.csb")
	csbnode:addTo(self)
	
end

function ViewMakeupBet:onEnter()
    ViewMakeupBet.super.onEnter(self)
end

function ViewMakeupBet:onExit()
    ViewMakeupBet.super.onExit(self)
end


return ViewMakeupBet