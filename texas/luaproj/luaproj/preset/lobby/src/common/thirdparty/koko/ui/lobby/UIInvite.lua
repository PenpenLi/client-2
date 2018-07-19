-----------------------------------------------------------------------------------
-- 福利（邀请）  2017.9
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
local UIWelcomeAccountUpgrade = require "koko.ui.lobby.UIWelcome".UIWelcomeAccountUpgrade
module "koko.ui.lobby.UIInvite"
-----------------------------------------------------------------------------------
local LC_Data = {bInviteMessage = true}
UIInvite = CC.UI:Create{
	Path = "koko/ui/lobby/invite.csb",
	Key = "UIInvite",

	kImageBtn = "koko/atlas/all_common/button/left_selet.png",
	kImageBtnS = "koko/atlas/all_common/button/left.png",
	kTextEditQRCode = "请输入推广口令",
	NE_PAGE = 3,
	NE_GIFT = 4,
	NE_GIFT_IN = 101,
}
function UIInvite:Public()
	self.UIInviteGift = UIInviteGift
	self.UIInviteGift2 = UIInviteGift2
	self.UIInviteBegin = UIInviteBegin
	self.UIInviteHelp = UIInviteHelp
	self.UIInviteGiftList = UIInviteGiftList
	self.UIInviteMessage = UIInviteMessage
end

function UIInvite:Load()
	C("btClose"):Close()
	for i=1,self.NE_PAGE do
		C("btInvite"..i):Click("OnClickPage")
	end	
	local kNine = C("rInvite1"):Nine()
	kNine:Attach(7, C("rInvite2"):Nine(), 7)
	kNine:Attach(7, C("rInvite3"):Nine(), 7)
	self.t.iPage = 2
	-- 邀请礼包
	C("btInvite1"):Hide()
	for i=1,self.NE_GIFT do
		C("btGift"..i):Param("Gift"):Click("OnClickOK")
	end	
	C("btOK1"):Param("Share"):Click("OnClickOK")
	self.t[1] = {}
	-- 推广口令
	C("btHelp"):Open(self.UIInviteHelp)
	self.t[2] = {kTextMyCode = C("txMyCode"):Text(), kSwitch = CC.Switch()}
	-- 推广福利
	C("btOK3"):Param("GetGift"):Click("OnClickOK")
	C("btOK32"):Param("GetGiftByQRCode"):Click("OnClickOK")
	C("btGiftList"):Open(self.UIInviteGiftList)
	self.t[3] = {kCode0 = nil, kSwitch = CC.Switch()}

	if self:Step() == 4 then
		if LC_Data.bInviteMessage then
			CC.UIMgr:Unload(self)
			CC.UIMgr:Load(self.UIInviteMessage)
		else
			CC.UIMgr:Load(UIWelcomeAccountUpgrade)
		end
	end
end
function UIInvite:Call(tVal)
	tVal = tVal or {}
	if tVal.RegOK and self:Step() == 4 then
		self:Step(1)
	end
end

function UIInvite:CallBackPage3(tVal)
	if tVal.success then
		self:Step(3)
		self:Refresh()
		CC.UIMgr:Load(self.UIInviteGift2)
		CC.UIMgr:Call("UIInviteGift2", {GiftID = self.NE_GIFT_IN})
	else
		CC.Message({Text = tVal.message})
	end
end

function UIInvite:Refresh()
	local iPage = self.t.iPage
	local t = self.t[iPage]
	for i=1,self.NE_PAGE do
		C("rInvite"..i):Visible(iPage == i)
	end
	
	for i=1, self.NE_PAGE do
		C("btInvite"..i):Image(iPage == i and self.kImageBtnS or self.kImageBtn)
	end	
	C("btInvite1"):C("iRedPoint"):Visible(CC.PlayerMgr.Invite.Gift.bRedPoint)
	C("btInvite3"):C("iRedPoint"):Visible(CC.PlayerMgr.Invite.List.bRedPoint)
	-- 邀请礼包
	if iPage == 1 then
		local kData, kExcel = CC.PlayerMgr.Invite.Gift, CC.Excel.InviteGift
		for i=1,self.NE_GIFT do
			C("btGift"..i):Color(kData.tGift[i] == 2 and CC.Color.White or CC.Color.Gray)
		end
		C("iProgress"):Progress(kData.iInvite / kExcel:At(self.NE_GIFT).InviteNum)
	-- 推广口令
	elseif iPage == 2 then
		if t.kSwitch:TryOn() then
			C("iMyCode"):Web(_G.require("config").webUrl.."downloadQr.htm?iid="..CC.Player.iid.."&platform=lua"):Image()
		end
		C("txMyCode"):Text(t.kTextMyCode..CC.Player.iid)
	-- 推广福利
	elseif iPage == 3 then
		if t.kSwitch:TryOn() then
			t.kEditCode = CC.Sample.Edit:Create{Node = C("rEditQRCode"):Node(), Info = self.kTextEditQRCode}
			t.tTextInfo3 = CC.String:Split(C("txInfo3"):Text(),"#")
		end
		local iStep = self:Step()
		C("txInfo3"):Text(t.tTextInfo3[iStep])
		C("rEditQRCode"):Visible(iStep == 1)
		C("btOK32"):Visible(iStep == 1)
		C("btOK3"):Color(iStep == 3 and CC.Color.Gray or CC.Color.White):Enabled(iStep ~= 3)
		C("iRedPointList"):Visible(CC.PlayerMgr.Invite.List.bRedPoint)
	end
end
function UIInvite:Step(iVal)
	if iVal then
		CC.PlayerMgr.Invite.List.iStep = iVal
	else
		return CC.PlayerMgr.Invite.List.iStep
	end
end
function UIInvite:OnClickPage(kNode)
	self.t.iPage = C(kNode):Index()
	self:Refresh()
end

function UIInvite:OnClickOK(kNode)
	local kKey = C(kNode):Param()
	local iPage = self.t.iPage
	local t = self.t[iPage]
	-- 邀请礼包
	if iPage == 1 then
		if kKey == "Gift" then		
			t.iGift = C(kNode):Index()
			CC.UIMgr:Load(self.UIInviteGift)
		end
	-- 推广口令
	elseif iPage == 2 then
		if kKey == "Share" then
			_G.share("http://game.test.koko.com:8081/appbms/share.htm", "KOKO游戏", "一起来玩吧！", 1, 0)
			CC.Print("UIInvite:OnClickOK 发送分享请求")
		end
	-- 推广福利	
	elseif iPage == 3 then		
		local function LF_Call(kVal, bQRCode)
			local iStep = self:Step()
			if iStep == 1 then
				local kCode = kVal or t.kEditCode:Text()
				if _G.string.len(kCode) == 0 then
					CC.Message{Tip = "推广口令不能为空"}
				else
					if bQRCode then
						CC.SendWeb("promotion/addRecordlua.htm", {param = kCode}, "UIInvite","CallBackPage3")
					else
						CC.SendWeb("promotion/addRecord.htm", {inviteIid = kCode},"UIInvite","CallBackPage3")
					end
				end
			elseif iStep == 2 then
				CC.SendWeb("promotion/bquiltLong.htm", {},"UIInvite","CallBackPage3")
			end
		end
		if kKey == "GetGift" then
			LF_Call()
		elseif kKey == "GetGiftByQRCode" then
			local function LF_Temp(iOK, kText)
				if iOK == 1 and kText then
					LF_Call(kText, true)
				else
					CC.Message{Text = "扫码失败"}
					CC.Print("扫码失败"..(iOK or 0)..(kText or ""))
				end
			end
			_G.scan_qrcode(LF_Temp)
			CC.Print("开始扫码：scan_qrcode")
		end
	end
end
-----------------------------------------------------------------------------------
UIInviteGift = CC.UI:Create{
	Path = "koko/ui/lobby/invite_gift.csb", 
	Key = "UIInviteGift",

	NE_ITEM = 3,
}
function UIInviteGift:Load()
	C("btClose"):Close()
	C("btOK"):Click("OnClickOK")
	self.t.txFormat = C("txInfo"):Text()
end

function UIInviteGift:Refresh()	
	local iGift = CC.UIMgr:Get("UIInvite").t[1].iGift
	local kExcel = CC.Excel.InviteGift[iGift]
	C("txInfo"):Format(self.t.txFormat, kExcel.InviteNum)
	for i=1,self.NE_ITEM do
		local tItem = kExcel.Items[i]
		local kC = C("rItem"..i)
		local bVisible = false
		if tItem then
			local kExcelItem = CC.Excel.Item[tItem.ID]
			if kExcelItem then
				bVisible = true
				kC:C("iItem"):Image(kExcelItem.Icon)
				kC:C("txNum"):Text(tItem.Num)
			end
		end
		kC:C("iItem"):Visible(bVisible)
		kC:C("txNum"):Visible(bVisible)
	end
	local iStep = CC.PlayerMgr.Invite.Gift.tGift[iGift]
	C("btOK"):Visible(iStep == 2)
end

function UIInviteGift:OnClickOK(kNode)
	--TODO
	CC.UIMgr:Unload(self)
end
-----------------------------------------------------------------------------------
UIInviteGift2 = CC.UI:Create{
	Path = "koko/ui/lobby/invite_gift_2.csb", 
	Key = "UIInviteGift2",

	NE_ITEM = 3,
}
function UIInviteGift2:Load()
	C("btClose"):Close()
	C("btOK"):Close()
	self.t.iGift = nil
end

function UIInviteGift2:Refresh()	
	if self.t.iGift then
		local kExcel = CC.Excel.InviteGift[self.t.iGift]
		for i=1,self.NE_ITEM do
			local tItem = kExcel.Items[i]
			local kC = C("rItem"..i)
			local bVisible = false
			if tItem then
				local kExcelItem = CC.Excel.Item[tItem.ID]
				if kExcelItem then
					bVisible = true
					kC:C("iItem"):Image(kExcelItem.Icon)
					kC:C("txNum"):Text(tItem.Num)

					CC.Send(1038, {item_id_ = tItem.ID}, "求刷物品")
				end
			end
			kC:C("iItem"):Visible(bVisible)
			kC:C("txNum"):Visible(bVisible)
		end
	end
end

function UIInviteGift2:Call(tVal)
	if tVal.GiftID then
		self.t.iGift = tVal.GiftID
		self:Refresh()
	end
end
-----------------------------------------------------------------------------------
UIInviteBegin = CC.UI:Create{
	Path = "koko/ui/lobby/invite_begin.csb", 
	Key = "UIInviteBegin",

	NE_INVITE = 4,
}
function UIInviteBegin:Load()
	C("btClose"):Close()
	C("iInvite", self.NE_INVITE):Click("OnClickOK")
end

function UIInviteBegin:Refresh()	
end

function UIInviteGift:OnClickOK(kNode)
	local iIndex = C(kNode):Index()
end
-----------------------------------------------------------------------------------
UIInviteHelp = CC.UI:Create{
	Path = "koko/ui/lobby/invite_help.csb", 
	Key = "UIInviteHelp",
}
function UIInviteHelp:Load()
	C("btClose"):Close()
end
-----------------------------------------------------------------------------------
UIInviteGiftList = CC.UI:Create{
	Path = "koko/ui/lobby/invite_list.csb", 
	Key = "UIInviteGiftList",

	NE_PER_PAGE = 20,
	NE_GIFT_OUT = 201
}
function UIInviteGiftList:Load()
	C("btClose"):Close()
	self.t.kTextPlayer = C("txPlayer"):Text()
	self.t.kTextGot = C("txGot"):Text()
	self.t.kTextCan = C("txCan"):Text()
	self.t.kSwitchMore = CC.Switch()
	CC.PlayerMgr.Invite.List:Sync()
	C("rScroll"):Event(_G.SCROLLVIEW_EVENT_SCROLL_TO_BOTTOM, "OnScrollBottom")
	self:More()
end

function UIInviteGiftList:Public()
	self.UIInviteGift2 = UIInviteGift2
end

function UIInviteGiftList:Update()
end

function UIInviteGiftList:More()
	if self.t.kSwitchMore:TryOn() and self.Timer:CD("More", 0.5) then
		if not self.t.tList then
			self.t.tList = {}
			self.t.iPage = 0
		end
		local tList = self.t.tList
		self.t.iNow = #tList
		if self.t.iList and self.t.iList <= self.t.iNow then
			return
		end
		
		self.t.iPage = self.t.iPage + 1
		
		CC.SendWeb("promotion/proList.htm", {page = self.t.iPage, pageSize = self.NE_PER_PAGE}, "UIInviteGiftList", "CallBackNext")
	end
end

function UIInviteGiftList:CallBackNext(tVal)
	if tVal.success then
		local tData = tVal.data.result
		self.t.iList = tData.totalItems				
		for i,v in _G.ipairs(tData.result) do
			self.t.tList[self.t.iNow + i] = {Name = v.quNickname, Time = v.CREATE_TIME, Gift = v.invite_status ~= "true", ID = v.id}
		end
		self.t.kSwitchMore:TryOff()
		CC.Print("UIInviteGiftList:More Page="..self.t.iPage)
		self:Refresh()
	else
		CC.Message{Text = tVal.message}
	end
end

function UIInviteGiftList:Refresh()
	local tInfo = CC.PlayerMgr.Invite.List.tData
	C("txPlayer"):Text(self.t.kTextPlayer..tInfo.iPlayer)
	C("txGot"):Text(self.t.kTextGot..tInfo.iGot)
	C("txCan"):Text(self.t.kTextCan..tInfo.iCan)
	local kC = C("rScroll")
	if self.t.tList then
		kC:Show()
		local iMax = _G.math.max(1, #self.t.tList)
		CC.Node:Array{Node = C("rRecord1"):Node(), Y = iMax, Keep = true}
		for i=1,iMax do
			local tData = self.t.tList[i]
			local kR = kC:C("rRecord"..i)
			if tData then
				kR:Show()
				kR:C("txPlayer"):Text(tData.Name)
				kR:C("txTime"):Text(tData.Time)
				kR:C("btItem"):Visible(tData.Gift):Param(tData):Click("OnClickGift")
				kR:C("txItem"):Visible(not tData.Gift)
			else
				kR:Hide()
			end
		end
		kC:Scroll():Fix{Keep = true}
	else
		kC:Hide()
	end
end

function UIInviteGiftList:OnScrollBottom()
	self:More()
end

function UIInviteGiftList:OnClickGift(kNode)
	if self.t.tData == nil then
		local tData = self.t.tList[C(kNode:getParent()):Index()]
		self.t.tData = tData
		CC.SendWeb("promotion/beInvitedLong.htm", {id = tData.ID}, "UIInviteGiftList", "CallBackInvite")
	end
end

function UIInviteGiftList:CallBackInvite(tVal)
	if tVal.success then
		self.t.tData.Gift = false
		self:Refresh()
		CC.UIMgr:Load(self.UIInviteGift2)
		CC.UIMgr:Call("UIInviteGift2", {GiftID = self.NE_GIFT_OUT})
		CC.PlayerMgr.Invite.List:Sync()
	else
		CC.Message{Text = tVal.message}
	end
	self.t.tData = nil
end
-----------------------------------------------------------------------------------
UIInviteMessage = CC.UI:Create{
	Path = "koko/ui/lobby/invite_message.csb", 
	Key = "UIInviteMessage",
}
function UIInviteMessage:Load()
	C("btOK"):Click("OnClickOK")
	C("btCancel"):Click("OnClickCancel")
end
function UIInviteMessage:Public()
	self.UIInvite = UIInvite
end
function UIInviteMessage:OnClickOK()
	LC_Data.bInviteMessage = false
	CC.UIMgr:Load(self.UIInvite)
	CC.UIMgr:Unload(self)
end
function UIInviteMessage:OnClickCancel()
	CC.UIMgr:Unload(self)
end
