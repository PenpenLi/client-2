-----------------------------------------------------------------------------------
-- 邮件  2017.10
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
module "koko.ui.lobby.UIMail"
-----------------------------------------------------------------------------------
UIMail = CC.UI:Create{
	Path = "koko/ui/lobby/mail.csb",
	Key = "UIMail",

	NE_PAGE = 2,
	kPicMenuDown = "koko/atlas/all_common/title/0002.png",
	kPicMenuUp = "koko/atlas/all_common/title/0001.png",
	Page = {"System", "Gift"}
}
function UIMail:Public()
	self.UIMailInfo = UIMailInfo
end
function UIMail:Load()
	C("btClose"):Close()
	C("iMenu1"):Click("OnClickPage"):C("txInfo"):LineSpacing(2)
	C("iMenu2"):Click("OnClickPage"):C("txInfo"):LineSpacing(2)
	C("rView1"):Nine():Attach(C("rView2"):Nine())
	C("btGet"):Click("OnClickGetAll"):Nine():Attach(C("btDelAll"):Click("OnClickDelAll"):Nine())
	self.t.iPage = 1
end

function UIMail:Refresh(tVal)
	tVal = tVal or {}
	local iPage = self.t.iPage
	local kMgr = CC.PlayerMgr.Mail
	local atData = kMgr:GetMails(self.Page[iPage])
	local iCount = #atData
	local tRedPoint = {}
	local atMail = kMgr:GetMails()
	for i,v in _G.ipairs(atMail) do
		if v:RedPoint() then
			tRedPoint[v.eType] = true
		end
	end
	for i=1,self.NE_PAGE do
		local kMenu = C("iMenu"..i)
		kMenu:Node():ignoreContentAdaptWithSize(true)
		kMenu:Image(iPage == i and self.kPicMenuDown or self.kPicMenuUp):Component():C():Visible(tRedPoint[self.Page[i]] or false)
		kMenu:C("txInfo"):Node():setPositionX(kMenu:Node():getContentSize().width/2)
	end
	C("rView1"):Visible(iCount > 0)
	C("rView2"):Visible(iCount == 0)
	if iCount > 0 then
		C("rItem1"):Array{Y = iCount, Keep = true}
		local bAnyItem = false
		local bAnyClosed = false
		local iMax = C("rScroll"):ChildrenCount()
		for i = 1, iMax do
			local kC = C("rItem"..i)
			if i <= iCount then
				local kData = atData[i]
				kC:Show()
				kC:Param(kData):Click("OnClickMail")
				kC:C("iMail"):Image(kData:RedPoint() and "koko/atlas/mail/7.png" or "koko/atlas/mail/6.png"):C("iRedPoint"):Visible(kData:RedPoint())
				kC:C("txTitle"):Text(kData:Title())
				kC:C("txTime"):Text(kData:Time())
				if kData.bCanGetItem then
					bAnyItem = true
				end
				if not kData.bOpen then
					bAnyClosed = true
				end 
			else
				kC:Hide()
			end
		end
		C("rScroll"):Scroll():Fix{Keep = tVal.ScrollFix == nil and true or tVal.ScrollFix}
		C("btDelAll"):Param({AnyClosed = bAnyClosed}):Visible(not bAnyItem)
		C("btGet"):Visible(bAnyItem)
	end
end
function UIMail:OnClickPage(kNode)
	self.t.iPage = C(kNode):Index()
	self:Refresh({ScrollFix = false})
end
function UIMail:OnClickMail(kNode)
	local kParam = C(kNode):Param()
	CC.UIMgr:Load(self.UIMailInfo)
	CC.UIMgr:Call("UIMailInfo", {Open = true, ID = kParam.iID})
end
function UIMail:OnClickDelAll(kNode)
	local kParam = C(kNode):Param()
	if kParam.AnyClosed then
		CC.Message("邮件有未读")
	else
		CC.Message("邮件全删", function(bOK)
			if bOK then
				CC.Send(1051, {mail_type_ = self.t.iPage - 1}, "删除全部邮件")
			end
		end)
	end
end
function UIMail:OnClickGetAll(kNode)
	self:Call{AutoGet = 1}
end
function UIMail:Call(tVal)
	if tVal.AutoGet then
		local iStep = tVal.AutoGet
		local kStep = self.t.kStepAutoGet or CC.Step()
		self.t.kStepAutoGet = kStep
		if iStep == 1 and kStep:Try(1) then
			-- Try get
			local kMgr = CC.PlayerMgr.Mail
			local atData = kMgr:GetMails(self.Page[self.t.iPage])
			local bOK = false
			for i,v in _G.ipairs(atData) do
				local kData = atData[i]
				if kData.bCanGetItem then
					bOK = true
					CC.Send(1052, {id_ = kData.iID}, "邮件领取附件")
					break
				end
			end
			if not bOK then
				self.t.kStepAutoGet = nil
			end
		elseif iStep == 2 and kStep:Try(2) then
			self.t.kStepAutoGet = nil
			self:Call{AutoGet = 1}
		end
	end
end
-----------------------------------------------------------------------------------
UIMailInfo = CC.UI:Create{
	Path = "koko/ui/lobby/mail_info.csb",
	Key = "UIMailInfo",

	NE_ITEM = 6,
}

function UIMailInfo:Load()
	C("btClose"):Close()
	C("btGo"):Click("OnClickGo")
	C("btGet"):Click("OnClickGet"):Nine():Attach(C("btDel"):Click("OnClickDel"):Nine())
	self.t.iID = nil
	self.t.kTextTime = C("txTime"):Text()
	self.t.kTextTitle = C("txTitle"):Text()
end

function UIMailInfo:Refresh()
	local tData = CC.PlayerMgr.Mail:GetMail(self.t.iID)
	if tData and not self.t.bAutoItem then
		C(""):Show()
		C("txTitle"):Text(self.t.kTextTitle..tData:Title())
		C("txTime"):Text(self.t.kTextTime..CC.String:Time(tData.iTime))
		C("txInfo"):Text(tData.kInfo or "")
		C("btGo"):Param(tData.kLink or ""):Visible(tData.kLink and tData.kLink ~= "")
		C("btGet"):Visible(tData.bCanGetItem)
		C("btDel"):Visible(not tData.bCanGetItem)
		for i=1,self.NE_ITEM do
			local tItem = tData.tItem[i]
			local kItem = nil
			if tItem then
				kItem = CC.ItemMgr.Item:Create(tItem.iID)
				kItem.iNum = tItem.iNum
				C("rItem"..i):Component():Set(kItem)
			end
		end
	else
		C(""):Hide()
	end
end

function UIMailInfo:Call(tVal)
	if tVal.Open then
		if self.t.iID ~= tVal.ID then
			local tData = CC.PlayerMgr.Mail:GetMail(tVal.ID)
			if tData then
				self.t.iID = tVal.ID
				self.t.bAutoItem = tVal.AutoItem
				if not tData:HasInfo() then
					CC.Send(1049, {id_ = tVal.ID}, "获取邮件详情")
				end
				self:Refresh()
			end
		end
	end
end

function UIMailInfo:OnClickGo(kNode)
	local kLink = C(kNode):Param()
end

function UIMailInfo:OnClickDel(kNode)
	local tData = CC.PlayerMgr.Mail:GetMail(self.t.iID)	
	CC.Message("邮件删除", function(bOK)
		if bOK then
			CC.UIMgr:Unload(self)
			CC.Send(1050, {id_ = tData.iID}, "删除邮件")
		end
	end)	
end

function UIMailInfo:OnClickGet(kNode)
	local tData = CC.PlayerMgr.Mail:GetMail(self.t.iID)
	CC.UIMgr:Unload(self)	
	CC.Send(1052, {id_ = tData.iID}, "邮件领取附件")
end
