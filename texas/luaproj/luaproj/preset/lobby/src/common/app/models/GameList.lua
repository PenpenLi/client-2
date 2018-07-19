local GameList = {
	[-1] = {
		gameid = -1,
		name = "大厅",
		icon = "0",
		catalog = "",
		orientation = device.landscape,
		designSize = cc.size(1334,750);
		localp = "lobby/",
		remotep = "http://poker.game577.com/game_update/lobby/"
	},

	[566] = {
		gameid = 566,
		name = "启源德州",
		icon = "images/game_icons/xuanze_huanlebuyu.png",
		catalog = "fishing",
		orientation = device.portrait,
		designSize = cc.size(750, 1334);
		localp = "games/texas/",
		remotep = "http://poker.game577.com/game_update/games/texas"
	},

	[10] = {
		gameid = 10,
		name = "赛车运动会",
		icon = "images/game_icons/xuanze_benchibaoma.png",
		catalog = "street",
		orientation = device.landscape,
		designSize = cc.size(1280,720);
		localp = "games/texas/",
		remotep = "http://poker.game577.com/game_update/games/texas"
	},

	[11] = {
		gameid = 11,
		name = "欢乐牛牛",
		icon = "images/game_icons/xuanze_liurenniuniu.png",
		catalog = "chess",
		orientation = device.landscape,
		designSize = cc.size(1280,720);
		localp = "games/texas/",
		remotep = "http://poker.game577.com/game_update/games/texas"
	},
	[12] = {
		gameid = 12,
		name = "马戏团",
		icon = "images/game_icons/xuanze_maxituan.png",
		catalog = "multiplayer",
		orientation = device.landscape,
		designSize = cc.size(1280,720);
		localp = "games/texas/",
		remotep = "http://poker.game577.com/game_update/games/texas"
	},
	[13] = {
		gameid = 13,
		name = "森林狩猎",
		icon = "images/game_icons/xuanze_senglingshoulie.png",
		catalog = "street",
		orientation = device.landscape,
		designSize = cc.size(1280,720);
		localp = "games/texas/",
		remotep = "http://poker.game577.com/game_update/games/texas"
	},
	[32] = {
		gameid = 32,
		name = "水果转转",
		icon = "images/game_icons/xuanze_shuiguoji.png",
		catalog = "street",
		orientation = device.landscape,
		designSize = cc.size(1280,720);
		localp = "games/fruit/",
		remotep = "http://poker.game577.com/game_update/games/texas"
	},
	[15] = {
		gameid = 15,
		name = "水浒转",
		icon = "images/game_icons/xuanze_shuihuzhuan.png",
		catalog = "street",
		orientation = device.landscape,
		designSize = cc.size(1280,720);
		localp = "games/texas/",
		remotep = "http://poker.game577.com/game_update/games/texas"
	},

	[16] = {
		gameid = 16,
		name = "运动会",
		icon = "images/game_icons/xuanze_yundonghui.png",
		catalog = "street",
		orientation = device.landscape,
		designSize = cc.size(1280,720);
		localp = "games/texas/",
		remotep = "http://poker.game577.com/game_update/games/texas"
	},
}

function defaultGame()
	return GameList[566];
end

return GameList;