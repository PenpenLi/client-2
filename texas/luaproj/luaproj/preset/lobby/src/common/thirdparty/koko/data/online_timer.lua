local _G = _G
module("koko.data.online_timer")

local _timerInterval = 60
local _gameId = 0
local _startClock = 0
local _scheduleId = 0

local function _timerProc()
    _G.require("net_bridge").notifyActionOnline(1, _gameId, _G.math.floor(_G.os.clock() - _startClock))
    _G.cclog("纪录在线时长更新 游戏Id：%d 时长：%d", _gameId, _G.math.floor(_G.os.clock() - _startClock))
    return true
end

function start(gameId)
    if _scheduleId ~= 0 then
        _G.kk.timer.cancel(_scheduleId)
        _scheduleId = 0
    end

    _gameId = gameId
    _startClock = _G.os.clock()
    _G.require("net_bridge").notifyActionOnline(0, _gameId, _G.math.floor(_G.os.clock() - _startClock))
    _G.cclog("纪录在线时长新增 游戏Id：%d 时长：%d", _gameId, _G.math.floor(_G.os.clock() - _startClock))
    _scheduleId = _G.kk.timer.delay(_timerInterval, _timerProc)
end

function stop()
    if _scheduleId ~= 0 then
        _G.kk.timer.cancel(_scheduleId)
        _scheduleId = 0
    end
end

