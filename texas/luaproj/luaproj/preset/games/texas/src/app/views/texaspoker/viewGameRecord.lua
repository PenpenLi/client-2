local UIHelper = require("app.common.UIHelper")
local LeftBaseLayer = require("app.views.common.LeftBaseLayer")
local viewGameRecord = class("viewGameRecord", LeftBaseLayer)
local utils = require("utils")

function viewGameRecord:ctor()
	viewGameRecord.super.ctor(self, "cocostudio/game/GameRecord.csb");
	self.lastGame = UIHelper.seekNodeByName(self, "lastGameContainer");
	self.currGame = UIHelper.seekNodeByName(self, "currentGameContainer");
	
	local btnLast = UIHelper.seekNodeByName(self, "lastGame");
	local btnCurr = UIHelper.seekNodeByName(self, "currentGame");

	btnLast:addTouchEventListener(function (sender,evt) 
		if evt == ccui.TouchEventType.ended  then
			self.currGame:setVisible(false);
			self.lastGame:setVisible(true);
			btnCurr:setSelected(false);
		end
    end);


	btnCurr:addTouchEventListener(function (sender,evt) 
        if evt == ccui.TouchEventType.ended  then
			self.currGame:setVisible(true);
			self.lastGame:setVisible(false);
            btnLast:setSelected(false);
        end
    end);
	
	self.lastGamePlist = UIHelper.seekNodeByName(self, "players");
	self.evt = addListener(self, "NET_MSG", handler(self, self.onMsg))

	--上局游戏玩家
	self.lastGameP = {}

	--请求上局游戏数据
	SOCKET_MANAGER.sendToGameServer(8, {});
end

--GET_CLSID(msg_last_game_summary) = 22,
--GET_CLSID(msg_last_game_detail) = 23,
function viewGameRecord:onMsg(fromServer, subCmd, content)
	if subCmd == 22 then
		self:updateLastGameItem(content);
	elseif subCmd == 23 then
		self:addLastGameItem(content);
	end
end

function viewGameRecord:addLastGameItem(content)
	local pla = APP:createView("texaspoker.viewGameRecordItem", content);
	self.lastGameP[content.uid_] = pla;
	self.lastGamePlist:addChild(pla);
end

--std::string scene_set_;
function viewGameRecord:updateLastGameItem(content)
	local betSet = UIHelper.seekNodeByName(self, "betSet");
	betSet:setString(string.format("%d/%d", tonumber(content.scene_set_) / 2, tonumber(content.scene_set_)));
end

function viewGameRecord:onExit()
	viewGameRecord.super.onExit(self)
	removeListener(self.evt);
end

return viewGameRecord