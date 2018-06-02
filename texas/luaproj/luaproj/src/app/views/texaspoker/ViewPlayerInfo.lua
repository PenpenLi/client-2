local UIHelper = require("app.common.UIHelper")
local utils = require("app.common.utils")
local PopBaseLayer = require("app.views.common.PopBaseLayer")
local ViewPlayerInfo = class("ViewPlayerInfo", PopBaseLayer)

ViewPlayerInfo.PROPS = {
	{id = 1, img = ""},
	{id = 2, img = ""},
	{id = 3, img = ""},
	{id = 4, img = ""},
	{id = 5, img = ""},
}

function ViewPlayerInfo:ctor(uid)
	ViewPlayerInfo.super.ctor(self)

	self.uid = uid
	local players = APP.GD.room_players
	local player = players:getPlayerByUid(uid)

	local csbnode = cc.CSLoader:createNode("cocostudio/game/PlayerInfoNode.csb")
		:addTo(self.BG)
		:move(357, 253)

	self.img_Head = UIHelper.seekNodeByName(csbnode, "Image_Head")
	self.img_Head:loadTexture(string.format("cocostudio/game/image/head_%d.png", player.head_ico or 1))

	local text_Nickname = UIHelper.seekNodeByName(csbnode, "Text_Nickname")
	text_Nickname:setString(tostring(player.uname))

	local text_Gold = UIHelper.seekNodeByName(csbnode, "Text_Gold")
	text_Gold:setString(utils.convertNumberShort(player.credits))

	local text_Total = UIHelper.seekNodeByName(csbnode, "AtlasLabel_Total")
	text_Total:setString(tostring(10000))
	local text_Win = UIHelper.seekNodeByName(csbnode, "AtlasLabel_Win")
	local text_BetIn = UIHelper.seekNodeByName(csbnode, "AtlasLabel_BetIn")
	local text_BetOut = UIHelper.seekNodeByName(csbnode, "AtlasLabel_BetOut")

	self:updateNumber(text_Win, 56.2)
	self:updateNumber(text_BetIn, 15.0)
	self:updateNumber(text_BetOut, 3.2)

	self.textPropTip = UIHelper.seekNodeByName(csbnode, "Text_PropTip")

	self:addProps()
end

function ViewPlayerInfo:onEnter()
    ViewPlayerInfo.super.onEnter(self)
end

function ViewPlayerInfo:onExit()
    ViewPlayerInfo.super.onExit(self)
end

-- 显示数字和调整百分号的位置
function ViewPlayerInfo:updateNumber(textNode, number)
	local n_str = tostring(number)
	-- 取一位小数
	local dot = string.find(n_str, '%.') 
    if dot then
        n_str = string.format("%s:%s", string.sub(n_str, 1, dot - 1), string.sub(n_str, dot + 1, dot + 1))
    end
    textNode:setString(n_str)
end

-- 添加道具
function ViewPlayerInfo:addProps()
	local gameUser =APP.GD.GameUser
	if gameUser.uid == self.uid then
		self.textPropTip:hide()
		return
	end
	for i = 1, #ViewPlayerInfo.PROPS do
		local n = (i - math.ceil(#ViewPlayerInfo.PROPS / 2))
		if math.mod(#ViewPlayerInfo.PROPS, 2) == 0 then
			n = n - 0.5
		end

		ccui.Button:create("cocostudio/game/image/player/prop_bg.png", "cocostudio/game/image/player/prop_bg.png")
			:addTo(self.BG)
			:move(357 + n * 80, 253 - 175)
	end
end

return ViewPlayerInfo