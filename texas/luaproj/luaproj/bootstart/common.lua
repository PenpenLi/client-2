
local vcp = require("VersionCompare")
local utils = require("utils")

--先检查版本,再执行更新
function    installUpdate(vw, onSucc)
    local st, prog, progmax;
    vcp:install_update();
    local cor_182331 = 0;
	local sh1 = 0;
    sh1 = scheduler.scheduleGlobal(function()
        local st, prog, progmax = vcp:query_version_status();
        if cor_182331 == 0 then
            if vcp:is_working() == 1 then
                if st == 2 then
                    vw:updateProgress("正在更新...", prog, progmax);
                elseif st == 11 then
                    vw:updateProgress("正在校验文件...", 0, 0);  
				else
                    vw:updateProgress("正在移动文件...", 0, 0);
                end
            else
                cor_182331 = 1;
				vw:updateProgress("正在更新...", progmax, progmax);
            end
        elseif cor_182331 == 1 then
            scheduler.unscheduleGlobal(sh1);
			vcp:clean();
            --成功
            if st == 7 then
                onSucc();
            else
                vw:setError("更新失败,请尝试切换网络环境重试.");
            end
        end
    end, 0.1);
end

--检查版本
function	checkVersion(contex, localp, remotep, vw, onSucc)
	local per = 0;
	local sh_2121 = 0;
	sh_2121 = scheduler.scheduleGlobal(function()
		local chk = vcp:check_version(contex, localp, remotep);
		if chk ~= 0 then
			vw:updateProgress("正在进入游戏...", 100, 100);
			scheduler.unscheduleGlobal(sh_2121);
			--没有新版本
			if chk == 6 or get_cmdline("-debug") == "1" then
				vcp:clean();
				singleShot(0.1, onSucc);
			--有新版本
			elseif chk == 5 then
				installUpdate(vw, onSucc);
			--版本对比失败	
			elseif chk ~= 0 then
				vcp:clean();
				vw:setError("检查版本失败.");
			end
		else
			vw:updateProgress("正在进入游戏...", per, 100);
			per = per + 2;
		end
	end, 0.1);
end


function cc.Node:findChild(path)
	local dirs = utils.stringSplit(path, "/");
	local current = self;
	for k, v in ipairs(dirs) do
		local finded = false;
		for _, child in pairs(current:getChildren()) do
			local childName = child:getName();
			if  childName == v then
				current = child;
				finded = true;
				break;
			end
		end
		if not finded then
			return nil;
		end		
	end
	return current;
end

function findChild(path)
    local scene = APP:getCurrentController().UIContainer;
    if not path or path == "" then return scene end
    return scene and scene:findChild(path)
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
    return dispatcher:removeEventListener(evt);
end

function addListener(node, evtName, callback, prior)
    local evt = cc.EventListenerCustom:create(evtName,
    function(e)
        callback(unpack(e.param));
    end);
	
	prior = prior or 1;

    local dispatcher = cc.Director:getInstance():getEventDispatcher()
	if node then
		dispatcher:addEventListenerWithSceneGraphPriority(evt, node)
	else
		dispatcher:addEventListenerWithFixedPriority(evt, prior);
	end
    return evt
end

function singleShot(dur, func, ...)
	local taskid = 0;
	local params = {...}
	taskid = scheduler.scheduleGlobal(function()
		func();
		scheduler.unscheduleGlobal(taskid);
	end, dur);
	return taskid;
end

function touchHandler(callback)
	return function(sender, etype)
		if etype ~= ccui.TouchEventType.ended then return end;
		callback(sender, etype);
	end
end