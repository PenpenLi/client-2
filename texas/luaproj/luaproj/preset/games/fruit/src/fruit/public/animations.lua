
-----------------------------------------------
----------------SCALE ANIMATION----------------
-----------------------------------------------

local scaleAnim = {}
scaleAnim.__index = scaleAnim
scaleAnim.__anim_time = 0.25

--desc:set the animation time.
--@time     the animation time.
function scaleAnim:setTime(time)
    self.__anim_time = time
end

--desc:start normal scale animation
--@view         the view object
function scaleAnim:onViewEnter(view)
    local node = view:getNode()
    assert(node, "can't find the control!")

    local layer = node:findChild("layer")
    if layer then
        layer:setOpacity(0)
        layer:runAction(cc.EaseQuarticActionOut:create(cc.FadeTo:create(self.__anim_time, 255)))
    end

    local panel = node:findChild("panel")
    if panel then
        panel:setOpacity(0)
        panel:setScale(0, 0)
        local a = cc.Spawn:create(cc.ScaleTo:create(self.__anim_time, 1), cc.FadeTo:create(self.__anim_time, 255))
        panel:runAction(cc.Sequence:create(cc.EaseQuarticActionOut:create(a)))
    end
end

--desc:end normal scale animation
--@view         the view object
function scaleAnim:onViewExit(view)
    local node = view:getNode()
    assert(node, "can't find the control!")

    local layer = node:findChild("layer")    
    if layer then
        layer:runAction(cc.EaseQuarticActionIn:create(cc.FadeTo:create(self.__anim_time, 0)))
    end

    local panel = node:findChild("panel")
    if panel then
        local a = cc.Spawn:create(cc.ScaleTo:create(self.__anim_time, 0), cc.FadeTo:create(self.__anim_time, 0))
        local b = cc.CallFunc:create(function()
            if view:getNode() then
                view:getNode():removeFromParent()
            end
        end)
        panel:runAction(cc.Sequence:create(cc.EaseQuarticActionIn:create(a), b))
    end
end

--desc:create normal scale animation
--@time     the animation time.
function createScaleAnimation(time)
    local t = {}
    if type(time) == "number" then
        t.__anim_time = time
    end
    setmetatable(t, scaleAnim)
    return t
end


-----------------------------------------------
----------------FALL ANIMATION-----------------
-----------------------------------------------

local fallAnim = {}
fallAnim.__index = fallAnim

function fallAnim:onViewEnter(view)
    local node = view:getNode()
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
    node:runAction(a)
end

function fallAnim:onViewExit(view)
    local node = view:getNode()
    assert(node, "can't find the control!")

    local animtime = 0.3
    local a1 = cc.FadeTo:create(animtime, 200)
    local a2 = cc.MoveBy:create(animtime, cc.p(0, 720))
    local a = cc.EaseExponentialIn:create(cc.Spawn:create(a1, a2))
    local b = cc.CallFunc:create(function()
        if view:getNode() then
            view:getNode():removeFromParent()
        end
    end)
    node:runAction(cc.Sequence:create(a, b))
end

function createFallAnimation()
    local t = {}
    setmetatable(t, fallAnim)
    return t
end

