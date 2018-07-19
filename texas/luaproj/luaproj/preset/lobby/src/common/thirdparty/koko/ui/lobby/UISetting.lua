-----------------------------------------------------------------------------------
-- 设置  2017.10
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
module "koko.ui.lobby.UISetting"
-----------------------------------------------------------------------------------
UISetting = CC.UI:Create{
	Path = "koko/ui/lobby/setting.csb",
	Key = "UISetting",

	NE_SETTING = 2,
}

function UISetting:Load()
	C("btClose"):Close()
	C("btOK"):Click("OnClickLogin")
	--C("btWeb"):Click("OnClickWeb")
	C("btCancel"):Click("OnClickExit")
	for i=1,self.NE_SETTING do
		C("aToggle"..i):Param(i):Scale(1):Click("OnClickSetting")
	end
	self.t.kTextVersion = C("txVersion"):Text()

	if CC.Version and CC.Version.Gov then
		C("btWeb"):Hide()
		C("iWeb"):Hide()
	end
end
function UISetting:Refresh(tVal)
	local tMusic = CC.PlayerMgr.Setting:Music()
	local kClickParam = tVal and tVal.ClickParam
	self:Switch("aToggle1", tMusic.Background, kClickParam == 1)
	self:Switch("aToggle2", tMusic.Effect, kClickParam == 2)
	C("txVersion"):Text(self.t.kTextVersion..CC.Config.version)
	C("txName"):Text(CC.Player.nickName)
	CC.PlayerMgr.IconBack:Image{Back = C("iPlayerIconBack"):Node(), Icon = C("iPlayerIcon"):Node()}	
	local bGov = CC.Version and CC.Version.Gov
	if self.t.bForGame or bGov then
		C("btOK"):Hide()
		C("btCancel"):Hide()
	end
end
function UISetting:OnClickSetting(kNode)
	local kParam = C(kNode):Param()
	local kSetting = CC.PlayerMgr.Setting
	if kParam == 1 then
		kSetting:Music{Background = not kSetting:Music().Background}
	elseif kParam == 2 then
		kSetting:Music{Effect = not kSetting:Music().Effect}
	end
	self:Refresh{ClickParam = kParam}
end
function UISetting:OnClickExit()
	CC.UIMgr:Do("UILobby", "OnClickClose")
end
function UISetting:OnClickLogin()
	local function LF_Temp(iOK, kText)
		if iOK == 1 and kText then
			CC.SendWeb("complex/qrCodelua.htm", {qrCode = kText})
		else
			CC.Message{Text = "扫码失败"}
			CC.Print("扫码失败"..(iOK or 0)..(kText or ""))
		end
	end
	_G.scan_qrcode(LF_Temp)
end
function UISetting:Switch(kNodeName, bOK, bAnim)
	local fTo = bOK and 1 or 0.5
	local fFrom = bAnim and fTo - 0.5 or fTo
	C(kNodeName):From(fFrom):To(fTo):Action()
end
function UISetting:OnClickWeb()
	_G.callweb("http://www.koko.com")
end
function UISetting:Call(tVal)
	if tVal.ForGame then
		self.t.bForGame = true
		self:Refresh()
	end
end