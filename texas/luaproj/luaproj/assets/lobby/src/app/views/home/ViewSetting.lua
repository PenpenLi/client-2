local GameConfig = require("app.core.GameConfig")
local UIHelper = require("app.common.UIHelper")
local LeftBaseLayer = require("app.views.common.LeftBaseLayer")
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
			FSM.doEvent(FSM.E_LOGOUT)
		end
	end)

	local btn_Rule = UIHelper.seekNodeByName(csbnode, "Button_Rule")
	btn_Rule:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			print("clicked rule button!")
		end
	end)

	local text_Version = UIHelper.seekNodeByName(csbnode, "Text_Version")
	text_Version:setString(GameConfig.Version)

	self.musicBG = UIHelper.seekNodeByName(csbnode, "Image_MusicBG")
	self.musicBtn = UIHelper.seekNodeByName(csbnode, "Button_Music")
	self.soundBG = UIHelper.seekNodeByName(csbnode, "Image_SoundBG")
	self.soundBtn = UIHelper.seekNodeByName(csbnode, "Button_Sound")
	self.vibrateBG = UIHelper.seekNodeByName(csbnode, "Image_VibrateBG")
	self.vibrateBtn = UIHelper.seekNodeByName(csbnode, "Button_Vibrate")

	self.musicBtn:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			local newState = (not APP.GD:musicOn())
  			APP.GD.music_on = newState
			cc.UserDefault:getInstance():setBoolForKey(GameConfig.KEY_MUSIC, newState)
			self:musicStatusChange(newState)
		end
	end)
	self.soundBtn:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			local newState = (not APP.GD:soundOn())

  			APP.GD.sound_on = newState

			cc.UserDefault:getInstance():setBoolForKey(GameConfig.KEY_SOUND, newState)
			self:soundStatusChange(newState)
		end
	end)
	self.vibrateBtn:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			local newState = (not APP.GD:vibrateOn())

  			APP.GD.vibrate_on = newState
	
			cc.UserDefault:getInstance():setBoolForKey(GameConfig.KEY_VIBRATE, newState)
			self:vibrateStatusChange(newState)
		end
	end)

	self:initStatus()
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

function ViewSetting:musicStatusChange(on)
	if on then
		self.musicBG:loadTexture(ViewSetting.IMG_SWITCH_OPEN)
		self.musicBtn:setPositionX(ViewSetting.POSX_OPEN)
	else
	 	self.musicBG:loadTexture(ViewSetting.IMG_SWITCH_CLOSE)
	 	self.musicBtn:setPositionX(ViewSetting.POSX_CLOSE)
	end
end

function ViewSetting:soundStatusChange(on)
	if on then
		self.soundBG:loadTexture(ViewSetting.IMG_SWITCH_OPEN)
		self.soundBtn:setPositionX(ViewSetting.POSX_OPEN)
	else
	 	self.soundBG:loadTexture(ViewSetting.IMG_SWITCH_CLOSE)
	 	self.soundBtn:setPositionX(ViewSetting.POSX_CLOSE)
	end 
end

function ViewSetting:vibrateStatusChange(on)
	if on then
		self.vibrateBG:loadTexture(ViewSetting.IMG_SWITCH_OPEN)
		self.vibrateBtn:setPositionX(ViewSetting.POSX_OPEN)
	else
	 	self.vibrateBG:loadTexture(ViewSetting.IMG_SWITCH_CLOSE)
	 	self.vibrateBtn:setPositionX(ViewSetting.POSX_CLOSE)
	end 
end

return ViewSetting