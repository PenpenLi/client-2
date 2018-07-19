
local _G = _G
local cc = cc
local unpack = unpack

module("comm.kk.timer")

--desc:延迟执行一次
function delayOnce(interval, callback, ...)
    local schedule_id = 0
    local param = {...}
    local function schedule_func()
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedule_id)
        callback(unpack(param))
    end
    schedule_id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(schedule_func, interval, false)
    return schedule_id
end

--desc:延迟执行N次，直到回调函数返回false为止
function delay(interval, callback, ...)
    local schedule_id = 0
    local param = {}
    local function schedule_func()
        local r = callback(unpack(param))
        if not r then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedule_id)
        end
    end
    schedule_id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(schedule_func, interval, false)
    return schedule_id
end

--desc:取消延迟回调
function cancel(id)
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(id)
end