--region *.lua
--endregion
cc.FileUtils:getInstance():setPopupNotify(false)
if not cc.FileUtils:getInstance():isFileExist("main.lua") then

--切换游戏环境,
--路径有优先级,优先使用执更新路径,如果热更新路径下不存在资源,才使用assets路径下的资源
--这样做主要为了解决IOS中的资源需要集成在ipa包中,热更新又不能更改ipa包中的内容这个问题.
local presetPackage = package.path;

package.path = presetPackage .. "assets/lobby/src/?.lua;"
--如果大厅目录下不存在版本文件,从assets里复制出来一份
local vcp = require("app.common.VersionCompare");
vcp:copy_dir("assets/", "./");

package.path = presetPackage;

require("lobby/main");
end