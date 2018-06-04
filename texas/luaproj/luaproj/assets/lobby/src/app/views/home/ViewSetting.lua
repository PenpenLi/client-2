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
            --APP:enterScene("LoginScene")
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


    self.CheckBox_list = {
             CheckBox_music = csbnode:getChildByName("CheckBox_music"),
             CheckBox_effect = csbnode:getChildByName("CheckBox_effect"),
             CheckBox_Vibrate = csbnode:getChildByName("CheckBox_Vibrate")
    }

    for k, v in pairs(self.CheckBox_list) do 
        v : addEventListener(handler(self,self.checkBoxEvent))
    end
    


	self:initStatus()
end

function ViewSetting:checkBoxEvent(sender,eventType)
    if sender == self.CheckBox_list.CheckBox_effect then 
        self:soundStatusChange(not APP.GD:soundOn())
    elseif sender == self.CheckBox_list.CheckBox_music then 
        self:musicStatusChange(not APP.GD:musicOn())
    elseif sender == self.CheckBox_list.CheckBox_Vibrate then 
        self:vibrateStatusChange(not APP.GD:vibrateOn())
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

function ViewSetting:musicStatusChange(on)
    if APP.GD:musicOn() ~= on then 
        local UserDefault = cc.UserDefault:getInstance()
        UserDefault:setBoolForKey(GameConfig.KEY_MUSIC,on)
        UserDefault:flush()
    end
    self.CheckBox_list.CheckBox_music:setSelected(on)
end

function ViewSetting:soundStatusChange(on)
    if APP.GD:soundOn() ~= on then 
        local UserDefault = cc.UserDefault:getInstance()
        UserDefault:setBoolForKey(GameConfig.KEY_SOUND,on)
        UserDefault:flush()
    end
    self.CheckBox_list.CheckBox_effect:setSelected(on)
end

function ViewSetting:vibrateStatusChange(on)
    if APP.GD:vibrateOn() ~= on then 
        local UserDefault = cc.UserDefault:getInstance()
        UserDefault:setBoolForKey(GameConfig.KEY_VIBRATE,on)
        UserDefault:flush()
    end
    self.CheckBox_list.CheckBox_Vibrate:setSelected(on)
end

return ViewSetting