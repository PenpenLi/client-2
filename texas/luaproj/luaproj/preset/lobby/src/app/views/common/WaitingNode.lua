local UIHelper = require("app.common.UIHelper")
local utils = require("utils")

local WaitingNode = class("WaitingNode", function()
    return display.newNode()
end)

function WaitingNode:ctor(options)
	local options = options or {}
	local blank = options.blank or false
    local view = cc.CSLoader:createNode("cocostudio/common/WaitingLayer.csb"):addTo(self)

	local bg = UIHelper.seekNodeByName(view, "Image_BG")
	if blank then
        bg:setOpacity(0)
    else
        bg:setOpacity(140)
    end

    local loading = UIHelper.seekNodeByName(view, "Image_Loading")
    local rotAction = cc.RotateBy:create(1,360)
    local repAction = cc.RepeatForever:create(rotAction)
    loading:runAction(repAction)

	if options.autoClose == 1 then
		loading:runAction(cc.Sequence:create(cc.DelayTime:create(5.0), cc.RemoveSelf:create()));
	end

	loading:resume();
end

function WaitingNode:onEnter()
   self.super.onEnter(self);
	
end

return WaitingNode