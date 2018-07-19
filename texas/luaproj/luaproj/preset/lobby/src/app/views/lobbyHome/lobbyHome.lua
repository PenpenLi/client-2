local slideItem = require("app.common.slideItem")
local UIHelper = require("app.common.UIHelper")
local LayoutItems = require("app.common.LayoutItems")
local lobbyHome = class("lobbyHome", cc.mvc.ViewBase)
local GameConfig = require("app.common.GameConfig")
local CMD = require ("app.net.CMD")
local GameList = require("app.models.GameList")

function lobbyHome:ctor()
	self.super.ctor(self)
		
	self.csbnode = cc.CSLoader:createNode("home/lobby_home.csb"):addTo(self);
	self.UIContainer = self.csbnode;

	self.topbar = UIHelper.seekNodeByName(self.csbnode, "topbar");
	self.rightbar = UIHelper.seekNodeByName(self.csbnode, "rightbar");
	self.game_cat = UIHelper.seekNodeByName(self.csbnode, "game_cat");
	self.game_item = UIHelper.seekNodeByName(self.csbnode, "game_item");
	self.item_topbar = UIHelper.seekNodeByName(self.csbnode, "item_topbar");

	self.btnRecomm = UIHelper.seekNodeByName(self.game_cat, "btnRecomm");
	self.btnRecomm:addTouchEventListener(touchHandler(handler(self, self.switchToGameItem)));

	self.btnChess = UIHelper.seekNodeByName(self.game_cat, "btnChess");
	self.btnChess:addTouchEventListener(touchHandler(handler(self, self.switchToGameItem)));

	self.btnBackCat = UIHelper.seekNodeByName(self.item_topbar, "btnBackCat");
	self.btnBackCat:addTouchEventListener(touchHandler(handler(self, self.switchToGameCat)));

	self.sldCat = {};
	self.sldItems = {};

	local slidei = slideItem.new(self.topbar, slideItem.orientation_top);
	table.insert(self.sldCat, slidei);

	slidei = slideItem.new(self.rightbar, slideItem.orientation_right);
	table.insert(self.sldCat, slidei);

	slidei = slideItem.new(self.game_cat, slideItem.orientation_left);
	table.insert(self.sldCat, slidei);

	slidei = slideItem.new(self.game_item, slideItem.orientation_left);
	table.insert(self.sldItems, slidei);

	slidei = slideItem.new(self.item_topbar, slideItem.orientation_top);
	table.insert(self.sldItems, slidei);
			
	self:easeInGameCat();

	--params.strict
	--params.hspace
	--params.vspace
	--params.growth
	local scrollView =  UIHelper.seekNodeByName(self.game_item, "ScrollView_1");
	self.gameItemLayout = LayoutItems.new(scrollView);
	local params = {strict = scrollView:getContentSize(), growth = LayoutItems.growthHorizontal}
	self.gameItemLayout:setParams(params)

	self:updateUserInfo();

	self.msgEvt = addListener(self, "NET_MSG", handler(self, self.onMsg));
	
	local Image_Head = UIHelper.seekNodeByName(self.csbnode, "Image_Head")
	self.Image_Head = Image_Head
	Image_Head:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			if APP:getCurrentController().showPersonal then
				APP:getCurrentController():showPersonal()
			end
		end
	end)

	local btn_AddGold = UIHelper.seekNodeByName(self.csbnode, "Button_AddCoin")
	btn_AddGold:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			if APP.hc.showShop then
				APP.hc:showShop(false, self.UIContainer)
			end
		end
	end)

	local btn_Shop = UIHelper.seekNodeByName(self.csbnode, "Button_Shop")
	btn_Shop:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			if APP:getCurrentController().showShop then
				APP:getCurrentController():showShop(false, self.UIContainer)
			end
		end
	end)

--local Button_Shop_Animation = UIHelper.seekNodeByName(csbnode, "Button_Shop_Animation")
--UIHelper.newAnimation(47, Button_Shop_Animation,
-- function (i) return string.format("sc__%05d.png", i - 1) end);

	local btn_Service = UIHelper.seekNodeByName(self.csbnode, "Button_Service")
	btn_Service:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			if APP:getCurrentController().showSevice then
				APP:getCurrentController():showSevice()
			end
		end
	end)

    local btn_Mail = UIHelper.seekNodeByName(self.csbnode,"Button_Mail")
    btn_Mail:addTouchEventListener(function (ref, t)
        if t == ccui.TouchEventType.ended then 
            if APP:getCurrentController().showMail then
                APP.getCurrentController():showMail()
            end
        end
    end)

--local btn_DailyTasks = UIHelper.seekNodeByName(csbnode,"Button_DailyTasks")
--btn_DailyTasks:addTouchEventListener(function (ref, t)
--    if t == ccui.TouchEventType.ended then 
--        if APP.hc.showDailyTasks then
--            APP.hc:showDailyTasks()
--            end
--       end
--end)

	self.textGold = UIHelper.seekNodeByName(self.csbnode, "Text_Coin")
	self.textNickname = UIHelper.seekNodeByName(self.csbnode, "Text_Nickname")

	self:updateUserInfo()

	local moreView = UIHelper.seekNodeByName(self.csbnode, "Node_More")

	local btn_Exit = UIHelper.seekNodeByName(self.csbnode, "Button_Exit")
	btn_Exit:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP:ActiveCtrl("LoginController")
		end
	end)

	local btn_Setting = UIHelper.seekNodeByName(self.csbnode, "Button_Setting")
	btn_Setting:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			if APP:getCurrentController().showSetting then
				APP:getCurrentController():showSetting()
			end
		end
	end)

	local btnBanker = UIHelper.seekNodeByName(self.csbnode, "btnBanker")
	btnBanker:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP:getCurrentController():showBanker(self)
		end
	end)

	self:filterGames("all");
end


function lobbyHome:addGameItem(game)
	local gamei = APP:createView("lobbyHome.gameIcon", game);
	self.gameItemLayout:addChild(gamei);
end

--[566] = {
--		gameid = 566,
--		name = "»¶ÀÖ²¶Óã",
--		icon = "images/game_icons/xuanze_huanlebuyu.png",
--		catalog = "²¶Óã",
--	},

function lobbyHome:filterGames(catalog)
	local Image_Catalog = UIHelper.seekNodeByName(self.csbnode, "Image_Catalog")
	if catalog == "chess" then
		Image_Catalog:loadTexture("images/game_icons/xuanze_qipaiyouxi.png", 1);
	elseif catalog == "street" then
		Image_Catalog:loadTexture("images/game_icons/xuanze_jiejiyouxi.png", 1);
	elseif catalog == "fishing" then
		Image_Catalog:loadTexture("images/game_icons/xuanze_quanmingbuyu.png", 1);
	elseif catalog == "multiplayer" then
		Image_Catalog:loadTexture("images/game_icons/xuanze_duorenduizhan.png", 1);
	else
		Image_Catalog:loadTexture("images/game_icons/xuanze_jiejiyouxi.png", 1);
    end

	self.gameItemLayout:removeAllChildren();

    for _, gi in pairs(GameList) do
		if (gi.catalog == catalog  or catalog == "all") and gi.gameid >= 0 then
			self:addGameItem(gi);
		end
	end
	
	self.gameItemLayout:doLayout();
end


function lobbyHome:onEnter()
    lobbyHome.super.onEnter(self)
end

function lobbyHome:onExit()
    lobbyHome.super.onExit(self)
	removeListener(self.msgEvt);
end

function lobbyHome:updateUserInfo()
	local User = APP.GD.User
    self.Image_Head:loadTexture(string.format("image/%s",GameConfig:HeadIco(User.head_pic)))
    self.textGold:setString(tonumber(User.game_gold))
    self.textNickname:setString(User.uname)
end

function lobbyHome:onMsg(fromServer, subCmd, content)
    if fromServer ~= GameConfig.ID_COORDINATESERVER  then 
        return 
    end
	if subCmd == CMD.GAME_USERINFO_SET_RESP then
        APP.GD.User.head_pic = content.head_ico_
        APP.GD.User.uname = content.nickname_
        self:updateUserInfo()
	end
end

function lobbyHome:updateUserInfo()
	local txtNickName = UIHelper.seekNodeByName(self.csbnode, "Text_Nickname");
	txtNickName:setString(APP.GD.User.nickname);

	local txtGold = UIHelper.seekNodeByName(self.csbnode, "Text_Coin");
	txtGold:setString(APP.GD.User.game_gold);

end

function lobbyHome:switchToGameCat()
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(handler(self, self.easeOutGameItems)),
		cc.DelayTime:create(0.15),
		cc.CallFunc:create(handler(self, self.easeInGameCat))));
end

function lobbyHome:switchToGameItem()
	self:runAction(cc.Sequence:create(
			cc.CallFunc:create(handler(self, self.easeOutGameCat)),
			cc.DelayTime:create(0.15),
			cc.CallFunc:create(handler(self, self.easeInGameItems))));
end

function lobbyHome:easeInGameCat()
	for k, v in pairs(self.sldCat) do
		v:slideIn();
	end
end

function lobbyHome:easeOutGameCat()
	for k, v in pairs(self.sldCat) do
		v:slideOut();
	end
end

function lobbyHome:easeInGameItems()
	for k, v in pairs(self.sldItems) do
		v:slideIn();
	end
end

function lobbyHome:easeOutGameItems()
	for k, v in pairs(self.sldItems) do
		v:slideOut();
	end
end

return lobbyHome