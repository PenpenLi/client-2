-----------------------------------------------------------------------------------
-- 背包  2017.9
-- By Chris
-----------------------------------------------------------------------------------
local CC = require "comm.CC"
module "koko.ui.lobby.UIItem"
-----------------------------------------------------------------------------------
UIItemTips = CC.UI:Create{
	Path = "koko/ui/lobby/item_tips.csb", 
	Key = "UIItemTips",
	Animation = false,
	Log = false,
}
function UIItemTips:Load()

end

function UIItemTips:Refresh()
	if self.t.iItem then
		C(""):Show()
		local kExcel = CC.Excel.Item[self.t.iItem]
		if kExcel then
			C("iItem"):Image(kExcel.Icon)
			C("txName"):Text(kExcel.Name)
			C("txTip"):Text(kExcel.Tip)
			C("txInfo"):Text("")
		end
	else
		C(""):Hide()
	end
end

function UIItemTips:Update()
	if self.t.kPartner then
		if not CC.UIMgr:Get(self.t.kPartner) then
			CC.UIMgr:Unload(self)
		end
	end
end
function UIItemTips:Call(tVal)
	if tVal.SetItem then
		self.t.iItem = tVal.iID
		self:Refresh()
	end
	if tVal.Node then
		CC.Nine:Create{Node = tVal.Node}:Attach(7, C(""):Nine(), 1)
	end
	if tVal.UI then
		self.t.kPartner = tVal.UI
	end
end