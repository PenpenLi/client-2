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
	
	self:scheduleOnce(function()
        if APP.GD.private_room_select == 2 and self.UIContainer then
			APP.hc:showFriendRoom(self.UIContainer);
		elseif APP.GD.private_room_select == 1 and  self.UIContainer then
			APP.hc:showSelectRoom(self.UIContainer);
		end 
	end, 0.05, "12313")

	self.btn_Rank = UIHelper.seekNodeByName(csbnode,"Button_rank")
    self.btn_Rank:addTouchEventListener(function (ref, t)
        if t == ccui.TouchEventType.ended then    
			APP.hc:showRank()
		end
    end)
    self.btn_Rank:setOpacity(0)

	local Button_Game_An =  UIHelper.seekNodeByName(csbnode,"Button_Game_An");
	UIHelper.newAnimation(27, Button_Game_An, function(i) return string.format("youxichang_%05d.png", i - 1) end);

	local Button_FriendRoom_An =  UIHelper.seekNodeByName(csbnode,"Button_FriendRoom_An");
	UIHelper.newAnimation(23, Button_FriendRoom_An, function(i) return string.format("paiyouchang_%04d.png", i) end);

	local Sprite_18 =  UIHelper.seekNodeByName(csbnode,"Sprite_18");
	UIHelper.newAnimation(16, Sprite_18, function(i) return string.format("paihang1_%05d.png", i - 1) end);

	local Sprite_16 =  UIHelper.seekNodeByName(csbnode,"Sprite_16");
	UIHelper.newAnimation(16, Sprite_16, function(i) return string.format("paihang2_%05d.png", i - 1) end);
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
	UIHelper.newAnimation(24, self,
	 function(i)  return string.format("image/start/start_%d.png", i) end,
	 cc.p(self.btn_QuickStart:getPositionX(), self.btn_QuickStart:getPositionY()));
end

return ViewEntry