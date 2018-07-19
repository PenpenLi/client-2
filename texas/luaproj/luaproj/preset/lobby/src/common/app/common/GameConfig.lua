local GameConfig = {}

GameConfig.Version = "0.0.0.1"

GameConfig.Standalone = false

-- 通用ZOrder定义
GameConfig.Z_Top = 10000
GameConfig.Z_Waiting = 9999
GameConfig.Z_Alert = 9998
GameConfig.Z_GamePop = 2000
GameConfig.Z_GameTop = 1000
GameConfig.Z_UI = 100

-- socket name
-- 账号服务器
GameConfig.ACCOUNTSERVER = "ACCOUNTSERVER"
-- 协同服务器
GameConfig.COORDINATESERVER = "COORDINATESERVER"
-- 游戏服务器
GameConfig.GAMESERVER = "TEXASPOKERSERVER"

-- socket id
GameConfig.ID_ACCOUNTSERVER = 1
GameConfig.ID_COORDINATESERVER = 2
GameConfig.ID_GAMESERVER = 3

-- 语言
GameConfig.LANG = 1 	--中文

-- UserDefault keys
GameConfig.KEY_MUSIC = "LOCAL_KEY_MUSIC"
GameConfig.KEY_SOUND = "LOCAL_KEY_SOUND"
GameConfig.KEY_VIBRATE = "LOCAL_KEY_VIBRATE"

GameConfig.QQ1 = 888888888
GameConfig.QQ2 = 999999
GameConfig.GameEnv = {}

GameConfig.GameEnv.DEV_HJT = 1 	-- hjt测试服务器
GameConfig.GameEnv.DEV_210 = 2		-- 210局域网
GameConfig.GameEnv.RELEASE = 100 	-- 正式服务器
GameConfig.WebpartUrl = "http://poker.game577.com/"
GameConfig.UpdateUrl = "http://poker.game577.com/"
function GameConfig.getSocketEnv()
	return GameConfig.GameEnv.SocketEnv[GameConfig.GameEnv.Current]
end

--当前使用的服务器
--如果是内部调试使用版本，自由设置服务器端IP
if get_cmdline("-debug") == "1" then
	GameConfig.GameEnv.Current = GameConfig.GameEnv.DEV_HJT
--如果是发布版本，只设定为GameEnv.RELEASE,不要动这个代码
else
	GameConfig.GameEnv.Current = GameConfig.GameEnv.RELEASE
end

GameConfig.head_icon = {
	h0 = "zhujiemian_nv1.png",
	h1 = "zhujiemian_nv1.png",
	h2 = "zhujiemian_nv2.png",
	h3 = "zhujiemian_nv3.png",
	h4 = "zhujiemian_nv4.png",
	h5 = "zhujiemian_nv5.png",
	h6 = "zhujiemian_nv6.png",
	h7 = "zhujiemian_nv7.png",
	h8 = "zhujiemian_nv8.png",
	h9 = "zhujiemian_nan2.png",
	h10 = "zhujiemian_nan1.png",
	h11 = "zhujiemian_nan3.png",
	h12 = "zhujiemian_nan4.png",
	h13 = "zhujiemian_nan5.png",
	h14 = "zhujiemian_nan6.png",
	h15 = "zhujiemian_nan7.png",
	h16 = "zhujiemian_nan8.png"
}

GameConfig.GameEnv.SocketEnv = {
	[GameConfig.GameEnv.DEV_HJT] = {host = "192.168.2.100", port = "10000"},
	[GameConfig.GameEnv.DEV_210] = {host = "192.168.1.210", port = "10000"},
	[GameConfig.GameEnv.RELEASE] = {host = "poker.game577.com", port = "10000"},
}

function GameConfig:HeadIco(indx)
	indx = indx or 1;
	return self.head_icon["h"..indx]
end

return GameConfig