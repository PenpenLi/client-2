
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


print("app start!!")

cc.FileUtils:getInstance():setPopupNotify(false)

local pathWritable = cc.FileUtils:getInstance():getWritablePath();

--如果应用程序目录下没有main.lua,则从apk包里复制数据到应用程序目录
if not cc.FileUtils:getInstance():isFileExist(pathWritable.."main.lua") then
	local presetPackage = package.path;
	package.path = presetPackage .. "preset/?.lua;"
	--如果大厅目录下不存在版本文件,从assets里复制出来一份
	local vcp = require("VersionCompare");
	vcp:copy_dir("preset/", pathWritable);
	package.path = presetPackage;
end

require(pathWritable.."main");