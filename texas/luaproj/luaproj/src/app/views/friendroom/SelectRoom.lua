--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIHelper = require("app.common.UIHelper")
local SelectRoom = class("SelectRoom", cc.mvc.ViewBase)

function SelectRoom:ctor(ctrl, container)
	SelectRoom.super.ctor(self)
	self.UIContainer = container;
	self.csbnode = cc.CSLoader:createNode("cocostudio/home/RoomSelect.csb")
    self.csbnode:addTo(self)

	local btnBack = UIHelper.seekNodeByName(self.csbnode, "btnBack");
	btnBack:addTouchEventListener(function(sender, evt)
		if evt == ccui.TouchEventType.ended then
			self:removeSelf();
		end
	end);

	local btnQuickStart = UIHelper.seekNodeByName(self.csbnode, "btnQuickStart");
	btnQuickStart:addTouchEventListener(function(sender, evt)
		if evt == ccui.TouchEventType.ended then
			APP.hc:quickStart();
		end
	end);

	local btnPrivate = UIHelper.seekNodeByName(self.csbnode, "btnPrivate");
	btnPrivate:addTouchEventListener(function(sender, evt)
		if evt == ccui.TouchEventType.ended then
			APP.hc:showFriendRoom(self.UIContainer);
			APP.GD.private_room_select = 1;
			self:removeSelf();
		end
	end);

	self:setInfo()
end
	
function SelectRoom:setInfo()
	for i = 1, 6 do
		local roomitem = APP.GD.room_list[i];
		if roomitem then
			local cont = UIHelper.seekNodeByName(self.csbnode, string.format("FileNode_%d", i));
			cont:addChild(APP:createView("friendroom.SelectRoomItem", APP.hc, roomitem));
		end
	end
end

return SelectRoom
--endregion
