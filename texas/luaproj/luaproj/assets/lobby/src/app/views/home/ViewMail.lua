local GameConfig = require("app.common.GameConfig")
local UIHelper = require("app.common.UIHelper")
local ViewMail = class("ViewMail", cc.mvc.ViewBase)

function ViewMail:ctor()
    ViewMail.super.ctor(self)

    local  csbnode = cc.CSLoader:createNode("cocostudio/home/MailLayer.csb")
        :addTo(self)

 

end

function ViewMail:onEnter()
    ViewMail.super.onEnter(self)

end

function ViewMail:onExit()
   ViewMail.super.onExit(self)
end

return ViewMail