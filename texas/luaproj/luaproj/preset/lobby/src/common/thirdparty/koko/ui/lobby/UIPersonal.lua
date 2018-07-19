-----------------------------------------------------------------------------------
-- 个人信息  2017.9
-- By Chris
-----------------------------------------------------------------------------------
local CC = require "comm.CC"
module "koko.ui.lobby.UIPersonal"
-----------------------------------------------------------------------------------
local L_tUserData = {kSwitchFirst = CC.Switch()}
UIPersonalInfo = CC.UI:Create{
	Path = "koko/ui/lobby/personal_info.csb", 
	Key = "UIPersonalInfo",
	Animation = false,

	PE_ACHIEVEMENT = "koko/atlas/personal/iAchievement",
	PE_MALE = "koko/atlas/personal/iMale",
	PE_FEMALE = "koko/atlas/personal/iFemale",
	NE_MAX = 7,
}
function UIPersonalInfo:Public()
	self.UIPersonalInfoName = UIPersonalInfoName
	self.UIPersonalInfoIcon = UIPersonalInfoIcon
end
function UIPersonalInfo:Load()
	--Info
	local tVal = 
	{
		Name = self:Child("rInfo/txName"):getString(),
		ID = self:Child("rInfo/txID"):getString(),
		LoginTime = self:Child("rInfo/txLoginTime"):getString(),
		Location = self:Child("rInfo/txLocation"):getString(),		
	}
	self.t.tInfo = tVal
	self:RegOpen("rInfo/btChangeName", self.UIPersonalInfoName)
	self:RegOpen("rInfo/rIcon", self.UIPersonalInfoIcon)
	self:RegClick("rInfo/iMale", self.OnClickSex)
	self:RegClick("rInfo/iFemale", self.OnClickSex)
	self:RegClick("iMoney1/btAdd", self.OnClickBuy)
	self:RegClick("iMoney2/btAdd", self.OnClickBuy)
	self.t.iSex = CC.Player.gender + 1
	--Achievement
	local kScroll = CC.ScrollView:Create({Node = self:Child("rAchievement/rScroll")})
	--CC.Node:Array({Node = kScroll:Child("rItem1"), X = self.NE_MAX})
	kScroll:Fix()
	if L_tUserData.kSwitchFirst:TryOn() then
		CC.SendWeb("login/loginLogList.htm", {}, "UIPersonalInfo", "OnWeb")
	end
end

function UIPersonalInfo:OnWeb(tVal)
	if tVal.success then
		local tData = tVal.data.result
		CC.Player.kLocation = tData[1] and tData[1].project or ""
		CC.Player.kLastLocation = tData[2] and tData[2].project or ""
		CC.Player.kLastLoginTime = tData[2] and tData[2].time or ""
		self:Refresh()
	end
end

function UIPersonalInfo:Refresh()
	--Info
	local tInfo = self.t.tInfo
	self:Child("rInfo/txName"):setString(tInfo.Name..CC.Player.nickName)
	self:Child("rInfo/txID"):setString(tInfo.ID..CC.Player.iid)
	self:Child("rInfo/txLoginTime"):setString(tInfo.LoginTime..CC.Player.kLastLocation.." "..CC.Player.kLastLoginTime)
	self:Child("rInfo/txLocation"):setString(tInfo.Location..CC.Player.kLocation)
	self:Child("rInfo/iMale"):loadTexture(self.PE_MALE..((self.t.iSex == 1 and "") or "2")..".png", 1)
	self:Child("rInfo/iFemale"):loadTexture(self.PE_FEMALE..((self.t.iSex == 2 and "") or "2")..".png", 1)
	self:Child("rInfo/txLevel"):setString(CC.Player.level)
	CC.PlayerMgr.IconBack:Image{Back = self:Child("rInfo/rIcon/iIconBack"), Icon = self:Child("rInfo/rIcon/iIcon")}
	self:Child("rInfo/rIcon/txNum"):setString(CC.Player.vipLevel)
	local kProgress = self:Child("rInfo/rProgress/iProgress")
	local kVec = kProgress:getSizePercent()
	kVec.x = CC.Player.exp / CC.Math:Max(CC.Player.expMax, 1)
	kProgress:setSizePercent(kVec)
	--Money
	self:Child("iMoney1/txNum"):setString(CC.Player.gold)
	self:Child("iMoney2/txNum"):setString(CC.Player.diamond)
	self:Child("iMoney3/txNum"):setString(_G.math.floor(CC.Player.ticket / 100))
	--Achievement
	local tVal = CC.Player.tAchievement
	-- 金币 积分 时长 奖励 比赛 榜单 游戏
	local tKey = {tVal.iKB, tVal.iScore, tVal.iTime, tVal.iMatchWiner, tVal.iMatch, tVal.iRankTime, tVal.iGame}
	local tCount = {true, false, false, true, true, true, true}
	for i=1,self.NE_MAX do
		local kItem = self:Child("rAchievement/rScroll/rItem"..i)
		kItem:loadTexture(self.PE_ACHIEVEMENT..i..".png", 1)
		kItem:findChild("iBack"):show()
		local kInfo = kItem:findChild("txInfo")
		kInfo:show()
		kInfo:setString(tKey[i]..((tCount[i] and "次") or ""))
		kItem:findChild("btGet"):hide()
	end
end

function UIPersonalInfo:OnClickBuy(kNode)
	local iIndex = C(kNode:getParent()):Index()
	if iIndex == 1 then
		CC.Sample.Recharge:KB()
	elseif iIndex == 2 then
		CC.Sample.Recharge:Diamond()
	end
end

function UIPersonalInfo:OnClickSex(kNode)
	self.t.iSex = (kNode:getName() == "iMale" and 1) or 2
	self:Refresh()
	CC.SendWeb("user/setGender.htm", {gender = self.t.iSex - 1}, function (tVal)
		if tVal.success then
			CC.Player:Sync()
		end
		CC.Message{Text = tVal.message}
	end)
end
-----------------------------------------------------------------------------------
UIPersonalInfoIcon = CC.UI:Create{
	Path = "koko/ui/lobby/personal_info_icon.csb",
	Key = "UIPersonalInfoIcon",

	kIconPath = "koko/atlas/head_ico/",
	kBackPath = "koko/atlas/head_ico/iHeadBack",
	kBackPath2 = "koko/atlas/personal/iIconCardB",
	NE_ICON = 6, 
	NE_BACK = CC.Excel.PlayerIconBack:Count(),
}
function UIPersonalInfoIcon:Load()
	self:RegClose("panel/rMessageBox/btClose")
	self:RegClick("panel/btLeft", self.OnClickChange)
	self:RegClick("panel/btRight", self.OnClickChange)
	self:RegClick("panel/btOK", self.OnClickOK)
	self:RegClick("panel/iIcon", self.OnClickIcon)
	self.t.kScroll = CC.ScrollView:Create({Node = self:Child("panel/rCardBack/rScroll")})
	CC.Node:Array({Node = self.t.kScroll:Child("rItem1"), X = self.NE_BACK})
	for i=1,self.NE_BACK do
		local kCard = self.t.kScroll:Child("rItem"..i)
		self:RegClick(kCard, self.OnClickBack)
		C(kCard):C("btBuy"):Click("OnClickBuy")
	end
	self.t.iIcon = CC.PlayerMgr.IconBack.iIcon
	self.t.iBack = CC.PlayerMgr.IconBack.iIconBack
	CC.Send(1041, {}, "获取头像框列表")
	CC.Send(1058, {}, "获取头像列表")
end

function UIPersonalInfoIcon:Refresh()	
	self:Child("panel/btPhoto"):hide()	
	self:Child("panel/btCamera"):hide()
	self:Child("panel/iIcon"):loadTexture(self.kIconPath..self.t.iIcon..".png", 1)
	self:Child("panel/txDay"):setString(CC.PlayerMgr.IconBack:HasById(self.t.iIcon).value)
	self:Child("panel/txDay"):getVirtualRenderer():setLineSpacing(0)
	self:Child("panel/iIconBack"):loadTexture(CC.Excel.PlayerIconBack[self.t.iBack].Icon, 1)
	local iFix = 1
	for i=1,self.NE_BACK do
		local kC = C(self.t.kScroll:Child("rItem"..iFix))
		local bHas = CC.PlayerMgr.IconBack:Has(i)
		local bUse = CC.PlayerMgr.IconBack.iIconBack == i
		local kExcel = CC.Excel.PlayerIconBack[i]
		if kExcel.Visible then
			iFix = iFix + 1
			kC:Show()
			kC:C("iIcon"):Image(kExcel.Icon)
			kC:C("iBack"):Image(self.kBackPath2..(bHas and "" or "2")..".png")
			local kCHas, kCKB, kCDiamond, kBuy, kSign = kC:C("txInfo"), kC:C("iKB"), kC:C("iDiamond"), kC:C("btBuy"), kC:C("sign")	
			-- kCHas:Hide()
			kCHas:Show():Text("不可用")
			kBuy:Hide()
			kCKB:Hide()
			kCDiamond:Hide()
			kSign:Visible(bUse and bHas)
			local tParam = {iID = i}
			if bHas then
				--kCHas:Show():Text(bUse and "可用" or "不可用")
				kCHas:Show():Text("可用")
				tParam.bHas = true
			elseif CC.Player.vipLevel < kExcel.VIP then
				kCHas:Show():Text("需要VIP"..kExcel.VIP)
				tParam.bVIP = true
			elseif kExcel.Price then
				kBuy:Show()
				local iKB, iDiamond = kExcel.Price.KB, kExcel.Price.Diamond

				--------------------------------
				-- local tShopList = CC.PlayerMgr.Shop.ShopList[kExcel.ShopID]
				-- if tShopList then

				-- end
                -- local p = _G.string.split(local tShopList.price, ",")
                -- self.price = tonumber(p[3])
                -- self.buytype = tonumber(p[2])
                --------------------------------

				if iKB then
					kCKB:Show():C("txPrice"):Fix():Text(iKB)
					tParam.iKB = iKB
				end
				if iDiamond then
					kCDiamond:Show():C("txPrice"):Fix():Text(iDiamond)
					tParam.iDiamond = iDiamond
				end
			end
			kC:Param(tParam)
		end
	end
	for i = iFix, self.NE_BACK do
		C(self.t.kScroll:Child("rItem"..i)):Hide()
	end
	self.t.kScroll:Fix{Keep = true}
end
function UIPersonalInfoIcon:OnClickIcon(kNode)
	if CC.PlayerMgr.IconBack:HasById(self.t.iIcon).value == "不可用" then
		_G.kk.msgbox.showOkCancel("您尚未获得这个头像的使用权", function(is_ok)
			if is_ok then
				_G.kk.uimgr.load("koko.ui.lobby.ui_shop")		
			end
		end, 0, "PersonalHeadIcon")
	end
end
function UIPersonalInfoIcon:OnClickChange(kNode)
	self.t.iIcon = self.t.iIcon + ((kNode:getName() == "btLeft" and -1) or 1)
	self.t.iIcon = (self.t.iIcon) % P.HeadIconCount
	self:Refresh()
end

function UIPersonalInfoIcon:OnClickOK(kNode)
	if CC.PlayerMgr.IconBack:HasById(self.t.iIcon).value == "不可用" then
		_G.kk.msgbox.showOk("当前头像不可用，请使用其他头像")
		return
	end
	CC.Send(1042, {head_ico_ = self.t.iIcon, headframe_id_= self.t.iBack}, "设置头像和框")
	CC.UIMgr:Unload(self)
end

function UIPersonalInfoIcon:OnClickBuy(kNode)
	local tParam = C(kNode:getParent()):Get():Param()
	local bOK = false
	if tParam.iKB then
		bOK = CC.Sample.Check:KB(tParam.iKB, true)
	elseif tParam.iDiamond then
		bOK = CC.Sample.Check:Diamond(tParam.iDiamond, true)
	end
	if bOK then
		local shoplist = CC.PlayerMgr.Shop.ShopList[CC.Excel.PlayerIconBack[tParam.iID].Price.ShopID]
		if shoplist then
			_G.kk.uimgr.load("koko.ui.lobby.ui_shop_gift", "", CC.Excel.PlayerIconBack[tParam.iID].Price.ShopID)
		else
            _G.kk.msgup.show("商城配置错误")
		end
	end
end

function UIPersonalInfoIcon:OnClickBack(kNode)
	local tParam = C(kNode):Get():Param()
	if tParam.bHas then
		self.t.iBack = tParam.iID
		self:Refresh()
	elseif tParam.bVIP then
		CC.Message{Tip = "VIP等级不足"}
	else
		CC.Message{Tip = "您还没有获得这个头像框"}
	end
end
-----------------------------------------------------------------------------------
UIPersonalInfoName = CC.UI:Create{
	Path = "koko/ui/lobby/personal_info_name.csb",
	Key = "UIPersonalInfoName",

	TipEnum = {First = 1, Later = 2},
	NumEnum = {Pay = 100}
}
function UIPersonalInfoName:Load()
	self:RegClose("panel/rMessageBox/btClose")
	self:RegClick("panel/btOK", self.OnClickOK)
	self:RegCheck("panel/kCheck1", self.OnCheckSex)
	self:RegCheck("panel/kCheck2", self.OnCheckSex)
	self.t.kEdit = CC.Sample.Edit:Create({Node = self:Child("panel/rEdit/rPanel"), Any = true, Info = "请输入昵称", Size = 18, Color = CC.Color.Gray, TipColor = CC.Color.Gray})
	self.t.iSex = CC.Player.gender + 1
	self.t.tFirstTip = CC.String:Split(self:Child("panel/txFirst"):getString(), "#") 
	CC.SendWeb("user/userModify.htm", {type = "nickname"}, "UIPersonalInfoName", "OnCallWeb")
end

function UIPersonalInfoName:OnCallWeb(tVal)
	if tVal.success then
		self.t.bFree = tVal.data.status == 0
		self:Refresh()
	end
end

function UIPersonalInfoName:Refresh()
	for i=1,2 do
		self:Child("panel/kCheck"..i):setSelected(self.t.iSex == i)
	end
	self:Child("panel/txFirst"):setString(self.t.bFree == nil and "" or self.t.tFirstTip[self.t.bFree and self.TipEnum.First or self.TipEnum.Later])
	C("btOK"):Enabled(self.t.bFree ~= nil)
end

function UIPersonalInfoName:OnClickOK(kNode)
	if not CC.Check:Name(self.t.kEdit:Text()) then
		CC.Message({Text = "格式错误，"..CC.Check.Tip.Name})
	elseif self.t.bFree or CC.Sample.Check:Diamond(self.NumEnum.Pay, true) then
		CC.SendWeb("user/setNicknameLua.htm", {nickname = self.t.kEdit:Text(), gender = self.t.iSex - 1}, function (tVal)
			if tVal.success then
				CC.Player:Sync()
			end
			CC.Message{Text = tVal.message}
		end)
		CC.UIMgr:Unload(self)
	end
end

function UIPersonalInfoName:OnCheckSex(kNode)
	local kP, iI = CC.Node:GetNamePair(kNode)
	self.t.iSex = iI
	self:Refresh()
end
