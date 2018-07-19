local UIHelper = require("app.common.UIHelper")

local conf = require("app.common.GameConfig")

local HomeControllerBase = require("app.controllers.HomeControllerBase");
local HomeController = class("HomeController", HomeControllerBase)


function HomeController:ctor()
    HomeController.super.ctor(self)

	UIHelper.cacheEffectHome()
	cc.SpriteFrameCache:getInstance():addSpriteFrames("cocostudio/home/image/personal/personal_sp.plist")
	UIHelper.cacheCards()

	self:addChild(APP:createView("home.ViewHome", self))

    local broadcastWidth = 500
	local broadcastHeight = 40
    local broadcastView = APP:createView("common.BroadcastNode", {width = broadcastWidth, height = broadcastHeight})
    broadcastView:setPosition(cc.p((display.width - broadcastWidth) / 2, 1150))
    self:addChild(broadcastView)
	
end

function HomeController:onExit()
	HomeController.super.onExit(self)

end

function HomeController:onDelete()
	HomeController.super.onDelete(self)

end

function HomeController:quickStart()
	
	local gold_exchaged = APP.GD:isGoldExchanged()
	if gold_exchaged then
		local roomList = APP.GD:getRoomList()
		local config_index = roomList[1].id
		self:enterRoom(0, config_index)
	else
		local LANG =APP.GD.LANG
		self:showAlertOK({desc = LANG.TIP_NET_NOT_READY})
	end
	APP.GD.private_room_select = 0;
end
return HomeController