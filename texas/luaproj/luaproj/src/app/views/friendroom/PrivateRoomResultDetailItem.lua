--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIHelper = require("app.common.UIHelper")
local PrivateRoomResultDetailItem = class("PrivateRoomResultDetailItem", cc.mvc.ViewBase)
local CMD = require("app.net.CMD")
local utils = require("app.common.utils")

--detail格式
--int				room_id_;
--std::string		uid_;
--std::string		nickname_;
--__int64			win_;		//输赢
--__int64			scores_;	//积分
--__int64			pay_;
--int				state_;		//0-离开 1-站起 2-坐下

function PrivateRoomResultDetailItem:ctor(ctrl, order, detail)
	PrivateRoomResultDetailItem.super.ctor(self)
	self.csbnode = cc.CSLoader:createNode("cocostudio/home/PrivateRoomResultDetailItem.csb")
	self.csbnode:addTo(self);
	self:setContentSize(self.csbnode:getContentSize());

	local txtOrder = UIHelper.seekNodeByName(self.csbnode, "txtOrder");
	txtOrder:setString(tostring(order));

	local txtName = UIHelper.seekNodeByName(self.csbnode, "txtName");
	txtName:setString(detail.nickname_);

	local txtPay = UIHelper.seekNodeByName(self.csbnode, "txtPay");
	txtPay:setString(detail.pay_);

	local txtWin = UIHelper.seekNodeByName(self.csbnode, "txtWin");
	txtWin:setString(detail.win_);
end

return PrivateRoomResultDetailItem
--endregion
