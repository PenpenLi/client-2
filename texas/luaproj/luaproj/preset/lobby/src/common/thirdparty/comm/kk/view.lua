
local cls = class("kk.view")

function cls:getCsbPath()
    return self.__csb_path
end
function cls:setCsbPath(csb)
    self.__csb_path = csb
end

function cls:getAnimation()
    return self.__animation
end
function cls:setAnimation(anim)
    self.__animation = anim
end

function cls:getNode()
    return self.Node
end
function cls:getClassName()
    return self.__cname
end

function cls:onClick(key, callback)
    self.Node:findChild(key):onClick(callback)
end

function cls:isVisible()
    return self.Node:isVisible()
end
function cls:setVisible(vsb)
    self.Node:setVisible(vsb)
end

function cls:install(pp)
    self.__islive = true
    local parent = nil
    if type(pp) == "userdata" then
        parent = pp
    elseif type(pp) == "string" then
        parent = findChild(pp)
    elseif pp == nil then
        parent = findChild("")
    end
    assert(parent, string.format("%s parent is nil!", self.__cname))
    
    assert(self:getCsbPath(), string.format("%s csb path is nil!", self.__cname))
    local node = cc.CSLoader:createNode(self:getCsbPath())
    local x, y = parent:getContentSize().width / 2, parent:getContentSize().height / 2
    node:setPosition(x, y)
    parent:addChild(node, self:getZOrder() or 0)
    self:attach(node)
    return self
end

function cls:getZOrder()
    return self.__zorder
end
function cls:setZOrder(zorder)
    self.__zorder = zorder
end

function cls:attach(node)
    self.Node = node
    
    node.destroy = handler(self, self.destroy)
    node.close = handler(self, self.close)
    
    tryInvoke(self.onInit, self, node)

    if self:getAnimation() then
        self:getAnimation():onAnimationEnter(self.Node, nil)
    end
end

function cls:close()
    if not self.__islive then return end
    self.__islive = false

    if self.Node then    
        if self:getAnimation() then
            self:getAnimation():onAnimationExit(self.Node, handler(self, self.destroy))
        else
            self:destroy()
        end
    end
end

function cls:destroy()
    if self.Node then
        if self.onDestroy then
            tryInvoke(self.onDestroy, self, self.Node)
        end
        self.Node:removeFromParent()
        self.Node = nil
    end
end

return cls
