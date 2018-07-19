
local vb = require("packages.mvc.ViewBase");

local ViewCommon = class("ViewCommon", vb)
--由于每个游戏的设计分变率可能是不一样的，但GLVIEW的大小已经确定不会改
--而这些公共模块的VIEW的设定分辨率是固定的，所以需要重新缩放大小
function ViewCommon:ctor()
	ViewCommon.super.ctor(self);
	local scalex = 1.0
	local scaley = 1.0
	if device.orientation == device.landscape then
		scalex = g_CurrentGame().designSize.width / 1334;
		scaley = g_CurrentGame().designSize.height / 750;
	else
		scalex =  g_CurrentGame().designSize.width / 750;
		scaley = g_CurrentGame().designSize.height / 1334;
	end
	
	self:setScaleX(scalex);
	self:setScaleY(scaley);
end

return ViewCommon;