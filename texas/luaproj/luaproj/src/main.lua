
cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"

-- mvc
cc.mvc = require("packages.mvc.init")
print("mvc !!!")

package.path = package.path .. ";src/?.lua"

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
    require("app.MyApp").new():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
