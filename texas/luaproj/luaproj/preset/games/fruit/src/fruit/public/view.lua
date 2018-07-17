
local view = {}
view.__index = view

--desc:get parent control.
function view:getParent()
    if self.__node then return self.__node:getParent() end
    return self.__parent or findChild(self.__parent_path)
end

--desc:get this control.
function view:getNode()
    return self.__node
end

--desc:get the csb file path.
function view:getCsb()
    return self.__csb_path
end

--desc:设置父窗口路径
--@parent_path  父窗口路径
function view:setParent(parent)
    if type(parent) == "string" then
        self.__parent_path = parent
    elseif type(parent) == "userdata" then
        self.__parent = parent
    end
end

function view:setCsb(csb_path)
    self.__csb_path = csb_path
end

--desc:设置控件的新名称
--@new_name     新名称
function view:setNewName(new_name)
    self.__new_name = tostring(new_name)
end

--desc:设置ZOrder
--@zorder   Z序值
function view:setZOrder(zorder)
    self.__zorder = zorder
end

function view:onClick(key, callback)
    self:getNode():findChild(key):onClick(callback)
end

function view:isVisible()
    return self:getNode():isVisible()
end

function view:setVisible(vsb)
    self:getNode():setVisible(vsb)
end

function view:create()
    assert(not self.__node, "can't call create view for many times!")

    local parent = self:getParent()
    self.__islive = true

    local node = cc.CSLoader:createNode(self.__csb_path)
    self.__node = node
    node:onNodeEvent("exit", function(param)
        self:onExit(self.__node)
        self.__node = nil
        if self.onPostExit then
            DelayCallOnce(0, handler(self, self.onPostExit))
        end
    end)

    if self.__new_name then
        node:setName(self.__new_name)
    end

	if parent then
		local x, y = parent:getContentSize().width / 2, parent:getContentSize().height / 2;
		local p1 = parent:convertToNodeSpace(cc.p(x, y))
		node:setPosition(cc.p(x, y))
		parent:addChild(node, self.__zorder or 0)
	end


    --callback the init function
    self:onInit(node)

    --process animation
    if self.__anim then
        self.__anim:onViewEnter(self)
    end

    return self
end

function view:node()
	return self.__node;
end

function view:destroy()
    if not self.__islive then return end
    self.__islive = false
    
    if self.__node then
        if self.__anim then
            self.__anim:onViewExit(self)
        else
            self.__node:removeFromParent()
        end
    end
end

--desc:callback when created
function view:onInit(node)

end

--desc:callback when end animation over
function view:onExit(node)

end

function view:onPostExit()
end


--desc:create new view object
--@parent       the full path of the parent control.
--@csb_path     the csb file path of this control.
--@anim         the animation object for the control.
function createView(parent, csb_path, anim)
    local t = {}
    t.__csb_path = csb_path
    t.__anim = anim
    setmetatable(t, view)
    t:setParent(parent)
    return t
end
