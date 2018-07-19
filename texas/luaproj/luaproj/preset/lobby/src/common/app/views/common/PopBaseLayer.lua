local UIHelper = require("app.common.UIHelper")

local PopBaseLayer = class("PopBaseLayer", cc.mvc.ViewBase)

function PopBaseLayer:ctor()
	PopBaseLayer.super.ctor(self)

	local csbnode = cc.CSLoader:createNode("common/PopBaseLayer.csb")
    csbnode:addTo(self)

    self.BG = UIHelper.seekNodeByName(csbnode, "Image_BG")
    self.BG:setScale(0.00)
end

--MVCÖÐµÄC-¿ØÖÆÆ÷
function PopBaseLayer:pctor()
	local btn_Close = UIHelper.seekNodeByName(self, "Button_Close")
    btn_Close:addTouchEventListener(function(ref, t)
        if t == ccui.TouchEventType.ended then
            self:actionExit()
        end
    end)
end

function PopBaseLayer:onEnter()
	PopBaseLayer.super.onEnter(self)
	self:actionEnter()
end

function PopBaseLayer:onExit()
	PopBaseLayer.super.onExit(self)
end

function PopBaseLayer:actionEnter()
	self.BG:runAction(cc.ScaleTo:create(0.15, 1))
end

function PopBaseLayer:actionExit()
	self.BG:runAction(
		cc.Sequence:create(
			cc.ScaleTo:create(0.15, 0.00), 
			cc.CallFunc:create(function()
				self:removeSelf()
			end)))
end

return PopBaseLayer