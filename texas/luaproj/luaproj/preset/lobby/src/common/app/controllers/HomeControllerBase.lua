local UIHelper = require("app.common.UIHelper")
local ControllerBase = require("app.controllers.ControllerBase")
local AlertOK = require("app.views.common.AlertOK")
local coorCmd = require("app.commands.LoginCoordinateCommand")
local switchGSHandler = require("app.handlers.MsgTakeoverOnSwitchingSrv")
local conf = require("app.common.GameConfig")
local CMD = require("app.net.CMD")
local SoundUtils = require("app.common.SoundUtils")

local HomeControllerBase = class("HomeControllerBase", ControllerBase)

function HomeControllerBase:ctor()
    HomeControllerBase.super.ctor(self)

	self:enableNodeEvents()

	self:retSignAwardData()
    self.viewRankH = nil
   
	addListener(self, "COMMON_ERROR", handler(self, self.onError));
	SoundUtils.playMusic()

end

function  HomeControllerBase:findPrivateRoom(roomId)
	self:showWaiting();
	switchGSHandler.active({purpose = "joinroom", roomId = roomId});
	coorCmd.findPrivateRoom(g_CurrentGame().gameid, roomId);

	self:scheduleOnce(function()
		self:hideWaiting();
		switchGSHandler.deactive();
	end, 3, "21f312")

end

function  HomeControllerBase:onError(desc)
	self:hideWaiting();
	self:showAlertOK({desc = desc});
end

function  HomeControllerBase:QueryMyPrivateRoom()
	coorCmd.findPrivateRoom(g_CurrentGame().gameid, 0);
end

function  HomeControllerBase:onEnter()
	HomeControllerBase.super.onEnter(self)
end

function HomeControllerBase:onExit()
	HomeControllerBase.super.onExit(self)
end

function HomeControllerBase:onDelete()
	HomeControllerBase.super.onDelete(self)
	self:hideWaiting();
	switchGSHandler.deactive();
end

function HomeControllerBase:createPrivateRoom(config_indx, dur)
	local data = {
		config_index_ = config_indx,
		params_ = "",
		psw_ = "",
		turn_num_ = dur,
		type_ = 1;
	}
	SOCKET_MANAGER.sendToGameServer(CMD.GAME_CREATE_ROOM, data);
end


function HomeControllerBase:QueryMyResult()
	SOCKET_MANAGER.sendToGameServer(CMD.GAME_PRIVATE_ROOM_RESULT_REQ, {});
end

function HomeControllerBase:QueryMyResultDetail(sn)
	local data = {
		sn_ = sn
	}
	SOCKET_MANAGER.sendToGameServer(CMD.GAME_PRIVATE_ROOM_RESULT_DETAIL_REQ, data);
end

-- if roundId = 0x00FFFFFF 表示自动进入上次所在的房间(用于掉线重连)
-- if roundId = 0 表示自动分配房间
-- if roundId = N 表示进入某个确定的房间
-- roomId << 24 | roundId
function HomeControllerBase:enterRoom(roomId, roundId)
	self:showWaiting()
	local id = bit.blshift(roundId, 24)
	id = bit.bor(id, roomId)

	printLog("a","id:" .. tostring(id))
	local data = {
		room_id_ = id
	}

	if SOCKET_MANAGER.sendToGameServer(CMD.GAME_ENTER_GAME_REQ, data) ~= 0 then
		self:hideWaiting()
	end
end

-- 用户设置
function HomeControllerBase:sendUserInfo(headId, nickName)
	local data = {
		head_ico_ = headId,
		headframe_id_ = "",
		nickname_ = nickName
	}
	SOCKET_MANAGER.sendToCoordinateServer(CMD.GAME_USERINFO_SET_REQ, data)
end

--邮件

function HomeControllerBase:sendMailGetAttachReq(id)
    local data = { id_ = id }
    SOCKET_MANAGER.sendToCoordinateServer(CMD.GAME_GET_MAIL_ATTACH_REQ, data)
end


-----------------------------

function HomeControllerBase:showPersonal()
	self:addChild(APP:createView("home.ViewPersonal", self))
end

function HomeControllerBase:showModifyPersonal()
	self:addChild(APP:createView("home.ViewModifyPersonal", self))
end

function HomeControllerBase:showShop(isShowDiamond, container)
	container:addChild(APP:createView("home.ViewShop", isShowDiamond, container))
end

function HomeControllerBase:showSetting()
	self:addChild(APP:createView("home.ViewSetting", self))
end

function HomeControllerBase:showSevice()
	self:addChild(APP:createView("home.ViewService", self))
end

function HomeControllerBase:showMail()
    self:addChild(APP:createView("home.ViewEmail",self))
end

function HomeControllerBase:showDailyTasks()
    self:addChild(APP:createView("home.ViewDailyTasks",self))
end

function HomeControllerBase:showRank()
    self.viewRankH = APP:createView("home.ViewRank",self)
    self:addChild(self.viewRankH)
    
end
function HomeControllerBase:showSignLayer(signInfoTable)
    self:addChild(APP:createView("home.ViewSignLayer",signInfoTable))
end

function HomeControllerBase:showFriendRoom(container)
	container:addChild(APP:createView("friendroom.ViewFriendRoom", self))
end

function HomeControllerBase:showSelectRoom(container)
	container:addChild(APP:createView("home.SelectRoom", self, container))
end

function HomeControllerBase:showBanker(container)
    container:addChild(APP:createView("home.ViewBank"))
end

function HomeControllerBase:showCreateRoom(container)
	container:addChild(APP:createView("friendroom.CreatePrivateRoom", self))
end
function HomeControllerBase:showEnterPrivateRoom(container)
	container:addChild(APP:createView("friendroom.EnterPrivateRoom", self))
end

function HomeControllerBase:retSignAwardData()
    printLog("a","=====retSignAwardData======")
	SOCKET_MANAGER.sendToCoordinateServer(CMD.GAME_SIGN_REQ, {});
end
--0-每日签到奖励 1:3天连续签到奖励 2:6天连续签到奖励 3:9天连续签到奖励 
function HomeControllerBase:retSignAward(dNumber) 
printLog("a","retSignAward  dNumber=",dNumber)
    	local data = {
		type_ = dNumber
	}
    
    SOCKET_MANAGER.sendToCoordinateServer(CMD.GAME_SIGN_GET_REQ,data);
end

function HomeControllerBase:ShowSignAward(data)
    if self.ViewSignAward == nil then
		self.ViewSignAward = APP:createView("home.ViewSignAward",data);
		self:addChild(self.ViewSignAward);
    else
		self.ViewSignAward:addAward(data)
    end 
end 


function HomeControllerBase:ReqRankData(rankN)

printLog("a","==================  ReqRankData ")
    local rankReqData = {
    type_  =  rankN,
    page_  = 0,
    page_count_ = 20
    }
    dump(rankReqData)
    SOCKET_MANAGER.sendToGameServer(CMD.GAME_RANK_REQ,rankReqData);
end 

function HomeControllerBase:ViewRankUpData(Rankdata) 
	printLog("a","============================   HomeController") 
	dump(self.viewRankH)
	printLog("a",tolua.type(self.viewRankH)) 
	if self.viewRankH ~= nil then
		self.viewRankH:upDateRankInfo(Rankdata)
	end 
	--APP.hc.ViewRank:upDateRankInfo(data)
end


return HomeControllerBase