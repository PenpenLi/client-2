-----------------------------------------------------------------------------------
-- 功能名字  2017.X
-- By 程序员名字
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
module "koko.ui.UISample"
-----------------------------------------------------------------------------------
UISample = CC.UI:Create{
	Path = "koko/ui/lobby/bag.csb", --换你的界面名
	Key = "UISample",--和类名一样
}
function UISample:Load()
	--加载，一般用于注册点击消息，创建控件
	--[[
	self:RegClose("panel/XXX")
	self:RegClick("panel/XXX", self.OnClickOK)
	self:RegClick(self:findChild("panel/XXX"), self.OnClickOK) --和上一句等价

	local kNode = self:findChild("panel/XXX")
	kNode:setVisible(false)]]
end

function UISample:Refresh()	
	--刷新，换图片，换文字，隐藏显示控件等。加载后会自动调用。在数据变更后手动调用。
end
--[[
function UISample:Unload()
	--卸载 可省略
end
function UISample:Update(fDelta)
	--每帧更新 可省略 如调用self.Timer计时器
end
]]




--[[
-----------------------------------------------------------------------------------
其他说明

--外部要打开此界面
local UISample = require("koko.ui.UISample").UISample
CC.UIMgr:Load(UISample)

--外部要关闭此界面
CC.UIMgr:Unload(UISample)

--外部要调用此界面函数(无需require，无需判空)
CC.UIMgr:Do("UISample", "Refresh")
]]