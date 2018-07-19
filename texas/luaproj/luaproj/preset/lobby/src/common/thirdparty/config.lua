local _G = _G
local CC = require "comm.CC"
module("config")


title = "KOKO竞技平台"
maxRankCount = 10                                                               --排行榜每页最多显示数量
rechargeUrl = "http://cpphelper.koko.com:8080/kokoportal/recharge/main.htm"     --充值地址
version = "1.0.1"                                                             --版本号
envirFlag = 0

if _G.CCVersion then
	if _G.CCVersion.Gov then
		WORLDADDR = "183.146.209.101"
	    WORLDPORT = 10001
	end
elseif _G.CCDebug and _G.CCDebug.Server == 2 then
	WORLDADDR = "192.168.17.31"
	WORLDPORT = 10000
elseif _G.CCDebug and _G.CCDebug.Server == 3 then
	WORLDADDR = "192.168.17.231"
	WORLDPORT = 10000
elseif _G.CCDebug and _G.CCDebug.Server == 32 then
	WORLDADDR = "192.168.17.25"
	WORLDPORT = 10000
elseif _G.CCDebug and _G.CCDebug.Server == 0 then
	WORLDADDR = "183.146.209.101"
	WORLDPORT = 10001
else
	WORLDADDR = "183.146.209.103"--   测试服:"183.146.209.101"--          蔡明强:192.168.17.31  clogin.test.koko.com
	WORLDPORT = 10001
end

if _G.CCVersion then
	if _G.CCVersion.Gov then
		webUrl = "http://183.146.209.101:8081/appbms/"
	end
elseif _G.CCDebug and _G.CCDebug.Web == 3 then
	webUrl = "http://192.168.17.19:8080/appbms/"
elseif _G.CCDebug and _G.CCDebug.Web == 0 then
	webUrl = "http://183.146.209.101:8081/appbms/"
elseif _G.CCDebug and _G.CCDebug.Web == 2 then
	webUrl = "http://192.168.17.202:8088/appbms/"      -- 张超:"http://192.168.17.202:8088/appbms/"       --测试："http://192.168.17.19:8080/appbms/"
else
	webUrl = "http://183.146.209.103:8081/appbms/"
end

webHost = webUrl.."app/"

	WORLDADDR = "192.168.1.238"--   测试服:"183.146.209.101"--          蔡明强:192.168.17.31  clogin.test.koko.com
	WORLDPORT = 10000
	webUrl = "http://183.146.209.103:8081/appbms/"
--错误报告上传地址
reportErrorUrl = "http://115.236.8.106:18088/appbms/app/error/addError.htm"


