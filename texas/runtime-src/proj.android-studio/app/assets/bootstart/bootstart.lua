cc.FileUtils:getInstance():setPopupNotify(false)
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
print = babe_output;

--注册最基础的lua文件目录
function registerBootstartPackages()
    package.path = package.path .. ";src_framework/?.lua;"
    package.path = package.path .. "bootstart/?.lua;"

    local tb = cc.FileUtils:getInstance():getSearchPaths();
    table.insert(tb, "bootstart/");
	cc.FileUtils:getInstance():setSearchPaths(tb);
end

--注册lua查找文件目录,在此之后才能用到cocos2d lua类
registerBootstartPackages();

--保存lua查找文件目录
presetPackage = package.path;

--加载cocos组件
require("config")
require("cocos.init")
--加载公用库
require("common")

local wbPath = cc.FileUtils:getInstance():getWritablePath();
local loading = require("loading");

--版本检查完毕,启动程序
--将lobby添加入搜索目录,进入大厅逻辑
local function onVersionCheckePass()
	
	--如果是开发模式下,访问开发下的资源目录
	if get_cmdline("-debug") == "1" then
		local tb = cc.FileUtils:getInstance():getSearchPaths();
		table.insert(tb, wbPath.."preset/lobby/");
		table.insert(tb, wbPath.."preset/lobby/res/");
		table.insert(tb, wbPath.."preset/common/res/");
		cc.FileUtils:getInstance():setSearchPaths(tb);

		package.path = package.path..wbPath.."preset/common/?.lua;"
		package.path = package.path..wbPath.."preset/?.lua;"
		package.path = package.path..wbPath.."preset/lobby/?.lua;"
		package.path = package.path..wbPath.."preset/lobby/src/?.lua;"
		presetPackage = package.path;
	else
		local tb = cc.FileUtils:getInstance():getSearchPaths();
		table.insert(tb, wbPath.."lobby/");
		table.insert(tb, wbPath.."lobby/res/");
		table.insert(tb, wbPath.."common/res/");
		cc.FileUtils:getInstance():setSearchPaths(tb);

		package.path = package.path..wbPath.."common/?.lua;"
		package.path = package.path..wbPath.."?.lua;"
		package.path = package.path..wbPath.."lobby/?.lua;"
		package.path = package.path..wbPath.."lobby/src/?.lua;"
		presetPackage = package.path;
	end
    --启动程序
    require("main");
end

--显示日志归类[A]
log_filter["a"] = 1;

--如果启动参数中有-debug,则不进行热更新,并且目录切换到preset下.避免热更新造成麻烦
local function main()
    local sce = display.newScene("updator");
    local vw = loading.new():addTo(sce);
    display.runScene(sce)
	checkVersion("lobby/", wbPath, "http://poker.game577.com/game_update/texas/", vw, onVersionCheckePass);
end

--设置全局异常处理,写入日志文件+派发错误事件让子模块处理错误
__G__TRACKBACK__ = function(msg)
    local msg = debug.traceback(msg, 3)
    io.writefile(wbPath.."runlog"..os.date("%Y-%m-%d", os.time())..".log", "[" ..os.date("%Y-%m-%d %H:%M:%S", os.time()) .. "]" .. msg .. "\r\n", "a");
	dispatchCustomEvent("SCRIPT_ERROR", msg);
    return msg
end

--lua运行环境已经准备好,可以开始运行了
local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
