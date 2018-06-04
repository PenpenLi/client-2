local UIHelper = require("app.common.UIHelper")
local CMD = require("app.net.CMD")

local ViewMenu = class("ViewMenu", function ()
	return display.newNode()
end)

function ViewMenu:ctor()
	local csbnode = cc.CSLoader:createNode("cocostudio/game/MenuLayer.csb")
	csbnode:addTo(self)

	local btn_BG = UIHelper.seekNodeByName(csbnode, "Image_BG")
	local btn_Exit = UIHelper.seekNodeByName(csbnode, "Button_Exit")
	local btn_Situp = UIHelper.seekNodeByName(csbnode, "Button_Situp")
	local btn_ChangeTable = UIHelper.seekNodeByName(csbnode, "Button_ChangeTable")
	local btn_CardType = UIHelper.seekNodeByName(csbnode, "Button_CardType")
	local btn_Setting = UIHelper.seekNodeByName(csbnode, "Button_Setting")

	btn_BG:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			self:removeSelf()
		end
	end)

	btn_Exit:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			local data = {
				pos_ = 0,
				why_ = 0
			}
			SOCKET_MANAGER.sendToGameServer(CMD.GAME_PLAYER_LEAVE_REQ, data)
		end
	end)

	btn_CardType:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			self:removeSelf()
			APP:getCurrentController():showCardTypeLayer()
		end
	end)

	btn_Setting:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			self:removeSelf()
			APP:getCurrentController():showGameSettingLayer()
		end
	end)

	btn_Situp:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			self:removeSelf()
			APP:getCurrentController():standUp()
		end
	end)
end

return ViewMenu