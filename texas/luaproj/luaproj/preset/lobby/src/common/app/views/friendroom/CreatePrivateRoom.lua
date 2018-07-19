--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIHelper = require("app.common.UIHelper")

local CreatePrivateRoom = class("CreatePrivateRoom", cc.mvc.ViewBase)

function CreatePrivateRoom:ctor()
	CreatePrivateRoom.super.ctor(self, ctrl);
	self.indx = 1
	self.csbnode = cc.CSLoader:createNode("cocostudio/home/CreateRoomLayer.csb")
    self.csbnode:addTo(self)

	local txt = UIHelper.seekNodeByName(self.csbnode, "Text_RoomName");

	local gameUser =APP.GD.GameUser
    txt:setString(gameUser.uname .. "的牌局")

	for i = 1, 6, 1 do
		local chk = UIHelper.seekNodeByName(self.csbnode, "CheckBox_Time_" .. tostring(i))
		chk:addTouchEventListener(function(sender, evt)
			if evt == ccui.TouchEventType.ended then
				self:exclusiveSelectTime(sender)
			end	end);
	end

	local chk = UIHelper.seekNodeByName(self.csbnode, "CheckBox_Time_1")
	chk:setSelected(true);

	slider = UIHelper.seekNodeByName(self.csbnode, "Slider_TakeBet")
	slider:addEventListener(function(sender, evt)
		if evt == ccui.SliderEventType.percentChanged then
			self:SliderChange(sender:getPercent());
		end	end);

	slider:setPercent(0);
	self:SliderChange(1);
	
	local btn = UIHelper.seekNodeByName(self, "Button_Create_Room")
	btn:addTouchEventListener(function(target, eType)
        if eType == ccui.TouchEventType.ended then
           self:createRoom();
        end
    end)
end

function CreatePrivateRoom:createRoom()
	APP.hc:createPrivateRoom(self:getConfigSet(), self:getDurSet());

	addListener(self, "ROOM_CREATE_SUCC", 
	function(content) 
		APP.hc:enterRoom(tonumber(content.roomid_), 0)
	end);
end

function CreatePrivateRoom:exclusiveSelectTime(sel)
	for i = 1, 6, 1 do
		local chk = UIHelper.seekNodeByName(self.csbnode, "CheckBox_Time_" .. tostring(i))
		if chk ~= sel then
			chk:setSelected(false);
		end
	end
end

--id = tonumber(content.id_),
--balance_with = tonumber(content.balance_with_),     --结算货币的ID
--banker_set = tonumber(content.banker_set_),         --抢庄保证金
--bet_set = tonumber(content.bet_set_),               --最小压注金额
--enter_cap = tonumber(content.enter_cap_),           --进入场次的最低货币限制
--enter_cap_top = tonumber(content.enter_cap_top),    --进入场次的最低货币限制
--enter_scene = tonumber(content.enter_scene_),       --是否进入场次信息。1是，0服务器参数，2， 开始 3服务器参数配置结束
--params = content.params_,
--sequence_1 = tonumber(content.sequence_1_)

function CreatePrivateRoom:SliderChange(percent)
	--私人房配置
	local roomlist = {}
	for k,v in pairs(APP.GD.room_list) do
		if v.params == "private" then
		table.insert(roomlist, v)
		end
	end
	local cnt = #roomlist;
	local unit = 100 / cnt;
	local indx = math.ceil(percent / unit);
	local roomitem = roomlist[indx]
	if roomitem then
		local bet1 = UIHelper.seekNodeByName(self.csbnode, "AtlasLabel_BaseBet")
		bet1:setString(string.format("%d/%d", roomitem.bet_set / 2, roomitem.bet_set));
		local bet2 = UIHelper.seekNodeByName(self.csbnode, "AtlasLabel_TakeBet")
		bet2:setString(string.format("%d", roomitem.banker_set));
		self.indx = roomitem.id;
	end
end

function CreatePrivateRoom:getDurSet()
	for i = 1, 6, 1 do
		local chk = UIHelper.seekNodeByName(self.csbnode, "CheckBox_Time_" .. tostring(i))
		if chk:isSelected() then
			return 120;--chk:getTag();
		end
	end
	return 120;
end

function CreatePrivateRoom:getConfigSet()
	return self.indx;
end

return CreatePrivateRoom;
--endregion
