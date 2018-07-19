local UIHelper = require("app.common.UIHelper")
local gameIcon = class("gameIcoon", cc.mvc.ViewBase)


--[566] = {
--		gameid = 566,
--		name = "ª∂¿÷≤∂”„",
--		icon = "images/game_icons/xuanze_huanlebuyu.png",
--		catalog = "≤∂”„",
--	},
function gameIcon:ctor(game)
	self.super.ctor(self);
	
	self.csbnode = cc.CSLoader:createNode("home/game_ico.csb");
	self.csbnode:addTo(self);

	self:setContentSize(self.csbnode:getContentSize());

	self.game = game;
	self.isChecking = false;

	local Button_Go = UIHelper.seekNodeByName(self.csbnode, "Button_Go");
	Button_Go:loadTextureNormal(game.icon, 1);
	Button_Go:loadTexturePressed(game.icon, 1);
	
	Button_Go:addTouchEventListener(touchHandler(handler(self, self.Go)))

	local gameico = display.newSprite("#"..game.icon);
	gameico:setColor(cc.c3b(0,0,0));
	
	self.timerProgress = cc.ProgressTimer:create(gameico)
	self.timerProgress:setType(1)
	self.timerProgress:setMidpoint(cc.p(0, 0))
	self.timerProgress:setBarChangeRate(cc.p(0, 1))
	self.timerProgress:setVisible(true)
	self.timerProgress:setPercentage(0)
	self.timerProgress:setOpacity(128);
	
	self.Progress = UIHelper.seekNodeByName(self.csbnode, "Progress");
	self.Progress:addChild(self.timerProgress, -1);

	self.txtPercent = UIHelper.seekNodeByName(self.csbnode, "txtPercent");
	self.txtPercent:setString("0.0%");
end

function gameIcon:showProgress()
	local per = 100;

	self.evt = scheduler.scheduleGlobal(function () 
		per = per - 1; self.timerProgress:setPercentage(per);
		self.txtPercent:setString(tostring(100 - per).."%");
		if per <= 0 then
			scheduler.unscheduleGlobal(self.evt);
			self.timerProgress:setPercentage(0);
			self.evt = nil;
		end
	end, 0.1);
	
end

function gameIcon:Go()
	startGame(self.game);
end

return gameIcon;