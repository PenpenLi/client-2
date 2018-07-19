local CC = require("comm.CC")
require("fruit.public.functions")
require("fruit.public.view")
require("fruit.public.animations")

require("fruit.module.functions")
require("fruit.module.sound")
require("fruit.Platform")
require("fruit.VarDefine")
require("fruit.Config")
require("fruit.Trigger")
require("fruit.Proto")
require("fruit.Form")
require("fruit.SceneManager")
require("fruit.reconnect")
_G.kk = require("comm.kk")
_G.E = _G.kk.enum

local GameConfig = require("app.common.GameConfig");

local MyApp = class("MyApp", cc.mvc.MyAppBase)

function MyApp:ctor()
	MyApp.super.ctor(self)
	CC.Load();
    CC.CC = CC
	self.evt31123 = addListener(nil, "NET_MSG", handler(self, self.onMsg));

end

function MyApp:onMsg(fromServer, subCmd, content)
	if fromServer == GameConfig.ID_GAMESERVER then
		Trigger_FormAck(subCmd, content);
	end
end

function MyApp:dtor()
	local succ = removeListener(self.evt31123);

    --移除包含
    remove_require("fruit.module.functions")
    remove_require("fruit.module.sound")
    remove_require("fruit.Platform")
    remove_require("fruit.VarDefine")
    remove_require("fruit.Config")
    remove_require("fruit.Trigger")
    remove_require("fruit.Proto")
    remove_require("fruit.Form")
    remove_require("fruit.SceneManager")
    remove_require("fruit.reconnect")
    remove_require("fruit_main")

    --清空桥接处理
    require("net_bridge").setEventHandler(nil)

    --释放资源
    local frees = 
    {
        "anim_loading",
        "anim_ring",
        "anim_rotation1",
        "anim_rotation2",
        "anim_select",
        "anim_win_effect",
        "common",
        "countdown",
        "game",
        "loading",
        "login",
        "setting",
    }
    local texcache = cc.Director:getInstance():getTextureCache()
    for _,v in pairs(frees) do
        cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(string.format("fruit/Packages/%s.plist", v))
        texcache:removeTextureForKey(string.format("fruit/Packages/%s.png", v))
    end

	MyApp.super.dtor(self);
end

return MyApp


