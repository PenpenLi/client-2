
local ctrl = createView("", "fruit/UILogic/Setting/Switch.csb", nil)

function ctrl:show(parent_path, switch_flag, callback)
    self:setParent(parent_path)
    self.SwitchFlag = switch_flag
    self.Callback = callback
    return self:create()
end

function ctrl:onInit(node)
    if node:getParent().setBackGroundColorOpacity then
        node:getParent():setBackGroundColorOpacity(0)
    end

    self:setSwitch(self.SwitchFlag)

    local thumb = node:findChild("btnThumb")
    local scale = 1.08
    local delay = 0.08
    local atag = 1379
    local sx = thumb:getScaleX()
    local sy = thumb:getScaleY()
    local function thumb_move_switch(sender, switch_flag, callback)
        local function callback_help()
            TryInvoke(callback)
        end

        local distance = 47 + (switch_flag and (- sender:getPositionX()) or sender:getPositionX())
        if distance == 0 then
            callback_help()
        end

        local time = delay
        local txtOn = sender:getParent():findChild("txtOn")
        local txtOff = sender:getParent():findChild("txtOff")
        local move_action = cc.MoveTo:create(time, cc.p(switch_flag and 47 or -47, sender:getPositionY()))
        sender:runAction(cc.Sequence:create(
            move_action,
            cc.CallFunc:create(callback_help)
        ))
        if switch_flag then
            txtOn:runAction(cc.FadeIn:create(time))
            txtOff:runAction(cc.FadeOut:create(time))
        else
            txtOff:runAction(cc.FadeIn:create(time))
            txtOn:runAction(cc.FadeOut:create(time))
        end
    end
    thumb:setTouchEnabled(true)
    thumb:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            sound.playClickEffect()
            local action = cc.ScaleTo:create(delay, sx*scale, sy*scale)
            action:setTag(atag)
            sender:runAction(action)
        elseif eventType == ccui.TouchEventType.canceled then
            sender:stopActionByTag(atag)
            local dt = (sx - sender:getScaleX()) / (sx - sx * scale) * delay
            local action = cc.ScaleTo:create(dt, sx, sy)
            sender:runAction(action)
            thumb_move_switch(sender, sender:getTag() == 1)
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended then
            sender:stopActionByTag(atag)
            local dt = (sx - sender:getScaleX()) / (sx - sx * scale) * delay
            local action = cc.ScaleTo:create(dt, sx, sy)
            sender:runAction(action)
            
            local function move_end_callback()
                local current_flag = sender:getTag() == 1
                self:setSwitch(not current_flag)
                TryInvoke(self.Callback, not current_flag)
            end
            thumb_move_switch(sender, sender:getTag() == 0, move_end_callback)
        end
    end)
end

function ctrl:setSwitch(switch_flag)
    local node = self:getNode()
    if not node then
        return
    end

    local thumb = node:findChild("btnThumb")
    thumb:setTag(switch_flag and 1 or 0)

    local rate = thumb:getTag()
    local val = -47 + 94 * rate
    thumb:stopAllActions()
    thumb:setPositionX(val)
    node:findChild("txtOn"):setOpacity(rate * 255)
    node:findChild("txtOff"):setOpacity((1 - rate) * 255)
end

return ctrl
