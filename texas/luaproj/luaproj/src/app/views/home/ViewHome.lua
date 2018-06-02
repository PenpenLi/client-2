local CMD = require("app.net.CMD")
local UIHelper = require("app.common.UIHelper")
local ViewHome = class("ViewHome", cc.mvc.ViewBase)

function ViewHome:ctor()
	ViewHome.super.ctor(self)
	local csbnode = cc.CSLoader:createNode("cocostudio/home/HomeLayer.csb")
	csbnode:addTo(self)

	self.UIContainer = UIHelper.seekNodeByName(csbnode, "UIConatainer");
	local ve = APP:createView("home.ViewEntry", APP.hc, self.UIContainer);
	self.UIContainer:addChild(ve)
	
	local btn_Head = UIHelper.seekNodeByName(csbnode, "Button_Head")
	btn_Head:addTouchEventListener(function(ref, t)
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
				APP.hc:showShop()
			end
		end
	end)

	local btn_Shop = UIHelper.seekNodeByName(csbnode, "Button_Shop")
	btn_Shop:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			if APP.hc.showShop then
				APP.hc:showShop()
			end
		end
	end)

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
            -- print("sssssssss")
            if APP.hc.showMail then
          
               -- APP.hc:showMail()
                --  APP.hc:showSignLayer()
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

  --[[  local btn_Rank = UIHelper.seekNodeByName(csbnode,"Button_")
    btn_Rank:addTouchEventListener(function (ref, t)
        if t == ccui.TouchEventType.ended then 
            if APP.hc.showRank then
                APP.hc:showRank()
                end
           end
    end)]]--

    

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
end

function ViewHome:onEnter()
    ViewHome.super.onEnter(self)
end

function ViewHome:onExit()
    ViewHome.super.onExit(self)
end

function ViewHome:updateUserInfo()
	local gameUser = APP.GD.GameUser
    self.textGold:setString(tonumber(gameUser.gold_game))
    self.textNickname:setString(gameUser.uname)
end

return ViewHome