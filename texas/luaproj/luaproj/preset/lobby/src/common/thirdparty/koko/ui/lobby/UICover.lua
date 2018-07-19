-----------------------------------------------------------------------------------
-- 礼物  2017.11
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
module "koko.ui.lobby.UICover"
-----------------------------------------------------------------------------------
UICover = CC.UI:Create{
	Path = "koko/ui/lobby/cover.csb",
	Key = "UICover",
	Animation = false,
}
function UICover:Load()
	C(""):Node():setZOrder(1000)
end

Cover = {tData = {}}
function Cover:On(kKey)
	_G.assert(_G.type(kKey) == "string")
	self.tData[kKey] = true
	self:__Refresh()
end

function Cover:Off(kKey)
	_G.assert(_G.type(kKey) == "string")
	if kKey == "All" then
		self.tData = {}
	else
		self.tData[kKey] = nil
	end
	self:__Refresh()
end

function Cover:__Refresh()
	local bOK = false
	for k,v in _G.pairs(self.tData) do
		bOK = true
		break
	end
	if bOK then
		if CC.UIMgr:Get("UICover") == nil then
			CC.UIMgr:Load(UICover)
		end
	else
		CC.UIMgr:Unload(UICover)
	end
end