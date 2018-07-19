
local cls = class("kk.anim_fall")

function cls:ctor()
    self.__anim_time = 0.25
end

function cls:onAnimationEnter(node, callback)
    assert(node, "can't find the control!")

    local animtime = 0.25
    node:setOpacity(0)
    node:setScale(0.6)
    local x, y = node:getPosition()
    node:setPosition(x, y + 720)

    local a1 = cc.FadeIn:create(animtime)
    local a2 = cc.ScaleTo:create(animtime, 1)
    local a3 = cc.MoveBy:create(animtime, cc.p(0, -720))
    local a = cc.EaseQuarticActionOut:create(cc.Spawn:create(a1, a2, a3))
    local b = cc.CallFunc:create(function()
        if type(callback) == "function" then callback() end
    end)
    node:runAction(cc.Sequence:create(a, b))
end

function cls:onAnimationExit(node, callback)
    assert(node, "can't find the control!")

    local animtime = 0.3
    local a1 = cc.FadeTo:create(animtime, 200)
    local a2 = cc.MoveBy:create(animtime, cc.p(0, 720))
    local a = cc.EaseExponentialIn:create(cc.Spawn:create(a1, a2))
    local b = cc.CallFunc:create(function()
        if type(callback) == "function" then callback() end
    end)
    node:runAction(cc.Sequence:create(a, b))
end

return cls