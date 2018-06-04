local CMD = require("app.net.CMD")
local UIHelper = require("app.common.UIHelper")

local ViewEntry = class("ViewEntry", cc.mvc.ViewBase)

function ViewEntry:ctor(ctrl, container)
	ViewEntry.super.ctor(self)
	self.UIContainer = container;
	local csbnode = cc.CSLoader:createNode("cocostudio/home/EntryLayer.csb")
	csbnode:addTo(self)

	self.btn_QuickStart = UIHelper.seekNodeByName(csbnode, "Button_QuickStart")
	self.btn_QuickStart:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP.hc:quickStart();
		end
	end)

	local btn_Game = UIHelper.seekNodeByName(csbnode, "Button_Game")
	btn_Game:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP.hc:showSelectRoom(self.UIContainer);
			APP.GD.private_room_select = 1;
		end
	end)

	local btn_FriendRoom = UIHelper.seekNodeByName(csbnode, "Button_FriendRoom")
	btn_FriendRoom:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP.hc:showFriendRoom(self.UIContainer)
			APP.GD.private_room_select = 2;
		end
	end)

	self:effectStart()
	
	self.handle = scheduler.scheduleGlobal(function()
        if APP.GD.private_room_select == 2 and self.UIContainer then
			APP.hc:showFriendRoom(self.UIContainer);
		elseif APP.GD.private_room_select == 1 and  self.UIContainer then
			APP.hc:showSelectRoom(self.UIContainer);
		end 
		scheduler.unscheduleGlobal(self.handle);
	end, 0.05)
end

function ViewEntry:onEnter()
    ViewEntry.super.onEnter(self)
end

function ViewEntry:onExit()
	if self.handle then
			scheduler.unscheduleGlobal(self.handle);
	end
    ViewEntry.super.onExit(self)
end

-- 快速开始特效
function ViewEntry:effectStart()
	local spriteFrameCache = cc.SpriteFrameCache:getInstance()
	local frames = {}
	for i = 1, 24 do
		table.insert(frames, spriteFrameCache:getSpriteFrame(string.format("image/start/start_%d.png", i)))
	end
	local animation, sprite = display.newAnimation(frames, 0.08)
	local animate = cc.Animate:create(animation)
	sprite:addTo(self)
		:move(self.btn_QuickStart:getPositionX(), self.btn_QuickStart:getPositionY())
	sprite:runAction(
		cc.RepeatForever:create(animate)
	)
end

return ViewEntry