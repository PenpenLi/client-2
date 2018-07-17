
local ctrl = createView("", "fruit/UILogic/Setting/Setting.csb", createScaleAnimation())
local CC = require("comm.CC")
function ctrl:show(nick_name)
    self.NickName = nick_name
    return self:create()
end

function ctrl:onInit(node)
    --初始化控件
    node:findChild("panel/btnClose"):onClick(function()
        self:destroy()
    end)
    node:findChild("panel/btnLogout"):onClick(function()
        self:onLogout()
    end)

    --设置玩家名字
    node:findChild("panel/panelHead/nickname"):setString(tostring(self.NickName))

    --switchbar
    self.sb1 = g_Require("fruit/module/switchbar")
    self.sb1:show("Setting/panel/panelMusic", self:getSoundMusic(), function(flag)
        self:onMusicSwitchChanged(flag)
    end)
    self.sb2 = g_Require("fruit/module/switchbar")
    self.sb2:show("Setting/panel/panelEffect", self:getSoundEffect(), function(flag)
        self:onEffectSwitchChanged(flag)
    end)
    CC.PlayerMgr.IconBack:Image({Icon = node:findChild("panel/panelHead/head"), Back = node:findChild("panel/panelHead/headbk")})
end

--------------------
--------------------
function ctrl:setMusicPlay(is_on)
    cc.SimpleAudioEngine:getInstance():setMusicVolume(is_on and 1 or 0)
end
function ctrl:setEffectPlay(is_on)
    cc.SimpleAudioEngine:getInstance():setEffectsVolume(is_on and 1 or 0)
    if not is_on then
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
    end
end

--------------------
--------------------
function ctrl:onLogout()
    msgup.show("该功能正在开发中，敬请期待！")
end
function ctrl:onMusicSwitchChanged(is_on)
    cclog("[设置] 音乐：%s", is_on and "开" or "关")
    self:setSoundMusic(is_on)
    self:setMusicPlay(is_on)
end
function ctrl:onEffectSwitchChanged(is_on)
    cclog("[设置] 音乐：%s", is_on and "开" or "关")
    self:setSoundEffect(is_on)
    self:setEffectPlay(is_on)
end

--------------------
--------------------
--获取、设置参数
function ctrl:getSoundMusic()
    return cc.UserDefault:getInstance():getBoolForKey("Music.Background", true)
end
function ctrl:setSoundMusic(is_open)
    cc.UserDefault:getInstance():setBoolForKey("Music.Background", is_open)
end
function ctrl:getSoundEffect()
    return cc.UserDefault:getInstance():getBoolForKey("Music.Effect", true)
end
function ctrl:setSoundEffect(is_open)
    cc.UserDefault:getInstance():setBoolForKey("Music.Effect", is_open)
end

return ctrl
