-----------------------------------------------------------------------------------
-- 游戏重连  2018.2
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
module "koko.ui.game.UIReconnectGame"
-----------------------------------------------------------------------------------
UIReconnectGame = CC.UI:Create{
	Path = "koko/ui/game/reconnect_game.csb",
	Key = "UIReconnectGame",
	Root = true,
	Play = {Loop = true},
	Animation = false,
}
function UIReconnectGame:Load()
	self.Timer:Add("Reconnect", P.ReconnectInfo[1], P.ReconnectInfo[2], CC.Debug and CC.Math:Random(5) - 1 or 0.0)
	self.Timer:Add("End", P.ReconnectInfo[1] * P.ReconnectInfo[2])
end

function UIReconnectGame:Update()
	if self.Timer:Check("Reconnect") then
		if CC.Game then
			CC.Print("重连游戏服务器")
			CC.Game:TryLogin{ kCallBack = CC.UIFunction("UIReconnectGame", "ReconnectCallBack")}
		end
	end
	if self.Timer:Check("End") then
		CC.Message("游戏断线", function()
            CC.GameMgr.Scene:Set("Lobby")
        end)
	end
end

function UIReconnectGame:ReconnectCallBack(bLoginOK)
	if bLoginOK then
		CC.UIMgr:Unload(self)
		CC.Event("GameReconnect")
	end
end
