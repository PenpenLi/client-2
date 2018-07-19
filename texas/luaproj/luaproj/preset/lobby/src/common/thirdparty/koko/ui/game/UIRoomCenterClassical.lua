-----------------------------------------------------------------------------------
-- 房间中心  2018.1
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
local UILobby = require "koko.ui.lobby.UILobby".UILobby

module "koko.ui.game.UIRoomCenterClassical"
UIRoomCenterClassical = CC.UI:Create{
    Path = "koko/ui/game/room_center_classical.csb", 
    Key = "UIRoomCenterClassical", 
    Animation = false,
}
function UIRoomCenterClassical:Load()
	C("btHelp"):Visible(CC.Game):Click("OnClickHelp")
	CC.UIMgr:Unload("UILobby")
	self.Timer:Add("Lobby", 0.01)
	for i=1,C("rScroll"):ChildrenCount() do
		C("rRoom"..i):Click("OnClickGame")
	end
	C("btStart"):Click("OnClickStart")
end

function UIRoomCenterClassical:Refresh()
	local kCenter = CC.GameMgr.RoomCenter
	for i=1,C("rScroll"):ChildrenCount() do
		local kC = C("rRoom"..i)
		if i <= kCenter:Count() then
			kC:Show()
			local kData = kCenter:At(i)
			kC:C("txScore"):Text(kData.iScore)
			local kMax = kData.iCostMax == 0 and "无限制" or CC.String:NumFix(kData.iCostMax)
			kC:C("txRange"):Text(CC.String:NumFix(kData.iCostMin).."-"..kMax)
		else
			kC:Hide()
		end
	end
end

function UIRoomCenterClassical:Update()
	if self.Timer:Check("Lobby") then
		CC.UIMgr:Load(UILobby)
		CC.UIMgr:Call("UILobby", {Partner = "UIRoomCenterClassical", setFunctionVisible = false})
	end
end

function UIRoomCenterClassical:OnClickGame(kNode)
	if self.Timer:CD("Click", 1.0) then
		local iIndex = C(kNode):Index()
		if self.Timer:CD("Join"..iIndex, 3) then
			local kCenter = CC.GameMgr.RoomCenter
			kCenter:At(iIndex):Join()
		end
	end
end
function UIRoomCenterClassical:OnClickHelp(kNode)
	if CC.Game then
		CC.Game:Call{Load = "MJUIHelp"}
	end
end
function UIRoomCenterClassical:OnClickStart(kNode)
	local kCenter = CC.GameMgr.RoomCenter
	local kRoom = nil
	local iIndex = 1
	for i = 1,kCenter:Count() do
		kRoom = kCenter:At(i)
		if kRoom:Check(CC.Player.gold) then
			break
		end
	end
	if kRoom and self.Timer:CD("Join"..iIndex, 3) then
		kRoom:Join()
	end
end
