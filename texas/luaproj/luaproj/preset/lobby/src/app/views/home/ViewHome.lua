local CMD = require("app.net.CMD")
local UIHelper = require("app.common.UIHelper")
local ViewHome = class("ViewHome", cc.mvc.ViewBase)
local GameConfig = require("app.common.GameConfig")

function ViewHome:ctor()
	ViewHome.super.ctor(self)

	addListener(self, "NET_MSG", handler(self, self.onMsg));

	local csbnode = cc.CSLoader:createNode("cocostudio/home/HomeLayer.csb")
	csbnode:addTo(self)

	self.UIContainer = UIHelper.seekNodeByName(csbnode, "UIConatainer");
	local ve = APP:createView("home.ViewEntry", APP.hc, self.UIContainer);
	self.UIContainer:addChild(ve)
	
	local Image_Head = UIHelper.seekNodeByName(csbnode, "Image_Head")
	self.Image_Head = Image_Head
	Image_Head:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			if APP.hc.showPersonal then
				APP.hc:showPersonal()
			end
		end
	end)

	local btn_AddGold = UIHelper.seekNodeByName(csbnode, "Button_AddCoin")
	btn_AddGold:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			if APP.hc.showShop then
				APP.hc:showShop(false, self.UIContainer)
			end
		end
	end)

	local btn_Shop = UIHelper.seekNodeByName(csbnode, "Button_Shop")
	btn_Shop:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			if APP.hc.showShop then
				APP.hc:showShop(false, self.UIContainer)
			end
		end
	end)

	local Button_Shop_Animation = UIHelper.seekNodeByName(csbnode, "Button_Shop_Animation")
	UIHelper.newAnimation(47, Button_Shop_Animation,
	 function (i) return string.format("sc__%05d.png", i - 1) end);

	local btn_Service = UIHelper.seekNodeByName(csbnode, "Button_Service")
	btn_Service:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			if APP.hc.showSevice then
				APP.hc:showSevice()
			end
		end
	end)

    local btn_Mail = UIHelper.seekNodeByName(csbnode,"Button_Mail")
    btn_Mail:addTouchEventListener(function (ref, t)
        if t == ccui.TouchEventType.ended then 
            if APP.hc.showMail then
                APP.hc:showMail()
            end
        end
    end)

    local btn_DailyTasks = UIHelper.seekNodeByName(csbnode,"Button_DailyTasks")
    btn_DailyTasks:addTouchEventListener(function (ref, t)
        if t == ccui.TouchEventType.ended then 
            if APP.hc.showDailyTasks then
                APP.hc:showDailyTasks()
                end
           end
    end)

	self.textGold = UIHelper.seekNodeByName(csbnode, "Text_Coin")
	self.textNickname = UIHelper.seekNodeByName(csbnode, "Text_Nickname")

	self:updateUserInfo()

	local moreView = UIHelper.seekNodeByName(csbnode, "Node_More")

	local btn_Exit = UIHelper.seekNodeByName(csbnode, "Button_Exit")
	btn_Exit:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP:ActiveCtrl("LoginController")
		end
	end)

	local btn_Setting = UIHelper.seekNodeByName(csbnode, "Button_Setting")
	btn_Setting:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			if APP.hc.showSetting then
				APP.hc:showSetting()
			end
		end
	end)

	local bg = UIHelper.seekNodeByName(csbnode, "bg0");
	
	local skeleton = sp.SkeletonAnimation:createWithJsonFile("effect/girl/renwu.json", "effect/girl/renwu.atlas", 1)
    skeleton:setAnimation(0, "idle", true)
    bg:addChild(skeleton)
end

function ViewHome:onEnter()
    ViewHome.super.onEnter(self)
end

function ViewHome:onExit()
    ViewHome.super.onExit(self)
end

function ViewHome:updateUserInfo()
	local gameUser = APP.GD.GameUser
    self.Image_Head:loadTexture(string.format("image/%s",GameConfig:HeadIco(gameUser.head_pic)))
    self.textGold:setString(tonumber(gameUser.gold_game))
    self.textNickname:setString(gameUser.uname)
end

function ViewHome:onMsg(fromServer, subCmd, content)
    if fromServer ~= GameConfig.ID_COORDINATESERVER  then 
        return 
    end
	if subCmd == CMD.GAME_USERINFO_SET_RESP then
        APP.GD.GameUser.head_pic = content.head_ico_
        APP.GD.GameUser.uname = content.nickname_
        self:updateUserInfo()
	end

end

return ViewHome