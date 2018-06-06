local ErrorCode = {}

ErrorCode.error_wrong_sign = -1000			-- 数字签名不对
ErrorCode.error_wrong_password = -999 		-- 密码不对
ErrorCode.error_sql_execute_error = -998	-- sql语句执行失败
ErrorCode.error_no_record = -997			-- 数据库中没有相应记录
ErrorCode.error_user_banned = -996			-- 用户被禁止
ErrorCode.error_account_exist = -995 		-- 注册账户名已存在
ErrorCode.error_server_busy = -994			-- 服务器正忙
ErrorCode.error_cant_find_player = -993		-- 找不到玩家
ErrorCode.error_cant_find_match = -992		-- 找不到比赛项目
ErrorCode.error_cant_find_server = -991		-- 找不到服务器
ErrorCode.error_msg_ignored = -990			-- 消息被忽略
ErrorCode.error_cancel_timer = -989			-- 定时器被取消
ErrorCode.error_cannt_regist_more = -988	-- 不能再注册了
ErrorCode.error_email_inusing = -987		-- 邮箱地址被使用
ErrorCode.error_mobile_inusing = -986 		-- 手机号被使用
ErrorCode.error_wrong_verify_code = -985	-- 验证码错误
ErrorCode.error_time_expired = -984			-- 过期了
ErrorCode.error_invalid_data = -983			-- 数据不合法
ErrorCode.error_acc_name_invalid = -982		-- 用户名不合法
ErrorCode.error_cant_find_room = -981 		-- 找不到房间

ErrorCode.error_success = 0					-- 请求处理成功
ErrorCode.error_business_handled = 1		-- 请求被处理

ErrorCode.error_invalid_request = 2			-- 请求非法
ErrorCode.error_not_enough_gold = 3			-- 金币不足
ErrorCode.error_not_enough_gold_game = 4	-- 游戏币不足
ErrorCode.error_not_enough_gold_free = 5	--
ErrorCode.error_cant_find_coordinate = 6 	-- 找不到协同服务器
ErrorCode.error_no_173_account = 7			--
ErrorCode.error_no_173_pretty = 8			-- 
ErrorCode.error_cannot_send_present = 9 	-- 不能发送礼物
ErrorCode.error_cannot_recv_present = 10	-- 不能接收礼物
ErrorCode.error_not_enough_item = 11		-- 道具不足
ErrorCode.error_activity_is_invalid = 12	-- 活动已失效
ErrorCode.error_already_buy_present = 13	-- 已经购买了，不能再次购买
ErrorCode.error_cannt_del_attach_mail = 14	-- 不能删除带有附件的邮件
ErrorCode.error_mail_state_invalid = 15		-- 邮件状态不合法
ErrorCode.error_not_enough_viplevel = 16	-- VIP等级不够
ErrorCode.error_beyond_today_limit = 17		-- 超过今日上限
ErrorCode.error_count_invalid = 18 			-- 数量不合法
ErrorCode.error_mysql_execute_uncertain = 19 	-- 

return ErrorCode