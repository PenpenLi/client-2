local UIHelper = require("app.common.UIHelper")
local utils = require("utils")
local ViewAddBet = class("ViewAddBet", cc.mvc.ViewBase)

ViewAddBet.SCROLL_TO_HEIGHEST = 1054	-- 最高点
ViewAddBet.SCROLL_TO_LOWEST = 539		-- 最底点

function ViewAddBet:ctor(baseBet, allInBet)
	ViewAddBet.super.ctor(self)

	local csbnode = cc.CSLoader:createNode("cocostudio/game/AddBetLayer.csb")
	csbnode:addTo(self)

	self.baseBet = baseBet
	self.allInBet = allInBet

    local room = APP.GD.game_room

    if self.baseBet <= 0 then
	    self.baseBet = room.bet_set
	end

	self.currentBet = self.baseBet

	self.betBtns = {}

	local img_BG = UIHelper.seekNodeByName(csbnode, "Image_1")
	local btn_Confirm = UIHelper.seekNodeByName(csbnode, "Button_Confirm")
	local img_AddBet = UIHelper.seekNodeByName(csbnode, "Image_AddBet")
	self.text_CurrentBet_Left = UIHelper.seekNodeByName(csbnode, "Text_CurrentBet_Left")
	self.text_CurrentBet = UIHelper.seekNodeByName(csbnode, "Text_CurrentBet")
	local img_Number = UIHelper.seekNodeByName(csbnode, "Image_Number")
	local btn_AllIn = UIHelper.seekNodeByName(csbnode, "Button_AllIn")
	local text_AllIn = UIHelper.seekNodeByName(csbnode, "Text_AllIn")

	self.text_CurrentBet_Left:setString(tostring(self.baseBet))
	self.text_CurrentBet:setString(tostring(self.baseBet))
	text_AllIn:setString(tostring(self.allInBet))

	img_BG:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			self:removeSelf()
		end
	end)

	for i = 1, 8 do
		local btn_Bet = UIHelper.seekNodeByName(csbnode, string.format("Button_Bet_%d", i))
		btn_Bet:addTouchEventListener(function(ref, t)
			if t == ccui.TouchEventType.ended then
				local posy = ref:getPositionY()
				img_AddBet:setPositionY(posy)
				self:addBetNumber(posy)
				self:updateBet()
			end
		end)
		self.betBtns[i] = btn_Bet
	end

	btn_Confirm:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			if APP:isObjectExists("ViewRoom") then
				APP:getObject("ViewRoom"):onOperateButtonClicked(nil, self.currentBet)
			end
			self:removeSelf()
		end
	end)

	btn_AllIn:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			img_AddBet:setPositionY(ViewAddBet.SCROLL_TO_HEIGHEST)
			self.currentBet = self.allInBet
			self:updateBet()
		end
	end)

	img_AddBet:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.began then

		elseif t == ccui.TouchEventType.moved then
			local posy = ref:getTouchMovePosition().y
			if posy > ViewAddBet.SCROLL_TO_LOWEST and posy < ViewAddBet.SCROLL_TO_HEIGHEST then
				ref:setPositionY(posy)
				self:addBetNumber(posy)
				self:updateBet()
			end
		elseif t == ccui.TouchEventType.ended then
			local posy = ref:getTouchEndPosition().y
			if posy <= ViewAddBet.SCROLL_TO_LOWEST then
				ref:setPositionY(ViewAddBet.SCROLL_TO_LOWEST)
				self.currentBet = self.baseBet
				self:updateBet()
			elseif posy >= ViewAddBet.SCROLL_TO_HEIGHEST then
				ref:setPositionY(ViewAddBet.SCROLL_TO_HEIGHEST)
				self.currentBet = self.allInBet
				self:updateBet()
			end
		elseif t == ccui.TouchEventType.canceled then
			local posy = ref:getTouchEndPosition().y
			if posy <= ViewAddBet.SCROLL_TO_LOWEST then
				ref:setPositionY(ViewAddBet.SCROLL_TO_LOWEST)
				self.currentBet = self.baseBet
				self:updateBet()
			elseif posy >= ViewAddBet.SCROLL_TO_HEIGHEST then
				ref:setPositionY(ViewAddBet.SCROLL_TO_HEIGHEST)
				self.currentBet = self.allInBet
				self:updateBet()
			end
		end
	end)
end

function ViewAddBet:onEnter()
	ViewAddBet.super.onEnter(self)
end

function ViewAddBet:onExit()
	ViewAddBet.super.onExit(self)
end

function ViewAddBet:updateBet()
	self.text_CurrentBet_Left:setString(utils.convertNumberShort(tonumber(self.currentBet)))
	
	if self.currentBet == self.allInBet then
		self.text_CurrentBet:setString("ALL IN")
	else
		self.text_CurrentBet:setString(utils.convertNumberShort(tonumber(self.currentBet)))
	end
end

-- 滑动加多少注算法
function ViewAddBet:betForLevel(level)
	local more = (self.allInBet - self.baseBet * 8)
	if level == 1 then
		return self.baseBet
	elseif level == 2 then
		return self.baseBet * 2
	elseif level == 3 then
		return self.baseBet * 4
	elseif level == 4 then
		return self.baseBet * 6
	elseif level == 5 then
		return self.baseBet * 8
	elseif level == 6 then
		return math.floor((more * 2 / 16 + self.baseBet * 8) / self.baseBet) * self.baseBet
	elseif level == 7 then
		return math.floor((more * 5 / 16 + self.baseBet * 8) / self.baseBet) * self.baseBet
	elseif level == 8 then
		return math.floor((more * 9 / 16 + self.baseBet * 8) / self.baseBet) * self.baseBet
	elseif level == 9 then
		return self.allInBet
	end
end

function ViewAddBet:bet(level)
	local b = self:betForLevel(level)
	if b > self.allInBet then
		return self:bet(level - 1)
	else
		return b
	end
end

-- 总共
function ViewAddBet:addBetNumber(posy)
	if posy >= ViewAddBet.SCROLL_TO_HEIGHEST then
		self.currentBet = self.allInBet
		return
	elseif posy <= ViewAddBet.SCROLL_TO_LOWEST then
		self.currentBet = self.baseBet
		return
	end
	for i = #self.betBtns, 1, -1 do
		local btnPosy = self.betBtns[i]:getPositionY()
		if posy >= btnPosy then
			self.currentBet = self:bet(i)
			break
		end
	end
end

return ViewAddBet