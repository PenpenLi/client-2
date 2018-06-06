local UIHelper = require("app.common.UIHelper")

local LeftBaseLayer = class("LeftBaseLayer", cc.mvc.ViewBase)

function LeftBaseLayer:ctor()
	LeftBaseLayer.super.ctor(self)

	local csbnode = cc.CSLoader:createNode("cocostudio/common/LeftBaseLayer.csb")
    csbnode:addTo(self)

    local bg = UIHelper.seekNodeByName(csbnode, "Image_BG")
    bg:addTouchEventListener(function(ref, t)
        if t == ccui.TouchEventType.ended then
            self:actionExit()
        end
    end)
end

function LeftBaseLayer:onEnter()
	LeftBaseLayer.super.onEnter(self)
	self:actionEnter()
end

function LeftBaseLayer:onExit()
	LeftBaseLayer.super.onExit(self)
end

function LeftBaseLayer:actionEnter()
	self:runAction(cc.EaseSineIn:create(cc.MoveTo:create(0.2, cc.p(574, 0))))
end

function LeftBaseLayer:actionExit()
	self:runAction(
		cc.Sequence:create(
			cc.EaseSineOut:create(
				cc.MoveTo:create(0.2, cc.p(0, 0))
			), 
			cc.RemoveSelf:create()))
end

return LeftBaseLayer