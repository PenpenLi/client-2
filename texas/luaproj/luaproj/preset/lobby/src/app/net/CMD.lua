
-- 游戏命令

local CMD = {}

-------------账号服务器-------------------

CMD.ACCOUNT_PING = 0xFFFF

CMD.ACCOUNT_COMMOM_REPLY = 1001

CMD.ACCOUNT_USER_LOGIN_REQ = 100
CMD.ACCOUNT_USER_LOGIN_RESP = 1000

CMD.ACCOUNT_GET_GAME_COORDINATE_REQ = 117
CMD.ACCOUNT_GET_GAME_COORDINATE_RESP = 1009

CMD.ACCOUNT_REGISTER = 101
CMD.ACCOUNT_SENDCODE = 111
-- 协同服务器

CMD.COORDINATE_PING = 0xFFFF

CMD.COORDINATE_COMMOM_REPLY = 1001

CMD.COORDINATE_USER_LOGIN_COORDINATE_REQ = 107
CMD.COORDINATE_ENTER_PRIVATE_ROOM = 120

CMD.COORDINATE_GET_GAME_SERVER_REQ = 1030
CMD.COORDINATE_GET_GAME_SERVER_RESP = 1028
CMD.COORDINATE_ENTER_PRIVATE_ROOM_RET = 1023
CMD.COORDINATE_JOIN_CHANNEL = 102
CMD.COORDINATE_LEAVE_CHANNEL = 104
CMD.COORDINATE_CHAT = 103
CMD.COORDINATE_SAMEACCOUNT_LOGIN = 1005
-- 同步玩家信息
CMD.COORDINATE_SYNC_ITEM = 1016

-- 广播
CMD.COORDINATE_BROADCAST = 1004

-- 兑换金币
CMD.COORDINATE_EXCHANGE_GOLD = 126

------------------- 游戏服务器---------------------------

---------------公共部分-------------------

CMD.GAME_PING = 0xFFFF
CMD.GAME_COMMOM_REPLY = 1001

CMD.GAME_USER_LOGIN_GAME_REQ = 994
CMD.GAME_USER_LOGIN_RESP = 1000

-- 玩家信息
CMD.GAME_PLAYER_DATA = 18
-- 同步玩家信息
CMD.GAME_SYNC_ITEM = 1016
-- 登陆游戏服务器时返回玩家信息
CMD.GAME_CURRENCY_CHANGE = 1007

-- 房间列表
CMD.SERVER_PARAMETERS = 1107

-- 进入房间
CMD.GAME_ENTER_GAME_REQ = 502
CMD.GAME_DEPOSIT_CHANGE2_NOTIFY = 1113

-- 离开房间
CMD.GAME_PLAYER_LEAVE_REQ = 505
CMD.GAME_PLAYER_LEAVE_NOTIFY = 1112

CMD.GAME_PLAYER_HINT_NOTIFY = 28
CMD.GAME_PLAYER_SEAT_NOTIFY = 1110
CMD.GAME_PLAYER_IS_READY_NOTIFY = 1204
CMD.GAME_PLAYER_STANDUP = 1134
CMD.GAME_PLAYER_SITDOWN = 1132

CMD.GAME_CREATE_ROOM_RET = 1210
CMD.GAME_CREATE_ROOM = 1204
CMD.GAME_PRIVATE_ROOM_INFO = 1208
CMD.GAME_IS_IN_GAME = 1205

-- 签到奖励
CMD.GAME_SIGN_RESULT =1037
CMD.GAME_SIGN_REQ = 1039
CMD.GAME_SIGN_GET_REQ = 1040
CMD.GAME_SIGN_GET_RESULT = 1050

-- 排行榜
CMD.GAME_RANK_REQ = 506
CMD.GAME_RANK_RESULT = 1122
------------------------------------------



-----------------私人房间-----------------

CMD.PRIVATE_xxx = 0

------------------------------------------



-----------------MTT----------------------

CMD.MTT_xxx = 0

------------------------------------------



------------------SNG---------------------

CMD.SNG_xxx = 0

------------------------------------------



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
------------------聊天   -----------------
CMD.GAME_CHAT_RESP = 1114                                -- 聊天接受消息
------------------------------------------


---------------- 用户设置 ----------------
CMD.GAME_USERINFO_SET_REQ = 1042                        -- 请求修改用户信息
CMD.GAME_USERINFO_SET_RESP = 1040                       -- 用户信息被修改
------------------------------------------
---------------- 邮件 --------------------
CMD.GAME_USER_MAIL_LIST_RESP = 1046                     -- 邮件列表收取
CMD.GAME_USER_MAIL_OP_RESP   = 1048                     -- 邮件列表操作
CMD.GAME_GET_MAIL_ATTACH_REQ = 1052                     -- 邮件附件获取
------------------------------------------
function CMD:getName(id)
	for k, v in pairs(self) do
		if v == id then
			return k;
		end
	end
end

return CMD
