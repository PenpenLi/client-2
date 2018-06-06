local UIHelper = require("app.common.UIHelper")
local utils = require("app.common.utils")

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
        bg:setOpacity(180)
    end

    local loading = UIHelper.seekNodeByName(view, "Image_Loading")
    local rotAction = cc.RotateBy:create(1,360)
    local repAction = cc.RepeatForever:create(rotAction)
    loading:runAction(repAction)

	self.container = UIHelper.seekNodeByName(view, "progress");

end

function WaitingNode:updateProgress(desc, cur, max)
	local des = UIHelper.seekNodeByName(self.container, "txtDesc");
	local pct = UIHelper.seekNodeByName(self.container, "txtProgress");
	
	self.container:setVisible(true);
	if max == 0 then
		des:setString(desc);
	else
		pct:setString(string.format("%d%%", math.ceil((cur / max) * 100)))
		des:setString(desc..string.format("%s/%s", utils.convertNumberShortKM(cur), utils.convertNumberShortKM(max)));
	end
end

return WaitingNode