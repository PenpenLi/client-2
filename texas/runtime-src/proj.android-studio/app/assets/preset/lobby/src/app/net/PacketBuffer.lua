--[[
PacketBuffer receive the byte stream and analyze them, then pack them into a message packet.
The method name, message metedata and message body will be splited, and return to invoker.
@see https://github.com/zrong/as3/blob/master/src/org/zengrong/net/PacketBuffer.as
@author zrong(zengrong.net)
Creation: 2013-11-14
]]
local ByteArray = require("cocos.framework.ByteArray")
local PacketBuffer = class("PacketBuffer")
local CMD = require("app.net.CMD")

PacketBuffer.ENDIAN = ByteArray.ENDIAN_BIG

-- 包总长度占用2字节
PacketBuffer.ALL_LEN = 2
-- 固定数字0xcccc占用2字节
PacketBuffer.CONST_LEN = 2
-- subCmd占用2字节
PacketBuffer.SUBCMD_LEN = 2
-- 是否压缩isCompress占用2字节
PacketBuffer.ISCOMPRESS_LEN = 2

-- 一个完整的包至少包含length、0xcccc、subcmd、isCompress，内容可以为空
PacketBuffer.BODY_LEN = PacketBuffer.ALL_LEN + PacketBuffer.CONST_LEN + PacketBuffer.SUBCMD_LEN + PacketBuffer.ISCOMPRESS_LEN

function PacketBuffer.getBaseBA()
	return ByteArray.new(PacketBuffer.ENDIAN)
end

function PacketBuffer._createHeader(payload)
	local buffer = PacketBuffer.getBaseBA()
	local payloadLen = string.len(payload)
	-- 总长度
	local len = PacketBuffer.BODY_LEN + payloadLen
	buffer:writeShort(len)
	-- 固定字节
	buffer:writeShort(0xcccc)
	return buffer 
end

function PacketBuffer._parseHeader(buffer)
	return buffer:readInt()
end

function PacketBuffer._createBody(subCmd, payload, isCompress)
	local buffer = PacketBuffer.getBaseBA()
	-- subCmd
	buffer:writeShort(subCmd)
	-- compress
	local compress = 0
	if isCompress then
		compress = 1
	end
	-- subCmd
	buffer:writeShort(compress)

	buffer:writeString(payload)
	return buffer
end

function PacketBuffer._parseBody(buffer, length)

	local subCmd = buffer:readShort()
	local isCompressed = buffer:readShort()
	local content = buffer:readString(length - 4)
	-- printInfo("subCmd:" .. tostring(subCmd))
	-- printInfo("isCompressed:" .. tostring(isCompressed))
	-- printInfo("content:" .. tostring(content))

	if isCompressed == 0 then
		isCompressed = false
	else
		isCompressed = true
	end
	
	printLog("net", "[%s][%s]", CMD:getName(subCmd) or tostring(subCmd), content);
	return {subCmd = subCmd, isCompressed = isCompressed, content = content}
end

--- Create a formated packet that to send server
function PacketBuffer.createPacket(subCmd, payload, isCompress)
	local buffer = PacketBuffer.getBaseBA()
	local headerBuffer = PacketBuffer._createHeader(payload)
	local bodyBuffer = PacketBuffer._createBody(subCmd, payload, isCompress)
	buffer:writeBytes(headerBuffer)
	buffer:writeBytes(bodyBuffer)
	return buffer
end

function PacketBuffer:ctor()
	self:init()
end

function PacketBuffer:init()
	self._buffer = PacketBuffer.getBaseBA()
end

--- Get a byte stream and analyze it, return a splited table
-- Generally, the table include a message, but if it receive 2 packets meanwhile, then it includs 2 messages.
function PacketBuffer:parsePackets(__byteString)
	local __msgs = {}
	local __pos = 0
	self._buffer:setPos(self._buffer:getLen() + 1)
	self._buffer:writeBuf(__byteString)
	-- print("buffer:" .. ByteArray.toString(self._buffer))
	self._buffer:setPos(1)
	local __flag1 = nil
	local __flag2 = nil
	local __preLen = PacketBuffer.BODY_LEN
	-- printInfo("start analyzing... buffer len: %u, available: %u", self._buffer:getLen(), self._buffer:getAvailable())
	while self._buffer:getAvailable() >= __preLen do
		-- body长度
		local __bodyLen = self._buffer:readShort() - PacketBuffer.ALL_LEN - PacketBuffer.CONST_LEN
		-- printInfo("__bodyLen:" .. tostring(__bodyLen))
		-- 固定0xcccc字节
		local __temp = self._buffer:readShort()
		local __pos = self._buffer:getPos()
		-- printInfo("\t\tbody lenth:%u", __bodyLen)
		-- buffer is not enougth, waiting...
		if self._buffer:getAvailable() < __bodyLen then 
			-- restore the position to the head of data, behind while loop, 
			-- we will save this incomplete buffer in a new buffer,
			-- and wait next parsePackets performation.
			-- printInfo("\t\treceived data is not enough, waiting... need %u, get %u", __bodyLen, self._buffer:getAvailable())
			-- printInfo("\t\tbuffer: ", self._buffer:toString())
			self._buffer:setPos(self._buffer:getPos() - PacketBuffer.ALL_LEN - PacketBuffer.CONST_LEN)
			break
		end

		local packet = PacketBuffer._parseBody(self._buffer, __bodyLen)
		assert(packet ~= nil)
		__msgs[#__msgs+1] = packet
		-- printInfo("\t\tafter get body position:%u", self._buffer:getPos())
	end
	-- clear buffer on exhausted
	if self._buffer:getAvailable() <= 0 then
		self:init()
	else
		-- some datas in buffer yet, write them to a new blank buffer.
		-- printInfo("cache incomplete buff, len: %u, available: %u", self._buffer:getLen(), self._buffer:getAvailable())
		local __tmp = PacketBuffer.getBaseBA()
		printInfo("__temp:%s", type(__tmp))
		self._buffer:readBytes(__tmp, 1, self._buffer:getAvailable())
		self._buffer = __tmp
		-- printInfo("tmp len: %u, available: %u", __tmp:getLen(), __tmp:getAvailable())
		-- printInfo("buffer:", __tmp:toString())
	end
	return __msgs
end

return PacketBuffer
