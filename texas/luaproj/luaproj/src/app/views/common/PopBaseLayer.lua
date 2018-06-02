local UIHelper = require("app.common.UIHelper")

local PopBaseLayer = class("PopBaseLayer", cc.mvc.ViewBase)

function PopBaseLayer:ctor()
	PopBaseLayer.super.ctor(self)

	local csbnode = cc.CSLoader:createNode("cocostudio/common/PopBaseLayer.csb")
    csbnode:addTo(self)

    self.BG = UIHelper.seekNodeByName(csbnode, "Image_BG")
    local btn_Close = UIHelper.seekNodeByName(csbnode, "Button_Close")
    btn_Close:addTouchEventListener(function(ref, t)
        if t == ccui.TouchEventType.ended then
            self:actionExit()
        end
    end)
    self.BG:setScale(0.01)
end

function PopBaseLayer:onEnter()
	PopBaseLayer.super.onEnter(self)
	self:actionEnter()
end

function PopBaseLayer:onExit()
	PopBaseLayer.super.onExit(self)
end

function PopBaseLayer:actionEnter()
	self.BG:runAction(cc.EaseBackInOut:create(cc.ScaleTo:create(0.15, 1)))
end

function PopBaseLayer:actionExit()
	self.BG:runAction(
		cc.Sequence:create(
			cc.EaseBackInOut:create(
				cc.ScaleTo:create(0.15, 0.01)
			), 
			cc.CallFunc:create(function()
				self:removeSelf()
			end)))
end

return PopBaseLayer