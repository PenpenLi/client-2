local GameConfig = require("app.core.GameConfig")
local CN = require("app.language.CN")

local LANG_CN = 1
local LANG_EN = 2

if GameConfig.LANG == LANG_CN then
	return CN
else
	printInfo("not supported language:%d", GameConfig.LANG)
end