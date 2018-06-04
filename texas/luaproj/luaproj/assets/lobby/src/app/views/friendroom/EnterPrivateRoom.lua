local UIHelper = require("app.common.UIHelper")
local CMD = require("app.net.CMD")
local EnterPrivateRoom = class("EnterPrivateRoom", cc.mvc.ViewBase)

function EnterPrivateRoom:ctor()
	EnterPrivateRoom.super.ctor(self)
	self.index = 1;
	self.csbnode = cc.CSLoader:createNode("cocostudio/home/EnterRoomLayer.csb")
    self.csbnode:addTo(self)

	for i = 0, 9, 1 do
		local btnNumber = UIHelper.seekNodeByName(self.csbnode, "Button_Number_"..tostring(i));
		btnNumber:setTag(i);
		btnNumber:addTouchEventListener(function(target, eType)
			if eType == ccui.TouchEventType.ended then
				self:OnNumberPressed(target);
			end
		end)
	end

	local btnDel = UIHelper.seekNodeByName(self.csbnode, "Button_Number_Del")
    btnDel:addTouchEventListener(function(target, eType)
        if eType == ccui.TouchEventType.ended then
            self:onDel(target);
        end
    end)

end

function EnterPrivateRoom:getInput()
	local ret = "";
	for i = 1, 6, 1 do
		local txt = UIHelper.seekNodeByName(self.csbnode, "AtlasLabel_Number_"..tostring(i));
		ret = ret..txt:getString();
	end
	return ret;
end
function EnterPrivateRoom:OnNumberPressed(target)
	local txt = UIHelper.seekNodeByName(self.csbnode, "AtlasLabel_Number_"..tostring(self.index));
	if self.index > 6 then return end;
	txt:setString(tostring(target:getTag()));
	if self.index == 6 then
		APP.hc:findPrivateRoom(self:getInput());
	end
	self.index = self.index + 1;
end

function EnterPrivateRoom:onDel()
	self.index = self.index - 1;
	local txt = UIHelper.seekNodeByName(self.csbnode, "AtlasLabel_Number_"..tostring(self.index));
	txt:setString(".");
	if self.index < 1 then self.index = 1 end;
end

function EnterPrivateRoom:onEnter()
	EnterPrivateRoom.super.onEnter(self)
end

function EnterPrivateRoom:onExit()
	EnterPrivateRoom.super.onExit(self)
end

return EnterPrivateRoom