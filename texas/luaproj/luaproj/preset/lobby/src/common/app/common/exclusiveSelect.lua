--用来管理组合单选，避免重复代码

local exclusiveSelect = class("exlusiveSelect")

function exclusiveSelect:ctor()
	self.children = {};
end

function exclusiveSelect:addItem(item, callback)
	table.insert(self.children, item);

	item:addTouchEventListener(touchHandler(function(sender, etype)
		self:onItemSelected(send, callback);
	end));
end

function exclusiveSelect:onItemSelected(sender, callback)
	for k, v in pairs(self.children) do
		v:setSelected(false);
	end
	callback()
end

return exclusiveSelect;

