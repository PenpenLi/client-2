local utils = require("utils")

local SocketTCP = require("app.net.SocketTCP")
local PacketBuffer = require("app.net.PacketBuffer")
-- local ByteArray = require("cocos.framework.ByteArray")

local SocketHandlers = require("app.handlers.SocketHandlers")

local GameSocket = class("GameSocket")

GameSocket.S_NONE = 1
GameSocket.S_INITED = 2
GameSocket.S_CONNECTING = 3
GameSocket.S_CONNECTED = 4
GameSocket.S_DISCONNECTING = 5
GameSocket.S_DISCONNECTED = 6

GameSocket.STATUS_PRINTS = {
    "NONE",
    "INITED",
    "CONNECTING",
    "CONNECTED",
    "DISCONNECTING",
    "DISCONNECTED"
}

function GameSocket:ctor(host, port, name, id)
	self._name = name
    self._id = id
	self._status = GameSocket.S_NONE
	self._msgQueue = {}
	self._blocked = false
	self.onConnected = nil
	self.PENDING_SEND = {}
	self.SEQUENCE = 0

    self._socket = SocketTCP.new(host, port, false)
    self._socket:addEventListener(SocketTCP.EVENT_CONNECTED, function(event) self:onSocketEvent(event) end)
    self._socket:addEventListener(SocketTCP.EVENT_CLOSE, function(event) self:onSocketEvent(event) end)
    self._socket:addEventListener(SocketTCP.EVENT_CLOSED, function(event) self:onSocketEvent(event) end)
    self._socket:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE, function(event) self:onSocketEvent(event) end)
    self._socket:addEventListener(SocketTCP.EVENT_DATA, function(event) self:onSocketData(event) end)

    self._packetBuffer = PacketBuffer.new()

    self:switchStatus(GameSocket.S_INITED)

    scheduler.scheduleGlobal(function(dt) self:handleMessages(dt) end, 0.01)
end

function GameSocket:getStatus()
    return self._status
end

function GameSocket:getStatusString()
    return GameSocket.STATUS_PRINTS[self._status]
end

function GameSocket:switchStatus(newStatus)
    printInfo("[GameSocket] [%s] switch status [%s] -> [%s]", 
    	self._name,
        GameSocket.STATUS_PRINTS[self._status], 
        GameSocket.STATUS_PRINTS[newStatus])
    self._status = newStatus
end

function GameSocket:connect(callback)
    assert(self._socket ~= nil)
    assert(self._status == GameSocket.S_INITED or
        self._status == GameSocket.S_DISCONNECTED)
    -- printInfo("[GameSocket] [%s] [%s] connect", self._name, utils.timeStr())
    self:switchStatus(GameSocket.S_CONNECTING)
    self.onConnected = callback
    self._socket:connect()
end

function GameSocket:disconnect()
    assert(self._socket ~= nil)
    assert(self._status ~= GameSocket.S_NONE)
    printInfo("a", "[GameSocket] [%s] [%s] disconnect", self._name, utils.timeStr())
    self:switchStatus(GameSocket.S_DISCONNECTING)
    self._socket:disconnect()
end

function GameSocket:close()
    self.PENDING_SEND = nil;
    assert(self._socket ~= nil)
    -- if self._status == GameSocket.S_CONNECTED then
        self._socket:close()
    -- end
end

function GameSocket:send(subCmd, data, isCompress)

    if type(subCmd) ~= "number" or tonumber(subCmd) < 0 then
        printInfo("Invalide subCmd:%s", tostring(subCmd))
        return -1
    end
    if type(data) ~= "table" then
        printInfo("[GameSocket] [%s] data must be a table:%s", self._name, tostring(data))
        return -1
    end

    data = json.encode(data)
    local packetBuffer = PacketBuffer.createPacket(subCmd, data, isCompress);

    if self._status == GameSocket.S_CONNECTED then
		if subCmd ~= 65535 then 
			printLog("net", "[GameSocket] send packet: %d, %s", 
				subCmd, data)
		end

        local nsend = self._socket:send(packetBuffer:getPack())
		if nsend and nsend > 0 then
			return 0
		else
			return -2;
		end
    --正在连接中,这个时候发送的数据都转到连接完成再发送
    elseif self._status == GameSocket.S_CONNECTING then
        table.insert(self.PENDING_SEND, packetBuffer);
    else
        --回调当网络已经不在连接状态下发包
        SocketHandlers.handleSendWithClose(subCmd, data, isCompress)
        return -2;
    end
    return 0;
end

function GameSocket:onSocketEvent(event)
    -- printInfo("[GameSocket] [%s] event: %s", utils.timeStr(), event.name)
    if event.name == SocketTCP.EVENT_CONNECTED then
        if self.PENDING_SEND then
            for _, v in pairs(self.PENDING_SEND) do
                self._socket:send(v:getPack())
            end
            self.PENDING_SEND = nil;
        end

        self:switchStatus(GameSocket.S_CONNECTED)
        if self.onConnected then
	        self.onConnected()
	    end
    elseif event.name == SocketTCP.EVENT_CLOSE then
		printLog("a","[GameSocket] [%s] EVENT_CLOSE", self._name)
    elseif event.name == SocketTCP.EVENT_CLOSED then
        printLog("a","[GameSocket] [%s] EVENT_CLOSED", self._name)
    elseif event.name == SocketTCP.EVENT_CONNECT_FAILURE then
    	printLog("a","[GameSocket] [%s] connect failure", self._name)
        local LANG =APP.GD.LANG
        dispatchCustomEvent("COMMON_ERROR", LANG.ERR_SOCKET_CONNECT)
    else
        assert(0, "[GameSocket] unknown event")
    end
end

function GameSocket:onSocketData(event)
    -- printInfo("[GameSocket] [%s] receive data", self._name)
    local __msgs = self._packetBuffer:parsePackets(event.data)
    local __msg = nil
    for i = 1, #__msgs do
        __msg = __msgs[i]
        -- printInfo("[GameSocket] [%s] [%s] receive packet", 
        -- 	self._name,
        --     utils.timeStr())
        table.insert(self._msgQueue, __msg)
    end
end

function GameSocket:handleMessages(dt)
    if self._blocked then
        return
    end
	
	if dt > 3.0 then
		self:close();
		return
	end

    self.SEQUENCE = self.SEQUENCE + 1
    while #self._msgQueue > 0 do
        local __msg = self._msgQueue[1]
		table.remove(self._msgQueue, 1)
        if __msg.socket_close then
            APP:getCurrentController():hideWaiting()
            if self:getStatus() ~= GameSocket.S_DISCONNECTED then
                self:switchStatus(GameSocket.S_DISCONNECTED)
            end
        else
			SocketHandlers.handleMessage(self._id, __msg)
        end
    end
end

function GameSocket:blockMessage()
	printLog("a","blockMessage")
    --self._blocked = true
end

function GameSocket:unblockMessage()
	printLog("a","unblockMessage")
    self._blocked = false
end

return GameSocket