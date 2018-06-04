local GameConfig = require("app.common.GameConfig")
local UIHelper = require("app.common.UIHelper")
local ViewDailyTasks = class("ViewDailyTasks", cc.mvc.ViewBase)

function ViewDailyTasks:ctor()
    ViewDailyTasks.super.ctor(self)

    local  csbnode = cc.CSLoader:createNode("cocostudio/home/DailyTasks.csb")
        :addTo(self)



end

function ViewDailyTasks:onEnter()
    ViewDailyTasks.super.onEnter(self)
end

function ViewDailyTasks:onExit()
   ViewDailyTasks.super.onExit(self)
end

return ViewDailyTasks