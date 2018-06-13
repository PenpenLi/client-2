
local vcp = require("VersionCompare")
local contex = nil;

function switchContex(newContex)
    if contex == newContex then return end;
    --重置全局变量

    --重置搜索路径
    local tb = cc.FileUtils:getInstance():getSearchPaths();
    if contex then
        table.removebyvalue(tb, wbPath..contex);
        table.removebyvalue(tb, wbPath..contex .. "res/");
    end

    contex = newContex;
    table.insert(tb, wbPath..contex);
    table.insert(tb, wbPath..contex .. "res/");
    cc.FileUtils:getInstance():setSearchPaths(tb);

    package.path = presetPackage;
    package.path = package.path..wbPath..contex .. "?.lua;"
    package.path = package.path..wbPath..contex .. "src/?.lua;"
end

local cor_182331 = 0;
local sh1 = 0;
--先检查版本,再执行更新
function    installUpdate(vw, onSucc)
    local st, prog, progmax;
    vcp:install_update();
    cor_182331 = 0;
    sh1 = scheduler.scheduleGlobal(function()
        local st, prog, progmax = vcp:query_version_status();
        if cor_182331 == 0 then
            if vcp:is_working() == 1 then
                printLog("a", "downloading %d,%d", prog, progmax);
                if st == 2 then
                    vw:updateProgress("正在更新...", prog, progmax);
                elseif st == 11 then
                    vw:updateProgress("正在确认版本...", 0, 0);
                else
                    vw:updateProgress("正在移动文件...", 0, 0);
                end
            else
                printLog("a", "vcp is not working, st = %d", st);
                cor_182331 = 1;
            end
        elseif cor_182331 == 1 then
            printLog("a", "is over.", st);
            scheduler.unscheduleGlobal(sh1);
            --成功
            if st == 7 then
                onSucc();
            --仍然存在旧版本
            elseif st == 8 then
                vw:setError("更新已完成,但有部分文件未能成功更新.");
            else
                vw:setError("更新失败.");
            end
        end
    end, 0.05);
end

--检查版本
function	checkVersion(contex, localp, remotep, vw, onSucc)
    vw:setVisible(false);
	local chk = vcp:check_version(contex, localp, remotep);
	--没有新版本
	if chk == 6 then
		onSucc();
	--有新版本
    elseif chk == 5 then
        vw:setVisible(true);
        installUpdate(vw, onSucc);
	--版本对比失败	
    elseif chk ~= 0 then
        vw:setVisible(true);
		vw:setError("检查版本失败.");
    end
end

function dispatchCustomEvent(evtName, ...)
    local e = cc.EventCustom:new(evtName)
    e.param = {...}
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    dispatcher:dispatchEvent(e)
end
--移除事件
function removeListener(evt)
	local dispatcher = cc.Director:getInstance():getEventDispatcher();
    dispatcher:removeEventListener(evt);
end

function addListener(node, evtName, callback)
    local evt = cc.EventListenerCustom:create(evtName,
    function(e)
        callback(unpack(e.param));
    end);

    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    dispatcher:addEventListenerWithSceneGraphPriority(evt, node)
    return evt
end
