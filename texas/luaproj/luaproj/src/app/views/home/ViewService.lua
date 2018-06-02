local GameConfig = require("app.core.GameConfig")
local UIHelper = require("app.common.UIHelper")
local PopBaseLayer = require("app.views.common.PopBaseLayer")
local ViewService = class("ViewService", PopBaseLayer)

function ViewService:ctor()
	ViewService.super.ctor(self)

	local csbnode = cc.CSLoader:createNode("cocostudio/home/ServiceNode.csb")
		:addTo(self.BG)
		:move(357, 253)

	local text_QQ_1 = UIHelper.seekNodeByName(csbnode, "Text_QQ_1")
	text_QQ_1:setString(tostring(GameConfig.QQ1))
	local text_QQ_2 = UIHelper.seekNodeByName(csbnode, "Text_QQ_2")
	text_QQ_2:setString(tostring(GameConfig.QQ2))
end

function ViewService:onEnter()
    ViewService.super.onEnter(self)
end

function ViewService:onExit()
    ViewService.super.onExit(self)
end

return ViewService