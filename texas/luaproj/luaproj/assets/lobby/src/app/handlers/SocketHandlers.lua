local GameConfig = require("app.core.GameConfig")
local CMD = require("app.net.CMD")

local AccountServerHandlers = require("app.handlers.AccountServerHandlers")
local CoordinateServerHandlers = require("app.handlers.CoordinateServerHandlers")
local GameCommonHandlers = require("app.handlers.GameCommonHandlers")
local TexasPokerHandlers = require("app.handlers.TexasPokerHandlers")

local SocketHandlers = {}

SOCKET_HANDLERS = SocketHandlers

SocketHandlers.HANDLERS = {}
SocketHandlers.HANDLERS[GameConfig.ID_ACCOUNTSERVER] = {}
SocketHandlers.HANDLERS[GameConfig.ID_COORDINATESERVER] = {}
SocketHandlers.HANDLERS[GameConfig.ID_GAMESERVER] = {}

function SocketHandlers.active()
    AccountServerHandlers.active();
    CoordinateServerHandlers.active();
    GameCommonHandlers.active();
end

function SocketHandlers.handleMessage(socket_id, data)
	local content = json.decode(data.content)
	APP:dispatchCustomEvent("NET_MSG", socket_id, data.subCmd, content)

    local handler = SocketHandlers.HANDLERS[socket_id][data.subCmd];
    if not handler then return end;
    if handler[2] then
        handler[2](content)
    elseif handler[1] then
        handler[1](content)
    else
        printInfo("[SocketHandlers] handle unkwown message type: %d", 
            data.subCmd)
    end
end

function SocketHandlers.registerHandler(server, cmd, level, handler)
    if not SocketHandlers.HANDLERS[server] then 
        SocketHandlers.HANDLERS[server] = {};
    end

    if not SocketHandlers.HANDLERS[server][cmd] then
        SocketHandlers.HANDLERS[server][cmd] = {};
    end
    SocketHandlers.HANDLERS[server][cmd][level] = handler;
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