local UIHelper = require("app.common.UIHelper")

local conf = require("app.common.GameConfig")
local loading = require ("loading")
local GameSpecificHandlers = g_Require("app.handlers.GameSpecificHandlers");
local GameCommonHandlers = g_Require("app.handlers.GameCommonHandlers")

local HomeControllerBase = require("app.controllers.HomeControllerBase");
local HomeController = class("HomeController", HomeControllerBase)


function HomeController:ctor()
    HomeController.super.ctor(self)
	GameCommonHandlers.active();
	GameSpecificHandlers.active();

	local vw = loading.new():addTo(self);
	vw:updateProgress("正在进入游戏...", 100, 100);
end

function HomeController:onExit()
	HomeController.super.onExit(self)
	GameSpecificHandlers.deactive();
	GameCommonHandlers.deactive();
end

function HomeController:quickStart()

end
return HomeController