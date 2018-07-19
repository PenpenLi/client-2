local UIHelper = require("app.common.UIHelper")
local LeftBaseLayer = require("app.views.common.LeftBaseLayer")
local ViewCardType = class("ViewCardType", LeftBaseLayer)

function ViewCardType:ctor(baseBet, allInBet)
	ViewCardType.super.ctor(self)

	local csbnode = cc.CSLoader:createNode("cocostudio/game/CardTypeLayer.csb")
	csbnode:addTo(self)
	
end

function ViewCardType:onEnter()
	ViewCardType.super.onEnter(self)
end

function ViewCardType:onExit()
	ViewCardType.super.onExit(self)
end

return ViewCardType