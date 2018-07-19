-----------------------------------------------------------------------------------
-- 转盘  2017.11
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
local UIGift = require ("koko.ui.lobby.UIGift").UIGift
module "koko.ui.lobby.UITurntable"
-----------------------------------------------------------------------------------
UITurntable = CC.UI:Create{
	Path = "koko/ui/lobby/turntable.csb",
	Key = "UITurntable",
}
function UITurntable:Public()
	self.UIGift = UIGift
end
function UITurntable:Prepare()
	C("rItem1"):Array{X = P.ItemCount}
	for i=1,P.ItemCount do
		C("iBack"..i):Nine():Attach(5, C("rItem"..i):Nine(), 5)
	end
	C("rPage1"):Nine():Attach(C("rPage2"):Nine())
	C("rItemShow1"):Array{X = P.Turn2[1], Adapt = true}
	C("rGift1"):Array{X = #(P.Gift), Adapt = true}
end
function UITurntable:Load()
	C("btClose"):Close()
	-- Item
	local kGift = CC.Excel.Gift.Key.Turntable:At(1).Items
	local tItem = CC.ItemMgr.Manager:CreateItems(kGift)
	for i=1,_G.math.min(P.ItemCount, #tItem) do
		C("rItem"..i):Component():Set(tItem[i])
	end
	self.t.tItem = tItem
	self.t.iShine = 1
	self.t.iRun = 0
	self.t.kTextLucky = C("txLucky"):Text()
	self.t.kTextGiftNum = C("rGift1"):C("txNum"):Text()
	self.Timer:Add("Time", 1.0, -1)
	self:Call{Sync = true}
	C("aBest"):Loop():Action()
	C("rItem1"):Nine():Attach(5,C("aShine"):Nine(),5)
end

function UITurntable:Refresh(tVal)
	local kData = CC.PlayerMgr.Turntable
	if tVal == nil then
		-- Button
		local bFree = CC.PlayerMgr.Turntable:RedPoint()
		C("btOK1"):Component():C():Visible(bFree)
		for i=1,P.OKCount do
			local kParam = i == 1 and bFree and P.TurnFree or P["Turn"..i]
			C("btOK"..i):Param(kParam):Click("OnClickOK"):C("txCount"):Text(kParam[1])
			C("rItemOK"..i):Component():Set(CC.ItemMgr.Item:Create(kParam[2]))
		end
		for i=1,P.OKCount do
			C("btOK"..i):Visible(not self.t.kStep or self.t.kStep:Is(0))
		end		
		-- Info
		local bShowItem = self.t.iRun >= 2 and self.t.tGiftGot and #(self.t.tGiftGot) > 0
		for i=1,P.OKCount do
			C("btOK"..i):Enabled(self.t.iRun == 0)
		end
		C("rPage1"):Visible(not bShowItem)
		C("rPage2"):Visible(bShowItem)
		C("iProgress"):Progress(kData.iLucky / P.LuckyMax)
		C("txLucky"):Text(self.t.kTextLucky..kData.iLucky)
		C("txGiftCount"):Text(kData.iCount)
		-- ShowItem
		if bShowItem then
			for i=1,P.Turn2[1] do
				C("rItemShow"..i):Component():Set(self.t.tGiftGot and self.t.tItem[self.t.tGiftGot[i]])
			end
		end
		-- Gift
		for i=1,#(P.Gift) do
			local kGift = P.Gift[i]
			local iID = kGift[2]
			local kGiftData = CC.PlayerMgr.Gift:Get(iID)
			C("rGift"..i):Gray(kGiftData:Status() ~= "OK"):Param(iID):Click("OnClickGift"):C("txNum"):Text(kGiftData:Status() == "End" and P.GiftEnd or kGift[1]..self.t.kTextGiftNum)
		end
	end

	if tVal == nil or tVal.Time then
		C("txTimeRefresh"):Text(CC.String:Time(kData.iTimeRefresh, "TimeToInterval"))
		if _G.math.abs(CC.PlayerMgr.Time:Get() - kData.iTimeRefresh) < 10 and self.Timer:CD("WeekBegin", 3.0) then
			self:Call{Sync = true}
		end
	end
end

function UITurntable:Update(fDelta)
	if self.Timer:Check("Time") then
		self:Refresh{Time = true}
	end

	local kStep, kMove = self.t.kStep, self.t.kMove
	if kMove and kStep then
		kMove:Update(fDelta)
		local iShine = _G.math.floor(kMove.S) % P.ItemCount + 1
		-- 加速
		if kStep:Is(1) then
			if kMove.V == kMove.V2 then
				self:Step(2)
			end
		-- 满速
		elseif kStep:Is(2) then
			if iShine == self.t.iShine2 and self.Timer:Check("Step2") then
				self:Step(3)
			end
		-- 减速
		elseif kStep:Is(3) then
			if kMove.V == kMove.V2 then
				self:Step(4)
			end
		-- 前往
		elseif kStep:Is(4) then
			if iShine == self:GiftIndex() and self.Timer:Check("Step4") then
				kMove:Stop()
				self:Step(5)
			end
		-- 领奖
		elseif kStep:Is(5) then
			if self.Timer:Check("Step5") then
				self:Step(6)
			end
		end
		if self.t.iShine and self.t.iShine ~= iShine then
			CC.Audio:Effect(P.AudioRun)
		end
		C("rItem"..iShine):Nine():Attach(5,C("aShine"):Nine(),5)
		self.t.iShine = iShine
	end
end

function UITurntable:Call(tVal)
	if tVal.Gift then
		self.t.tGift = tVal.Gift
		self.t.iGift = 1
		self.t.iRun = #tVal.Gift > 1 and 2 or 1
		self:Step(1)
	elseif tVal.Sync then
		CC.Send(1047, {}, "转盘同步数据")
	elseif tVal.Failed then
		CC.Cover:Off("UITurntable")
	end
end

function UITurntable:OnClickOK(kNode)
	local kParam = C(kNode):Param()
	local kItem = CC.ItemMgr.Item:Create(kParam[2])
	if CC.Sample.Check:Item(kItem, true) then
		CC.Cover:On("UITurntable")
		CC.Send(1046, {item_id_ = kItem.iID, times_ = kParam[1]}, "转盘开始")
	end
end

function UITurntable:OnClickGift(kNode)
	local iGiftID = C(kNode):Param()
	CC.UIMgr:Load(self.UIGift)
	CC.UIMgr:Call("UIGift", {Look = true, kKey = "Turntable", tItem = iGiftID})
end
----------------------------------------------------------------
function UITurntable:Step(i)
	if i == 1 then
		if self:GiftIndex() == nil then
			self.t.kStep = nil
			self.t.iRun = 0
			self:Refresh()
			CC.UIMgr:Load(self.UIGift)
			local tItem = {}
			for i,v in _G.ipairs(self.t.tGiftGot) do
				_G.table.insert(tItem, self.t.tItem[v])
			end
			CC.Cover:Off("UITurntable")
    		CC.UIMgr:Call("UIGift", {Open = true, kKey = "Turntable", tItem = tItem})
			return
		elseif self.t.iGift > 1 then
			self.t.kMove.V = ((self:GiftIndex() + 12 - self.t.iShine - 1 ) % 12 + 1) / P.TimeGiftInterval
			self.t.kMove.A = 0
			self.t.kMove.V2 = nil
			self.t.kStep:Jump(3)
			C("aShine"):From(0):To(0):Action()
			return self:Step(4)
		end
		self.t.kStep = CC.Step()
		self.t.kMove = self.t.kMove or CC.Physical:Move()
		self.t.tGiftGot = {}
		C("aShine"):From(0):To(0):Action()
	end
	local kStep, kMove = self.t.kStep, self.t.kMove
	if kStep and kMove and kStep:Try(i) then
		if i == 1 then			
			kMove.A = P.SpeedMax / P.TimeSpeedUp
			kMove.V2 = P.SpeedMax
		elseif i == 2 then
			self.Timer:Add("Step2", P.TimeSpeedMax)
			self.t.iShine2 = (self:GiftIndex() + P.ItemCount * 10 - _G.math.floor((P.SpeedGift + P.SpeedMax) / 2 * P.TimeSpeedDown) - 2) % 12 + 1
		elseif i == 3 then
			kMove.A = (P.SpeedGift - P.SpeedMax) / P.TimeSpeedDown
			kMove.V2 = P.SpeedGift
		elseif i == 4 then
			self.Timer:Add("Step4", 0.1)
		elseif i == 5 then
			self.Timer:Add("Step5", P.TimeGiftDelay)
			_G.table.insert(self.t.tGiftGot, self:GiftIndex())
			C("aShine"):Loop():Action()
			CC.Audio:Effect(P.AudioOK)
		elseif i == 6 then
			--奖品展示
			self.t.iGift = self.t.iGift + 1
			self:Step(1)
		end
	end
	
	self:Refresh()
end

function UITurntable:GiftIndex()
	return self.t.tGift and self.t.iGift and self.t.tGift[self.t.iGift]
end
