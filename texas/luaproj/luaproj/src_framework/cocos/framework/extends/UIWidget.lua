--[[

Copyright (c) 2014-2017 Chukong Technologies Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

local Widget = ccui.Widget

function Widget:onTouch(callback)
    self:addTouchEventListener(function(sender, state)
        local event = {x = 0, y = 0}
        if state == 0 then
            event.name = "began"
        elseif state == 1 then
            event.name = "moved"
        elseif state == 2 then
            event.name = "ended"
        else
            event.name = "cancelled"
        end
        event.target = sender
        callback(event)
    end)
    return self
end

--callback              回调函数
--scale                 缩放比例
--playsound             是否播放音效
--touch_delay           触摸延迟
--touch_delay_func      触摸延迟回调
--cd                    多次快速点击的cd，默认0.5秒
function Widget:onClick(callback, scale, playsound, touch_delay, touch_delay_func, cd)
    if not self._sx then self._sx = self:getScaleX() end
    if not self._sy then self._sy = self:getScaleY() end
    if playsound == nil then playsound = true end
    local rate = scale or 1.08
    local delay = 0.08
    local atag = 1379
    local sx = self._sx
    local sy = self._sy
    cd = cd or 0.5
    self:setTouchEnabled(true)

    local is_scheduled = false
    local is_delay_func_called = false
    local schedule_key = "ctrl.scale.delay"

    self:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            if playsound and sound and sound.playClickEffect then
                DelayCallOnce(0, function() sound.playClickEffect() end)
            end
            local action = cc.ScaleTo:create(delay, sx*rate, sy*rate)
            action:setTag(atag)
            sender:runAction(cc.EaseQuarticActionOut:create(action))

            is_scheduled = false
            is_delay_func_called = false
            if type(touch_delay) == "number" and type(touch_delay_func) == "function" then
                is_scheduled = true
                sender:scheduleOnce(function()
                    is_delay_func_called = true
                    touch_delay_func(sender)
                end, touch_delay, schedule_key)
            end
        elseif eventType == ccui.TouchEventType.canceled then
            sender:stopActionByTag(atag)
            local dt = (sx - sender:getScaleX()) / (sx - sx * rate) * delay
            local action = cc.ScaleTo:create(dt, sx, sy)
            sender:runAction(action)

            if is_scheduled and not is_delay_func_called then
                sender:unschedule(schedule_key)
            end
        elseif eventType == ccui.TouchEventType.ended then
            sender:stopActionByTag(atag)
            local dt = (sx - sender:getScaleX()) / (sx - sx * rate) * delay
            local a1 = cc.ScaleTo:create(dt, sx, sy)
            local a2 = cc.CallFunc:create(function()
                if sender:isEnabled() and sender:isTouchEnabled() then
                    if not is_delay_func_called and type(callback) == "function" then
                        local lastTick = self._clickLastTick or 0
                        if os.clock() - lastTick > cd then
                            print("按钮点击___"..sender:getPath())
                            callback(sender)
                            self._clickLastTick = os.clock()
                        end
                    end
                else
                    print("按钮已被禁用___"..sender:getPath())
                end
            end)
            sender:runAction(cc.Sequence:create(a1, a2))
            
            if is_scheduled and not is_delay_func_called then
                sender:unschedule(schedule_key)
            end
        end
    end)
end

--isGray                设置否是灰色显示
function Widget:setGray(isGray)
    local state = cc.GLProgramState:getOrCreateWithGLProgramName(isGray and "ShaderUIGrayScale" or "ShaderPositionTextureColor_noMVP")
    self:setGLProgramState(state)
end

--isEnabled             是否可用，若不可用则按钮置灰显示
function Widget:setEnableEx(isEnabled)
    self:setGray(not isEnabled)
    self:setTouchEnabled(isEnabled)
end
