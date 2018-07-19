local UIHelper = require("app.common.UIHelper")
local ControllerBase = require("app.controllers.ControllerBase")
local AlertOK = require("app.views.common.AlertOK")
local coorCmd = require("app.commands.LoginCoordinateCommand")
local switchGSHandler = require("app.handlers.MsgTakeoverOnSwitchingSrv")
local conf = require("app.common.GameConfig")
local CMD = require("app.net.CMD")
local SoundUtils = require("app.common.SoundUtils")

local HomeControllerBase = require("app.controllers.HomeControllerBase");

local HomeController = class("HomeController", HomeControllerBase)

function HomeController:ctor()
    HomeController.super.ctor(self)
	self:enableNodeEvents()
	self.homeView = APP:createView("lobbyHome.lobbyHome");
	self.homeView:addTo(self)
end

function HomeController:quickStart()
	self:showWaiting()
	local gold_exchaged = APP.GD:isGoldExchanged()
	if gold_exchaged then
		local roomList = APP.GD:getRoomList()
		local config_index = roomList[1].id
		self:enterRoom(0, config_index)
	else
		self:hideWaiting()
		local LANG =APP.GD.LANG
		self:showAlertOK({desc = LANG.TIP_NET_NOT_READY})
	end
	APP.GD.private_room_select = 0;
end

return HomeController