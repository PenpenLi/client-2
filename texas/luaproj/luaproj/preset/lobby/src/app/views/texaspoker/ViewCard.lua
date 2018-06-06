
local ViewCard = class("ViewCard", function ()
	return display.newNode()
end)

-- 牌背值
ViewCard.BACK_VALUE = 55

-- value:牌值，isNeedTurn是否需要先显示牌背，再翻转过来
function ViewCard:ctor(value, isNeedTurn, isSmall)
	self.value = value and tonumber(value) or ViewCard.BACK_VALUE
	self.isSmall = isSmall
	local displayValue = value
	if isNeedTurn then
		displayValue = ViewCard.BACK_VALUE
	end
	local img
	if isSmall then
		img = string.format("#image/card_small_%d.png", displayValue)
	else
		img = string.format("#image/card_%d.png", displayValue)
	end
	self.cardSprite = display.newSprite(img);
	self.cardSprite:addTo(self);
	
	if not isSmall then
		self.cardSprite:setPosition(45, 59);
	else
		self.cardSprite:setPosition(18, 24);
	end
end

function ViewCard:onEnter()
	-- body
end

function ViewCard:onExit()
	-- body
end

function ViewCard:setScale(scale)
	self.cardSprite:setScale(scale)
end

function ViewCard:toGray()
	self.cardSprite:setColor(cc.c3b(64, 64, 64))
end

function ViewCard:toWhite()
	self.cardSprite:setColor(cc.c3b(255, 255, 255))
end

-- 翻牌动作
function ViewCard:actionTurn()
	self.cardSprite:runAction(
		cc.EaseSineInOut:create(cc.Sequence:create(
 			cc.ScaleTo:create(0.2, 0, 1),
 			cc.CallFunc:create(function()
 				local img
				if self.isSmall then
					img = string.format("image/card_small_%d.png", self.value)
				else
					img = string.format("image/card_%d.png", self.value)
				end
 				self.cardSprite:setSpriteFrame(img)
 			end),
 			cc.ScaleTo:create(0.2, 1, 1)
		)))

end

return ViewCard