local GameConfig = require("app.common.GameConfig")
local CMD = require("app.net.CMD")

local AccountServerHandlers = require("app.handlers.AccountServerHandlers")
local CoordinateServerHandlers = require("app.handlers.CoordinateServerHandlers")


local SocketHandlers = {}

SOCKET_HANDLERS = SocketHandlers

SocketHandlers.HANDLERS = {}
SocketHandlers.HANDLERS[GameConfig.ID_ACCOUNTSERVER] = {}
SocketHandlers.HANDLERS[GameConfig.ID_COORDINATESERVER] = {}
SocketHandlers.HANDLERS[GameConfig.ID_GAMESERVER] = {}

function SocketHandlers.active()
    AccountServerHandlers.active();
    CoordinateServerHandlers.active();
end

function SocketHandlers.handleMessage(socket_id, data)
	local content = json.decode(data.content)

	if data.subCmd == CMD.GAME_PRIVATE_ROOM_INFO then
		printLog("clean", "private info:".. data.content);
		if APP.gc then
			local a = APP.gc.viewRoom;
		end
	end
	--接管处理存不存在
	local takeover = SocketHandlers.HANDLERS[socket_id]["takeover"];
	--如果存在
	if takeover then
		takeover(data.subCmd, data)
	--如果不存在,正常处理
	else
		
		dispatchCustomEvent("NET_MSG", socket_id, data.subCmd, content)

		local handler = SocketHandlers.HANDLERS[socket_id][data.subCmd];
		if not handler then return end;
		if handler[2] and handler[2].handler then
			handler[2].handler(content)
		elseif handler[1] and handler[1].handler then
			handler[1].handler(content)
		else
			printInfo("[SocketHandlers] handle unkwown message type: %d", 
				data.subCmd)
		end
	end

end

function SocketHandlers.registerHandler(server, cmd, level, handler, delkey)
	delkey = delkey or "default";

    if not SocketHandlers.HANDLERS[server] then 
        SocketHandlers.HANDLERS[server] = {};
    end

    if not SocketHandlers.HANDLERS[server][cmd] then
        SocketHandlers.HANDLERS[server][cmd] = {};
    end
	if not SocketHandlers.HANDLERS[server][cmd][level]  then
		SocketHandlers.HANDLERS[server][cmd][level] = {}
	end

	if handler then
		SocketHandlers.HANDLERS[server][cmd][level].handler = handler;
		SocketHandlers.HANDLERS[server][cmd][level].delkey = delkey;
	else
		if SocketHandlers.HANDLERS[server][cmd][level].delkey == delkey then
			SocketHandlers.HANDLERS[server][cmd][level] = nil;
		end
	end
end

function SocketHandlers.handleOfflineMessage(data)
    -- local handler = SocketHandlers.HANDLERS[data.subCmd]

    -- if handler then
    --     handler(data.payload, data.timestamp)
    -- else
    --     printInfo("[SocketManager] handle unkwown message type: 0x%04X", 
    --         data.subCmd)
    -- end   
end

function SocketHandlers.handleSendFail(type, data)
    -- local response = {type = type, data = data, err = true}
    -- APP:getCurrentController():updateByMessage(response)
end 

function SocketHandlers.handleSendWithClose(type, data)
    -- local response = {type = type, data = data, err = true}
    -- APP:getCurrentController():updateByMessage(response)    
end

return SocketHandlers