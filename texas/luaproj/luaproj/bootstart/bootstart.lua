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

function registerBootstartPackages()
    package.path = package.path .. ";src_framework/?.lua;"
    package.path = package.path .. "bootstart/?.lua;"

    local tb = cc.FileUtils:getInstance():getSearchPaths();
    table.insert(tb, "bootstart/");
	cc.FileUtils:getInstance():setSearchPaths(tb);
end

--注册lua查找文件目录
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
local function onVersionCheckePass()
    local tb = cc.FileUtils:getInstance():getSearchPaths();
    table.insert(tb, wbPath.."lobby/");
    table.insert(tb, wbPath.."lobby/res/");
    table.insert(tb, wbPath.."common/res/");
    cc.FileUtils:getInstance():setSearchPaths(tb);

    package.path = package.path..wbPath.."common/?.lua;"
    package.path = package.path..wbPath.."?.lua;"
    package.path = package.path..wbPath.."lobby/src/?.lua;"
    presetPackage = package.path;

    --启动程序
    require("main");
end

--显示日志归类[A]
log_filter["a"] = 1;

local function main()
    local sce = display.newScene("updator");
    local vw = loading.new():addTo(sce);
    display.runScene(sce)
    checkVersion("lobby/", wbPath, "http://poker.game577.com/game_update/texas/", vw, onVersionCheckePass);
end

__G__TRACKBACK__ = function(msg)
    local msg = debug.traceback(msg, 3)
    print(msg);

    io.writefile(pa.."runlog.log", "[" ..os.date("%Y-%m-%d %H:%M:%S", os.time()) .. "]" .. msg .. "\r\n", "a");
    local desc = APP.GD.LANG.UI_SCRIPT_ERROR;
    if APP:getCurrentController() then
        APP:getCurrentController():hideWaiting();
        APP:getCurrentController():showAlertOK({desc = desc});
    end
    return msg
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
