local UIHelper = require("app.common.UIHelper")
local LeftBaseLayer = require("app.views.common.LeftBaseLayer")
local ViewModifyPersonal = class("ViewModifyPersonal", LeftBaseLayer)

-- 头像数量
local HEAD_COUNT = 8

function ViewModifyPersonal:ctor()
	ViewModifyPersonal.super.ctor(self)

	local csbnode = cc.CSLoader:createNode("cocostudio/home/ModifyPersonalLayer.csb")
	csbnode:addTo(self)

	for i = 1, HEAD_COUNT do
		local btnHead = ccui.Button:create("cocostudio/home/image/dating_touxiangdi.png")
			:addTo(self)
		btnHead:setPosition(cc.p(-430 + math.mod((i - 1), 4) * 100, 700 - math.modf((i - 1) / 4) * 140))
	end

end

function ViewModifyPersonal:onEnter()
    ViewModifyPersonal.super.onEnter(self)
end

function ViewModifyPersonal:onExit()
    ViewModifyPersonal.super.onExit(self)
end

return ViewModifyPersonal