local UIHelper = require("app.common.UIHelper")
local CMD = require("app.net.CMD")

local ViewFullScreenBase = require("app.views.home.ViewFullScreenBase")
local ViewFriendRoom = class("ViewFriendRoom", ViewFullScreenBase)

function ViewFriendRoom:ctor()
	ViewFriendRoom.super.ctor(self)
	self.uiContainer = UIHelper.seekNodeByName(self, "UIContainer");

	self.csbnode = cc.CSLoader:createNode("cocostudio/home/FriendRoomLayer.csb")
    self.csbnode:addTo(self.uiContainer)

	self.myRooms = UIHelper.seekNodeByName(self.csbnode, "ListView_3");

    local btn_Create = UIHelper.seekNodeByName(self.csbnode, "Button_Join")
    btn_Create:addTouchEventListener(function(target, eType)
        if eType == ccui.TouchEventType.ended then
			APP:createView("friendroom.EnterPrivateRoom"):addTo(self.uiContainer);
        end
    end)

    local btn_Join = UIHelper.seekNodeByName(self.csbnode, "Button_Create")
    btn_Join:addTouchEventListener(function(target, eType)
        if eType == ccui.TouchEventType.ended then
			APP:createView("friendroom.CreatePrivateRoom"):addTo(self.uiContainer);
        end
    end)

	local btn_Join = UIHelper.seekNodeByName(self.csbnode, "Button_Record")
    btn_Join:addTouchEventListener(function(target, eType)
        if eType == ccui.TouchEventType.ended then
           APP:createView("friendroom.PrivateRoomResult", APP.hc, self.uiContainer):addTo(self.uiContainer);
        end
    end)


	btn = UIHelper.seekNodeByName(self, "Button_Help")
	btn:addTouchEventListener(function(target, eType)
        if eType == ccui.TouchEventType.ended then
           APP:createView("friendroom.ViewFriendRoomHelp"):addTo(self.uiContainer);
        end
    end)

	addListener(self, "NET_MSG", handler(self, self.onMsg));
	APP.hc:QueryMyPrivateRoom();
end

function ViewFriendRoom:onMsg(fromServer, subCmd, content)
	if subCmd == CMD.GAME_PRIVATE_ROOM_INFO and fromServer == 2 then
		local place_holder = UIHelper.seekNodeByName(self, "place_holder");
		place_holder:setVisible(false);

		local pi = APP:createView("friendroom.PrivateRoomItem");
		pi:setInfo(content);
		self.myRooms:addChild(pi);
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
end

return ViewFriendRoom