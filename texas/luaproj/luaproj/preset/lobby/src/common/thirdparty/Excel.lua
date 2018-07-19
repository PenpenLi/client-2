-----------------------------------------------------------------------------------
-- 表格  2017.9
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
module "Excel"
-----------------------------------------------------------------------------------
-- 表格数据
local tExcel = 
{
	--参数
	Parameter = 
	{
		--Key:和界面Key一致，必须继承UI类
		--用法:P.参数名
		--示例:P.ItemCount	->	12
	K = {"Key", 		"Param",		"Value"},
		----------------------------------------------------------------
		--个人信息
		{"UIPersonalInfoIcon", "HeadIconCount",  13},       --头像个数
		--转盘
		{"UITurntable",	"TurnFree",			{1,"1014,1"}},	--免费：转X次，消耗X物品X个
		{"UITurntable",	"Turn1",			{1,"1,10000"}},	--转X次，消耗X物品X个
		{"UITurntable",	"Turn2",			{5,"1,45000"}},	--转X次，消耗X物品X个
		{"UITurntable",	"ItemCount",		12 },			--物品数量
		{"UITurntable",	"OKCount",			2 },			--转几次按钮数量
		{"UITurntable",	"LuckyMax",			180 },			--满幸运
		{"UITurntable",	"SpeedMax",			15.0},			--速度：满速 (格/秒)
		{"UITurntable",	"SpeedGift",		1.0},			--速度：领奖速
		{"UITurntable",	"TimeSpeedUp",		2.0},			--时间：加速时间
		{"UITurntable",	"TimeSpeedDown",	3.0},			--时间：减速时间
		{"UITurntable",	"TimeSpeedMax",		1.5},		    --时间：满速最小持续时间
		{"UITurntable",	"TimeGiftDelay",	1.5},		    --时间：奖励停留时间
		{"UITurntable",	"TimeGiftInterval",	0.3},		    --时间：5连间隔时间
		{"UITurntable",	"Gift",				{{5,11},{12,12},{24,13},{42,14},{72,15},{124,16}}},--礼包：X次，ID
		{"UITurntable",	"GiftEnd",			"已领取"},	    --礼包已领取
		{"UITurntable",	"AudioRun",			"koko/audio/turntable_run.wav"},	    --转动音效
		{"UITurntable",	"AudioOK",			"koko/audio/turntable_ok.wav"},	        --获奖音效
		--物品
		{"UIBagUse",	"ItemMax",			9999},	        --物品使用上限
		----------------------------------------------------------------
		--游戏通用
		{"UIReconnectGame",	"ReconnectInfo", {5.0, 4}},	        --游戏重连：时间间隔、重连次数
		----------------------------------------------------------------
		--麻将加载
		{"MJUILoading",	"Time",				{0.5,0.3}},	        --加载时间，透明时间		
		--麻将战斗
		{"MJUIBattle",	"StandCount",		14},	        --站立X个
		{"MJUIBattle",	"FrontCount",		{6,4}},	        --出牌X个，X排
		{"MJUIBattle",	"CoverCount",		{14,2}},	    --牌墙X个，X排
		{"MJUIBattle",	"LieCount",			{4,4}},	    	--碰吃杠X个，X组
		{"MJUIBattle",	"PlayerTotalTime",	10},  	        --玩家出牌总时间
		{"MJUIBattle",	"StandMotionPosY",	{30, 0.1, 0.1, 100, 30}},--自己手牌点击后上升X高度,X秒,X秒落下  出牌高度 移动牌X轴超过x时为移动
		{"MJUIBattle",	"StandGetPaiPosY",	{70, 0.3}},     --摸到的牌起始相对高度， 下落X秒 
		{"MJUIBattle",	"RollImage",		"mj/atlas/animations/sz/%d.png"},--骰子图片
		{"MJUIBattle",	"MotionPlayTile",	{0.4, 0.08}},	--动画：出牌动画等待语音时间、出牌时间
		{"MJUIBattle",	"MotionFrontShow",	{0.5, 1.5}},	    --动画：出牌时 x秒透明度从1到0    持续显示x秒
		{"MJUIBattle",	"MotionStand",		{0.18, 0.04, 0.15, 30}},	    --动画：所有牌x轴移动时间（秒），单张牌x轴移动时间（秒）,y轴移动时间（秒），牌旋转角度
		{"MJUIBattle",	"DragBorder",		{50, 50}},	    --手牌拖动范围（像素）
		--麻将结算
		{"MJUIBattleResult","ResultIcon",	{"mj/atlas/battle/bq_5.png","mj/atlas/battle/bq_7.png","mj/atlas/battle/bq_6.png"}},	        --获胜图片：点炮、胡、自摸
		{"MJUIBattleWin",	"WinIcon",	{nil,"mj/atlas/battle/0001_20.png","mj/atlas/battle/0001_21.png"}},	        --获胜图片：点炮、胡、自摸
		--麻将货币 0-金币场玩法,1-积分场,2-私人场 100排位赛
		{"MJMoney",		"Type0",			"koko/atlas/shop/2003.png"},
		{"MJMoney",		"Type1",			"mj/atlas/common/integral.png"},
		--麻将AI		
		{"MJAI",		"PlayTileValue",	{1,1,2,3,3,3,2,1,1}},
		{"MJAI",		"PlayTileJumpValue", 5},
		{"MJAI",		"PlayTileArrayValue",{{0},{10,10},{20,20,20},{8,20,20,8},{10,20,20,20,10}, {20,20,20,20,20,20}, {8,20,20,20,20,20,8}, {10,20,20,20,20,20,20,10}, {20,20,20,20,20,20,20,20,20}}},
		{"MJAI",		"PlayTileTeamValue",{0,30,40,50}},
		----------------------------------------------------------------
		--丛林争霸
		{"CLZBUICenter", "ItemCount",       28},              --转子数量
		{"CLZBUICenter", "ItemPng",        {7,7,7,8,8,8,12,4,4,4,2,2,2,13,3,3,3,1,1,1,11,5,5,5,6,6,6,14}},               --转子图片索引
		{"CLZBUICenter", "TurnID",         {221,222,223,224,225,226,101,211,212,213,204,205,206,207,208,209,210,201,202,203,102,214,215,216,217,218,219,220}}, --转子对应Id
		{"CLZBUICenter", "TurnTotalTime",   10},              --转子总时间
		-- {"CLZBUICenter", "TimePercent",     {5,10,15,20,60,65,73,80,90,100}},         --时间百分
		-- {"CLZBUICenter", "DistancePercent", {1,2,3,5,86,88,92,95,98,100}},            --距离百分
		{"CLZBUICenter", "TimePercent",     {5,10,15,20,60,65,73,80,90,100}},         --时间百分
		{"CLZBUICenter", "DistancePercent", {1,2,3,5,88,90,94,97,99,100}},            --距离百分
		----------------------------------------------------------------
		-- 德州扑克

	},	
	--消息
	Message = 
	{
	--Type:弹窗、飘字
	--示例:CC.Message("删除邮件")
	--示例:CC.Message("删除邮件", function() end)
	K = {"Key",						"Type",				"Text"},
		{"邮件全删",				"弹窗可取消",		"您确定要删除全部已读邮件吗？"},
		{"邮件删除",				"弹窗可取消",		"是否确定将该邮件永久删除？"},
		{"邮件有未读",				"飘字",				"您有未读邮件或尚未领取的奖励。"},
		{"转盘失败",				"弹窗",				"转盘失败"},
		{"登陆游戏成功",			"飘字",				"登陆游戏成功"},
		{"登陆游戏失败",			"弹窗",				"登陆游戏失败"},
		{"发送协议失败",			"弹窗",				"连接服务器失败，请检查网络环境"},
		-- 游戏通用
		{"房间人已满",				"弹窗",				"该房间人数已满"},
		{"房间不存在",				"弹窗",				"该房间已不存在"},
		{"进房间积分不够",			"弹窗",				"积分不足，无法加入房间"},
		{"进房间金币不够",			"弹窗",				"金币不足，无法加入房间"},
		{"进房间密码错",			"弹窗",				"密码错误，请重试"},
		{"进房间钱太多",			"弹窗",				"您的金币太多啦，请去更高级的房间"},
		{"进房间积分太多",			"弹窗",				"您的积分太多啦，请去更高级的房间"},
		{"游戏断线",				"弹窗",				"与游戏服务器断开连接"},
		{"进房间失败",				"弹窗",				"进房间失败"},
		{"游戏被踢下线",			"弹窗",				"游戏被踢下线，可能账号被人登陆了"},		
		{"超过今日限额",            "弹窗",             "您今天的游戏状况已经超过限制，为保护您的账户安全，请明日再来继续游戏！"},
		-- 麻将
		{"操作失败",				"无",				""},
		{"非自己回合出牌",			"无",				"当前不是您的回合，无法出牌。"},
		{"吃吐不得分",				"弹窗可取消",		"吃来的牌吐出去将不得分，是否继续出牌？"},
		{"麻将退出战斗",			"弹窗可取消",		"是否退出游戏？"},
		{"麻将场次暂未开放",		"飘字",				"敬请期待"},
		{"德州场次暂未开放",		"飘字",				"敬请期待"},	
		{"服务器异常",				"弹窗可取消",		"网络不稳定，是否重新连接？"},		
	},
	--msgbox表
	Msgbox = {
	K = {"ID",  "Key",                   "Path"},
		{1,     "PersonalHeadIcon",     {Ok = "koko/atlas/all_common/button/an102.png", Cancel = "koko/atlas/all_common/button/btNextTime2.png"}},
		{2,     "PersonalSafeBox",      {Ok = "koko/atlas/all_common/button/2066.png", Cancel = "koko/atlas/all_common/button/btNextTime2.png"}},
	},
	--物品表
	Item = 
	{
	K = {"ID", 	"Sort",  "Name",					"Icon",							"CanTrade",		           "ShowNum",   "CanUse",	"Tip",                                           },--表头
		{1000,	  0,     "幸运勋章",		   "koko/atlas/shop/2036.png",	         {Min = 10, Max = 300},	       nil,	    true,		"使用后可得到5万K豆(可以赠送玩家)",                          },
		{1001,	  0,     "记牌器(个数)",	   "koko/atlas/shop/2051.png",	         false,	    					  nil,	   false,		"在游戏中使用该道具可拥有记牌器，每局游戏消耗一个。",        },
		{1002,	  0,     "记牌器(天数)",	   "koko/atlas/shop/2050.png",	         false,	    			  {Div = 86400},   false,		"在游戏中使用该道具可在有效时间内拥有记牌器。",    },
		{1003,	  0,     "翻倍卡(个数)",	   "koko/atlas/shop/2071.png",	         false,	    					  nil,	   false,		"确定地主身份后可以使用该道具，使用后额外翻4倍,每局游戏消耗一个。",    },
		{1004,	  0,     "霸王令(个数)",	   "koko/atlas/shop/2073.png",	         false,	    					  nil,	   false,		"发牌后可以使用该道具，使用后立即获得地主身份3倍开始牌局，每局只能有一个玩家使用。",    },
		{1005,	  0,     "斗地主房卡(个数)",   "koko/atlas/shop/2072.png",	         false,	    					nil,	 false,		"创建房间时需要消耗该卡，每局消耗1张。",    },
		{1006,	  0,     "跑车",		       "koko/atlas/shop/2045.png",	        {VIP = 2,Min = 1,Max = 300},     nil,	  true,   	"在商城中购买，使用后可得到5万K豆(可以赠送玩家)",                          },
		{1007,	  0,     "别墅",		       "koko/atlas/shop/2043.png",	        {VIP = 3,Min = 1,Max = 300},     nil,	  true, 		"在商城中购买，使用后可得到10万K豆(可以赠送玩家)",                           },
		{1008,	  0,     "游轮",		       "koko/atlas/shop/2046.png",	        {VIP = 4,Min = 1,Max = 300},     nil,	  true, 		"在商城中购买，使用后可得到50万K豆(可以赠送玩家)",                           },
		{1009,	  0,     "飞机",		       "koko/atlas/shop/2047.png",	        {VIP = 5,Min = 1,Max = 300},      nil,	  true,		"在商城中购买，使用后可得到100万K豆(可以赠送玩家)",                          },
		{1010,	  0,     "火箭",		       "koko/atlas/shop/2048.png",	        {VIP = 6,Min = 1,Max = 300},     nil,	  true, 		"在商城中购买，使用后可得到500万K豆(可以赠送玩家)",                          },
		{1013,	  0,     "30话费券",           "koko/atlas/shop/2049.png",	         false,   					     nil,	 false, 		"使用输入需要充值的手机号码，可以获得话费。",      },
		{1014,	  0,     "回馈券",             "koko/atlas/shop/2075.png",	         false,   					     nil,	  false, 		"消耗该道具，可以免费进行一次幸运转盘抽奖。",      },
		{1,	  	  0,     "K豆",                "koko/atlas/shop/s1.png",	         false,   				      nil,		false, 		"游戏中的核心货币，可以用来购买商城道具。",          },
		{0,	  	  0,     "钻石",               "koko/atlas/shop/s3.png",	         false,   				      nil,		false, 		"游戏中的核心货币，可以用来购买商城道具。",          },
		{2,    	  0,     "奖券",               "koko/atlas/shop/s2.png",	         false,  		      {Div = 100},		false, 		"游戏中的核心货币，可以用来购买商城道具。",          },
	},
	--礼包
	Gift = 
	{
		--Items:通用物品字符串(ID,个数|ID,个数|ID,个数)
	K = {"ID",				"Key", 					"Items"},
		{11,				"TurntableGift",	"1,6666|1001,1"},
		{12,				"TurntableGift",	"1,18888|1001,2"},
		{13,				"TurntableGift",	"0,38888|1001,3"},
		{14,				"TurntableGift",	"0,88888|1001,4"},
		{15,				"TurntableGift",	"2,1|1001,5"},
		{16,				"TurntableGift",	"2,3|1001,6"},


		--以下是客户端自己用的
		----------------------------------------------------------------
		--转盘                                     1     2      3      4      5     6    7       8    9     10   11   12
	 	{100000,			"Turntable",		"2,30|1,6666|1001,5|1000,1|0,6000|2,1|1001,10|1,8888|2,3|0,8000|2,5|1001,15"},--12个奖励
	},	
	--物品使用
	ItemUse = 
	{
	K = {"ID", 	"Num",  "Tip"},
		{1000,	5,		"恭喜您使用%d个%s获得了%d万K豆！"},
		{1006,	5,		"恭喜您使用%d个%s获得了%d万K豆！"},
		{1007,	10,		"恭喜您使用%d个%s获得了%d万K豆！"},
		{1008,	50,		"恭喜您使用%d个%s获得了%d万K豆！"},
		{1009,	100,	"恭喜您使用%d个%s获得了%d万K豆！"},
		{1010,	500,	"恭喜您使用%d个%s获得了%d万K豆！"},
	},

	--新手礼包
	RewardForWelcomeGift =
	{
	K = {"ID", 	"ItemID",	"Num"},
		{1016,	  1001,		10},		
	},

	--实名认证奖励
	RewardForIDCard =
	{
	K = {"ID", 	"ItemID",	"Num"},
		{1016,	  1001,		30},
		{1017,	  1004,		5},
	    {1018,	  1003,		10},
	
	},
	
	--邀请奖励
	InviteGift =
	{
	K = {"ID", 	"InviteNum",	"Items"},
		{1,		1,				{{ID = 1000, Num = 4}, {ID = 1000, Num = 4}, {ID = 1000, Num = 4}}},--邀人累计礼包
		{2,		3,				{{ID = 1001, Num = 4}, {ID = 1000, Num = 40}, {ID = 1000, Num = 4}}},
		{3,		6,				{{ID = 1000, Num = 12}, {ID = 1001, Num = 4}, {ID = 1000, Num = 4}}},	
		{4,		10,				{{ID = 1000, Num = 4}, {ID = 1000, Num = 4}, {ID = 1001, Num = 9999}}},	

		{101,	nil,			{{ID = 1003, Num = 5}, {ID = 1004, Num = 5}, {ID = 1001, Num = 20}}},--被推广礼包（受邀礼包）
		{201,	nil,			{{ID = 1003, Num = 5}, {ID = 1004, Num = 5}, {ID = 1001, Num = 20}}},--推广礼包
	
		
	},
	--头像框
	PlayerIconBack = 
	{
	K = {"ID", 	"Icon",										"Visible",	"VIP",	"Price"	},
		{1,		"koko/atlas/head_ico/iHeadBack1.png",		true,		0,		nil,				},
		{2,		"koko/atlas/head_ico/iHeadBack2.png",		false,		1,		nil,				},--{KB = 666, ShopID = 902},		},
		{3,		"koko/atlas/head_ico/iHeadBack3.png",		false,		3,		nil,				},--{Diamond = 100, ShopID = 903},	},
		{4,		"koko/atlas/head_ico/iHeadBack4.png",		true,		0,		nil,				},--{KB = 66666, ShopID = 904},	    },
		{5,		"koko/atlas/head_ico/iHeadBack5.png",		true,		0,		nil,				},--{Diamond = 88888, ShopID = 905},	},
		{6,		"koko/atlas/head_ico/iHeadBack6.png",		false,		5,		nil,				},--{Diamond = 500, ShopID = 906},	},
		{7,		"koko/atlas/head_ico/iHeadBack7.png",		true,		0,		nil,				},--{Diamond = 200000, ShopID = 907},	},
		{8,		"koko/atlas/head_ico/iHeadBack8.png",		true,		0,		nil,				},
		{9,		"koko/atlas/head_ico/iHeadBack8.png",		false,		1,		nil,				},
		{10,	"koko/atlas/head_ico/iHeadBack8.png",		false,		2,		nil,				},
		{11,	"koko/atlas/head_ico/iHeadBack8.png",		false,		3,		nil,				},
		{12,	"koko/atlas/head_ico/iHeadBack8.png",		false,		4,		nil,				},
		{13,	"koko/atlas/head_ico/iHeadBack8.png",		false,		5,		nil,				},
		{14,	"koko/atlas/head_ico/iHeadBack8.png",		false,		6,		nil,				},
		{15,	"koko/atlas/head_ico/iHeadBack8.png",		false,		7,		nil,				},
		{16,	"koko/atlas/head_ico/iHeadBack8.png",		false,		8,		nil,				},
		{17,	"koko/atlas/head_ico/iHeadBack8.png",		false,		9,		nil,				},
		{18,	"koko/atlas/head_ico/iHeadBack8.png",		false,		10,		nil,				},
	},
	--钻石
	Shop_ZS = 
	{
	K = {"ID", 	"Name",		 "Icon",					         "Price",       "BuyVIP",  "Hot",    "AddGive",},
		{1,	    "60",	     "koko/atlas/shop/2021.png",       6,              nil,     true,         nil,},
		{2,	    "180",	     "koko/atlas/shop/2021.png",       18,             nil,     false,        nil,},
		{3,	    "300",       "koko/atlas/shop/2022.png",       30,             nil,     false,        nil,},
		{4,	    "680",	     "koko/atlas/shop/2023.png",       68,             nil,     false,        nil,},
		{5,	    "1680",      "koko/atlas/shop/2024.png",       168,            nil,     false,        nil,},
		{6,	    "3280",	     "koko/atlas/shop/2025.png",       328,            nil,     false,        nil,},
		{7,	    "6660",	     "koko/atlas/shop/2026.png",       666,            6,       false,        nil,},
		{8,	    "18880",	 "koko/atlas/shop/2027.png",       1888,           8,       false,        nil,},
	},
	-- K豆
	Shop_KD = 
    {
	K = {"ID", 	"Name",	        "Icon",					        "Price",      "BuyVIP",   "Hot",    "AddGive",   },
		{1,  	"60000",		"koko/atlas/shop/2014.png",     60000,           nil,       true,         nil,},
		{2,  	"100000",		"koko/atlas/shop/2014.png",     100000,          nil,       false,        5,},
		{3,  	"200000",		"koko/atlas/shop/2015.png",     200000,          nil,       false,        10,},
		{4,  	"500000",		"koko/atlas/shop/2016.png",     500000,          nil,       false,        15,},
		{5,  	"1000000",		"koko/atlas/shop/2017.png",     1000000,         nil,       false,        20,},
		{6,  	"1800000",		"koko/atlas/shop/2018.png",     1800000,         nil,       false,        25,},
		{7,  	"3000000",		"koko/atlas/shop/2019.png",     3000000,         6,         false,        25,},
		{8,  	"5000000",		"koko/atlas/shop/2020.png",     5000000,         8,         false,        25,},
	},
	-- 商城
	Shop =
    {
	K = {"ID", 	"Type",    "Name",			  "Icon",					                "Num",         "Price" ,    "Tip",                                                           "Seq",            "BuyVIP",    "BuyType",    "IsShow"},  --BuyType 2：券   1：k豆  0：钻石                                               
		{2002,	"ShopDJ",  "记牌器(10个)",	  "koko/atlas/shop/2051.png",                nil,          "15000",     "在游戏中使用该道具可拥有记牌器，每局游戏消耗一个。",                  10,                 nil,         1,            true,  },       --  1      2       3     
		{2003,	"ShopDJ",  "记牌器(100个)",	  "koko/atlas/shop/2051.png",                nil,          "99999",     "在游戏中使用该道具可拥有记牌器，每局游戏消耗一个。",                  15,                 nil,         1,            true,  },
		{2004,	"ShopSW",  "记牌器(30天)",	  "koko/atlas/shop/2050.png",                nil,          "30",      "在游戏中使用该道具可拥有记牌器，30天内有效。",                       20,                 nil,         2,            true,  },
		{2006,	"ShopDJ",  "翻倍卡(1个)",	  "koko/atlas/shop/2071.png",                nil,          "2000",      "确定地主身份后可以使用该道具，使用后额外翻4倍,每局游戏消耗一个。", 25,        nil,         1,            true,  },
		{2007,	"ShopDJ",  "霸王令(1个)",	  "koko/atlas/shop/2073.png",                nil,          "4000",      "发牌后可以使用该道具，使用后立即获得地主身份3倍开始牌局，每局只能有一个玩家使用。",        30,        nil,         1,            true,  },
		{2008,	"ShopDJ",  "斗地主房卡(10个)", "koko/atlas/shop/2072.png",                nil,          "10000",        "创建房间时需要消耗该卡，每局消耗1张。",                                35,                 nil,         0,            true,  },
		{2009,	"ShopDJ",  "记牌器(1个)",	  "koko/atlas/shop/2051.png",                nil,          "1500",      "在游戏中使用该道具可拥有记牌器，每局游戏消耗一个。",                  40,                 nil,         1,            true,  },
		{2010,	"ShopDJ",  "记牌器(1天)",	  "koko/atlas/shop/2050.png",                nil,          "15000",     "在游戏中使用该道具可拥有记牌器，24小时内有效。",                      45,                 nil,         1,           true,  },
		{2011,	"ShopDJ",  "记牌器(7天)",	  "koko/atlas/shop/2050.png",                nil,          "99999",     "在游戏中使用该道具可拥有记牌器，7天内有效。",                         50,                 nil,         1,           true,  },
		{902,	"ShopDJ",  "金边头像框",      "koko/atlas/head_ico/iHeadBack2.png",      nil,          "666",       "VIP等级达到1级时，即可拥有该头像框。",                                 55,                 1,           1,           false,  },
		{903,	"ShopDJ",  "皇冠头像框",      "koko/atlas/head_ico/iHeadBack3.png",      nil,          "100",       "VIP等级达到3级时，开启该头像框。",                                     60,               3,           0,             false,  },
		{904,	"ShopDJ",  "蓝晶石头像框",    "koko/atlas/head_ico/iHeadBack4.png",      nil,          "60000",      "消耗66666K豆，即可拥有该头像框。",                                      65,               nil,         1,             false,  },
		{905,	"ShopDJ",  "紫宝石头像框",    "koko/atlas/head_ico/iHeadBack5.png",      nil,          "80000",       "消耗88888钻石，即可拥有该头像框。",                                      70,               nil,         0,             false,  },
		{906,	"ShopDJ",  "太阳花头像框",    "koko/atlas/head_ico/iHeadBack6.png",      nil,          "500",       "VIP等级达到5级时，开启该头像框。",                                     75,               5,           0,             false,  },
		{907,	"ShopLW",  "金铃铛头像框",    "koko/atlas/head_ico/iHeadBack7.png",      nil,          "200000",  "商城中稀有的头像框，是一种身份的象征,在个性设置中设置。",                80,               nil,         0,             true,  },
		{908,	"ShopDJ",  "竞技双剑头像框",  "koko/atlas/head_ico/iHeadBack8.png",      nil,          "9990000",  "只有在活动功能中，才可以获得的头像框。",                                85,               nil,         1,             false,  },
		{2000,	"ShopLW",  "幸运勋章",	      "koko/atlas/shop/2036.png",              50000,        "50050",        "在商城中购买，使用后可得到5万K豆（可以赠送玩家）",                      1,                nil,         1,             true,  },
		{2012,	"ShopLW",  "跑车",	        "koko/atlas/shop/2045.png",              50000,        "5",        "在商城中购买，使用后可得到5万K豆（可以赠送玩家）",                      2,                3,         2,             true,  },
		{2013,	"ShopLW",  "别墅",	        "koko/atlas/shop/2043.png",              100000,       "10",       "在商城中购买，使用后可得到10万K豆（可以赠送玩家）",                     5,                5,         2,             true,  },
		{2014,	"ShopLW",  "游轮",	        "koko/atlas/shop/2046.png",              500000,       "50",       "在商城中购买，使用后可得到50万K豆（可以赠送玩家）",                     10,                6,         2,            true,  },
		{2015,	"ShopLW",  "飞机",	        "koko/atlas/shop/2047.png",              1000000,      "100",      "在商城中购买，使用后可得到100万K豆（可以赠送玩家）",                    15,                7,         2,            true,  },
		{2016,	"ShopLW",  "火箭",	        "koko/atlas/shop/2048.png",              5000000,      "500",      "在商城中购买，使用后可得到500万K豆（可以赠送玩家）",                    20,                8,         2,            true,  },
		{2005,	"ShopSW",  "30话费券",      "koko/atlas/shop/2049.png",               nil,          "30",       "使用输入需要充值的手机号码，可以获得话费。",                            1,                nil,          2,           true,  },
	},
	Scene = 
	{
 	K = {"Key",		"Name"},
 		{"Null",	"无"},
 		{"Login",	"登陆"},
 		{"Lobby",	"大厅"},
 		{"Game",	"游戏"},
	},
	-- 游戏列表
	GameList = 
	{  	-- 1:ddz   2:hddmx  3:niuniu  4:fruit   5:shz  6:sport  http://183.146.209.101/test/kkmobile 
		-- Generation:1大厅前的游戏，2大厅后做的游戏
	K = {"ID", "Name",     	"Visible", "GamePage",  "GameIndex", "GameId", "Generation", "GameIdForGov","LocalDir",     "RemoteDir",   "MainFile",  "NetFile",             "Icon",                 			"CsbPath",                  "ShadeCsbPath",              "LoadingKey",     },
	    {1,    "斗地主",      true,        0,             1,	     21,         1,        161,            "ddz",     "ddz_zkoko",    "ddz_main",        "",	 "koko/atlas/game_ico/1004.png",     "koko/ui/lobby/lobby_ico_1.csb",   "ddz/UICommon/Loading.csb",    "UILoading_ddz",  },
		{2,    "麻将",        true,       0,             2,		  61,         2,          161,           "mj",      "mj_zkoko",      "MJGame",	  "MJNet",    "koko/atlas/game_ico/1006.png",     "koko/ui/lobby/lobby_ico_8.csb",    "koko/ui/login/loading.csb",  "UILoading_mj",  },
        {3,   "丛林争霸",     true,        0,            3,		    63,	        2,         161,           "clzb",    "clzb_zkoko",    "CLZBGame",  "CLZBNet",    "koko/atlas/game_ico/1002.png",     "koko/ui/lobby/lobby_ico_10.csb",   "clzb/UILogic/Game/Loading.csb",  "UILoading_clzb",  },
		{4,    "森林狩猎",    true,       0,             4,	        62,         1,         161,        "forest",  "forest_zkoko",  "forest_main",	     "",    "koko/atlas/game_ico/1006.png",     "koko/ui/lobby/lobby_ico_9.csb",    "forest/UICommon/Loading.csb", "UILoading_forest",  },
		{5,    "水浒传",      true,        0,             5,		 42,         1,        161,            "shz",     "shz_zkoko",    "shz_main",        "",    "koko/atlas/game_ico/1006.png",     "koko/ui/lobby/lobby_ico_5.csb",    "shz/UICommon/Loading.csb",    "UILoading_shz",  },
		{6,    "水果转转",    true,        0,             6,			32,	        1,         161,         "fruit",   "fruit_zkoko",  "fruit_main",        "",    "koko/atlas/game_ico/1002.png",     "koko/ui/lobby/lobby_ico_4.csb",   "fruit/UICommon/Loading.csb",  "UILoading_fruit",  },
		{7,    "西游记",      true,        1,             1,		 60,         1,        161,            "xyj",     "xyj_zkoko",    "xyj_main",        "",    "koko/atlas/game_ico/1007.png",     "koko/ui/lobby/lobby_ico_7.csb",     "xyj/UICommon/Loading.csb",   "UILoading_xyj",  },
	    {8,    "运动会",      true,        1,             2,		 15, 	     1,        161,          "sport",   "sport_zkoko",  "sport_main",        "",    "koko/atlas/game_ico/1001.png",     "koko/ui/lobby/lobby_ico_6.csb",   "sport/UICommon/Loading.csb",  "UILoading_sport",  },
		{9,    "海底大冒险",  true,        1,             3,         29,	       1,          161,        "hddmx",   "hddmx_zkoko",  "hddmx_main",        "",	    "koko/atlas/game_ico/1003.png",     "koko/ui/lobby/lobby_ico_2.csb",  "hddmx/UICommon/Loading.csb",  "UILoading_hddmx",  },
		{10,   "德州扑克",    false,       1,             5,		  61,         2,        161,          "dz",  "dz_zkoko", "DZGame",        "DZNet",    "koko/atlas/game_ico/1005.png",     "koko/ui/lobby/lobby_ico_3.csb",    "niuniu/UICommon/Loading.csb", "UILoading_dz",  },
		{11,   "拼十",       false,       1,             4,		  12,         1,        161,          "niuniu",  "niuniu_zkoko", "niuniu_main",        "",    "koko/atlas/game_ico/1005.png",     "koko/ui/lobby/lobby_ico_3.csb",    "niuniu/UICommon/Loading.csb", "UILoading_niuniu",  },
		{12,   "捕鱼",       false,       1,             6,		  564,         1,        161,          "fishing",  "fishing_zkoko", "forest_main",        "",    "koko/atlas/game_ico/1005.png",     "koko/ui/lobby/lobby_ico_3.csb",    "forest/UICommon/Loading.csb", "UILoading_fishing",  },
	},
	-- vip特权列表
	VipList = 
	{
	K = {"ID",  "MinExp",  "HeadIcon", "LuckNum", "SignAward", "PayRateAdd", "GiftLimit",   "unlockBuy",                   "unlockGive"}, --GiftLimit 以万为单位
	    {1,       60,	       1,            2,           2,        nil,           nil,      nil,                           nil,   },
		{2,       500, 	       2,            2,           2,        0.01,          nil,      nil,                           nil,   },
		{3,       1000,	       3,            3,           2,        0.01,          5,        "跑车",                        nil,   },
		{4,       2000,        4,            3,           3,        0.02,          10,       "跑车",                        "跑车",   },
		{5,       5000,        5,            4,           3,        0.02,          20,       "跑车、别墅",                   "跑车",   },
		{6,       10000,       6,            4,           3,        0.03,          50,       "跑车、别墅、游轮",             "跑车、别墅",   },
		{7,       20000,       7,            5,           4,        0.03,          100,      "跑车、别墅、游轮、飞机",        "跑车、别墅、游轮",   },
	    {8,       50000,       8,            5,           4,        0.04,          200,      "跑车、别墅、游轮、飞机、火箭",  "跑车、别墅、游轮、飞机",   },
	    {9,       100000,      9,            6,           4,        0.04,          500,      "跑车、别墅、游轮、飞机、火箭",  "跑车、别墅、游轮、飞机、火箭",   },
		{10,      200000,      10,           6,           5,        0.05,          1000,     "跑车、别墅、游轮、飞机、火箭",  "跑车、别墅、游轮、飞机、火箭",   },
		{11,      300000,      11,           7,           6,        0.06,          1500,     "跑车、别墅、游轮、飞机、火箭",  "跑车、别墅、游轮、飞机、火箭",   },
		{12,      500000,      12,           8,           7,        0.07,          2500,     "跑车、别墅、游轮、飞机、火箭",  "跑车、别墅、游轮、飞机、火箭",   },
		{13,      800000,      13,           9,           8,        0.08,          4000,     "跑车、别墅、游轮、飞机、火箭",  "跑车、别墅、游轮、飞机、火箭",   },
		{14,      1200000,     14,           10,          9,        0.09,          6000,     "跑车、别墅、游轮、飞机、火箭",  "跑车、别墅、游轮、飞机、火箭",   },
		{15,      1800000,     15,           11,          10,       0.10,          9000,     "跑车、别墅、游轮、飞机、火箭",  "跑车、别墅、游轮、飞机、火箭",   },
		{16,      2400000,     16,           12,          11,       0.11,          12000,    "跑车、别墅、游轮、飞机、火箭",  "跑车、别墅、游轮、飞机、火箭",   },
	},
	Activity = 
	{
	K = {"ID",       "Name",                   "Icon",                         "Price",},
	    {1,       "竞技双剑",     "koko/atlas/head_ico/iHeadBack8.png",  300,},
		{2,       "钻石 X 88888",     "koko/atlas/lobby/1030.png",                66,},
	},
	--  每日登陆奖励
	EveryLogin =   
	{
	K = {"ID",   "Award",                 "Icon",                               "Data",},
	    {1,      "记牌器X2",      "koko/atlas/shop/2051.png",       "koko/atlas/everyday_login/2000.png",},	
		{2,      "霸王令X1",     "koko/atlas/shop/2073.png",       "koko/atlas/everyday_login/2001.png",},
		{3,      "翻倍器X3",      "koko/atlas/shop/2071.png",       "koko/atlas/everyday_login/2002.png",},	
		{4,      "记牌器X5",      "koko/atlas/shop/2051.png",       "koko/atlas/everyday_login/2003.png",},	
		{5,      "翻倍器X5",     "koko/atlas/shop/2071.png",       "koko/atlas/everyday_login/2004.png",},	
		{6,      "霸王令X3",      "koko/atlas/shop/2073.png",       "koko/atlas/everyday_login/2005.png",},	
		{7,      "记牌器(1天)",      "koko/atlas/shop/2050.png",       "koko/atlas/everyday_login/2006.png",},	
	},

	--组件表
	Component = 
	{
		--Root:界面里根节点
		--Control：控件路径
	K = {"Type",			"TypeID",	"Root", 				"Control"},  
		---------------------------------------------------------------- 
		--EditBox
		{"EditBox",			1,			"rWelcomeGiftReg",		"eAccount",			},	
		{"EditBox",			2,			"rWelcomeGiftReg",		"ePassword",		},	
		{"EditBox",			3,			"rWelcomeGiftReg",		"ePassword2",		},	
		{"EditBox",			4,			"rWelcomeGiftReg",		"ePhone",			},	
		{"EditBox",			5,			"rWelcomeGiftReg",		"eCode",			},
	
		{"EditBox",			6,			"rWelcomeRegIDCard",	"eRealName",		},	
		{"EditBox",			7,			"rWelcomeRegIDCard",	"eIDCard",			},	
		{"EditBox",			8,			"rWelcomeRegIDCard",	"eCode",			},

		----------------------------------------------------------------
		--Item
		{"Item",			2,			"rMailInfo",			"rItem1",		},
		{"Item",			2,			"rMailInfo",			"rItem2",		},
		{"Item",			2,			"rMailInfo",			"rItem3",		},
		{"Item",			2,			"rMailInfo",			"rItem4",		},
		{"Item",			2,			"rMailInfo",			"rItem5",		},
		{"Item",			2,			"rMailInfo",			"rItem6",		},

		{"Item",			5,			"rGift",				"rItem1",		},
		{"Item",			5,			"rGift",				"rItem2",		},
		{"Item",			5,			"rGift",				"rItem3",		},
		{"Item",			5,			"rGift",				"rItem4",		},
		{"Item",			5,			"rGift",				"rItem5",		},
		{"Item",			5,			"rGift",				"rItem6",		},

		{"Item",			3,			"rTurntable",			"rItem1",		},
		{"Item",			3,			"rTurntable",			"rItem2",		},
		{"Item",			3,			"rTurntable",			"rItem3",		},
		{"Item",			3,			"rTurntable",			"rItem4",		},
		{"Item",			3,			"rTurntable",			"rItem5",		},
		{"Item",			3,			"rTurntable",			"rItem6",		},
		{"Item",			3,			"rTurntable",			"rItem7",		},
		{"Item",			3,			"rTurntable",			"rItem8",		},
		{"Item",			3,			"rTurntable",			"rItem9",		},
		{"Item",			3,			"rTurntable",			"rItem10",		},
		{"Item",			3,			"rTurntable",			"rItem11",		},
		{"Item",			3,			"rTurntable",			"rItem12",		},
		{"Item",			4,			"rTurntable",			"rItemOK1",		},
		{"Item",			4,			"rTurntable",			"rItemOK2",		},
		{"Item",			2,			"rTurntable",			"rItemShow1",		},
		{"Item",			2,			"rTurntable",			"rItemShow2",		},
		{"Item",			2,			"rTurntable",			"rItemShow3",		},
		{"Item",			2,			"rTurntable",			"rItemShow4",		},
		{"Item",			2,			"rTurntable",			"rItemShow5",		},

		{"Item",			3,			"first_charge",			"rItem1",		},
		{"Item",			3,			"first_charge",			"rItem2",		},
		{"Item",			3,			"first_charge",			"rItem3",		},
		{"Item",			3,			"first_charge",			"rItem4",		},
		{"Item",			3,			"first_charge",			"rItem5",		},

		----------------------------------------------------------------
		--RedPoint
		{"RedPoint",		1,			"rMail",				"iMenu1",		},
		{"RedPoint",		1,			"rMail",				"iMenu2",		},
		{"RedPoint",		1,			"rTurntable",			"btOK1",		},

		{"RedPoint",		2,			"rLobby",				"btWelfare",		},
		{"RedPoint",		2,			"rLobby",				"btActivity",		},
		{"RedPoint",		3,			"rLobby",				"btMail",		},
		{"RedPoint",		2,			"rLobby",				"btBag",		},
		{"RedPoint",		2,			"rLobby",				"btTurntable",		},
		{"RedPoint",		2,			"rLobby",				"btEverydayLogin",		},	
	},
	--编辑框
	Component_EditBox = 
	{
		--Type:文本/数字/密码
	K = {"ID",	"Type", 	"Tip","TipEmpty","TipError","IconError"}, 
		{1, 	"文本",		"请输入6-12位字母加数字","账号不能为空","账号不符合要求，请输入6-12位字母加数字",{Path = "koko/atlas/login/2003.png", PathOK = "koko/atlas/login/2004.png", XD = 305, YD = -18}},
		{2, 	"密码",		"请输入6-12位数字或字母","密码不能为空","请正确输入密码，6-12位数字或字母。",{Path = "koko/atlas/login/2003.png", PathOK = "koko/atlas/login/2004.png", XD = 305, YD = -18}},
		{3, 	"密码",		"请再输入一次密码进行确认","确认密码不能为空","两次密码不一致，请重新输入",{Path = "koko/atlas/login/2003.png", PathOK = "koko/atlas/login/2004.png", XD = 305, YD = -18}},
		{4, 	"数字",		"请输入您的手机号","手机号不能为空","请输入正确的手机号",{Path = "koko/atlas/login/2003.png", PathOK = "koko/atlas/login/2004.png", XD = 305, YD = -18}},
		{5, 	"文本",		"请输入验证码","验证码不能为空","验证码格式错误，请重新输入",{Path = "koko/atlas/login/2003.png", PathOK = "koko/atlas/login/2004.png", XD = 160, YD = -18}},

		{6, 	"文本",		"请输入您的真实姓名","真实姓名不能为空","请正确输入真实姓名",{Path = "koko/atlas/login/2003.png", PathOK = "koko/atlas/login/2004.png", XD = 295, YD = -18}},
		{7, 	"文本",		"请输入您的身份证号","身份证号码不能为空","身份证号码不符合要求，请重新输入",{Path = "koko/atlas/login/2003.png", PathOK = "koko/atlas/login/2004.png", XD = 295, YD = -18}},
		{8, 	"文本",		"请输入验证码","验证码不能为空","验证码格式错误，请重新输入",{Path = "koko/atlas/login/2003.png", PathOK = "koko/atlas/login/2004.png", XD = 155, YD = -18}},
	},
	--物品
	Component_Item = 
	{
		--Background背景:显示/无/自动
		--Fix:是否修正成X万X亿
	K = {"ID",	"Background",		"Name",			"Tip",		"Fix"}, 
		{1,		"显示",				nil,			true,		true},
		{2,		"自动",				nil,			true,		true},
		{3,		"无",				true,			true,		true},
		{4,		"无",				nil,			false,		false},
		{5,		"显示",				nil,			true,		false},
	},
	--小红点
	Component_RedPoint = 
	{
		--Position：XP/YP小红点位于父节点的百分比位置,如{XP = 0, YP = 0}左下角，{XP = 1, YP = 1}右上角
	K = {"ID",	"Position",}, 
		{1,		{XP = 1, YP = 1},},
		{2,		{XP = 0.85, YP = 0.85},},
		{3,		{XP = 0.75, YP = 0.65},},
	},
	--麻将操作
	MahjongOperation = 
	{
	K = {"ID",	"BaseID",		"Name",		"Inverse",		"When",			}, 
		{101,	101,			"出牌",		nil, 			nil,			},
		{201,	201,			"听",		"被听",			"Turn",			},
		{301,	301,			"吃",		"被吃",			"Operation",	},
		{401,	401,			"碰",		"被碰",			"Operation",	},
		{501,	501,			"杠",		"被杠",			"Operation",	},
		{502,	501,			"暗杠",		"被暗杠",		"Turn",			},
		{503,	501,			"补杠",		"被补杠",		"Turn",			},
		{601,	601,			"胡",		"点炮",			"Operation",	},
		{602,	601,			"自摸",		"被胡",			"Turn",			},
		{603,	601,			"一炮多响",	"被胡",			nil,			},
		{1001,	1001,			"被退税",	"退税",			nil,			},
	},
	--麻将音效
	MahjongAudio = 
	{
	K = {"Key",	"Background", "Path"},
		--背景
		{"Battle",	true,		"mj/audio/bg/battle.mp3"},
		{"City",	true, 		"mj/audio/bg/city.mp3"},

		--麻将 1万*9 2条*9 3饼*9 (4风*4 5箭*3 6花*8 暂无)
		{"11",		false,		"mj/audio/tile/g_1wan.mp3"},
		{"12",		false,		"mj/audio/tile/g_2wan.mp3"},
		{"13",		false,		"mj/audio/tile/g_3wan.mp3"},
		{"14",		false,		"mj/audio/tile/g_4wan.mp3"},
		{"15",		false,		"mj/audio/tile/g_5wan.mp3"},
		{"16",		false,		"mj/audio/tile/g_6wan.mp3"},
		{"17",		false,		"mj/audio/tile/g_7wan.mp3"},
		{"18",		false,		"mj/audio/tile/g_8wan.mp3"},
		{"19",		false,		"mj/audio/tile/g_9wan.mp3"},
		{"21",		false,		"mj/audio/tile/g_1tiao.mp3"},
		{"22",		false,		"mj/audio/tile/g_2tiao.mp3"},
		{"23",		false,		"mj/audio/tile/g_3tiao.mp3"},
		{"24",		false,		"mj/audio/tile/g_4tiao.mp3"},
		{"25",		false,		"mj/audio/tile/g_5tiao.mp3"},
		{"26",		false,		"mj/audio/tile/g_6tiao.mp3"},
		{"27",		false,		"mj/audio/tile/g_7tiao.mp3"},
		{"28",		false,		"mj/audio/tile/g_8tiao.mp3"},
		{"29",		false,		"mj/audio/tile/g_9tiao.mp3"},
		{"31",		false,		"mj/audio/tile/g_1tong.mp3"},
		{"32",		false,		"mj/audio/tile/g_2tong.mp3"},
		{"33",		false,		"mj/audio/tile/g_3tong.mp3"},
		{"34",		false,		"mj/audio/tile/g_4tong.mp3"},
		{"35",		false,		"mj/audio/tile/g_5tong.mp3"},
		{"36",		false,		"mj/audio/tile/g_6tong.mp3"},
		{"37",		false,		"mj/audio/tile/g_7tong.mp3"},
		{"38",		false,		"mj/audio/tile/g_8tong.mp3"},
		{"39",		false,		"mj/audio/tile/g_9tong.mp3"},
		--操作
		{"出牌",	false,		"mj/audio/op/yx_chupai.mp3"},
		{"听",		false,		"mj/audio/op/g_ting.mp3"},
		{"吃",		false,		"mj/audio/op/g_chi.mp3"},
		{"碰",		false,		"mj/audio/op/g_peng.mp3"},
		{"杠",		false,		"mj/audio/op/g_gang.mp3"},
		{"暗杠",	false,		"mj/audio/op/g_gang.mp3"},
		{"补杠",	false,		"mj/audio/op/g_gang.mp3"},
		{"胡",		false,		"mj/audio/op/g_hu.mp3"},
		{"自摸",	false,		"mj/audio/op/g_hu_zimo.mp3"},
		{"一炮多响",false,		"mj/audio/op/g_hu.mp3"},
		{"被退税",	false,		"mj/audio/op/yx_money.mp3"},
		{"让我想想",false,		"mj/audio/op/g_letMeThink.mp3"},
		{"闹钟",    false,		"mj/audio/op/yx_naozhong.mp3"},
	},
	--丛林争霸	
	CLZB_BetItem = 
	{
	K = {"ID",	"Name",	"BetId", "Mult",  "Type",          "Image",              "Audio"},   --Type 0:其它 1:飞禽 2:走兽  
		{1,		"燕子",	 22,      6,      1,   "clzb/atlas/Game/1999.png",  "clzb/Sound/yanzi.mp3"},     -- 201  202  203
		{2,		"鸽子",	 23,      8,      1,   "clzb/atlas/Game/1998.png",  "clzb/Sound/gezi.mp3"},      -- 204  205  206
		{3,		"孔雀",	 24,      8,      1,   "clzb/atlas/Game/2003.png",  "clzb/Sound/kongque.mp3"},   -- 208  209  210 
		{4,		"老鹰",	 25,      12,      1,   "clzb/atlas/Game/2004.png",  "clzb/Sound/laoying.mp3"},  -- 211  212  213
		{5,		"狮子",	 27,      12,      2,   "clzb/atlas/Game/2005.png",  "clzb/Sound/shizi.mp3"},    -- 214  215  216
		{6,		"熊猫",	 28,      8,      2,   "clzb/atlas/Game/2007.png",  "clzb/Sound/xiongmao.mp3"},  -- 217  218  219
		{7,		"猴子",	 29,      8,      2,   "clzb/atlas/Game/2001.png",  "clzb/Sound/houzi.mp3"},     -- 221  222  223
		{8,		"兔子",	 30,      6,      2,   "clzb/atlas/Game/2006.png",  "clzb/Sound/tuzi.mp3"},      -- 224  225  226
		{9,		"飞禽",	 21,       2,      1,   "clzb/atlas/Game/2008.png",  nil},                       -- 
		{10,    "走兽",	 26,       2,      2,   "clzb/atlas/Game/2008.png",  nil},
		{11,    "鲨鱼",	 11,      24,      0,   "clzb/atlas/Game/2008.png",  "clzb/Sound/yinsha.mp3"},   -- 102
		{12,    "金鲨",	 nil,     100,     0,   "clzb/atlas/Game/2002.png",  "clzb/Sound/jinsha.mp3"},   -- 101
		{13,    "通杀",	 nil,      24,     0,   "clzb/atlas/Game/2028.png",  nil},                       -- 207
		{14,    "通赔",	 nil,      1,      0,   "clzb/atlas/Game/2029.png",  nil},                       -- 220
	},
	--丛林争霸	
	-- CLZB_StateConfig = 
	-- {
	-- K = {"ID",	"Name",	  "Mult",           "Image"}, 
	-- 	{1,		"下注",	  24,    "clzb/atlas/Game/2001.png"},
	-- 	{2,		"转圈",	  24,    "clzb/atlas/Game/2001.png"},
	-- 	{3,		"结算",	  24,    "clzb/atlas/Game/2001.png"},
	-- },

	--德州扑克顺序
	DZOrder = 
	{
	K = {"ID",	"Name",	},     
		{1,		"庄家",	},     
		{2,		"小盲注",},      
		{3,		"枪口A",}, 
		{4,		"枪口B",}, 
		{5,		"中位A",}, 
		{6,		"中位B",}, 
		{7,		"中位C",}, 
		{8,		"劫位",}, 
		{9,		"关位",}, 
	},
	--德州扑克牌型
	DZWinType = 
	{
	K = {"ID",	"Name",	},     
		{1,		"皇家同花顺",},     
		{2,		"同花顺",},      
		{3,		"四条",}, 
		{4,		"葫芦",}, 
		{5,		"同花",}, 
		{6,		"顺子",}, 
		{7,		"三条",}, 
		{8,		"两对",}, 
		{9,		"一对",}, 
		{10,	"高牌",}, 
	},

	--游戏样式
	GameStyle = 
	{
		--Style:【严禁】用这个判断！
		--Platform:【严禁】用这个判断！
		--GameLayoutFix: 进游戏后改变的界面
	K = {"Style",	"Platform",		"GameLayoutMap"}, 
		{"平台版",	"koko",			{UILobby = "koko/ui/game/lobby_fix.csb"},},
		{"单发版",	"single",		nil,},
		{"嵌入版",	"embed",		{UILobby = "koko/ui/game/lobby_fix.csb"},},

	},
	-- 服务器
	ServerList = 
	{
	K = {"Name",		"IP",				"Port",					"Web"}, 
		{"准备服",		"183.146.209.103",	10001,					"http://183.146.209.103:8081/appbms/"},
		{"测试服",		"183.146.209.101",	10001,					"http://183.146.209.101:8081/appbms/"},
		{"私服：蔡明强","192.168.17.31",	10000,					"http://192.168.17.222:8081/appbms/"},
		{"私服：范杨",	"192.168.17.25",	10000,					"http://192.168.17.202:8088/appbms/"},
	},
	-- 作弊
	Hacker = 
	{
	K = {"Name",				"Key",				"Value"}, 
		{"麻将·自动测试",		"AutoTest",			"MJ"},
		{"麻将·自动断线",		"AutoDisconnected",	"MJ"},
		{"德州·自动测试",		"AutoTest",			"DZ"},
		{"平台·界面点击日志",	"ClickLog",			true},
		{"平台·欢迎界面关闭",	"Welcome",			false},
	},
}
-----------------------------------------------------------------------------------
-- Excel
--[[ 
1、	读表：	CC.Excel.表名[ID].列名

	例：	local CC = require "comm.CC"
			local kItemName = CC.Excel.Item[10001].Name

2、	遍历：	CC.Excel.表名:Count()
			CC.Excel.表名:At(第几个)

	例：	local kExcel = CC.Excel.RewardForIDCard
			for i=1,kExcel:Count() do
				local iItemID = kExcel:At(i).ItemID
			end

3、	随机：	CC.Excel.表名.Random	

	例：	CC.Excel.Item.Random.Name	

4、	多重映射：	CC.Excel.表名.字段名.属性名 得到一个多重映射（有缓存）

	例：	local tExcel = CC.Excel.Component.Root.rWelcomeGiftReg
			for i = 1,tExcel:Count() do
				local kExcel = tExcel:At(i)
				CC.Print(kExcel.TypeID)
			end
5、 无ID支持: 会自动帮你添加唯一ID
]]
Excel = {}
local mt = {}
function mt:__index(kKey)
	local CC = _G.require "comm.CC"
	local tVal = tExcel[kKey]
	tExcel[kKey] = nil
	local kClass = {tMultiMap = {}}
	_G.assert(tVal, "Excel ["..kKey.."] isn't existed")
	_G.assert(tVal.K, "Excel ["..kKey.."] doesn't has a K value")

	local bNoID = tVal.K[1] ~= "ID"
	local tKey, tData, tVector = {ID = 1}, {}, {}
	for i,v in _G.ipairs(tVal.K) do
		tKey[v] = bNoID and i + 1 or i
	end
	for i,v in _G.ipairs(tVal) do
		if bNoID then
			local tV = {i}
			for ii,vv in _G.ipairs(v) do
				_G.table.insert(tV, vv)
			end
			v = tV
		end
		tData[v[1]] = v
	end
  	tVector = CC.Table:Vector(tData)
	local lmt = {}
	function lmt:__index(iKey2)	
		--Random
		if iKey2 == "Random" then
			iKey2 = tVector[_G.math.random(1, #tVector)].Key
		--MultiMap
		elseif tKey[iKey2] then
			local tTemp = self.tMultiMap[iKey2]
			if not tTemp then
				tTemp = {}
				self.tMultiMap[iKey2] = tTemp
				for i,v in _G.pairs(tData) do
					local kKeyNow = v[tKey[iKey2]]
					local tTemp2 = tTemp[kKeyNow]
					if not tTemp2 then
						tTemp2 = {}
						tTemp[kKeyNow] = tTemp2
					end
					_G.table.insert(tTemp2, i)
				end
			end
			local kClassMM = {}
			local lmtmm = {}
			function lmtmm:__index(iKey3)
				if not tTemp[iKey3] then
					return nil
				else
					local tData = tTemp[iKey3]
					local kClassMultiMap = {}
					function kClassMultiMap:Count()
						return #tData
					end
					function kClassMultiMap:At(iIndex)
						return kClass[tData[iIndex]]
					end
					return kClassMultiMap
				end
			end
			_G.setmetatable(kClassMM, lmtmm)
			return kClassMM
		end
		iKey2 = _G.tonumber(iKey2)
		if not tData[iKey2] then
			return
		end
		local kClass2 = {}
		function kClass2:__Set(iKey3, kVal)
			tData[iKey2][tKey[iKey3]] = kVal
		end
		local llmt = {}
		function llmt:__index(iKey3)
			local iKeyFix = tKey[iKey3]
			return iKeyFix and tData[iKey2][iKeyFix]
		end
		_G.setmetatable(kClass2, llmt)
		return kClass2
	end
	--Vector
	function kClass:Count()
		return #tVector
	end
	function kClass:At(iIndex)
		_G.assert(tVector[iIndex], "Excel ["..iIndex.."] isn't a valid index")
		return self[tVector[iIndex].Key]
	end
	_G.setmetatable(kClass, lmt)
	Excel[kKey] = kClass
	return kClass
end	

function Excel:Param(kKey, kParam)
	local kExcel = Excel.Parameter.Key[kKey]
	for i=1,kExcel:Count() do
		local kData = kExcel:At(i)
		if kData.Param == kParam then
			return kData.Value
		end
	end
end
_G.setmetatable(Excel, mt)

function Excel:Prepare()
	local CC = _G.require "comm.CC"
	if CC.Version and CC.Version.Gov then
		local tExcel = Excel.GameList
		for i = 1, tExcel:Count() do
			local kExcel = tExcel:At(i)
			kExcel:__Set("GameId", kExcel.GameIdForGov)
		end
    end
end