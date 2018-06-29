local CN = {}
local ERR =
{
    [101] = {
        [-994] = "注册失败，服务器正忙",
        [-998] = "已达注册上限",
        [-995] = "账号已存在",
        [-985] = "验证码不正确",
        [-984] = "验证码已过期",
        [-988] = "注册太频繁,请1小时后再试",
        [-1000] = "签名失败",
    },

	[1204] = {
        [3] = "场次模板不存在.",
        [2010] = "已经在游戏房间中,不能创建新房间",
        [3005] = "已经存在私人房间,请先解散然后再创建新房间.",
        [3004] = "金币不足.",
    },

	[502] = {
		[1000] = "登录信息已经失效.",
        [3] = "发生内部错误.",
        [2010] = "非法进入房间.",
        [100010] = "到达每日输赢上下限.",
		[2005] = "金币不足,无法进入房间",
		[2003] = "积分不足,无法进入房间",
		[2014] = "金币超过房间限制",
		[2015] = "积分超过房间限制",
		[2002] = "房间不存在"
	}
}
---------界面控件上需要显示的文本-------------
CN.UI_ROOM = "的房间"
CN.UI_DOWNLOADIND = "正在更新..."
CN.UI_ALERT_DEFAULT_TITLE = "温馨提示"
CN.UI_ALERT_DEFAULT_CONFIRM = "确 定"
CN.UI_ALERT_DEFAULT_CANCEL = "取 消"
CN.UI_SCRIPT_ERROR = "非常抱歉发现运行时错误,我们将尽快修复这个问题,\r\n感谢您的理解和耐心.以下是我们收集到的信息:\r\n\r\n"

CN.UI_BROADCAST_TYPE_SYSTEM = "系统消息"
CN.UI_BROADCAST_TYPE_BROADCAST = "广播"

CN.UI_MISSION_ONLINE_TIME = "累计在线%d分钟"
CN.UI_MISSION_TIMES = "完成对局%d次"

CN.UI_MISSION_REWARD_GOLD = "奖励%d金币"
CN.UI_MISSION_REWARD_DIAMOND = "奖励%d钻石"

-----------------------------------------------



------------提示信息---------------------------

CN.TIP_NET_NOT_READY = "服务器还没准备好，请稍等一下重试！"
CN.TIP_NET_CREATE_ROOM_RET = "房间创建成功."
CN.TIP_SAME_ACCOUNT_LOGIN = "账号已在其它地方登录."
CN.TIP_ROOM_NEED_RENEW = "房间将于30秒后到期."
CN.TIP_LEAVE_ROOM = "你已离开游戏."
CN.TIP_CHANGE_TO_OBSERVER = "你正在观战游戏."
-----------------------------------------------

------------错误信息---------------------------
CN.ERR_SOCKET_CONNECT = "网络连接失败，请检查网络后重试！"
CN.ERR_ACCOUNT_OR_PWD = "账号或者密码错误！"
CN.ERR_CANNOT_LEAVE_ROOM = "现在不能离开房间"
CN.ERR_CANNOT_FIND_COOR = "无法连接协同服务器"
CN.ERR_CANNOT_FIND_GAME = "无法找到游戏服务器"
CN.ERR_LOGIN_GAME_FAILED = "登录游戏服务器失败"
CN.ERR_CANNOT_FIND_ROOM = "找不到房间"
CN.ERR_CANNOT_STANDUP1 = "请求已接受,本轮结束将自动站起."
CN.ERR_CANNOT_STANDUP2 = "您已经站起了."
CN.ERR_VERSION_COMPARE_FAILED = "检查版本失败."
CN.ERR_VERSION_COMPARE_OLDVERSION_REMAINS = "仍然存在某些文件没有更新成功,请尝试切换网络环境重试."
CN.ERR_PSW_NOTMATCH = "新旧密码不匹配."
CN.ERR_PSW_NEEDMORE_LENGTH = "密码长度不能于小6个字母."
-----------------------------------------------
CN.VCP = 
{
	[2]	= "正在更新文件...",
	[6]	= "正在解压文件...",
	[9]	= "正在移动文件...",
	[11] = "正在校验文件...",
}

-------------聊天默认消息----------------------
CN.CHAT_MSG = {
    "快点行动吧,时间宝贵",
    "各位爷,让看看牌再加钱吧",
    "我的宝剑已经饥渴难耐了",
    "莫偷鸡,偷鸡必被抓",
    "你牌技这么好,地球人知道吗?",
	"冲动是魔鬼,冷静",
    "打诚信德州,不偷不抢",
    "这手牌打得不错,赢的漂亮",
    "青山不改,绿水长流,改日再战",
    "冤家牌,没办法",
    "嘿嘿,我又赢了,感谢大家",
}
-----------------------------------------------

CN.ERR = ERR;
return CN