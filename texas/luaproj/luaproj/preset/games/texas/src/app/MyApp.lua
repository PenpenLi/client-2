local MyApp = class("MyApp", cc.mvc.MyAppBase)

local GameSpecificHandlers = g_Require("app.handlers.GameSpecificHandlers");
local GameCommonHandlers = g_Require("app.handlers.GameCommonHandlers")

function MyApp:ctor()
	MyApp.super.ctor(self)
	log_filter = {};
	log_filter.enable = 1;
    --设置日志显示级别
    --log_filter["a"] = 1;
    --log_filter["dump"] = 1;
	--log_filter["net"] = 1;
	log_filter["clean"] = 1;
end

function MyApp:run()
	MyApp.super.run(self)

	GameCommonHandlers.active();
	GameSpecificHandlers.active();
end

function MyApp:dtor()
	MyApp.super.dtor(self)
	
	GameSpecificHandlers.deactive();
	GameCommonHandlers.deactive();
end

return MyApp
