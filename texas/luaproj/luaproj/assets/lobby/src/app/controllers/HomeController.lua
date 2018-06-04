local UIHelper = require("app.common.UIHelper")
local ControllerBase = require("app.controllers.ControllerBase")
local AlertOK = require("app.views.common.AlertOK")
local coorCmd = require("app.commands.LoginCoordinateCommand")
local switchGSHandler = require("app.handlers.SwitchGameServerHandlers")
local conf = require("app.common.GameConfig")
local CMD = require("app.net.CMD")

local HomeController = class("HomeController", ControllerBase)

function HomeController:ctor()
    HomeController.super.ctor(self)
	self.waitHandle1 = nil;
	self.waitHandle2 = nil;
	self:enableNodeEvents()

	UIHelper.cacheCards()

	self:addChild(APP:createView("home.ViewHome", self))

    local broadcastWidth = 500
	local broadcastHeight = 40
    local broadcastView = APP:createView("common.BroadcastNode", {width = broadcastWidth, height = broadcastHeight})
    broadcastView:setPosition(cc.p((display.width - broadcastWidth) / 2, 1150))
    self:addChild(broadcastView)

  -- self:retSignAwardData()
    self.viewRankH = nil
   
	APP:addListener(self, "COMMON_ERROR", handler(self, self.onError));
end

function  HomeController:findPrivateRoom(roomId)
	APP.hc:showWaiting();
	switchGSHandler.active({purpose = "joinroom", roomId = roomId});
	coorCmd.findPrivateRoom(conf.GameID, roomId);

	self.waitHandle1 = scheduler.scheduleGlobal(function()
		APP.hc:hideWaiting();
		switchGSHandler.deactive();
		scheduler.unscheduleGlobal(self.waitHandle1);
	end, 3)
end

function  HomeController:onError(desc)
	APP.hc:hideWaiting();
	self:showAlertOK(desc);
end

function  HomeController:QueryMyPrivateRoom()
	coorCmd.findPrivateRoom(conf.GameID, 0);
end

function  HomeController:onEnter()
	print("HomeController:onEnter")
	HomeController.super.onEnter(self)
end

function HomeController:onExit()
	if self.waitHandle1 then
		scheduler.unscheduleGlobal(self.waitHandle1)
		self.waitHandle1 = nil;
	end;

	if self.waitHandle2 then
		scheduler.unscheduleGlobal(self.waitHandle2)
		self.waitHandle2 = nil;
	end;

    if self.viewRankH then
      self.viewRankH = nil
      end 
	HomeController.super.onExit(self)
end

function HomeController:createPrivateRoom(config_indx, dur)
	local data = {
		config_index_ = config_indx,
		params_ = "",
		psw_ = "",
		turn_num_ = dur,
		type_ = 1;
	}
	SOCKET_MANAGER.sendToGameServer(CMD.GAME_CREATE_ROOM, data);
end


function HomeController:QueryMyResult()
	SOCKET_MANAGER.sendToGameServer(CMD.GAME_PRIVATE_ROOM_RESULT_REQ, {});
end

function HomeController:QueryMyResultDetail(sn)
	local data = {
		sn_ = sn
	}
	SOCKET_MANAGER.sendToGameServer(CMD.GAME_PRIVATE_ROOM_RESULT_DETAIL_REQ, data);
end

-- if roundId = 0x00FFFFFF 表示自动进入上次所在的房间(用于掉线重连)
-- if roundId = 0 表示自动分配房间
-- if roundId = N 表示进入某个确定的房间
-- roomId << 24 | roundId
function HomeController:enterRoom(roomId, roundId)
	local id = bit.blshift(roundId, 24)
	id = bit.bor(id, roomId)

	print("id:" .. tostring(id))
	local data = {
		room_id_ = id
	}
	SOCKET_MANAGER.sendToGameServer(CMD.GAME_ENTER_GAME_REQ, data)
end

-- 用户设置
function HomeController:sendUserInfo(headId,nickName)
	local data = {
		head_ico_ = tostring(headId),
		headframe_id_ = "",
		nickname_ = nickName
	}
	SOCKET_MANAGER.sendToCoordinateServer(CMD.GAME_USERINFO_SET_REQ, data)
end

--邮件

function HomeController:sendMailGetAttachReq(id)
    local data = { id_ = id }
    SOCKET_MANAGER.sendToCoordinateServer(CMD.GAME_GET_MAIL_ATTACH_REQ, data)
end


-----------------------------

function HomeController:showPersonal()
	self:addChild(APP:createView("home.ViewPersonal", self))
end

function HomeController:showModifyPersonal()
	self:addChild(APP:createView("home.ViewModifyPersonal", self))
end

function HomeController:showShop(isShowDiamond)
	self:addChild(APP:createView("home.ViewShop", isShowDiamond))
end

function HomeController:showSetting()
	self:addChild(APP:createView("home.ViewSetting", self))
end

function HomeController:showSevice()
	self:addChild(APP:createView("home.ViewService", self))
end

function HomeController:showMail()
    self:addChild(APP:createView("home.ViewEmail",self))
end

function HomeController:showDailyTasks()
    self:addChild(APP:createView("home.ViewDailyTasks",self))
end

function HomeController:showRank()
    self.viewRankH = APP:createView("home.ViewRank",self)
    self:addChild(self.viewRankH)
    
end
function HomeController:showSignLayer(signInfoTable)
    self:addChild(APP:createView("home.ViewSignLayer",signInfoTable))
end
function HomeController:quickStart()
	self:showWaiting()
	local gold_exchaged = APP.GD:isGoldExchanged()
	if gold_exchaged then
		local roomList = APP.GD:getRoomList()
		local config_index = roomList[1].id
		self:enterRoom(0, config_index)
	else
		self:hideWaiting()
		local LANG =APP.GD.LANG
		self:showAlertOK({desc = LANG.TIP_NET_NOT_READY})
	end
	APP.GD.private_room_select = 0;
end

function HomeController:showFriendRoom(container)
	container:addChild(APP:createView("friendroom.ViewFriendRoom", self))
end

function HomeController:showSelectRoom(container)
	container:addChild(APP:createView("friendroom.SelectRoom", self, container))
end

function HomeController:showCreateRoom(container)
	container:addChild(APP:createView("friendroom.CreatePrivateRoom", self))
end
function HomeController:showEnterPrivateRoom(container)
	container:addChild(APP:createView("friendroom.EnterPrivateRoom", self))
end

function HomeController:retSignAwardData()
    print("=====retSignAwardData======")
	SOCKET_MANAGER.sendToCoordinateServer(CMD.GAME_SIGN_REQ, {});
end
--0-每日签到奖励 1:3天连续签到奖励 2:6天连续签到奖励 3:9天连续签到奖励 
function HomeController:retSignAward(dNumber) 
print("retSignAward  dNumber=",dNumber)
    	local data = {
		type_ = dNumber
	}
    
    SOCKET_MANAGER.sendToCoordinateServer(CMD.GAME_SIGN_GET_REQ,data);
end

function HomeController:ShowSignAward(data)
    if self.ViewSignAward == nil then 
    print("=======================   nooooooooooooooooooooooo")
      self:addChild(APP:createView("ViewSignAward",data))
    else
      print("=======================   yessssssssssssssssssssssssss")
    self.ViewSignAward:addAward(data)
    end 
    


--[[      local awardInfo ={

          itemNumber = 888,
          coinNumber = 999
    } 
 
   APP.hc:ShowSignAward(awardInfo)]]--
end 


function HomeController:ReqRankData(rankN)

printLog("a","==================  ReqRankData ")
    local rankReqData = {
    type_  =  rankN,
    page_  = 0,
    page_count_ = 20
    }
    dump(rankReqData)
     SOCKET_MANAGER.sendToGameServer(CMD.GAME_RANK_REQ,rankReqData);
end 

function HomeController:ViewRankUpData(Rankdata) 
   printLog("a","============================   HomeController") 
   dump(self.viewRankH)
   print(tolua.type(self.viewRankH)) 
   if self.viewRankH ~= nil then
   self.viewRankH:upDateRankInfo(Rankdata)
   end 
   --APP.hc.ViewRank:upDateRankInfo(data)
end


return HomeController