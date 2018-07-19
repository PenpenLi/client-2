
local _G = _G
local CC = require("comm.CC")

module("koko.data.ReconnectMgr")

--协同服务器是否正在重连中
local _isReconnecting = false

--延迟重连定时器Id
local _delayReconnectTimerId = 0
local function _startTimer(callback)
    _delayReconnectTimerId = _G.kk.timer.delayOnce(2, function()
        _delayReconnectTimerId = 0
        _G.tryInvoke(callback)
    end)
end
local function _stopTimer()
    if _delayReconnectTimerId ~= 0 then
        _G.kk.timer.cancel(_delayReconnectTimerId)
        _delayReconnectTimerId = 0
    end
end

--重连回调
local function _onReconnectCallback(rsp)
    --当前未在重连状态?
    if not _isReconnecting then
        _G.ccwrn("[ReconnectMgr] 系统错误，当前未在重连状态！")
        return
    end

    _stopTimer()
    if rsp.success then
        _G.cclog("[ReconnectMgr] 重连成功")
        _isReconnecting = false
        _G.kk.event.dispatch(_G.E.EVENTS.coordinate_reconnect_end, 1)
    else
        _G.ccwrn("[ReconnectMgr] 重连失败：%s", rsp.message)
        _G.disconnect2()
        _startTimer(_doReconnect)
    end
end

--重连函数
function _doReconnect()
    _G.cclog("[ReconnectMgr] 开始重连 %s:%d...", CC.Config.WORLDADDR, CC.Config.WORLDPORT)
    CC.Net.loginPlatform(CC.Config.WORLDADDR, CC.Config.WORLDPORT, _G.kk.util.getCoordinateChannelId(), CC.Player.uid, CC.Player.iid, 
    	CC.Player.nickName, CC.Player.sequence, CC.Player.token, _onReconnectCallback, nil)
end

---------------------------------------------------------------
--是否正在重连中
function isReconnecting()
    return _isReconnecting
end

--网络开始重连
function startReconnect()
    if _isReconnecting then
        _G.ccwrn("[ReconnectMgr] 状态错误，重连已经开始!")
        return
    end

    _isReconnecting = true
    _G.kk.event.dispatch(_G.E.EVENTS.coordinate_reconnect_begin)
    _doReconnect()
end

--停止重连并断开
function stopReconnect()
    if not _isReconnecting then
        _G.ccwrn("[ReconnectMgr] 状态错误，重连已经结束!")
        return
    end

    _stopTimer()
    _isReconnecting = false
    _G.ccwrn("[ReconnectMgr] 停止重连")
    _G.disconnect2()
    _G.kk.event.dispatch(_G.E.EVENTS.coordinate_reconnect_end, 2)
end



