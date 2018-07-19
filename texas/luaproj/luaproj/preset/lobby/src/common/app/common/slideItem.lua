--自动滑入滑出节点管理
local slideItem = class("slideItem")

slideItem.orientation_left = 0;
slideItem.orientation_right = 1;
slideItem.orientation_top = 2;
slideItem.orientation_bottom = 3;

function slideItem:ctor(item, orientation)
	self.item = item;
	self.orientation = orientation;
	self.pos = cc.p(item:getPosition());
end

function slideItem:slideOut()
	local p1 = nil;
	if self.orientation == slideItem.orientation_left then
		p1 = cc.p(self.pos.x - 120, self.pos.y);
	elseif self.orientation == slideItem.orientation_right then
		p1 = cc.p(self.pos.x + 120, self.pos.y);
	elseif self.orientation == slideItem.orientation_top then
		p1 = cc.p(self.pos.x, self.pos.y + 120);
	else
		p1 = cc.p(self.pos.x, self.pos.y - 120);
	end
	
	self.item:runAction(cc.Sequence:create(
		cc.Spawn:create(cc.FadeOut:create(0.2), cc.EaseIn:create(cc.MoveTo:create(0.2, p1), 3)),
		cc.MoveTo:create(0.00, self.pos),
		cc.Hide:create()));
end

function slideItem:slideIn()
	self.item:setVisible(true);

	if self.orientation == slideItem.orientation_left then
		self.item:move(cc.p(self.pos.x - 120, self.pos.y));
	elseif self.orientation == slideItem.orientation_right then
		self.item:move(cc.p(self.pos.x + 120, self.pos.y));
	elseif self.orientation == slideItem.orientation_top then
		self.item:move(cc.p(self.pos.x, self.pos.y + 120));
	else
		self.item:move(cc.p(self.pos.x, self.pos.y - 120));
	end
	self.item:setOpacity(0);
	
	self.item:runAction(cc.Spawn:create(cc.FadeIn:create(0.2), cc.EaseOut:create(cc.MoveTo:create(0.2, self.pos), 3)));
end

return slideItem