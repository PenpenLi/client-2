--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIHelper = require("app.common.UIHelper")

local PrivateRoomItem = class("PrivateRoomItem", cc.mvc.ViewBase)
function PrivateRoomItem:ctor()
	PrivateRoomItem.super.ctor(self);
	
	self.csbnode = cc.CSLoader:createNode("cocostudio/home/PrivateRoomItem.csb")
    self.csbnode:addTo(self)
	self:setContentSize(self.csbnode:getContentSize());

	self.txtName = UIHelper.seekNodeByName(self.csbnode, "txtName");
	self.txtBetSet = UIHelper.seekNodeByName(self.csbnode, "txtBetSet");
	self.txtPlayers = UIHelper.seekNodeByName(self.csbnode, "txtPlayers");
	self.txtTimeLeft = UIHelper.seekNodeByName(self.csbnode, "txtTimeLeft");

end

function PrivateRoomItem:setInfo(content)
	self.ct = content;
    self.txtName:setString(content.master_ .. "的牌局")
	self.txtPlayers:setString(content.player_num_ .."/" ..content.total_player_);
	self.timeleft = os.time() + tonumber(content.left_time_);
	self.txtBetSet:setString(content.bet_set_ .."/" ..content.to_banker_set_);

	self.tmh = scheduler.scheduleGlobal(handler(self, self.updateTime), 0.3)
	
	local btn = UIHelper.seekNodeByName(self.csbnode, "Button_9");
	btn:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP.hc:enterRoom(tonumber(self.ct.roomid_), 0);
		end
	end);
end

function PrivateRoomItem:updateTime()
	local tml = self.timeleft - os.time();
	local h = math.floor(tml / 3600);
	local m = math.floor((tml - 3600 * h) / 60);
	local s = tml - 3600 * h - 60 * m;
	local ct = string.format("%02d", h) .. ":" .. string.format("%02d", m) .. ":".. string.format("%02d", s)
	if tml > 0 then
		self.txtTimeLeft:setString(ct);	
	else
		self.txtTimeLeft:setString("00:00:00");
	end
end
function PrivateRoomItem:onEnter()
	PrivateRoomItem.super.onEnter(self)
end

function PrivateRoomItem:onExit()
	scheduler.unscheduleGlobal(self.tmh)
	PrivateRoomItem.super.onExit(self)
end

return PrivateRoomItem;
--endregion
