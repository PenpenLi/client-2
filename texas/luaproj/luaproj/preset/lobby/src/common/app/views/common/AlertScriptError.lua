local UIHelper = require("app.common.UIHelper")
local AlertScriptError = class("AlertScriptError", cc.mvc.ViewCommon)

function AlertScriptError:ctor(options)
	AlertScriptError.super.ctor(self)
    local options = options or {}
    local descText = options.desc or ""
    local okCallback = options.okCallback

    local viewNode = cc.CSLoader:createNode("common/AlertScriptError.csb"):addTo(self)

    local labelContent = UIHelper.seekNodeByName(viewNode, "txtLog")
    labelContent:setString(descText)

	local btnOK = UIHelper.seekNodeByName(viewNode, "Button_Close")

    btnOK:addTouchEventListener(function(target, eType)
        if eType == ccui.TouchEventType.ended then
			self:removeSelf()
		end
    end)
end

function AlertScriptError:actionEnter()
    
end
return AlertScriptError