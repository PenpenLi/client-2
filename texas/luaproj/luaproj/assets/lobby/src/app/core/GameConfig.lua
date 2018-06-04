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

--开发时脚本下载为了避免冲掉本地修改,给他另存一个位置
GameConfig.EnableUpdate = true
GameConfig.SAVEAS = "debugsave/"

return GameConfig