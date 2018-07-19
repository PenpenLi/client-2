local CMD = require("app.net.CMD")
local ErrorCode = require("app.net.ErrorCode")
local GameConfig = require("app.common.GameConfig")
local PlayerList = g_Require("app.models.PlayerList")
local GameRoom = require("app.models.GameRoom")
local GameSpecificHandlers = {}

function GameSpecificHandlers.active()
 
 
end

function GameSpecificHandlers.deactive()
 
end

return GameSpecificHandlers