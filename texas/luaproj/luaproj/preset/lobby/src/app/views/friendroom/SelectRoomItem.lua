--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIHelper = require("app.common.UIHelper")
local SelectRoomItem = class("SelectRoomItem", cc.mvc.ViewBase)

--id = tonumber(content.id_),
--balance_with = tonumber(content.balance_with_),     --结算货币的ID
--banker_set = tonumber(content.banker_set_),         --抢庄保证金
--bet_set = tonumber(content.bet_set_),               --最小压注金额
--enter_cap = tonumber(content.enter_cap_),           --进入场次的最低货币限制
--enter_cap_top = tonumber(content.enter_cap_top),    --进入场次的最低货币限制
--enter_scene = tonumber(content.enter_scene_),       --是否进入场次信息。1是，0服务器参数，2， 开始 3服务器参数配置结束
--params = content.params_,
--sequence_1 = tonumber(content.sequence_1_)

function SelectRoomItem:ctor(ctrl, roomitem)
	SelectRoomItem.super.ctor(self)
	self.roomitem = roomitem
	self.csbnode = cc.CSLoader:createNode("cocostudio/home/RoomItem.csb")
    self.csbnode:addTo(self)

	local btn = UIHelper.seekNodeByName(self.csbnode, "btn");
	btn:addTouchEventListener(function(ref, t)
		if t ~= ccui.TouchEventType.ended then return end;
		APP.hc:enterRoom(0, self.roomitem.id);    
	end);
	local pa = string.format("cocostudio/home/image/roomselect/youxichangyu_%d.png", self.roomitem.id)
	btn:loadTextureNormal(pa);
	btn:loadTexturePressed(pa);

	local txtPlayers = UIHelper.seekNodeByName(self.csbnode, "txtPlayers");
	txtPlayers:setString(string.format("%d", math.random(1000, 5000)));

	local txtBet = UIHelper.seekNodeByName(self.csbnode, "txtBet");
	txtBet:setString(string.format("%d/%d", self.roomitem.bet_set / 2, self.roomitem.bet_set));
	
end

return SelectRoomItem
--endregion
