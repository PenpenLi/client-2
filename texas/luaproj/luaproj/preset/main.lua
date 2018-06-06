
local contex = nil;

--�л���Ϸ����,
--·�������ȼ�,����ʹ��ִ����·��,����ȸ���·���²�������Դ,��ʹ��assets·���µ���Դ
--��������ҪΪ�˽��IOS�е���Դ��Ҫ������ipa����,�ȸ����ֲ��ܸ���ipa���е������������.
local presetPackage = package.path;
function switchContex(newContex)
	if contex == newContex then return end;
	--����ȫ�ֱ���

	--��������·��
	local tb = cc.FileUtils:getInstance():getSearchPaths();
	if contex then 
		table.removebyvalue(tb, contex);
		table.removebyvalue(tb, contex .. "res/");
		table.removebyvalue(tb, contex .. "../common/res/");
	end
	
	contex = newContex;
	table.insert(tb, contex);
	table.insert(tb, contex .. "res/");
	table.insert(tb, contex .. "../common/res/");

	package.path = presetPackage;
	package.path = package.path..contex .. "?.lua;"
	package.path = package.path..contex .. "src/?.lua;"

	cc.FileUtils:getInstance():setSearchPaths(tb);
end
local pathWritable = cc.FileUtils:getInstance():getWritablePath();
switchContex(pathWritable.."lobby/")
package.path = package.path .. pathWritable.."src_framework/?.lua;"
package.path = package.path .. pathWritable.."common/src/?.lua;"

require "config"
require "cocos.init"

-- mvc
cc.mvc = require("packages.mvc.init")
print("mvc !!!")

local function main()
	local app = require("app.MyApp").new();
	app:run();
end

__G__TRACKBACK__ = function(msg)
    local msg = debug.traceback(msg, 3)
	print("msg");
	local pa = cc.FileUtils:getInstance():getWritablePath();
	io.writefile(pa.."runlog.log", "[" ..os.date("%Y-%m-%d %H:%M:%S", os.time()) .. "]" .. msg .. "\r\n", "a");
	local desc = APP.GD.LANG.UI_SCRIPT_ERROR;
	if APP:getCurrentController() then
		APP:getCurrentController():showAlertOK({desc = desc});
	end
    return msg
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
