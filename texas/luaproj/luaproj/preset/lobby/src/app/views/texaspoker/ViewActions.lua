
local ViewActions = class("ViewActions", cc.mvc.ViewBase)

function ViewActions:ctor(baseBet, allInBet)
	ViewActions.super.ctor(self)
end

function ViewActions:onEnter()
	ViewActions.super.onEnter(self)
end

function ViewActions:onExit()
	ViewActions.super.onExit(self)
end

-- 飞筹码动作
-- from:起始位置
-- to:终点位置
-- count:数量
-- img:筹码图片
-- callback:回调函数，只在最后一个筹码动作执行完回调一次
function ViewActions:flyBet(from, to, count, img, callback)
	for i = 1, count do
		local betSprite = display.newSprite(img)
			:addTo(self)
			:move(from)
		local seqActions = {
			cc.DelayTime:create((i - 1) * 0.1),
			cc.Spawn:create(
				cc.EaseSineInOut:create(
					cc.MoveTo:create(0.35, to))),
			cc.RemoveSelf:create()
		}
		if i == count and callback then
			table.insert(seqActions, cc.CallFunc:create(callback))
		end
		betSprite:runAction(cc.Sequence:create(seqActions))
	end
end

local function transPosition(playerPos, targetPos)
	return cc.p(playerPos.x + targetPos.x, playerPos.y + targetPos.y)
end

-- 下注飞筹码
-- uid
-- betPos:下注相对于player的坐标
-- callback
function ViewActions:actionBetIn(uid, betPos, callback)
	local from = APP:getCurrentController():getPlayerPostion(uid)
	if not from then return end;
	local to = transPosition(from, betPos)
	self:flyBet(from, to, 1, "cocostudio/game/image/bet_small.png", callback)
end

-- 筹码飞到主池
function ViewActions:actionBetToPool(uid, betPos, callback)
	local playerPos = APP:getCurrentController():getPlayerPostion(uid)
	if not playerPos then return end;
	local from = transPosition(playerPos, betPos)
	local to = cc.p(APP:getObject("ViewRoom"):getMainPoolIconPos())
	self:flyBet(from, to, 1, "cocostudio/game/image/bet_small.png", callback)
end

-- 主池飞筹码到玩家
function ViewActions:actionMainPoolToPlayer(uid, callback)
	local from = cc.p(APP:getObject("ViewRoom"):getMainPoolIconPos())
	local to = APP:getCurrentController():getPlayerPostion(uid)
	if not to then return end;
	self:flyBet(from, to, 4, "cocostudio/game/image/bet_main.png", callback)
end

-- 边池飞筹码到玩家
function ViewActions:actionSidePoolToPlayer(id, uid, callback)
	local x, y = APP:getObject("ViewRoom"):getSidePoolIconPos(id);
	if not x then return end;

	local from = cc.p(x, y);
	local to = APP:getCurrentController():getPlayerPostion(uid)
	if not to or not from then return end;
	self:flyBet(from, to, 4, "cocostudio/game/image/bet_side.png", callback)
end

-- 主池飞筹码到边池
function ViewActions:actionMainPoolToSide(to, callback)
	local from = cc.p(APP:getObject("ViewRoom"):getMainPoolIconPos())
	self:flyBet(from, to, 1, "cocostudio/game/image/bet_side.png", callback)
end

return ViewActions