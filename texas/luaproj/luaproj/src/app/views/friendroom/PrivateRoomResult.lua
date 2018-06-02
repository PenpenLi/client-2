--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local UIHelper = require("app.common.UIHelper")
local PrivateRoomResult = class("PrivateRoomResult", cc.mvc.ViewBase)
local CMD = require("app.net.CMD")

function PrivateRoomResult:ctor(ctrl, container)
	PrivateRoomResult.super.ctor(self)
	self.csbnode = cc.CSLoader:createNode("cocostudio/home/PrivateRoomResult.csb")
	self.csbnode:addTo(self);
	self.container_ = container;
	self.index = 0;
	self.myResults = UIHelper.seekNodeByName(self.csbnode, "ListView_1");
	APP:addListener(self, "NET_MSG", handler(self, self.onMsg));
	APP.hc:QueryMyResult();
end

function PrivateRoomResult:onMsg(fromServer, subCmd, content)
	if subCmd == CMD.GAME_PRIVATE_ROOM_RESULT then
		local pi = APP:createView("friendroom.PrivateRoomResultItem", APP.hc, self.container_, content);
		self.myResults:addChild(pi)
	end
end

return PrivateRoomResult;


--endregion
