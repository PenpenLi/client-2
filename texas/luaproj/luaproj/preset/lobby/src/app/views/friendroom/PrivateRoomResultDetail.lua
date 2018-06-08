--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local UIHelper = require("app.common.UIHelper")
local PrivateRoomResultDetail = class("PrivateRoomResultDetail", cc.mvc.ViewBase)
local CMD = require("app.net.CMD")
local utils = require("utils")
--summary格式
--std::string sn_;
--std::string master_;
--std::string betset_;
--int			time_set_;
--__int64		time_;
--__int64		win_;
function PrivateRoomResultDetail:ctor(ctrl, container, content)
	PrivateRoomResultDetail.super.ctor(self)
	self.csbnode = cc.CSLoader:createNode("cocostudio/home/PrivateRoomResultDetail.csb")
	self.csbnode:addTo(self);
	self.container_ = container;
	self.content_ = content;
	self.players = UIHelper.seekNodeByName(self.csbnode, "ListView_1");
	self.index = 0;
	APP.hc:QueryMyResultDetail(content.sn_);

	addListener(self, "NET_MSG", handler(self, self.onMsg));
	
	local txtName = UIHelper.seekNodeByName(self.csbnode,"txtName");
	txtName:setString(content.master_);

	local txtTime = UIHelper.seekNodeByName(self.csbnode,"txtTime");
	txtTime:setString(utils.timeStr(tonumber(content.time_)));
	
	local txtBet = UIHelper.seekNodeByName(self.csbnode,"txtBet");
	txtBet:setString(content.betset_);

	local txtBet = UIHelper.seekNodeByName(self.csbnode,"txtBet");
	txtBet:setString(content.betset_);

	local txtTimeSet = UIHelper.seekNodeByName(self.csbnode,"txtTimeSet");
	txtTimeSet:setString(utils.timeStr2(tonumber(content.time_set_)));
end

function PrivateRoomResultDetail:onMsg(fromServer, subCmd, content)
	if subCmd == CMD.GAME_PRIVATE_ROOM_RESULT_DETAIL then
		local pi = APP:createView("friendroom.PrivateRoomResultDetailItem", APP.hc, self.index + 1, content);
		self.players:addChild(pi);
		self.index = self.index + 1;
	end
end

return PrivateRoomResultDetail
--endregion
