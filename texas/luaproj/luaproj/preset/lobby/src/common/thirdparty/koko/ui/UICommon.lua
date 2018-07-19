-----------------------------------------------------------------------------------
-- 通用控件  2017.10
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
module "koko.ui.UICommon"
-----------------------------------------------------------------------------------
UISwitch = CC.UI:Create{
	Path = "koko/ui/common/switch.csb",
	Key = "UISwitch",
	Animation = false,
	Play = true,
}
function UISwitch:Load()
	
end

function UISwitch:Refresh()	
	
end
