local GameConfig = require("app.core.GameConfig")
local UIHelper = require("app.common.UIHelper")
local CMD = require("app.net.CMD")

local ViewShop = class("ViewShop", cc.mvc.ViewBase)

ViewShop.GOLD_GOODS = {
	{count = 6, fee = 60},
	{count = 18, fee = 180},
	{count = 68, fee = 680},
	{count = 128, fee = 1280},
	{count = 328, fee = 3280},
	{count = 618, fee = 6180},
}
ViewShop.DIAMOND_GOODS = {
	{count = 60, fee = 6},
	{count = 18, fee = 18},
	{count = 68, fee = 68},
	{count = 128, fee = 128},
	{count = 328, fee = 328},
	{count = 618, fee = 618},
}

function ViewShop:ctor(isShowDiamond)
	ViewShop.super.ctor(self)

	local csbnode = cc.CSLoader:createNode("cocostudio/home/ShopLayer.csb")
	csbnode:addTo(self)

	local btn_Close = UIHelper.seekNodeByName(csbnode, "Button_Back")
	btn_Close:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			self:removeSelf()
		end
	end)

--	self.btn_Gold = UIHelper.seekNodeByName(csbnode, "Button_Gold")
--	self.btn_Gold:addTouchEventListener(function(ref, t)
--		if t == ccui.TouchEventType.ended then
--			self:setBtnGoldEnable(false)
--			self:setBtnDiamondEnable(true)
--			self.goldNode:show()
--			self.diamondNode:hide()
--		end
--	end)

--	self.btn_Diamond = UIHelper.seekNodeByName(csbnode, "Button_Diamond")
--	self.btn_Diamond:addTouchEventListener(function(ref, t)
--		if t == ccui.TouchEventType.ended then
--			self:setBtnGoldEnable(true)
--			self:setBtnDiamondEnable(false)
--			self.goldNode:hide()
--			self.diamondNode:show()
--		end
--	end)
    
    for i = 1 ,6 do
        local item = csbnode:getChildByName(string.format("Button_Pay_%d",i))
        item:addTouchEventListener(handler(self,self.touchPayEvent))
        item:setTag(i)
    end
    

	-- 提现
	self.btn_Deposit = UIHelper.seekNodeByName(csbnode, "Button_Deposit")
	self.btn_Deposit:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			APP:getCurrentController():showBrowser({url = "http://www.baidu.com"})
		end
	end)

	self.goldNode = cc.Node:create()
		:addTo(self)
	self.diamondNode = cc.Node:create()
		:addTo(self)

--	if isShowDiamond then
--		self:setBtnGoldEnable(true)
--		self:setBtnDiamondEnable(false)
--		self.goldNode:hide()
--	else
--		self:setBtnGoldEnable(false)
--		self:setBtnDiamondEnable(true)
--		self.diamondNode:hide()
--	end
--	self:initGoldItem()
--	self:initDiamondItem()
end

function ViewShop:touchPayEvent(sender,touchType)
    if ccui.TouchEventType.ended == touchType then 
        print("你买了第"..sender:getTag().."个")
    end
end

function ViewShop:initGoldItem()
	for i = 1, #ViewShop.GOLD_GOODS do
		local item_data = ViewShop.GOLD_GOODS[i]
		local item = cc.CSLoader:createNode("cocostudio/home/ShopItemNode.csb")
			:addTo(self.goldNode)
			:move(cc.p(165 + math.mod((i - 1), 3) * 210, 750 - math.modf((i - 1) / 3) * 430))
		local btn_BG = UIHelper.seekNodeByName(item, "Button_Item")
		local imgBG = string.format("cocostudio/home/image/shop/item_gold_%d.png", i)
		btn_BG:loadTextures(imgBG, imgBG)
		btn_BG:addTouchEventListener(function(ref, t)
			if t == ccui.TouchEventType.ended then
				printInfo("buy gold:%d", i)
				local data = {
					count_ = item_data.fee
			 	}
				SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_EXCHANGE_GOLD, data)
			end
		end)

		local textCount = UIHelper.seekNodeByName(item, "AtlasLabel_Count")
		textCount:setString(item_data.count)

		local textFee = UIHelper.seekNodeByName(item, "AtlasLabel_Fee")
		textFee:setString(item_data.fee)

		local feePosX = textFee:getPositionX()
		local feeWidth = textFee:getContentSize().width

		local icon = UIHelper.seekNodeByName(item, "Image_FeeIcon")
		local imgIcon = "cocostudio/home/image/shop/shangcheng_zuanshixiao.png"
		icon:loadTexture(imgIcon)
		local posy = icon:getPositionY()
		icon:move(cc.p(feePosX - feeWidth / 2 - 24, posy))
	end
end

function ViewShop:initDiamondItem()
	for i = 1, #ViewShop.DIAMOND_GOODS do
		local item_data = ViewShop.DIAMOND_GOODS[i]
		local item = cc.CSLoader:createNode("cocostudio/home/ShopItemNode.csb")
			:addTo(self.diamondNode)
			:move(cc.p(165 + math.mod((i - 1), 3) * 210, 750 - math.modf((i - 1) / 3) * 430))
		local btn_BG = UIHelper.seekNodeByName(item, "Button_Item")
		local imgBG = string.format("cocostudio/home/image/shop/item_diamond_%d.png", i)
		btn_BG:loadTextures(imgBG, imgBG)
		btn_BG:addTouchEventListener(function(ref, t)
			if t == ccui.TouchEventType.ended then
				APP:getCurrentController():showBrowser({url = "http://www.baidu.com"})
			end
		end)

		local textCount = UIHelper.seekNodeByName(item, "AtlasLabel_Count")
		textCount:setString(item_data.count)

		local textFee = UIHelper.seekNodeByName(item, "AtlasLabel_Fee")
		textFee:setString(item_data.fee)

		local feePosX = textFee:getPositionX()
		local feeWidth = textFee:getContentSize().width

		local icon = UIHelper.seekNodeByName(item, "Image_FeeIcon")
		local imgIcon = "cocostudio/home/image/shop/shangcheng_yuan.png"
		icon:loadTexture(imgIcon)
		local posy = icon:getPositionY() - 5
		icon:move(cc.p(feePosX + feeWidth / 2 + 21, posy))
	end
end

function ViewShop:onEnter()
    ViewShop.super.onEnter(self)
end

function ViewShop:onExit()
    ViewShop.super.onExit(self)
end

function ViewShop:actionEnter()
	
end

function ViewShop:actionExit()

end

--function ViewShop:setBtnGoldEnable(enable)
--	self.btn_Gold:setEnabled(enable)
--	self.btn_Gold:setTouchEnabled(enable)
--end

--function ViewShop:setBtnDiamondEnable(enable)
--	self.btn_Diamond:setEnabled(enable)
--	self.btn_Diamond:setTouchEnabled(enable)
--end

return ViewShop