
local utils = require("utils")

local loadingFrame = class("Loading", function ()
    return ccui.Widget:create()
end);

-- 查找子节点
local function seekNodeByName(par, name)
	local node = par:getChildByName(name)
	if node then
		return node
	end

	if par:getChildrenCount() > 0 then
		local children = par:getChildren()
		for _, child in pairs(children) do
            if child then
            	local ret = seekNodeByName(child, name)
			    if ret then
				    return ret
			    end
            end
		end
	end
end

function loadingFrame:ctor()
	self.container = cc.CSLoader:createNode("splash/loader.csb"); 
	self.container:addTo(self)
end

function loadingFrame:updateProgress(desc, cur, max)
	local des = seekNodeByName(self.container, "txtDesc");
	local pct = seekNodeByName(self.container, "progress");
	if cur > max then
		cur = max;
	end

	if max == 0 then
		des:setString(desc);
	else
		pct:setPercent(math.ceil(cur * 100 / max));
		des:setString(desc..string.format("%s/%s", utils.convertNumberShortKM(cur), utils.convertNumberShortKM(max)));
	end
end

function loadingFrame:setError(err)
	local des = seekNodeByName(self.container, "txtError");
	des:setString(err);
end

return loadingFrame;
 