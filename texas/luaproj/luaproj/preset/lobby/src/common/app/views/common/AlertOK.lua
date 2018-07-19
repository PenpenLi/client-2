local UIHelper = require("app.common.UIHelper")

local AlertOK = class("AlertOK", cc.mvc.ViewCommon)

function AlertOK:ctor(options)
	AlertOK.super.ctor(self)
    local options = options or {}
    local descText = options.desc or ""
    local okCallback = options.okCallback

    local viewNode = cc.CSLoader:createNode("common/AlertOKLayer.csb"):addTo(self)

    local imageTitle = UIHelper.seekNodeByName(viewNode, "Text_Title")
    if options.title then
        imageTitle:loadTexture(options.title)
    end

    local labelContent = UIHelper.seekNodeByName(viewNode, "Text_Content")
    labelContent:setString(descText)

    local btnOK = UIHelper.seekNodeByName(viewNode, "Button_Confirm")
    if options.ok then
        btnOK:loadTextures(options.ok.normal, options.ok.selected)
    end

    btnOK:addTouchEventListener(function(target, eType)
        if eType == ccui.TouchEventType.ended then
            if okCallback then
                okCallback()
            end
            self:actionExit()
        end
    end)

end

function AlertOK:actionEnter()
    
end

function AlertOK:actionExit()
    self:removeSelf()
end


return AlertOK