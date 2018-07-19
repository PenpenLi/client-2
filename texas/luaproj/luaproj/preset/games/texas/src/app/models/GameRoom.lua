local GameRoom = class("GameRoom")

function GameRoom:ctor()
	self.id = 0
	self.balance_with = 0
	self.banker_set = "" 		-- 庄家uid
	self.bet_set = 0			-- 大盲注，除以2是小盲注
	self.enter_cap = 0
	self.enter_cap_top = 0
	self.params = ""
	self.sequence_1 = 0

	self.maxseat = 0 		-- 房间最大人数
	self.require_seat = 0	-- 房间最小人数

	self.status = 0			-- 状态
	self.time_left = 0 		-- 本状态剩余时间
	self.time_total = 0 	-- 本状态总时间
    self.cards = ""         -- 公共牌
    -- self.pool_id = 0        -- 0底池,1主池,>1边池
    -- 没有收到id为2的边池，主池显示为pools[1]
    -- 收到id为2的边池，主池显示为pools[2]，pools[1]显示为边池
    -- 先收到id=1
    self.base_pool = 0		-- 底池
    self.pools = {}     	-- 主池和边池
    self.max_bet = 0 		-- 当前下的最大下注额

    self.take_pools = {}	-- 分奖池
end

function GameRoom:setServerData(data)
	self.id = tonumber(data.id_)
	self.balance_with = tonumber(data.balance_with_)
	self.banker_set = data.banker_set_
	self.bet_set = tonumber(data.bet_set_)
	self.enter_cap = tonumber(data.enter_cap_)
	self.enter_cap_top = tonumber(data.enter_cap_top)
	self.params = data.params_
	self.sequence_1 = tonumber(data.sequence_1_)
	self.maxseat = tonumber(data.maxseat_)
	self.require_seat = tonumber(data.require_seat_)
end

function GameRoom:changeStatus(data)
	self.status = tonumber(data.change_to_)
	self.sequence_1 = tonumber(data.sequence_1_)
	self.time_left = tonumber(data.time_left)
	self.time_total = tonumber(data.time_total_)
end

function GameRoom:changeSidePool( index, value)
    self.pools[index] = value
end

-- 优先使用id为2的当做主池
function GameRoom:getMainPool()
	if self.pools[2] and self.pools[2] > 0 then
		return self.pools[2], 2
	else
		return self.pools[1], 1
	end
end

function GameRoom:updatePublicCards(data)
	self.cards = data.cards_
end

function GameRoom:clearPublicCards()
	self.cards = ""
end

function GameRoom:updateBanker(data)
	self.banker_set = data.uid_
end

function GameRoom:updateMaxBet(bet)
	self.max_bet = bet
end

function GameRoom:clear()
	self.status = 0			-- 状态
	self.time_left = 0 		-- 本状态剩余时间
	self.time_total = 0 	-- 本状态总时间
    self.cards = ""         -- 公共牌
    self.base_pool = 0		-- 底池
    self.pools = {}		-- 主池、边池
    self.take_pools = {}

    self.max_bet = 0 		-- 当前下的最大下注额
end

return GameRoom