local UIHelper = require("app.common.UIHelper")
local CMD = require("app.net.CMD")

local ViewFullScreenBase = require("app.views.home.ViewFullScreenBase")
local ViewFriendRoom = class("ViewFriendRoom", ViewFullScreenBase)

function ViewFriendRoom:ctor()
	ViewFriendRoom.super.ctor(self)
	self.UIContainer = UIHelper.seekNodeByName(self, "UIContainer");

	self.csbnode = cc.CSLoader:createNode("cocostudio/home/FriendRoomLayer.csb")
    self.csbnode:addTo(self.UIContainer)

	self.myRooms = UIHelper.seekNodeByName(self.csbnode, "ListView_3");

    local btn_Create = UIHelper.seekNodeByName(self.csbnode, "Button_Join")
    btn_Create:addTouchEventListener(function(target, eType)
        if eType == ccui.TouchEventType.ended then
			APP:createView("friendroom.EnterPrivateRoom"):addTo(self.UIContainer);
        end
    end)

    local btn_Join = UIHelper.seekNodeByName(self.csbnode, "Button_Create")
    btn_Join:addTouchEventListener(function(target, eType)
        if eType == ccui.TouchEventType.ended then
			APP:createView("friendroom.CreatePrivateRoom"):addTo(self.UIContainer);
        end
    end)

	local btn_Join = UIHelper.seekNodeByName(self.csbnode, "Button_Record")
    btn_Join:addTouchEventListener(function(target, eType)
        if eType == ccui.TouchEventType.ended then
           APP:createView("friendroom.PrivateRoomResult", APP.hc, self.UIContainer):addTo(self.UIContainer);
        end
    end)


	btn = UIHelper.seekNodeByName(self, "Button_Help")
	btn:addTouchEventListener(function(target, eType)
        if eType == ccui.TouchEventType.ended then
           APP:createView("friendroom.ViewFriendRoomHelp"):addTo(self.UIContainer);
        end
    end)

	self.evt = addListener(self, "NET_MSG", handler(self, self.onMsg));
	self.shouldClear = false;
	self:scheduleOnce(handler(self, self.refreshInfo), 0.1, "34121");

end

function ViewFriendRoom:refreshInfo()
	if self.shouldClear then
		self.myRooms:removeAllChildren();
		local place_holder = UIHelper.seekNodeByName(self, "place_holder");
		place_holder:setVisible(true);
		self.shouldClear = false;
	else
		self.shouldClear = true;
	end
	if APP.hc then
		APP.hc:QueryMyPrivateRoom()
		self:scheduleOnce(handler(self, self.refreshInfo), 5.0, "34121");
	end
end

function ViewFriendRoom:onMsg(fromServer, subCmd, content)
	if subCmd == CMD.GAME_PRIVATE_ROOM_INFO and fromServer == 2 then
		if self.shouldClear then
			self.myRooms:removeAllChildren();
			self.shouldClear = false;
		end
		
		local place_holder = UIHelper.seekNodeByName(self, "place_holder");
		place_holder:setVisible(false);

		--房间将要被销毁了，不显示
		if content.state_ == "1" or content.state_ == "3" then
			local a = 0;
		else
			local pi = APP:createView("friendroom.PrivateRoomItem");
			pi:setInfo(content);
			self.myRooms:addChild(pi);
		end

	elseif subCmd == 1001 and fromServer == 3 then
		
	end
end

function ViewFriendRoom:back()
	self:removeSelf();
end

function ViewFriendRoom:onEnter()
	ViewFriendRoom.super.onEnter(self)
end

function ViewFriendRoom:onExit()
	ViewFriendRoom.super.onExit(self)
	removeListener(self.evt);
end

return ViewFriendRoom