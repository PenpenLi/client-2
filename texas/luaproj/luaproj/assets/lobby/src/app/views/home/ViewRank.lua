local GameConfig = require("app.core.GameConfig")
local UIHelper = require("app.common.UIHelper")
local PopBaseLayer = require("app.views.common.PopBaseLayer")
local ViewRank = class("ViewRank", PopBaseLayer)

function ViewRank:ctor()
    ViewRank.super.ctor(self)

    local  csbnode = cc.CSLoader:createNode("cocostudio/home/MailLayer.csb")
        :addTo(self)


end

function ViewRank:onEnter()
    ViewRank.super.onEnter(self)
end

function ViewRank:onExit()
   ViewRank.super.onExit(self)
end

return ViewRank