
local vb = require("packages.mvc.ViewBase");

local ViewCommon = class("ViewCommon", vb)
--����ÿ����Ϸ����Ʒֱ��ʿ����ǲ�һ���ģ���GLVIEW�Ĵ�С�Ѿ�ȷ�������
--����Щ����ģ���VIEW���趨�ֱ����ǹ̶��ģ�������Ҫ�������Ŵ�С
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