-----------------------------------------------------------------------------------
-- 重连  2017.10
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
module "koko.ui.login.UIReconnect"
-----------------------------------------------------------------------------------
UIReconnect = CC.UI:Create{
	Path = "koko/ui/login/reconnect.csb",
	Key = "UIReconnect",
	Root = true,
	Play = {Loop = true},
	Animation = false,

	MaxReconnectTime = 20,
}
function UIReconnect:Load()
	_G.kk.event.addListener(self.kNode, _G.E.EVENTS.coordinate_reconnect_end, _G.handler(self, self.OnReconnectEnd))
	self.kNode:delayOnce(self.MaxReconnectTime, function()
		CC.Data.ReconnectMgr.stopReconnect()
	end)
end

function UIReconnect:OnReconnectEnd(state)
	CC.UIMgr:Unload(self)
	CC.Event("Reconnect", {OK = state == 1})
end

