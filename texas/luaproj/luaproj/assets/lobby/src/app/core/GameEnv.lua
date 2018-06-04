local GameEnv = {}

GameEnv.DEV_HJT = 1 	-- hjt测试服务器
GameEnv.DEV_210 = 2		-- 210局域网
GameEnv.RELEASE = 100 	-- 正式服务器

-- 当前使用的服务器
GameEnv.Current = GameEnv.DEV_HJT

GameEnv.SocketEnv = {
	[GameEnv.DEV_HJT] = {host = "192.168.11.135", port = "10000"},
	[GameEnv.DEV_210] = {host = "192.168.1.210", port = "10000"},
	[GameEnv.RELEASE] = {host = "poker.game577.com", port = "10000"},
}

function GameEnv.getSocketEnv()
	return GameEnv.SocketEnv[GameEnv.Current]
end

return GameEnv