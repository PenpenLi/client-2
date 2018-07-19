
local cls = class("kk.anim_scale")

function cls:ctor()
    self.__anim_time = 0.25
end

function cls:onAnimationEnter(node, callback)
    assert(node, "can't find the control!")

    local layer = node:findChild("layer")
    if layer then
        layer:setOpacity(0)
        layer:runAction(cc.EaseQuarticActionOut:create(cc.FadeTo:create(self.__anim_time, 255)))
    end

    local panel = node:findChild("panel")
    if panel then
        panel:setOpacity(0)
        panel:setScale(0.1, 0.1)
        local a = cc.Spawn:create(cc.ScaleTo:create(self.__anim_time, 1), cc.FadeTo:create(self.__anim_time, 255))
        local b = cc.CallFunc:create(function()
            if type(callback) == "function" then callback() end
        end)
        panel:runAction(cc.Sequence:create(cc.EaseQuarticActionOut:create(a), b))
    end
end

function cls:onAnimationExit(node, callback)
    assert(node, "can't find the control!")

    local layer = node:findChild("layer")    
    if layer then
        layer:runAction(cc.EaseQuarticActionIn:create(cc.FadeTo:create(self.__anim_time, 0)))
    end

    local panel = node:findChild("panel")
    if panel then
        local a = cc.Spawn:create(cc.ScaleTo:create(self.__anim_time, 0), cc.FadeTo:create(self.__anim_time, 0))
        local b = cc.CallFunc:create(function()
            if type(callback) == "function" then callback() end
        end)
        panel:runAction(cc.Sequence:create(cc.EaseQuarticActionIn:create(a), b))
    end
end

return cls
