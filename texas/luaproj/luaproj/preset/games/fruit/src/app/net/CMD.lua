
-- 游戏命令
local CMD_BASE = require("app.net.CMD_BASE")

local CMD = CMD_BASE
------------------------------------------
function CMD:getName(id)
	for k, v in pairs(self) do
		if v == id then
			return k;
		end
	end
end

return CMD
