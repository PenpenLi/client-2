local GameConfig = {}

GameConfig.Version = "0.0.0.1"

-- 通用ZOrder定义
GameConfig.Z_Top = 10000
GameConfig.Z_Waiting = 9999
GameConfig.Z_Alert = 9998
GameConfig.Z_GamePop = 2000
GameConfig.Z_GameTop = 1000
GameConfig.Z_UI = 100

-- gameid
GameConfig.GameID = 566

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
GameConfig.WebpartUrl = "http://poker.game577.com/withdraw/withdraw/index?uid=%s&sn=%s&token=%s"
GameConfig.UpdateUrl = "http://poker.game577.com/withdraw/withdraw/index?uid=%s&sn=%s&token=%s"
function GameConfig.getSocketEnv()
	return GameConfig.GameEnv.SocketEnv[GameConfig.GameEnv.Current]
end

-- 当前使用的服务器
GameConfig.GameEnv.Current = GameConfig.GameEnv.DEV_HJT

GameConfig.GameEnv.SocketEnv = {
	[GameConfig.GameEnv.DEV_HJT] = {host = "192.168.2.100", port = "10000"},
	[GameConfig.GameEnv.DEV_210] = {host = "192.168.1.210", port = "10000"},
	[GameConfig.GameEnv.RELEASE] = {host = "poker.game577.com", port = "10000"},
}
return GameConfig