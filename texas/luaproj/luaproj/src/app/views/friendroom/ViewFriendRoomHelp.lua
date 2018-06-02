--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIHelper = require("app.common.UIHelper")
local ViewFriendRoomHelp = class("ViewFriendRoomHelp", cc.mvc.ViewBase)

function ViewFriendRoomHelp:ctor()
	ViewFriendRoomHelp.super.ctor(self)
	local csbnode = cc.CSLoader:createNode("cocostudio/home/PrivateRoomHelper.csb")
	csbnode:addTo(self);

end
return ViewFriendRoomHelp;
--endregion
