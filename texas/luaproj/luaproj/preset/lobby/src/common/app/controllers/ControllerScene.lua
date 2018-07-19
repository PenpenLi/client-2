
local ControllerScene = class("ControllerScene", function(name, params)
    return display.newScene(name, params);
end)

function ControllerScene:ctor()
	self:enableNodeEvents()
	self.UIContainer = display.newNode();
	self:addChild(self.UIContainer);
	self.UIContainer:setContentSize(g_CurrentGame().designSize);	
	if g_CurrentGame().orientation ~= device.orientation then
		self:Rotation();
	end
end

function ControllerScene:Rotation()
	self.UIContainer:setRotation(-90);
	if g_CurrentGame().orientation == device.landscape then
		self.UIContainer:setPosition(cc.p(g_CurrentGame().designSize.height, 0));
	else
		self.UIContainer:setPosition(cc.p(g_CurrentGame().designSize.width, 0));
	end
end

function ControllerScene:addChild(child, zorder, tag)
	zorder = zorder or 0;
	tag = tag or 0;
	if child ~= self.UIContainer then
		self.UIContainer:addChild(child, zorder, tag);
	else
		cc.Node.addChild(self, child, zorder, tag);
	end
end


return ControllerScene;