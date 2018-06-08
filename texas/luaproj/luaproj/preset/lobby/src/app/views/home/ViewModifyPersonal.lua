local GameConfig = require("app.common.GameConfig")
local CMD = require("app.net.CMD")
local UIHelper = require("app.common.UIHelper")
local LeftBaseLayer = require("app.views.common.LeftBaseLayer")
local ViewModifyPersonal = class("ViewModifyPersonal", LeftBaseLayer)

-- 头像数量
local HEAD_COUNT = 8

function ViewModifyPersonal:ctor()
	ViewModifyPersonal.super.ctor(self)

    addListener(self, "NET_MSG", handler(self, self.onMsg));

    local gameUser = APP.GD.GameUser
    local headID = tonumber(gameUser.head_pic) == 0 and 1 or tonumber(gameUser.head_pic)
	local csbnode = cc.CSLoader:createNode("cocostudio/home/ModifyPersonalLayer.csb")
	csbnode:addTo(self)
    local Node_head = csbnode:getChildByName("Node_head")
    self.Node_head = Node_head
    self.Image_SelectFrame = csbnode:getChildByName("Image_SelectFrame")

    self.TextField_Nickname = csbnode:getChildByName("TextField_Nickname")
    self.TextField_Nickname:setString(gameUser.uname)

    local Button_OK = csbnode:getChildByName("Button_OK")
    Button_OK:addTouchEventListener(handler(self,self.butTouchEvent))
    local children = Node_head:getChildren()
    for i,var in ipairs(children) do
        if i <= HEAD_COUNT then 
            if i == headID then 
                self.Image_SelectFrame:setPosition(var:getPosition())
            end
            var:addTouchEventListener(handler(self,self.ImageTouchEvent))
            var:setTag(i)
        else
            var:hide()
        end
    end
end

function ViewModifyPersonal:ImageTouchEvent(sender,touchType)
    if ccui.TouchEventType.ended == touchType then 
        self.head_id = sender:getTag()
        local children = self.Node_head:getChildren()
        local pos =cc.p(children[self.head_id]:getPosition())
        self.Image_SelectFrame:setPosition(pos)

    end
end

function ViewModifyPersonal:butTouchEvent(sender,touchType)
    self.bModify = false
    local gameUser = APP.GD.GameUser
    local newNick  = nil
    if ccui.TouchEventType.ended == touchType then 
        newNick = self.TextField_Nickname:getString()
        if newNick ~= "" and newNick ~= gameUser.uname then 
            self.bModify = true
        end

        if tonumber(gameUser.head_pic) ~= self.head_id then 
            self.bModify = true
        end
    end

    if self.bModify then 
        self:sendModife(self.head_id,newNick)
    end
end

--function ViewModifyPersonal:initInputText(csbnode)

----    TextField_Input:addEventListener(function (sender,eventType)
----        if eventType ==ccui.TextFiledEventType.attach_with_ime then
----            print("TextFiledEventType.attach_with_ime")
----        elseif eventType == ccui.TextFiledEventType.detach_with_ime then 
----               print("TextFiledEventType.detach_with_ime")
----         elseif eventType == ccui.TextFiledEventType.delete_backward then 
----             print("TextFiledEventType.delete_backward")
----          elseif eventType == ccui.TextFiledEventType.insert_text then 
----             print("TextFiledEventType.insert_text")
----        end
----    end)
--    self.TextField_Input = TextField_Input
--end

function ViewModifyPersonal:onEnter()
    ViewModifyPersonal.super.onEnter(self)
end

function ViewModifyPersonal:onExit()
    ViewModifyPersonal.super.onExit(self)
end

---------------------Net-----------------------
function ViewModifyPersonal:sendModife(headId,nickName)
    APP:getCurrentController():sendUserInfo(headId,nickName)
end

function ViewModifyPersonal:onMsg(fromServer, subCmd, content)
    if fromServer ~= GameConfig.ID_COORDINATESERVER  then 
        return 
    end
    local bRight = nil
	if subCmd == CMD.GAME_USERINFO_SET_RESP then
        local msg = {
            headId = content.head_ico_,
            nickName = content.nickname_,
        }
        bRight = true
--    elseif subCmd == CMD.COORDINATE_COMMOM_REPLY then 
--        local cmd = tonumber(content.rp_cmd_)
--        local err = tonumber(content.err_)
--        if cmd == CMD.GAME_CHAT_RES then 

--        end
	end
    if bRight then 
        self:removeFromParent()
    end
end




----------------------------------------------
return ViewModifyPersonal