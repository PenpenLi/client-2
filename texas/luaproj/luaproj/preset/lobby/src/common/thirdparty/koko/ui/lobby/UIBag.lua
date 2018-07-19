-----------------------------------------------------------------------------------
-- 背包  2017.9
-- By Chris
-----------------------------------------------------------------------------------
local CC = require "comm.CC"
local ItemMgr = require("koko.data.ItemMgr")
module "koko.ui.lobby.UIBag"
-----------------------------------------------------------------------------------
UIBag = CC.UI:Create{
	Path = "koko/ui/lobby/bag.csb", 
	Key = "UIBag", 

	kBackPath = "koko/atlas/all_common/title/kuang1.png", 
	kBackPath2 = "koko/atlas/all_common/title/kuang_selet.png",
	iItemMax = 9999,
	NumEnum = {X = 4, Y = 4, N = 16},
}
function UIBag:Public()
	self.UIBagUse = UIBagUse
	self.UIBagGift = UIBagGift
	self.UIBagGiftList = UIBagGiftList
end
function UIBag:Load()	
    self:RegClose("panel/iBack/iClose")
    self:RegOpen("panel/iInfo/rTip/btUse", self.UIBagUse)
    self:RegOpen("panel/iInfo/rTip/btGift", self.UIBagGift)
    self:RegOpen("panel/iBack/btGiftList", self.UIBagGiftList)
    ItemMgr.Manager:Call({RedPoint = false})
    local kScroll = CC.ScrollView:Create{Node = self:Child("panel/iItems/rScroll")}
    CC.Node:Array{Node = kScroll.kNode:findChild("rItem1"), X = self.NumEnum.X, Y = self.NumEnum.Y}
    kScroll:Fix()
    for i=1,self.NumEnum.N do
    	local rItem = kScroll.kNode:findChild("rItem"..i)
    	self:RegClick(rItem, self.OnClickItem)
    end
    self.Timer:Add("Check", 1, -1)
end

function UIBag:Update()
	if self.Timer:Check("Check") then
		local akItem = ItemMgr.Manager:Vector()
		local bRefresh = false
		for i,v in _G.ipairs(akItem) do
			local kItem = v.Value
			if kItem.kTimeLeft then
				if kItem.kTimeLeft:getLeftTime() <= 0 then
					ItemMgr.Manager:Del(kItem.iID)
					bRefresh = true
				end
			end
		end
		if bRefresh then
			CC.Event("RefreshItem")
		end
		self:Refresh({Tip = true})
	end
end

function UIBag:Refresh(tVal)
	if self.t.tSelect then
		local kItem = ItemMgr.Manager.tItem[self.t.tSelect.Item.iID]
		if kItem then
			self.t.tSelect.Item = kItem
		else
			self.t.tSelect = nil
		end
	end
    local akItem = ItemMgr.Manager:Vector()
    local tSelect = self.t.tSelect
	--Item
	if tVal == nil then
	    local kScroll = self:Child("panel/iItems/rScroll")
	    for i=1,self.NumEnum.N do
	    	local rItem = kScroll:findChild("rItem"..i)
	    	local kNodeItem = rItem:findChild("iItem")
	    	local kNodeNum = rItem:findChild("txNum")   	
	    	if i <= #akItem then
	    		local kItem = akItem[i].Value
	    		kNodeItem:loadTexture(kItem:Excel().Icon, 1)
	    		kNodeItem:show()
		    	kNodeNum:setString((kItem.iNum == 1 and "") or ""..kItem.iNum)
	    		C(rItem):Param{Item = kItem} 
	    		--Auto select
	    		if tSelect == nil then
	    			tSelect = {Node = rItem, Item = kItem}
	    		end
	    		rItem:setTouchEnabled(true)
	    	else
	    		kNodeItem:hide()
	    		kNodeNum:hide()
	    		rItem:setTouchEnabled(false)
	    	end
	    	local bSelected = tSelect and tSelect.Node == rItem
	    	rItem:loadTexture((bSelected and self.kBackPath2) or self.kBackPath, 1)
	    end
	end
    --Tips
    if tVal == nil or tVal.Tip then
	    local kInfo = self:Child("panel/iInfo")
	    local kEmpty = kInfo:findChild("rEmpty")
	    local kTip = kInfo:findChild("rTip")
	    if tSelect then
	    	kEmpty:hide()
	    	kTip:show()
	    	local kExcel = tSelect.Item:Excel()
	    	kTip:findChild("txName"):setString(kExcel.Name)
	    	local kText = kExcel.Tip
	    	if tSelect.Item.kTimeLeft then
	    		kText = "剩余时间："..CC.String:Time(tSelect.Item.kTimeLeft:getLeftTime(), "Interval").."\n"..kText
	    	end
	    	kTip:findChild("txTip"):setString(kText)
	    	kTip:findChild("iItem"):loadTexture(kExcel.Icon, 1)
	    	kTip:findChild("btUse"):setVisible(kExcel.CanUse)
	    	C(kTip):C("btGift"):Visible(kExcel.CanTrade)
	    else
	    	kEmpty:show()
	    	kTip:hide()
	    end
	end

    self.t.tSelect = tSelect
end

function UIBag:OnClickItem(kNode)
	local kItem = C(kNode):Get():Param().Item
	self.t.tSelect = {Node = kNode, Item = kItem}
	self:Refresh()
end

function UIBag:Call(tVal)
	if tVal.GetSelect then
		return self.t.tSelect
	end
end
-----------------------------------------------------------------------------------
UIBagUse = CC.UI:Create{
	Path = "koko/ui/lobby/bag_use.csb", 
	Key = "UIBagUse",
}
function UIBagUse:Load()
    self:RegClose("panel/rMessageBox/iClose")
    self:RegClick("panel/rMessageBox/iOK", self.OnClickOK)
    self:RegClick("panel/rMessageBox/rEditMax/iMax", self.OnClickMax)
    self.t.kEdit = CC.Sample.Edit:Create({Node = self:Child("panel/rMessageBox/rEditMax/rPanel")})	
    self:RegEdit(self.t.kEdit.kNode, self.OnEditNum)	
    self.t.iNum = 1
end

function UIBagUse:Refresh(tVal)
	local tSelect = CC.UIMgr:Call("UIBag", {GetSelect = true})
	if tSelect then
		local kExcel = tSelect.Item:Excel()
		self:Child("panel/rMessageBox/txName"):setString(kExcel.Name)
		self:Child("panel/rMessageBox/iItem"):loadTexture(kExcel.Icon, 1)
		local iNumOld = self.t.iNum
		self.t.iNum = CC.Math:Clamp(self.t.iNum, 1, CC.Math:Min(P.ItemMax, tSelect.Item.iNum))
		if tVal and tVal.NumMessage and iNumOld ~= self.t.iNum then
			CC.Message{Text = "您输入的数量超过限制或不足，已为您修正为"..self.t.iNum}
		end
		self.t.kEdit:Text(self.t.iNum)
	end
end

function UIBagUse:OnEditNum(kNode)
	self.t.iNum = CC.ToNumber(self.t.kEdit:Text())
	self:Refresh({NumMessage = true})
end

function UIBagUse:OnClickOK(kNode)
	local tSelect = CC.UIMgr:Call("UIBag", {GetSelect = true})
	if tSelect then
		CC.Send(1031, {present_id_ = tSelect.Item.iID, count_ = self.t.iNum}, "使用物品")
	end
	CC.UIMgr:Unload(self)
end

function UIBagUse:OnClickMax(kNode)
	local tSelect = CC.UIMgr:Call("UIBag", {GetSelect = true})
	if tSelect then
		self.t.iNum = tSelect.Item.iNum
		self:Refresh()
	end
end
-----------------------------------------------------------------------------------
UIBagGiftList = CC.UI:Create{
	Path = "koko/ui/lobby/bag_gift_list.csb", 
	Key = "UIBagGiftList",
	kPicMenuDown = "koko/atlas/all_common/title/0002.png",
	kPicMenuUp = "koko/atlas/all_common/title/0001.png",

	NE_PAGE = 2,
	NE_PER_PACK = 20,

	PE_GET = 1,
	PE_SEND = 2,
}

function UIBagGiftList:Load()
    C("iClose"):Close()
    -- Page
	self.t.iPage = 1
    for i = 1, self.NE_PAGE do
    	C("iMenu"..i):Click("OnClickPage"):C("txInfo"):LineSpacing(2)
    end
	self.t.kScroll = C("rScroll"):Scroll()

	local function LF_Data()
		local kClass = {iPage = 0, tData = {}, iMax = nil}
		function kClass:Count()
			return #self.tData
		end
		function kClass:At(i)
			return self.tData[i]
		end
		function kClass:NeedMore()
			return self.iMax == nil or self:Count() < self.iMax
		end
		return kClass
	end
	self.t.tData = {LF_Data(), LF_Data()}

	self.t.kSwitchMore = CC.Switch()
	C("rScroll"):Event(_G.SCROLLVIEW_EVENT_SCROLL_TO_BOTTOM, "More")

	self:More()
end

function UIBagGiftList:More()	
	local iPage = self.t.iPage
	local kData = self.t.tData[iPage]
	if kData:NeedMore() then
		if self.t.kSwitchMore:TryOn() and self.Timer:CD("More", 0.5) then
			kData.iPage = kData.iPage + 1
			if iPage == self.PE_SEND then
				CC.SendWeb("UserPrize/itemHandselPage.htm", {page = kData.iPage, 
					pageSize = self.NE_PER_PACK}, "UIBagGiftList", "CallBackSend")
			elseif iPage == self.PE_GET then
				CC.SendWeb("UserPrize/itemHandselto.htm", {page = kData.iPage, 
					pageSize = self.NE_PER_PACK}, "UIBagGiftList", "CallBackGet")
			end
		end
	end
end
function UIBagGiftList:CallBackSend(tVal)
	self:__CallBack(tVal, self.PE_SEND)
end
function UIBagGiftList:CallBackGet(tVal)
	self:__CallBack(tVal, self.PE_GET)
end
function UIBagGiftList:__CallBack(tVal, iPage)
	if tVal.success then
		local tData = tVal.data.result
		local kDataList = self.t.tData[iPage]
		kDataList.iMax = tData.totalItems				
		for i,v in _G.ipairs(tData.result) do
			local kExcel = CC.Excel.Item[v.present_id]
			local kItemName = kExcel and kExcel.Name or "未知"..v.present_id
			_G.table.insert(kDataList.tData, {PlayerName = v.nickname, Time = v.create_time, ItemName = kItemName, Num = v.count})
		end

		self.t.kSwitchMore:TryOff()
		if self.t.iPage == iPage then
			self:Refresh{ScrollKeep = true}
		end
	else
		CC.Message{Text = tVal.message}
	end
end

function UIBagGiftList:Refresh(tVal)
	tVal = tVal or {}
	-- Page
	local iPage = self.t.iPage
	for i=1, self.NE_PAGE do
		C("iMenu"..i):Fix():Image((iPage == i and self.kPicMenuDown) or self.kPicMenuUp)
	end
	local kDataList = self.t.tData[self.t.iPage]
	local iMax = _G.math.max(self.t.tData[1]:Count(), 1)
	iMax = _G.math.max(self.t.tData[2]:Count(), iMax)
	C("rRecord1"):Array{Y = iMax, Keep = true}
	for i=1,iMax do
		local kC = C("rRecord"..i)
		local kData = kDataList:At(i)
		if kData then
			kC:C("txPlayer"):Text(kData.PlayerName)
			kC:C("txID"):Text(kData.ID)
			kC:C("txTime"):Text(kData.Time)
			kC:C("txItem"):Text(kData.ItemName)
			kC:C("txNum"):Text(kData.Num)
			kC:Show()
		else
			kC:Hide()
		end
	end
	self.t.kScroll:Fix{Keep = tVal.ScrollKeep}
end
function UIBagGiftList:OnClickPage(kNode)
	self.t.iPage = C(kNode):Index()
	self:More()
	self:Refresh()
end
-----------------------------------------------------------------------------------
UIBagGift = CC.UI:Create{
	Path = "koko/ui/lobby/bag_gift.csb", 
	Key = "UIBagGift",
}
function UIBagGift:Public()
	self.UIBagGiftConfirm = UIBagGiftConfirm
end
function UIBagGift:Load()
	self.t.tSetting = CC.ItemMgr.Manager.tGiftSetting
    C("iMax"):Click("OnClickMax")
    self:RegClose("panel/rMessageBox/iClose")
    self:RegClick("panel/rMessageBox/iOK", self.OnClickOK)
    self:RegClick("panel/rMessageBox/rEditEx/iMinus", self.OnClickMinus)
    self:RegClick("panel/rMessageBox/rEditEx/iAdd", self.OnClickAdd)
    self.t.kEditNum = CC.Sample.Edit:Create({Node = self:Child("panel/rMessageBox/rEditEx/rPanel")})	
    self:RegEdit(self.t.kEditNum.kNode, self.OnEditNum)
    self.t.kEditID = CC.Sample.Edit:Create({Node = self:Child("panel/rMessageBox/rEditID/rPanel")})	
    self.t.kEditPW = CC.Sample.Edit:Create({Node = self:Child("panel/rMessageBox/rEditPassword/rPanel"), Password = true})	
    if self.t.tSetting.kPassword then
    	self.t.kEditPW:Text(self.t.tSetting.kPassword)
    end
    self.t.iNum = 1	
end

function UIBagGift:Refresh(tVal)
	local tSelect = CC.UIMgr:Call("UIBag", {GetSelect = true})
	if tSelect then
		local kExcel = tSelect.Item:Excel()
		if tVal == nil then
			if not CC.Sample.Check:VIP(kExcel.CanTrade.VIP or 0, true) then
				CC.UIMgr:Unload(self)
				return
			elseif CC.Player.bankPsw == "" then
				CC.Message{Text = "请先到大厅里点人物头像设置保险柜密码"}
				CC.UIMgr:Unload(self)
				return
		    elseif tSelect.Item.iNum < kExcel.CanTrade.Min then
		        CC.Message{Text =  "“"..kExcel.Name.."”最少需要"..kExcel.CanTrade.Min.."个，才能赠送哦"}
				CC.UIMgr:Unload(self)
				return
			end
			self:Child("panel/rMessageBox/iItem"):loadTexture(kExcel.Icon, 1)
		end
		if tVal == nil or tVal.EditNum then
			local iNumOld = self.t.iNum
			self.t.iNum = CC.Math:Clamp(self.t.iNum, kExcel.CanTrade.Min or 1, CC.Math:Min(kExcel.CanTrade.Max or 300, tSelect.Item.iNum))
			if tVal and tVal.EditNum and iNumOld ~= self.t.iNum then
				CC.Message{Text = "您输入的数量超过限制或不足，已为您修正为"..self.t.iNum}
			end
			self.t.kEditNum:Text(self.t.iNum)
		end
	end
end

function UIBagGift:Update()
	if self.Timer:Check("CheckOK") then
		local tSelect = CC.UIMgr:Call("UIBag", {GetSelect = true})
		if tSelect then
			local kPlayer = CC.PlayerMgr.Manager:Get(tSelect.iGiftID)
			local kName = kPlayer:Name()
			if kName == "" then
				self.Timer:Del("CheckOK")
				CC.Message{Tip = "该玩家不存在"}				
			elseif kName ~= kPlayer:Default():Name() then
				self.Timer:Del("CheckOK")
				if kPlayer.iID == CC.Player.iid then
					CC.Message{Tip = "不能送给自己"}
				elseif tSelect.kGiftPW ~= CC.Player.bankPsw then
					CC.Message{Tip = "保险柜密码错误"}
				else

					CC.UIMgr:Load(self.UIBagGiftConfirm)
					CC.UIMgr:Unload(self)
				end
			end
		end
	end
end

function UIBagGift:OnClickOK(kNode)
	local tSelect = CC.UIMgr:Call("UIBag", {GetSelect = true})
	if tSelect then
		tSelect.iGiftNum = CC.ToNumber(self.t.kEditNum:Text())
		tSelect.iGiftID = CC.ToNumber(self.t.kEditID:Text())
		tSelect.kGiftPW = self.t.kEditPW:Text()
		self.t.tSetting.kPassword = tSelect.kGiftPW
	end
	self.Timer:Add("CheckOK", 0.5, -1, 0.0)
end
function UIBagGift:OnEditNum(kNode)
	self.t.iNum = CC.ToNumber(self.t.kEditNum:Text()) or 1
	self:Refresh{EditNum = true}
end
function UIBagGift:OnClickMinus(kNode)
	self.t.iNum = self.t.iNum - 1
	self:Refresh()
end
function UIBagGift:OnClickMax(kNode)
	local tSelect = CC.UIMgr:Call("UIBag", {GetSelect = true})
	if tSelect then
		local kExcel = tSelect.Item:Excel()
		self.t.iNum = kExcel.CanTrade.Max or 300
		self:Refresh()
	end
end
function UIBagGift:OnClickAdd(kNode)
	self.t.iNum = self.t.iNum + 1
	self:Refresh()
end
-----------------------------------------------------------------------------------
UIBagGiftConfirm = CC.UI:Create{
	Path = "koko/ui/lobby/bag_gift_confirm.csb", 
	Key = "UIBagGiftConfirm",
}
function UIBagGiftConfirm:Load()
    self:RegClose("panel/rMessageBox/iClose")
    self:RegClick("panel/rMessageBox/iOK", self.OnClickOK)
    self.t.kInfoFormat1 = self:Child("panel/rMessageBox/txInfo1"):getString()
    self.t.kInfoFormat2 = self:Child("panel/rMessageBox/txInfo2"):getString()
end

function UIBagGiftConfirm:Refresh()
	local tSelect = CC.UIMgr:Call("UIBag", {GetSelect = true})
	if tSelect then
		local kExcel = tSelect.Item:Excel()
		self:Child("panel/rMessageBox/iItem"):loadTexture(kExcel.Icon, 1)
		self:Child("panel/rMessageBox/txNum"):setString(tSelect.iGiftNum)
		self:Child("panel/rMessageBox/txInfo1"):setString(CC.String:Format(self.t.kInfoFormat1, tSelect.iGiftNum, kExcel.Name))
		self:Child("panel/rMessageBox/txInfo2"):setString(CC.String:Format(self.t.kInfoFormat2, CC.PlayerMgr.Manager:Get(tSelect.iGiftID):Name() .. "(" .. tSelect.iGiftID ..")"))
	end
end

function UIBagGiftConfirm:OnClickOK(kNode)
	local tSelect = CC.UIMgr:Call("UIBag", {GetSelect = true})
	if tSelect then
		CC.Send(1037, {present_id_ = tSelect.Item.iID, count_ = tSelect.iGiftNum, to_ = tSelect.iGiftID, bank_pwd_ = tSelect.kGiftPW }, "物品赠送")
	end
	CC.UIMgr:Unload(self)
end