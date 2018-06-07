--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local UIHelper = require("app.common.UIHelper")
local PrivateRoomResultItem = class("PrivateRoomResultItem", cc.mvc.ViewBase)
local LANG =APP.GD.LANG
local utils = require("utils")

--content格式
--std::string sn_;
--std::string master_;
--std::string betset_;
--int			time_set_;
--__int64		time_;
--__int64		win_;

function PrivateRoomResultItem:ctor(ctrl, container, content)
	PrivateRoomResultItem.super.ctor(self)
	self.csbnode = cc.CSLoader:createNode("cocostudio/home/PrivateRoomResultItem.csb")
	self.csbnode:addTo(self)
	self:setContentSize(self.csbnode:getContentSize());

	self.container_ = container;
	self.content_ = content;
	local txtName = UIHelper.seekNodeByName(self.csbnode, "txtName");
	txtName:setString(content.master_.. LANG.UI_ROOM);

	local txtTime = UIHelper.seekNodeByName(self.csbnode, "txtTime");
	txtTime:setString(utils.timeStr(tonumber(content.time_)));

	local txtWin = UIHelper.seekNodeByName(self.csbnode, "txtWin");
	if tonumber(content.win_) > 0 then
		txtWin:setString("+"..content.win_);
	else
		txtWin:setString("-"..content.win_);
	end 

	local btn = UIHelper.seekNodeByName(self.csbnode, "Button_1");
	btn:addTouchEventListener(function(ref, t)
		if t ~= ccui.TouchEventType.ended then return end;
		APP:createView("friendroom.PrivateRoomResultDetail", APP.hc, self.container_, self.content_):addTo(self.container_)
	end)
end

return PrivateRoomResultItem;
--endregion
