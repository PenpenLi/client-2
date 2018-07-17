--尝试调用lua函数
function TryInvoke(f, ...)
    if type(f) == "function" then
        f(...)
    end
end

--desc:获取当前scene对象
function GetScene()
    return cc.Director:getInstance():getRunningScene()
end

--desc:延迟执行一次
function DelayCallOnce(interval, func)
    local schedule_id = 0
    local function schedule_func()
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedule_id)
        func()
    end
    schedule_id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(schedule_func, interval, false)
    return schedule_id
end
--desc:延迟执行N次，直到回调函数返回false为止
function DelayCall(interval, func)
    local schedule_id = 0
    local function schedule_func()
        local r = func()
        if not r then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedule_id)
        end
    end
    schedule_id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(schedule_func, interval, false)
    return schedule_id
end
--desc:取消延迟回调
function CancelCall(id)
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(id)
end

--desc:添加Sprite点击事件，放大模式
function AddImageClickEvent_Big(ctrl, func)
    AddImageClickEventWithScale(ctrl, func, 1.08, true)
end
--desc:添加Sprite点击事件，缩小模式
function AddImageClickEvent_Small(ctrl, func)
    AddImageClickEventWithScale(ctrl, func, 0.92, true)
end
--desc:添加Sprite点击事件，正常模式
function AddImageClickEvent_Normal(ctrl, func)
    AddImageClickEventWithScale(ctrl, func, 1, false)
end
function AddImageClickEventWithScale(ctrl, func, scale, is_playsound)
    local rate = scale
    local delay = 0.08
    local atag = 1379
    local sx = ctrl:getScaleX()
    local sy = ctrl:getScaleY()
    ctrl:setTouchEnabled(true)
    ctrl:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            if is_playsound and sound then
                DelayCallOnce(0, function() sound.playClickEffect() end)
            end
            local action = cc.ScaleTo:create(delay, sx*rate, sy*rate)
            action:setTag(atag)
            ctrl:runAction(cc.EaseQuarticActionOut:create(action))
        elseif eventType == ccui.TouchEventType.canceled then
            ctrl:stopActionByTag(atag)
            local dt = (sx - ctrl:getScaleX()) / (sx - sx * rate) * delay
            local action = cc.ScaleTo:create(dt, sx, sy)
            ctrl:runAction(action)
        elseif eventType == ccui.TouchEventType.ended then
            ctrl:stopActionByTag(atag)
            local dt = (sx - ctrl:getScaleX()) / (sx - sx * rate) * delay
            local action = cc.ScaleTo:create(dt, sx, sy)
            local callback = cc.CallFunc:create(function()
                TryInvoke(func, sender)
            end)
            ctrl:runAction(cc.Sequence:create(action, callback))
        end
    end)
end

--desc:获取短文字金币显示
function GetShortGoldString(gold)
    local str = ""
    local num = tonumber(gold)
    if num then
        str = tostring(math.floor(num))
    end
    local l = string.len(str)
    if l <= 5 then
        return str
    elseif l > 5 and l <= 8 then
        return string.format("%."..(8 - l).."f万", num / 10000)
    elseif l > 8 and l <= 12 then
        return string.format("%."..(12 - l).."f亿", num / 100000000)
    else
        return string.format("%d亿", math.floor(num / 100000000))
    end
    return str
end

function GetIntegerGoldString(gold)
    local str = ""
    local num = tonumber(gold)
    if num then
        str = tostring(math.floor(num))
    end
    local l = string.len(str)
    if l < 5 then
        return str
    elseif l < 9 then
        return string.sub(str, 1, -5).."万"
    end
    return string.sub(str, 1, -9).."亿"
end

--desc:获取utf8字符长度
function GetUtf8CharLength(c)
    if c >= 0xFC then
        return 6
    elseif c >= 0xF0 then
        return 4
    elseif c >= 0xE0 then
        return 3
    elseif c >= 0xC0 then
        return 2
    end
    return 1
end

--desc:分割内部tag标签
function SplitInnerTag(content, c1, c2, callback)
    local t = {}

    local start = 1
    local pos1 = 0
    local state = 1  --1寻找c1 2寻找c2
    local index = 1

    local c1len = GetUtf8CharLength(string.byte(c1, 1))
    local c2len = GetUtf8CharLength(string.byte(c2, 1))

    local length = string.len(content)
    while index <= length do
        local c = string.sub(content, index, index)
        local l = GetUtf8CharLength(string.byte(content, index))
        if c == c1 then
            index = index + l
            pos1 = index
            state = 2
        elseif c == c2 then
            if state == 2 then
                local tag = string.sub(content, pos1, index - 1)
                if callback(tag) then
                    table.insert(t, {false, string.sub(content, start, pos1 - c1len - 1)})
                    table.insert(t, {true, tag})
                    index = index + l
                    start = index
                    state = 1
                else
                    index = index + l
                    state = 1
                end
            else
                index = index + l
            end
        else
            index = index + l
        end
    end

    if start <= length then
        table.insert(t, {false, string.sub(content, start, -1)})
    end

    return t
end

--创建回调数据table
function CreateCallbackTableSuccess()
    local t = {}
    t.isSuccess = true
    t.errMessage = ""
    return t
end
function CreateCallbackTableError(err)
    local t = {}
    t.isSuccess = false
    t.errMessage = err
    return t
end

--从命令行或配置中获取参数
function GetValueFromEnvirOrConfig(key)
    local val = envir_getvalue(key)
    if val == "" then
        local cfg = Config or config
        if type(cfg) == "table" then
            val = cfg[key] or ""
        end
    end
    return val
end
