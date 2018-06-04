
local ViewBase = class("ViewBase", function()
    return ccui.Widget:create()
end)

--MVC中的C-控制器
function ViewBase:ctor()
    if self._setObject == nil then
        self._setObject = true
    end
    self:enableNodeEvents()
    self:setCascadeOpacityEnabled(true)
end

--MVC中的C-控制器
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
    if self._setObject then
        APP:setObject(self.__cname, self)
    end
end

function ViewBase:onExit()
    if self._setObject then
        APP:removeObject(self.__cname)
    end
end

return ViewBase