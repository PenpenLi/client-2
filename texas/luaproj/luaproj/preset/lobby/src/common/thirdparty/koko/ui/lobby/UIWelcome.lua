-----------------------------------------------------------------------------------
-- 欢迎界面(注册奖励等)  2017.9
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
module "koko.ui.lobby.UIWelcome"
-----------------------------------------------------------------------------------
WelcomeManager = {tUI = {}, kKeyNow = nil}
function WelcomeManager:Load()
	self:Unload()
	CC.UIMgr:Set("WelcomeManager", self)
end
function WelcomeManager:TryLoad()
	if CC.UIMgr:Get(self.kKeyNow) then
		return
	end

	for k,v in _G.pairs(self.tUI) do
		CC.UIMgr:Load(v)
		self.kKeyNow = v.Key
		self.tUI[k] = nil
		break
	end
end
function WelcomeManager:Add(kUI)
	_G.table.insert(self.tUI, kUI)
end
function WelcomeManager:Unload()
	for k,v in _G.pairs(self.tUI) do
		CC.UIMgr:Unload(v)
	end
	self.tUI = {}
	CC.UIMgr:Set("WelcomeManager", nil)
end
-----------------------------------------------------------------------------------
UIWelcomeGift = CC.UI:Create{
	Path = "koko/ui/lobby/welcome_gift.csb", 
	Key = "UIWelcomeGift",

	NE_ITEM = 4,
}
function UIWelcomeGift:Public()
	self.UIWelcomeAccountUpgrade = UIWelcomeAccountUpgrade
end

function UIWelcomeGift:Load()
    self:RegClose("panel/btCancel")
    self:RegClick("panel/btOK", self.OnClickOK)

    if not CC.Player.tWelcome.bGift then
    	CC.UIMgr:Unload(self)
    end
end

function UIWelcomeGift:Unload()
	CC.UIMgr:Do("WelcomeManager", "TryLoad")
end

function UIWelcomeGift:Refresh()	
	local kExcel = CC.Excel.RewardForWelcomeGift
	for i=1, self.NE_ITEM do
		local kP = self:Child("panel/rItem"..i)
		local kNodeIcon = kP:findChild("iItem")
		local kNodeNum = kP:findChild("txNum")
		local bVisible = false
		if i <= kExcel:Count() then	
			local kData = kExcel:At(i)
			local kItemData = CC.Excel.Item[kData.ItemID]
			if kItemData then	
				bVisible = true
				kNodeIcon:loadTexture(kItemData.Icon, 1)
				kNodeNum:setString(CC.ToString(kData.Num))
			end
		end
		kNodeIcon:setVisible(bVisible)
		kNodeNum:setVisible(bVisible)
	end
	C("btOK"):Image(CC.Player:IsAccountNeedUpgrate() and "koko/atlas/all_common/button/an100.png" or "koko/atlas/all_common/button/an14.png")
end

function UIWelcomeGift:OnClickOK(kNode)
	if CC.Player:IsAccountNeedUpgrate() then
		CC.UIMgr:Load(self.UIWelcomeAccountUpgrade)
	else
		CC.SendWeb("receive/packs.htm", {uid = CC.Player.uid, appKey = CC.Player.appKey, type = "newly_wed"}, "UIWelcomeGift", "OnCallWeb")		
	end
end

function UIWelcomeGift:OnCallWeb(tVal)
	if tVal.success then
		local kExcel = CC.Excel.RewardForWelcomeGift
		for i=1,kExcel:Count() do
			local kData = kExcel:At(i)
			CC.Send(1038, {item_id_ = kData.ItemID}, "求刷物品")
		end
		CC.UIMgr:Unload(self)
	end
	CC.Message{Text = tVal.message}
end

-----------------------------------------------------------------------------------
UIWelcomeAccountUpgrade = CC.UI:Create{
	Path = "koko/ui/lobby/welcome_gift_reg.csb", 
	Key = "UIWelcomeAccountUpgrade",

	NE_ITEM = 4,
}
function UIWelcomeAccountUpgrade:Load()
	C("btClose"):Click("OnClickClose")
    self:RegClick("panel/btOK", self.OnClickOK)
    self.t.btPhoneCode = self:Child("panel/btPhoneCode")
    self:RegClick(self.t.btPhoneCode, self.OnClickPhoneCode)

    C("eAccount"):Component():SetCheck(function (kText)
    	return CC.Check:Account(kText)
    end)
    C("ePassword"):Component():SetCheck(function (kText)
    	return CC.Check:Password(kText)
    end)
    C("ePassword2"):Component():SetCheck(function (kText)
    	return CC.Check:Password(kText) and kText == C("ePassword"):Component():Text()
    end)
    C("ePhone"):Component():SetCheck(function (kText)
    	return CC.Check:Phone(kText)
    end)
    C("eCode"):Component():SetCheck(function (kText)
    	return kText ~= ""
    end)
end
function UIWelcomeAccountUpgrade:OnClickClose()	
	CC.UIMgr:Unload("UIInvite")
	CC.UIMgr:Unload(self)
end
function UIWelcomeAccountUpgrade:Refresh()	
    self.t.btPhoneCode:setEnabled(true)
    self.t.btPhoneCode:findChild("txNum"):hide()
end

function UIWelcomeAccountUpgrade:Update(fDelta)
	if self.Timer:Check("TimeRepeat") then
		self.t.btPhoneCode:findChild("txNum"):setString(self.t.TimeCount)
		self.t.TimeCount = self.t.TimeCount - 1
	end
	if self.Timer:Check("TimeEnd") then
		self:Refresh()
	end
end

function UIWelcomeAccountUpgrade:OnClickPhoneCode(kNode)
	if self:CheckBase() then
		local function LF_CallBack(t)
	        if not t.success then
	            CC.Message({Text = t.message})
	        end 
		end
		CC.Web.sendPhoneCodeReq(C("ePhone"):Component():Text(), LF_CallBack)
		CC.Message{Tip = "验证码已发送，60秒后方可再次获取"}
		self.t.btPhoneCode:setEnabled(false)
		self.Timer:Add("TimeRepeat", 1.0, 60, 0.0)
		self.Timer:Add("TimeEnd", 60.0)
		self.t.TimeCount = 60
    	self.t.btPhoneCode:findChild("txNum"):show()
	end
end

function UIWelcomeAccountUpgrade:CheckBase()
	return self.Component:Check{"eAccount","ePassword","ePassword2","ePhone"}
end

function UIWelcomeAccountUpgrade:OnClickOK(kNode)
	if self.Component:Check() then
		CC.SendWeb("login/register.htm", {uid = CC.Player.uid, uname = C("eAccount"):Component():Text(), mobile = C("ePhone"):Component():Text(), pwd = C("ePassword"):Component():Text(), 
			machine = _G.get_device_code(), clientId = "", code = C("eCode"):Component():Text(), bindProxy = ""}, "UIWelcomeAccountUpgrade", "OnCallWeb")		
	end
end
function UIWelcomeAccountUpgrade:OnCallWeb(tVal)
	CC.Message{Text = tVal.success and "恭喜你，账号升级成功！" or tVal.message}
	if tVal.success then
		CC.Player:setPlayerselfInfo(tVal.data.result)
		CC.Data.entryCache:setCurrentWithUpgradeAccount(C("eAccount"):Component():Text(), C("ePassword"):Component():Text())
		CC.UIMgr:Call("UIInvite", {RegOK = true})
		CC.UIMgr:Unload(self)
	end
end
-----------------------------------------------------------------------------------
UIWelcomeRegIDCard = CC.UI:Create{
	Path = "koko/ui/lobby/welcome_reg_id_card.csb", 
	Key = "UIWelcomeRegIDCard",
	
	NE_ITEM = 3,
}
function UIWelcomeRegIDCard:Load()
	self.t.kNodeClose = self:Child("panel/iBack/btClose")
	self.t.kNodeClose:hide()
    self:RegClose(self.t.kNodeClose)
    self:RegClick("panel/iBack/btOK", self.OnClickOK)
    self:RegClick("panel/iBack/rInfo/btRefresh", self.OnClickRefresh)
    C("eRealName"):Component():SetCheck(function (kText)
    	return CC.Check:RealName(kText)
    end)
    C("eIDCard"):Component():SetCheck(function (kText)
    	return CC.Check:IDCard(kText)
    end)
    C("eCode"):Component():SetCheck(function (kText)
    	return kText ~= ""
    end)
	if not CC.Player.tWelcome.bIDCard or CC.Player:IsAccountNeedUpgrate() then
		self.AnimScale = nil
    	CC.UIMgr:Unload(self)
    end
end

function UIWelcomeRegIDCard:Unload()
	CC.UIMgr:Do("WelcomeManager", "TryLoad")
end

function UIWelcomeRegIDCard:Refresh()
	local kExcel = CC.Excel.RewardForIDCard
	for i=1, self.NE_ITEM do
		local kP = self:Child("panel/iBack/rGift/rItem"..i)
		local kNodeIcon = kP:findChild("iItem")
		local kNodeNum = kP:findChild("txNum")
		local bVisible = false
		if i <= kExcel:Count() then	
			local kData = kExcel:At(i)
			local kItemData = CC.Excel.Item[kData.ItemID]
			if kItemData then	
				bVisible = true	
				kNodeIcon:loadTexture(kItemData.Icon, 1)
				kNodeNum:setString(CC.ToString(kData.Num))
			end
		end
		kNodeIcon:setVisible(bVisible)
		kNodeNum:setVisible(bVisible)
	end

	_G.require("web").bindCodeWithControl(self:Child("panel/iBack/rInfo/iCode"))
end

function UIWelcomeRegIDCard:OnClickOK(kNode)
	if C("eRealName"):Component():Text() == "" then
		self.t.kNodeClose:show()
	end
	if self.Component:Check() then
		CC.SendWeb("user/boundIdnumber.htm", {uid = CC.Player.uid, appKey = CC.Player.appKey, idnumber = C("eIDCard"):Component():Text(), 
			name = C("eRealName"):Component():Text(), code = C("eCode"):Component():Text()}, "UIWelcomeRegIDCard", "OnCallWeb")
	end
end

function UIWelcomeRegIDCard:OnCallWeb(tVal)
	if tVal.success then
		local kExcel = CC.Excel.RewardForIDCard
		for i=1,kExcel:Count() do
			local kData = kExcel:At(i)
			CC.Send(1038, {item_id_ = kData.ItemID}, "求刷物品")
		end
		CC.Player:Sync()
		CC.UIMgr:Unload(self)
	end
	CC.Message{Text = tVal.message}
end

function UIWelcomeRegIDCard:OnClickRefresh(kNode)
	self:Refresh()
end