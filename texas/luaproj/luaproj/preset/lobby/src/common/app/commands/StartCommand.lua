
local GameConfig = require("app.common.GameConfig");
local StartCommand = {}

function StartCommand.execute()
	StartCommand.initSocket()
    StartCommand.initModels()
    StartCommand.scheduleGC()
    StartCommand.initLocalConfig()
end

function StartCommand.initSocket()
    local SocketHandlers = require("app.handlers.SocketHandlers");
    SocketHandlers.active();
	local SocketManager = require("app.net.SocketManager")
    SocketManager.init()
end

function StartCommand.initModels()

   
																																																																																																																																																																																																																																																																																	
end

function StartCommand.scheduleGC()
    scheduler.scheduleGlobal(function() collectgarbage("collect") end, 10)
end

function StartCommand.initLocalConfig()
    local musicOn = cc.UserDefault:getInstance():getBoolForKey(GameConfig.KEY_MUSIC, true)
    local soundOn = cc.UserDefault:getInstance():getBoolForKey(GameConfig.KEY_SOUND, true)
    local vibrateOn = cc.UserDefault:getInstance():getBoolForKey(GameConfig.KEY_VIBRATE, true)

    APP.GD.music_on = musicOn
    APP.GD.sound_on = soundOn
    APP.GD.vibrate_on = vibrateOn
end

return StartCommand