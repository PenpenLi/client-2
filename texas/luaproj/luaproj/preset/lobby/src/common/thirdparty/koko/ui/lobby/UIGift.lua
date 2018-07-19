-----------------------------------------------------------------------------------
-- 礼物  2017.11
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
module "koko.ui.lobby.UIGift"
-----------------------------------------------------------------------------------
UIGift = CC.UI:Create{
	Path = "koko/ui/lobby/gift.csb",
	Key = "UIGift",

	NE_ITEM = 6,
}
function UIGift:Load()
	C("btOK"):Click("OnClickOK"):Nine():Attach(C("btGet"):Click("OnClickGet"):Nine())
	C("rBack1"):Nine():Attach(C("rBack2"):Nine())
end

function UIGift:Unload()
	CC.Event("Gift", self.t.tData)
end
function UIGift:Refresh()
	if self.t.tData then
		C(""):Show()
		C("rBack1"):Visible(self.t.tData.Look)
		C("rBack2"):Visible(self.t.tData.Open)
		C("btGet"):Visible(self.t.bGet)
		C("btOK"):Visible(not self.t.bGet)
		local tItem = self.t.tData.tItem
		local iCount = #tItem
		for i=1,self.NE_ITEM do
			local kC = C("rItem"..i)
			if i <= iCount then
				kC:Show()
				C(iCount.."_"..(i - 1)):Nine():Attach(5, kC:Nine(), 5)
				kC:Component():Set(tItem[i])
			else
				kC:Hide()
			end
		end
	else
		C(""):Hide()
	end
end

function UIGift:Call(tVal)--{Look, Open, tItem}
	local kType = _G.type(tVal.tItem)
	self.t.bGet = false
	if kType == "string" then
		tVal.tItem = CC.ItemMgr.Manager:CreateItems(tVal.tItem)
	elseif kType == "number" then
    local iGift = tVal.tItem
		tVal.tItem = CC.ItemMgr.Manager:CreateItems(CC.Excel.Gift[iGift].Items)
		self.t.iGift = iGift
		self.t.bGet = CC.PlayerMgr.Gift:Get(iGift):Status() == "OK"
		tVal.Open = self.t.bGet
		tVal.Look = not self.t.bGet
	end
	self.t.tData = tVal
	self:Refresh()
end
function UIGift:OnClickOK()
	self.t.tData.Got = true
	CC.UIMgr:Unload(self)	
end
function UIGift:OnClickGet()
	CC.Send(1055, {present_id_ = self.t.iGift}, "礼包领取")
	CC.UIMgr:Unload(self)
end