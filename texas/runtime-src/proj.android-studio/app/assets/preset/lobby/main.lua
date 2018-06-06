


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

switchContex("lobby/")

package.path = package.path .. "src_framework/?.lua;"
package.path = package.path .. "common/src/?.lua;"

require "config"
require "cocos.init"

-- mvc
cc.mvc = require("packages.mvc.init")
print("mvc !!!")


function babe_tostring(...)
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

local function main()
	local app = require("app.MyApp").new();
	app:run();
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
