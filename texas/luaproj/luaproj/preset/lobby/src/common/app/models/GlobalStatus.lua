local LANG = require("app.language.lang")
local GameUser = require("app.models.GameUser")
local User = require("app.models.User")
local GlobalStatus = class("GlobalStatus", cc.mvc.ModelBase)
function GlobalStatus:ctor()
    self.super.ctor(self)
	self.login_options = {}
	self.connect_coordinate_options = {}
	self.connect_game_options = {}
	self.ping_handle_account = 0
	self.ping_handle_coordinate = 0
	self.ping_handle_game = 0
	self.is_logined = false
	self.is_gold_exchanged = false
	self.room_list = {}
	self.room_players = {}
	self.chang_id = 0
	self.room_id = 0
	self.music_on = false
	self.sound_on = false
	self.vibrate_on = false
	self.private_room_select = 0;
	self.LANG = LANG;
	self.GameUser = GameUser.new();
	self.User = User.new();
	APP:setObject("User", self.User);
end

function GlobalStatus:resetGameData()
	self.room_list = {}
	self.room_players = {}
	self.room_id = 0;
	self.private_room_select = 0;
end

function GlobalStatus:getLoginOptions()
	return self.login_options
end

function GlobalStatus:getConnectCoordinateOptions()
	return self.connect_coordinate_options
end

function GlobalStatus:getConnectGameOptions()
	return self.connect_game_options
end

function GlobalStatus:getPingHandleAccount()
	return self.ping_handle_account
end

function GlobalStatus:getPingHandleCoordinate()
	return self.ping_handle_coordinate
end

function GlobalStatus:getPingHandleGame()
	return self.ping_handle_game
end

function GlobalStatus:isLogined()
	return self.is_logined
end

function GlobalStatus:isGoldExchanged()
	return self.is_gold_exchanged
end

function GlobalStatus:getRoomList()
	return self.room_list
end

function GlobalStatus:getRoomPlayers()
	return self.room_players
end

function GlobalStatus:getGameRoom()
	return self.game_room
end

function GlobalStatus:getChangId()
	return self.chang_id
end

function GlobalStatus:getRoomId()
	return self.room_id
end

function GlobalStatus:musicOn()
	return self.music_on
end
function GlobalStatus:soundOn()
	return self.sound_on
end
function GlobalStatus:vibrateOn()
	return self.vibrate_on
end

return GlobalStatus