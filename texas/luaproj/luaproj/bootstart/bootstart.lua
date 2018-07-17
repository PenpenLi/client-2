local function babe_tostring(...)
    local num = select("#",...);
    local args = {...};
    local outs = {};
    for i = 1, num do
        if i > 1 then
            outs[#outs+1] = "\t";
        end
        outs[#outs+1] = tostring(args[i]);
    end
    return table.concat(outs);
end

local babe_print = print;

local babe_output = function(...)
    babe_print(...);

    if decoda_output ~= nil then
        local str = babe_tostring(...);
        decoda_output(str);
    end
end

local wbPath = nil;
local loading = nil;

local contex_22141 = nil;--加入随机数防止重名
local currentGame_w21f2 = nil;--加入随机数防止重名

function g_CurrentGame()
	return currentGame_w21f2;
end

function g_Require(fileName)
	_G.package.loaded[fileName] = nil;
	return _G.require(fileName);
end

function remove_require(fileName)
	_G.package.loaded[fileName] = nil;
end

--注册最基础的lua文件目录
local function registerBootstartPackages()
    package.path = package.path .. ";src_framework/?.lua;"
    package.path = package.path .. "bootstart/?.lua;"
end


local function startup()
	cc.FileUtils:getInstance():setPopupNotify(false)
	print = babe_output;
		--注册lua查找文件目录,在此之后才能用到cocos2d lua类
	registerBootstartPackages();

	--保存lua查找文件目录
	presetPackage = package.path;

	--加载cocos组件
	require("config")
	require("cocos.init")

	--加载公用库
	require("common")

	wbPath = cc.FileUtils:getInstance():getWritablePath();
	loading = require("loading");

end

local function switchContex(newContex)
    if contex_22141 == newContex then return end;

	if APP then	APP:dtor() end
	--停止音效
    audio.stopMusic()
    audio.stopAllEffects()
	cc.SpriteFrameCache:destroyInstance();
	cc.SpriteFrameCache:getInstance();

	resetSearchAndPackagePath();


    --重置全局变量
    contex_22141 = newContex;
	local tb = cc.FileUtils:getInstance():getSearchPaths();

	local prefix = "";
	--如果是开发模式下,访问开发下的资源目录
	if get_cmdline("-debug") == "1" then
		prefix = "preset/";
	end

	table.insert(tb, wbPath..prefix..contex_22141);
	table.insert(tb, wbPath..prefix..contex_22141 .. "res/");

	package.path = package.path..wbPath..prefix..contex_22141 .. "?.lua;"
	package.path = package.path..wbPath..prefix..contex_22141 .. "src/?.lua;"
	
	--加入公共的UI
	table.insert(tb, wbPath..prefix.."lobby/res/");
	package.path = package.path..wbPath..prefix.."lobby/src/common/?.lua;"
	package.path = package.path..wbPath..prefix.."lobby/src/common/thirdparty/?.lua;"
	--启动程序
	cc.mvc = require("packages.mvc.init")

	if currentGame_w21f2 then
		cc.mvc.MyAppBase = require("packages.mvc.MyAppBase");	
		--如果是横屏，调用横版UI
		if currentGame_w21f2.orientation == device.landscape then
			--最后加入大厅中的公共部分，可供游戏调用的部分
			table.insert(tb, wbPath..prefix.."lobby/res/common/landscape/");
			cc.FileUtils:getInstance():setSearchPaths(tb);
		else
			--最后加入大厅中的公共部分，可供游戏调用的部分
			table.insert(tb, wbPath..prefix.."lobby/res/common/portrait/");
			cc.FileUtils:getInstance():setSearchPaths(tb);
		end
	end
end

function	resetSearchAndPackagePath()
	local tb = {}
		--加入splash路径
	if currentGame_w21f2 and currentGame_w21f2.orientation == device.landscape then
		table.insert(tb, "./bootstart/splash/landscape/");
	else
		table.insert(tb, "./bootstart/splash/portrait/");
	end

	cc.FileUtils:getInstance():setSearchPaths(tb);

	--如果是开发模式下,访问开发下的资源目录
	if get_cmdline("-debug") == "1" then
		package.path = presetPackage..wbPath.."preset/?.lua;"
	else
		package.path = presetPackage..wbPath.."?.lua;"
	end
end

--版本检查完毕,启动程序
--将lobby添加入搜索目录,进入大厅逻辑

local function onVersionCheckePass()
	cc.SpriteFrameCache:getInstance():addSpriteFrames("common/head_icons.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("common/image/common_sp.plist")

	g_Require("app.MyApp").new();
	APP:run();
end


--[-1] = {
--		gameid = -1,
--		name = "大厅",
--		icon = "0",
--		catalog = "",
--		localp = "lobby/",
--		remotep = "http://poker.game577.com/game_update/lobby/"
--},
--如果启动参数中有-debug,则不进行热更新,并且目录切换到preset下.避免热更新造成麻烦
function startGame(game)
	currentGame_w21f2 = game;
	switchContex(game.localp)

	local config = {};
	config = game.designSize or cc.size(1334, 750);
	config.autoscale = "SHOW_ALL";
	display.setAutoScale(config);

	--显示日志归类[A]
	log_filter["a"] = 1;

	local ControllerScene = require("app.controllers.ControllerScene")

    local sce = ControllerScene.new();
    local vw = loading.new():addTo(sce);
    display.runScene(sce)

	--开始检查版本
	checkVersion(currentGame_w21f2.localp, wbPath, currentGame_w21f2.remotep, vw, onVersionCheckePass);
end

--设置全局异常处理,写入日志文件+派发错误事件让子模块处理错误
__G__TRACKBACK__ = function(msg)
    local msg = debug.traceback(msg, 3)
    io.writefile(wbPath.."runlog"..os.date("%Y-%m-%d", os.time())..".log", "[" ..os.date("%Y-%m-%d %H:%M:%S", os.time()) .. "]" .. msg .. "\r\n", "a");
	dispatchCustomEvent("SCRIPT_ERROR", msg);
    return msg
end

--启动运行环境
startup();
resetSearchAndPackagePath();

--设置默认搜索路径
switchContex(".")

local GameList = require("app.models.GameList")

--lua运行环境已经准备好,可以开始运行了
local status, msg = xpcall(startGame, __G__TRACKBACK__, defaultGame())
if not status then
    print(msg)
end
