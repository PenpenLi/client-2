local config = require("config")
local CC = require("comm.CC")
local proto2 = require("koko.proto2")
local tryInvoke = tryInvoke
local tonumber = tonumber
local tostring = tostring
local cclog = cclog
local ccerr = ccerr
local ccwrn = ccwrn
local _G = _G

module("koko.net")

function createResultTable(success, message)
    return { success = success, message = message }
end
function createSuccessResult()
    return createResultTable(true, "")
end
function createErrorResult(message)
    return createResultTable(false, message)
end

local param = nil   --登录请求参数
local envir = nil   --登录环境变量
function getEnvir()
    return envir
end

function loginPlatform(ip, port, gameid, uid, iid, uname, sn, token, callback, progressFunc)
    --清空监听回调函数
    _G.require("koko.form2").clearAllCallback()

    if param then
        tryInvoke(callback, createErrorResult("系统繁忙"))
        return
    end
    if not ip or ip == "" then
        tryInvoke(callback, createErrorResult("登录失败，缺少参数：IP地址"))
        return
    end
    port = tonumber(port)
    if not port or port == 0 then
        tryInvoke(callback, createErrorResult("登录失败，缺少参数：PORT"))
        return
    end
    gameid = tonumber(gameid)
    if not gameid then
        tryInvoke(callback, createErrorResult("登录失败，缺少参数：GAMEID"))
        return
    end
    if not uid or uid == "" then
        tryInvoke(callback, createErrorResult("登录失败，缺少参数：UID"))
        return
    end
    if not iid or iid == "" then
        tryInvoke(callback, createErrorResult("登录失败，缺少参数：IID"))
        return
    end
    --if not uname or uname == "" then
    --    tryInvoke(callback, createErrorResult("登录失败，缺少参数：NICKNAME"))
    --    return
    --end
    if not sn or sn == "" then
        tryInvoke(callback, createErrorResult("登录失败，缺少参数：SN"))
        return
    end
    if not token or token == "" then
        tryInvoke(callback, createErrorResult("登录失败，缺少参数：TOKEN"))
        return
    end

    param = {
        ip = ip,
        port = port,
        gameid = gameid,
        uid = uid,
        iid = iid,
        uname = uname,
        sn = sn,
        token = token,
        callback = callback,
        progressFunc = progressFunc,
        coordinateIp = "",
        coordinatePort = 0,
        _delayTimerId = 0,
        _delayTimerCallback = nil,
    }

    _doLoginPlatform()
end

--登录平台
function _doLoginPlatform()
    local function onCoordinateLoginCallback(tbl)
        if not tbl.success then
            _notifyError("无法登录协同服务器："..tbl.message)
        else
            _notifyProgress(1)
            proto2.sendJoinChannelReq(param.gameid)

            --登录成功
            envir = 
            {
                worldIp = param.ip,
                worldPort = param.port,
                gameid = param.gameid,
                coordinateIp = param.coordinateIp,
                coordinatePort = param.coordinatePort,
                uid = param.uid,
                iid = param.iid,
                uname = param.uname,
                sn = param.sn,
                token = param.token,
            }
            local tbl = createSuccessResult()
            tbl.envir = envir
            local callback = param.callback
            param = nil
            tryInvoke(callback, tbl)
        end
    end

    local function onGetCoordinateConnection(tbl)
        if not tbl.success then
            _notifyError("无法获取协同服务器地址："..tbl.message)
        else
            _notifyProgress(0.3)
            param.coordinateIp = tbl.ip
            param.coordinatePort = tonumber(tbl.port)
            cclog("主动断开世界服务器连接")
            _G.disconnect2()
            if _asyncConnectCoordinateAndLogin(onCoordinateLoginCallback, 5) then
                _notifyProgress(0.7)
            end
        end
    end

    local result = _asyncGetCoordinateConnection(onGetCoordinateConnection, 5)
    if result then
        _notifyProgress(0.2)
    end
end

--获取协同服务器地址
function _asyncGetCoordinateConnection(callback, timeout)
    param._delayTimerCallback = callback

    local r = _G.connect2(param.ip, param.port)
    if r ~= 0 then
        ccerr("无法连接世界服务器，请检查网络设置！[%s:%d]", param.ip, param.port)
        tryInvoke(param._delayTimerCallback, createErrorResult("无法连接世界服务器，请检查网络设置"))
        return false
    end

    proto2.sendGameCoordinateReq(param.gameid)
    local function onTimeoutCallback()
        if param then
            param._delayTimerId = 0
            ccerr("世界服务器连接超时，无法获取协同服务器连接地址")
            _G.disconnect2()
            tryInvoke(param._delayTimerCallback, createErrorResult("连接超时"))
        end
    end
    param._delayTimerId = _G.kk.timer.delayOnce(timeout, onTimeoutCallback)
    return true
end
function onRecvCoordinateConnection(t)
    if not param then return end
    if param._delayTimerId == 0 then return end

    _G.kk.timer.cancel(param._delayTimerId)
    param._delayTimerId = 0

    local tbl = createSuccessResult()
    tbl.ip = t.ip_
    tbl.port = t.port_
    cclog("获取到协同服务器连接方式：[%s:%s]", tbl.ip, tbl.port)
    tryInvoke(param._delayTimerCallback, tbl)
end
function onRecvCoordinateError(message)
    _G.disconnect2()
    if not param then return end
    if param._delayTimerId == 0 then return end

    _G.kk.timer.cancel(param._delayTimerId)
    param._delayTimerId = 0
    ccerr("获取协同服务器地址失败：%s", message)
    _G.disconnect2()
    tryInvoke(param._delayTimerCallback, createErrorResult(message))
end

--连接协同服务器，发送登录请求
function _asyncConnectCoordinateAndLogin(callback, timeout)
    param._delayTimerCallback = callback

    local ip = param.coordinateIp
    local port = param.coordinatePort

    local r = _G.connect2(ip, port)
    if r ~= 0 then
        ccerr("无法连接协同服务器，请检查网络设置！[%s:%d]", ip, port)
        _G.disconnect2()
        tryInvoke(param._delayTimerCallback, createErrorResult("无法连接协同服务器，请检查网络设置"))
        return false
    end

    proto2.sendCoordinateLoginReq(param.uid, param.sn, param.token)
    local function onTimeoutCallback()
        if param then
            param._delayTimerId = 0
            ccerr("协同服务器连接超时，无法登录协同服务器")
            _G.disconnect2()
            tryInvoke(param._delayTimerCallback, createErrorResult("连接超时"))
        end
    end
    param._delayTimerId = _G.kk.timer.delayOnce(timeout, onTimeoutCallback)
    return true
end
function onRecvCoordinateLogin(is_success)
    if not param then return end
    if param._delayTimerId == 0 then return end

    _G.kk.timer.cancel(param._delayTimerId)
    param._delayTimerId = 0

    if is_success then
        cclog("协同服务器登录成功")
        tryInvoke(param._delayTimerCallback, createSuccessResult())
    else
        tryInvoke(param._delayTimerCallback, createErrorResult("登录协同服务器遇到错误"))
    end
end











function _notifyError(message)
    _G.disconnect2()
    if param then
        ccerr(message)
        local callback = param.callback
        param = nil
        tryInvoke(callback, createErrorResult(message))
    end
end
function _notifyProgress(rate)
    if param then
        tryInvoke(param.progressFunc, rate)
    end
end
