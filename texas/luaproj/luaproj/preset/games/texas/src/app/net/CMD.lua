
-- 游戏命令
local CMD_BASE = require("app.net.CMD_BASE")

local CMD = CMD_BASE

-----------------德州扑克部分-------------

CMD.TEXASPOKER_TAKE_OP_REQ = 5                          --下注相关
CMD.GAME_PRIVATE_ROOM_RESULT_REQ = 6
CMD.GAME_PRIVATE_ROOM_RESULT_DETAIL_REQ = 7
CMD.GAME_PRIVATE_ROOM_RESULT = 21
CMD.GAME_PRIVATE_ROOM_RESULT_DETAIL = 20

CMD.TEXASPOKER_STATUS_CHANGE_NOTIFY = 10
CMD.TEXASPOKER_PROMOTE_BANKER_NOTIFY = 11               -- 玩家被选定为庄家
CMD.TEXASPOKER_PLEASE_TAKEOP_NOTIFY = 12                -- 要求玩家采取操作
CMD.TEXASPOKER_PLAYER_CARDS = 13                        -- 玩家底牌
CMD.TEXASPOKER_PUBLIC_CARDS = 14                        -- 公共牌
CMD.TEXASPOKER_PLAYER_OPTION_NOTIFY = 15                -- 广播玩家采取了什么操作
CMD.TEXASPOKER_BEST_PLAN_NOTIFY = 16                    -- 最佳牌型
CMD.TEXASPOKER_POOL_CHANGE_NOTIFY = 17                  -- 底池变化
CMD.TEXASPOKER_MATCH_RESULT_NOTIFY = 20009              -- 比赛结果
CMD.TEXASPOKER_POOL_SPLIT = 19							-- 分池
------------------------------------------
function CMD:getName(id)
	for k, v in pairs(self) do
		if v == id then
			return k;
		end
	end
end

return CMD
