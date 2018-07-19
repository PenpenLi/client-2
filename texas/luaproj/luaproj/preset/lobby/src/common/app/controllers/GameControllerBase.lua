local CMD = require("app.net.CMD");
local UIHelper = require("app.common.UIHelper")
local ControllerBase = require("app.controllers.ControllerBase")
local GameControllerBase = class("GameControllerBase", ControllerBase)

function GameControllerBase:ctor()
    GameControllerBase.super.ctor(self)

	self:onNodeEvent("enter", handler(self, self.afterEnter));
end

--站起来
function GameControllerBase:standUpRequest()
	local data = {}
	SOCKET_MANAGER.sendToGameServer(CMD.GAME_PLAYER_STANDUP, data)
end

function GameControllerBase:leaveRoomRequest()
	local data = {
		pos_ = 0,
		why_ = 0
	}
	SOCKET_MANAGER.sendToGameServer(CMD.GAME_PLAYER_LEAVE_REQ, data)
end

function GameControllerBase:enterChannelRequest()
	self.CHNSN = math.random(1, 9999999);
	self.CHNID = bit.blshift(g_CurrentGame().gameid, 24);
	self.CHNID = bit.bor(self.CHNID, APP.GD:getRoomId())
	local data = {
		sn_ = self.CHNSN,
		channel_ = self.CHNID;
	}
	SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_JOIN_CHANNEL, data)
end

function GameControllerBase:leaveChannelRequest()
	local data = {
		sn_ = self.CHNSN,
		channel_ = self.CHNID
	}
	SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_LEAVE_CHANNEL, data)
end

function GameControllerBase:chatRequest(content)
	local data = {
		channel_ = self.CHNID,
		to_ = "",
		content_ = content
	}
	SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_CHAT, data)
end

function GameControllerBase:changeRoomRequest()
	SOCKET_MANAGER.sendToGameServer(CMD.GAME_CHANGE_ROOM, {})
end

function GameControllerBase:onEnter()
	GameControllerBase.super.onEnter(self)
	self:enterChannelRequest();
end

function GameControllerBase:afterEnter()
	--放开消息处理
	table.merge(SOCKET_MANAGER.gameSocket._msgQueue, APP.GD.msgBuffering)
	APP.GD.msgBuffering = {}
end

function GameControllerBase:onExit()
	self:leaveChannelRequest();

	GameControllerBase.super.onExit(self)
end

return GameControllerBase;