--进入房间消息接管处理

require("app.handlers.SocketHandlers")
local GameConfig = require("app.common.GameConfig")
local CMD = require("app.net.CMD")

local MsgTakeoverOnEntering = {}
function MsgTakeoverOnEntering.active()
	SOCKET_HANDLERS.HANDLERS[GameConfig.ID_GAMESERVER]["takeover"] = function(subCmd, data)
		local content = json.decode(data.content);
		if subCmd == CMD.GAME_PLAYER_HINT_NOTIFY  then
			if content.hint_type_ == "2" then
				MsgTakeoverOnEntering.deactive();
				APP:ActiveCtrl("GameController");
			end
		else
			if not APP.GD.msgBuffering then
				APP.GD.msgBuffering = {}
			end
			table.insert(APP.GD.msgBuffering, data);
		end
	end
end

function MsgTakeoverOnEntering.deactive()
	SOCKET_HANDLERS.HANDLERS[GameConfig.ID_GAMESERVER]["takeover"] = nil;
end
return MsgTakeoverOnEntering;