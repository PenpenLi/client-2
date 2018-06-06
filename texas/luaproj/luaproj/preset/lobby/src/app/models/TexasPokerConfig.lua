local TexasPokerConfig = {}

-- 德州扑克房间状态
TexasPokerConfig.SATUS_WAITE_START = 1			-- 等待开始
TexasPokerConfig.STATUS_VOTE_BANKER = 4			-- 选庄
TexasPokerConfig.STATUS_DEAL_ROUND_1 = 2			-- 第一轮发牌
TexasPokerConfig.STATUS_BET_ROUND_1 = 10000		-- 第一轮下注
TexasPokerConfig.STATUS_DEAL_ROUND_2 = 10001
TexasPokerConfig.STATUS_BET_ROUND_2 = 10002
TexasPokerConfig.STATUS_DEAL_ROUND_3 = 10003
TexasPokerConfig.STATUS_BET_ROUND_3 = 10004
TexasPokerConfig.STATUS_DEAL_ROUND_4 = 10005
TexasPokerConfig.STATUS_BET_ROUND_4 = 10006
TexasPokerConfig.STATUS_BAT_BALANCE = 10007		-- 结算底注
TexasPokerConfig.STATUS_BALANCE = 3				-- 结算分数

-- 牌的类型
TexasPokerConfig.TYPE_SAMECOLOR_CONNECTS = 1	-- 皇家同花顺
TexasPokerConfig.TYPE_BOMB = 2					-- 金刚、炸弹
TexasPokerConfig.TYPE_GOURD = 3					-- 葫芦
TexasPokerConfig.TYPE_SAMECOLOR = 4				-- 同花
TexasPokerConfig.TYPE_CONNECTS = 5				-- 顺子
TexasPokerConfig.TYPE_THREE = 6					-- 三张
TexasPokerConfig.TYPE_TWOPAIRS = 7				-- 两对
TexasPokerConfig.TYPE_PAIRS = 8					-- 一对
TexasPokerConfig.TYPE_SINGLES = 9				-- 散牌

-- 玩家操作
TexasPokerConfig.ACTION_NONE = -1				-- 无操作
TexasPokerConfig.ACTION_GIVEWAY = 0				-- 让牌
TexasPokerConfig.ACTION_GIVEUP = 1				-- 弃牌
TexasPokerConfig.ACTION_FOLLOW = 2				-- 跟注
TexasPokerConfig.ACTION_ADD = 3					-- 加注
TexasPokerConfig.ACTION_ALLIN = 4				-- allin
TexasPokerConfig.ACTION_SMALLBET = 5			-- 小盲注
TexasPokerConfig.ACTION_BIGBET = 6				-- 大盲注
TexasPokerConfig.ACTION_BETIN = 7				-- 下注

-- 筹码池ID
TexasPokerConfig.BETID_BASE = 0					-- 底池
TexasPokerConfig.BETID_MAIN = 1					-- 主池
TexasPokerConfig.BETID_SIDE = 2					-- 边池


return TexasPokerConfig