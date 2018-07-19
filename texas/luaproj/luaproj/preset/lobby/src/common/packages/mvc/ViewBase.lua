
local ViewBase = class("ViewBase", function()
    return ccui.Widget:create()
end)

function ViewBase:ctor()
    if self._setObject == nil then
        self._setObject = true
    end
    self:enableNodeEvents()
    self:setCascadeOpacityEnabled(true)
	APP:setObject(self.__cname, self);
end

function ViewBase:pctor()
	local btnClose = self.seekNodeByName(self, "Button_Close");
	if btnClose then
		btnClose:addTouchEventListener(function(ref, t)
			if t ~= ccui.TouchEventType.ended then return end;
			self:removeSelf();
		end);
	end
end

function ViewBase.seekNodeByPath(obj, name)

end

function ViewBase.seekNodeByName(obj, name)
	local node = obj:getChildByName(name)
	if node then 
		return node 
	end
	
	if obj:getChildrenCount() > 0 then
		local children = obj:getChildren()
		for _, child in pairs(children) do
            if child then 
            	local ret = ViewBase.seekNodeByName(child, name)
			    if ret then
				    return ret
			    end
            end
		end
	end
end

function ViewBase:onEnter()
end

function ViewBase:onExit()
end

function ViewBase:onDelete()
    if self._setObject then
        APP:removeObject(self)
    end
end

return ViewBase