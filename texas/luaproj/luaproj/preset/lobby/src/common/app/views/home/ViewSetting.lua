local GameConfig = require("app.common.GameConfig")
local UIHelper = require("app.common.UIHelper")
local LeftBaseLayer = require("app.views.common.LeftBaseLayer")
local SoundUtils = require("app.common.SoundUtils")

local ViewSetting = class("ViewSetting", LeftBaseLayer)

ViewSetting.IMG_SWITCH_OPEN = "cocostudio/home/image/setting/shezhi_yinyuekai.png"
ViewSetting.IMG_SWITCH_CLOSE = "cocostudio/home/image/setting/shezhi_yinyueguan.png"

ViewSetting.POSX_OPEN = -55
ViewSetting.POSX_CLOSE = -228

function ViewSetting:ctor()
	ViewSetting.super.ctor(self)

	local csbnode = cc.CSLoader:createNode("cocostudio/home/SettingLayer.csb")
	csbnode:addTo(self)

	local btn_ChangeAccount = UIHelper.seekNodeByName(csbnode, "Button_ChangeAccount")
	btn_ChangeAccount:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
            --APP:enterScene("LoginScene")
		end
	end)

	local btn_Rule = UIHelper.seekNodeByName(csbnode, "Button_Rule")
	btn_Rule:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			printLog("a","clicked rule button!")
		end
	end)

	local text_Version = UIHelper.seekNodeByName(csbnode, "Text_Version")
	text_Version:setString(GameConfig.Version)


    self.CheckBox_list = {
             CheckBox_music = csbnode:getChildByName("CheckBox_music"),
             CheckBox_effect = csbnode:getChildByName("CheckBox_effect"),
             CheckBox_Vibrate = csbnode:getChildByName("CheckBox_Vibrate")
    }

    for k, v in pairs(self.CheckBox_list) do 
        v : addTouchEventListener(touchHandler(handler(self,self.checkBoxEvent)))
    end

	self:initStatus()
end

function ViewSetting:checkBoxEvent(sender,eventType)
    if sender == self.CheckBox_list.CheckBox_effect then 
        self:soundStatusChange(not APP.GD:soundOn(), true)
    elseif sender == self.CheckBox_list.CheckBox_music then 
        self:musicStatusChange(not APP.GD:musicOn(), true)
    elseif sender == self.CheckBox_list.CheckBox_Vibrate then 
        self:vibrateStatusChange(not APP.GD:vibrateOn(), true)
    end
end


function ViewSetting:onEnter()
    ViewSetting.super.onEnter(self)
end

function ViewSetting:onExit()
    ViewSetting.super.onExit(self)
end

function ViewSetting:initStatus()
	self:musicStatusChange(APP.GD:musicOn())
	self:soundStatusChange(APP.GD:soundOn())
	self:vibrateStatusChange(APP.GD:vibrateOn())
end

function ViewSetting:musicStatusChange(on, click)
    if APP.GD:musicOn() ~= on then 
		APP.GD.music_on = on;
        local UserDefault = cc.UserDefault:getInstance()
        UserDefault:setBoolForKey(GameConfig.KEY_MUSIC,on)
        UserDefault:flush()
		if not on then
			SoundUtils.stopMusic();
		else
			SoundUtils.playMusic();
		end
    end

	if not click then
		self.CheckBox_list.CheckBox_music:setSelected(on)
	end
end

function ViewSetting:soundStatusChange(on, click)
    if APP.GD:soundOn() ~= on then 
		APP.GD.sound_on = on;
        local UserDefault = cc.UserDefault:getInstance()
        UserDefault:setBoolForKey(GameConfig.KEY_SOUND,on)
        UserDefault:flush()
    end
	if not click then
		self.CheckBox_list.CheckBox_effect:setSelected(on)
	end
end

function ViewSetting:vibrateStatusChange(on, click)
    if APP.GD:vibrateOn() ~= on then 
		APP.GD.vibrate_on = on;
        local UserDefault = cc.UserDefault:getInstance()
        UserDefault:setBoolForKey(GameConfig.KEY_VIBRATE,on)
        UserDefault:flush()
    end
	if not click then
		self.CheckBox_list.CheckBox_Vibrate:setSelected(on)
	end
end

return ViewSetting