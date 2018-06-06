local UIHelper = require("app.common.UIHelper")

--[[ 
options:
{
    desc = "xxx",
    okCallback = xx,
    cancelCallback = xx,
    title = "",
    ok = {normal = "", selected = ""},
    cancel = {normal = "", selected = ""}
}
]]--

local AlertOKCancel = class("AlertOKCancel", function()
    return display.newNode()
end)

function AlertOKCancel:ctor(options)
    local options = options or {}
    local descText = options.desc or ""
    local okCallback = options.okCallback
    local cancelCallback = options.cancelCallback

    local viewNode = cc.CSLoader:createNode("cocostudio/common/AlertOKCancelLayer.csb"):addTo(self)

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
        elseif eType == ccui.TouchEventType.began then
            
        end
    end)

    local btnCancel = UIHelper.seekNodeByName(viewNode, "Button_Cancel")
    if options.cancel then
        btnOK:loadTextures(options.cancel.normal, options.cancel.selected)
    end

    btnCancel:addTouchEventListener(function(target, eType)
        if eType == ccui.TouchEventType.ended then
            if cancelCallback then
                cancelCallback()
            end
            self:actionExit()
        elseif eType == ccui.TouchEventType.began then
            
        end
    end)

end

function AlertOKCancel:actionEnter()
    
end

function AlertOKCancel:actionExit()
    self:removeSelf()
end


return AlertOKCancel