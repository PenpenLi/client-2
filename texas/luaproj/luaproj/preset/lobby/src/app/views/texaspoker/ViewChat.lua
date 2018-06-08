local utils = require("utils")
local UIHelper = require("app.common.UIHelper")
local LeftBaseLayer = require("app.views.common.LeftBaseLayer")
local ViewChat = class("ViewChat", LeftBaseLayer)
local CMD = require("app.net.CMD")

--ViewChat.RECORD = {
--	{fromId = 1, nickName = "test1111", text = "你好好的得得得1"},
--	{fromId = 2, nickName = "test2222", text = "你得得1"},
--	{fromId = 3, nickName = "test3333", text = "你好好的得得得2的范德萨发的的范德萨发的的发生发的"},
--	{fromId = 4, nickName = "test4444", text = "得得得2的范德萨发的的范德"},
--	{fromId = 4, nickName = "test444dd4", text = "dddddddddddddddddddddddddfdsfdsfdsfsdffffffffffff"},
--	{fromId = 4, nickName = "test44ss44", text = "dfdsdfdsfd范德萨发得分反反复复sfd"},
--	{fromId = 4, nickName = "test4444", text = "得得得2的范德萨发的的fdsfdsf范德"},
--	{fromId = 4, nickName = "test444ddd4", text = "得得得2的范德萨发的的范德dsfdsfds"},
--	{fromId = 4, nickName = "test444ddd4", text = "得得得2的范德萨发的的范德dsfdsfds"},
--	{fromId = 4, nickName = "test444ddd4", text = "得得得2的范德萨发的的范德dsfdsfds"},
--    {fromId = 4, nickName = "test444ddd4", text = "face_default_2"},
--    {fromId = 4, nickName = "test444ddd4", text = "face_default_5"},
--}


ViewChat.CHATITEM_ANCH_ME = display.RIGHT_TOP
ViewChat.CHATITEM_ANCH_OTHER = display.LEFT_TOP

ViewChat.CHATITEM_POSX_ME = 500
ViewChat.CHATITEM_POSX_OTHER = 70

local faceTotalNum = 23


---重写父类actionExit
function ViewChat:actionExit()
	self:runAction(
		cc.Sequence:create(
			cc.EaseSineOut:create(
				cc.MoveTo:create(0.2, cc.p(0, 0))
			),
            cc.CallFunc:create(function()
                self:setVisible(false)
            end)
			))
end

function ViewChat:ctor()
	ViewChat.super.ctor(self)

	addListener(self, "NET_MSG", handler(self, self.onMsg));


	self.recordY = 50

	local csbnode = cc.CSLoader:createNode("cocostudio/game/ChatLayer.csb")
	csbnode:addTo(self)
    local CheckBox_Word = csbnode:getChildByName("CheckBox_Word") 
    local CheckBox_Emoji = csbnode:getChildByName("CheckBox_Emoji")

    local function checkBoxEvent(sender,eventType)
        if sender == CheckBox_Emoji then 
            CheckBox_Word:setSelected(false)
            CheckBox_Emoji:setSelected(true)
            if self.bChatSelected == true then 
                self.bChatSelected = false
                self:selectFaceChat(true)
            end 
        else
            CheckBox_Word:setSelected(true)
            CheckBox_Emoji:setSelected(false)
            if self.bChatSelected == false then 
                self.bChatSelected = true
                self:selectFaceChat(false)
            end 
        end

    end 

    CheckBox_Emoji:addEventListener(checkBoxEvent)
    CheckBox_Word:addEventListener(checkBoxEvent)

    
    self.scroll_ChatRecord = UIHelper.seekNodeByName(csbnode, "ScrollView_ChatRecord")
	self.scroll_ChatRecord:setScrollBarEnabled(false)

    self.Panel_default = csbnode:getChildByName("Panel_default")
    self.Panel_chatRecord = csbnode:getChildByName("Panel_chatRecord")

    local Button_Send = csbnode:getChildByName("Button_Send")
    Button_Send:addTouchEventListener(function (sender,touchType)
        if ccui.TouchEventType.ended == touchType then 
            local str = self.TextField_Input:getString()
            if str ~= "" then 
                self:sendCustomChat(str)
                self.TextField_Input:setString("")
            end
        end 
    end)


	self:initChatRecord()
    self:initPreChatMsg()
    self:initFaceTableView()
    self:initInputText(csbnode)

    CheckBox_Emoji:setSelected(false)
    CheckBox_Word:setSelected(true)
    self.bChatSelected = true
    self:selectFaceChat(false)
end

function ViewChat:onEnter()
    ViewChat.super.onEnter(self)
end

function ViewChat:onExit()
    if self.PreChatMsgCell then 
        self.PreChatMsgCell:release()
    end
    if self.faceCell then 
        self.faceCell:release()
    end

    ViewChat.super.onExit(self)
end

function ViewChat:initInputText(csbnode)
    local TextField_Input = csbnode:getChildByName("TextField_Input")
--    TextField_Input:addEventListener(function (sender,eventType)
--        if eventType ==ccui.TextFiledEventType.attach_with_ime then
--            print("TextFiledEventType.attach_with_ime")
--        elseif eventType == ccui.TextFiledEventType.detach_with_ime then 
--               print("TextFiledEventType.detach_with_ime")
--         elseif eventType == ccui.TextFiledEventType.delete_backward then 
--             print("TextFiledEventType.delete_backward")
--          elseif eventType == ccui.TextFiledEventType.insert_text then 
--             print("TextFiledEventType.insert_text")
--        end
--    end)
    self.TextField_Input = TextField_Input
end

function ViewChat:selectFaceChat(bSelete)
    if bSelete then 
        self.preMsgView:setVisible(false)
        self.faceTableView:setVisible(true)
    else
        self.preMsgView:setVisible(true)
        self.faceTableView:setVisible(false)
    end
end


function ViewChat:initPreChatMsg()
    self.PreChatMsgData = APP.GD.LANG.CHAT_MSG

    local size = self.Panel_default:getContentSize()
    local preMsgView = cc.TableView:create(size)  
    preMsgView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)      
    preMsgView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)  
    --preMsgView:setColor(cc.c4f(255,0,0,255))
   -- preMsgView:setPosition(cc.p(size.width/2,size.height/2))  
    preMsgView:setDelegate()  
    self.Panel_default:addChild(preMsgView)  

    preMsgView:registerScriptHandler(handler(self,ViewChat.PreChatMsgCellTouched), cc.TABLECELL_TOUCHED)  
    preMsgView:registerScriptHandler(handler(self,ViewChat.PreChatMsgSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)  
    preMsgView:registerScriptHandler(handler(self,ViewChat.PreChatMsgCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)  
    preMsgView:registerScriptHandler(handler(self,ViewChat.PreChatMsgNumberOfCell), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) 

    preMsgView:reloadData()
    self.preMsgView = preMsgView
end

function ViewChat:createPreChatMsgCell(data)

    if self.PreChatMsgCell == nil then 
        local csbnode = cc.CSLoader:createNode("cocostudio/game/ChatPreMsgNode.csb")
        local Panel_cell = csbnode:getChildByName("Panel_cell")
        Panel_cell:retain()
        Panel_cell:removeFromParent()
        self.PreChatMsgCell = Panel_cell;
    end 
    local preChatMsgCell = self.PreChatMsgCell:clone()
    local Text_msg = preChatMsgCell:getChildByName("Text_msg")
    Text_msg:setString(data)
    local cell = cc.TableViewCell:new() 

    local size = preChatMsgCell:getContentSize()
    preChatMsgCell:setPosition(cc.p(size.width/2,size.height/2))

    preChatMsgCell:setSwallowTouches(false)
    preChatMsgCell:addTouchEventListener(handler(self,ViewChat.PreChatSendTouch))

    cell:addChild(preChatMsgCell)

    return cell

end

function ViewChat:PreChatSendTouch(send,touchTpye)
    if touchTpye == ccui.TouchEventType.moved then 
        self._touchMoved = true
    elseif touchTpye == ccui.TouchEventType.ended then 
        if self._touchMoved == false then 
            self:sendPreChat(send:getParent():getTag())
        else
            self._touchMoved = false 
        end
    else
        self._touchMoved = false
    end 
end 


function ViewChat:PreChatMsgCellTouched(view,cell)
    local idx = cell:getTag()
    print ("PreChatMsgCellTouched"..idx)
end

function ViewChat:PreChatMsgSizeForTable(view, idx)
    return 566,60
end

function ViewChat:PreChatMsgCellAtIndex(view, idx)
    idx = idx + 1

    local cell = view:dequeueCell()
    if nil == cell then 
        cell = self:createPreChatMsgCell(self.PreChatMsgData[idx])

    else
        local Text_msg = UIHelper.seekNodeByName(cell, "Text_msg")
        Text_msg:setString(self.PreChatMsgData[idx])
    end
    cell:setTag(idx)
    return cell
end

function ViewChat:PreChatMsgNumberOfCell(view)
    local num = #self.PreChatMsgData
    return num
end



function ViewChat:initFaceTableView()

    local size = self.Panel_default:getContentSize()
    local faceTableView = cc.TableView:create(size)  
    faceTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)      
    faceTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)   
    faceTableView:setDelegate()  
    self.Panel_default:addChild(faceTableView)  

    faceTableView:registerScriptHandler(handler(self,ViewChat.faceCellTouched), cc.TABLECELL_TOUCHED)  
    faceTableView:registerScriptHandler(handler(self,ViewChat.faceSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)  
    faceTableView:registerScriptHandler(handler(self,ViewChat.faceCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)  
    faceTableView:registerScriptHandler(handler(self,ViewChat.faceNumberOfCell), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) 

    faceTableView:reloadData()
    self.faceTableView = faceTableView
end

function ViewChat:createfaceCell(idx)

    if self.faceCell == nil then 
        local csbnode = cc.CSLoader:createNode("cocostudio/game/ChatFaceNode.csb")
        local Panel_cell = csbnode:getChildByName("Panel_cell")
        Panel_cell:retain()
        Panel_cell:removeFromParent()
        self.faceCell = Panel_cell;
    end 
    local faceCell = self.faceCell:clone()
    self:fillFaceIcon(faceCell,idx)
    local cell = cc.TableViewCell:new() 

    local size = faceCell:getContentSize()
    faceCell:setPosition(cc.p(size.width/2,size.height/2))

    cell:addChild(faceCell)

    return cell

end

function ViewChat:fillFaceIcon(cell,idx)
    
    local from = (idx - 1) * 5 + 1
    local to = 5 * idx 
    --to = to <= faceTotalNum and to or faceTotalNum
    for var = from ,to  do
        local img_idx = (var - 1) % 5 + 1 
        local img = cell:getChildByName("Image_face_"..img_idx)
        if var <= faceTotalNum then 
            img:setVisible(true)
           
            local img_path = string.format("cocostudio/game/image/chat/face/face_default_%d.png",var)
            print (img_path)
            img:loadTexture(img_path,ccui.TextureResType.localType)
            img:setTag(var)
            img:addTouchEventListener(handler(self,ViewChat.faceSendTouch))
            img:setSwallowTouches(false)

        else
            img:setVisible(false)
        end
    end
end

function ViewChat:faceSendTouch(send,touchTpye)
    if touchTpye == ccui.TouchEventType.moved then 
        self._touchMoved = true
    elseif touchTpye == ccui.TouchEventType.ended then 
        if self._touchMoved == false then 
            self:sendFace(send:getTag())
        else
            self._touchMoved = true
        end 
    else 
        self._touchMoved = false
    end 
end 


function ViewChat:faceCellTouched(view,cell)
    local idx = cell:getTag()
    print ("faceCellTouched"..idx)
end

function ViewChat:faceSizeForTable(view, idx)
    return 566,80
end

function ViewChat:faceCellAtIndex(view, idx)
    idx = idx + 1

    local cell = view:dequeueCell()
    print("view idx = "..idx)
    if nil == cell then 
        cell = self:createfaceCell(idx)

    else
        local Panel_cell = UIHelper.seekNodeByName(cell, "Panel_cell")
        self:fillFaceIcon(Panel_cell,idx)
    end
    cell:setTag(idx)
    return cell
end

function ViewChat:faceNumberOfCell(view)
    local num = math.ceil(faceTotalNum / 5)
    return num
end


function ViewChat:initChatRecord()
    
    
	local contrainerLayer = cc.Layer:create()
    local size = self.scroll_ChatRecord:getContentSize()
    contrainerLayer:setContentSize(size)
    self.contrainerLayer = contrainerLayer
    contrainerLayer:setAnchorPoint(cc.p(0,0))
    --self.scroll_ChatRecord:getInnerContainer()
	self.scroll_ChatRecord:addChild(contrainerLayer)
    --self:addChatRecords(ViewChat.RECORD)
end

function ViewChat:addChatRecords(data)
    
	for i = 1, #data do
		local chat = data[i]
		local chatNode = display.newNode()
			:addTo(self.contrainerLayer)
			:move(0, - self.recordY)
        
        local players = APP.GD.room_players
	    local player = players:getPlayerByUid(chat.fromId)

        local head_ico =player and player.head_ico or 0
        head_ico = head_ico + 1
	    local head = ccui.ImageView:create(string.format("cocostudio/game/image/head_%d.png", head_ico or 1))
			:addTo(chatNode, 2)
		head:setScale(0.7)

		local name = ccui.Text:create(chat.nickName, "Arial", 22)
			:addTo(chatNode)


        local offsetY = 0
        local l,m = string.find(chat.text,"face_default_")
        local bFace = l == 1
        local textSize = nil
        local bg = nil
        -- 判断是否自己
        local meInfo = APP.gc:getMe()

		if meInfo.uid == chat.fromId then
			head:align(display.LEFT_CENTER, ViewChat.CHATITEM_POSX_ME - 25, -10)
			name:align(display.RIGHT_CENTER, ViewChat.CHATITEM_POSX_ME - 50, 15)
            if bFace then 
                local faceImg = ccui.ImageView:create()
                faceImg:ignoreContentAdaptWithSize(false)
                faceImg:loadTexture(string.format("cocostudio/game/image/chat/face/%s.png",chat.text),ccui.TextureResType.localType)
                faceImg:align(ViewChat.CHATITEM_ANCH_ME, ViewChat.CHATITEM_POSX_ME - 50, -5)
                textSize = cc.size(40,40)
                faceImg:setContentSize(textSize)
                chatNode:addChild(faceImg,1)
            else
                local text_Content = cc.Label:createWithSystemFont(utils.checkStr(chat.text, 24), "Arial", 20)
	                    :addTo(chatNode, 1)
	            textSize = text_Content:getContentSize()
			    text_Content:align(ViewChat.CHATITEM_ANCH_ME, ViewChat.CHATITEM_POSX_ME - 50, -5)
                text_Content:setColor(cc.c4b(10,10,10,255))

            end
		    bg = ccui.Scale9Sprite:create(cc.rect(16, 20, 16, 5), "cocostudio/game/image/chat/chat_bg_my.png")
			    :addTo(chatNode)
			    :align(ViewChat.CHATITEM_ANCH_ME, ViewChat.CHATITEM_POSX_ME - 25, 0)
		    bg:setFlippedX(true)
		else
            if bFace then 
                local faceImg = ccui.ImageView:create()
                faceImg:ignoreContentAdaptWithSize(false)
                faceImg:loadTexture(string.format("cocostudio/game/image/chat/face/%s.png",chat.text),ccui.TextureResType.localType)
                faceImg:align(ViewChat.CHATITEM_ANCH_OTHER, ViewChat.CHATITEM_POSX_OTHER + 50, -5)
                textSize = cc.size(40,40)
                faceImg:setContentSize(textSize)
                chatNode:addChild(faceImg,1)               
            else
                local text_Content = cc.Label:createWithSystemFont(utils.checkStr(chat.text, 24), "Arial", 20)
	                    :addTo(chatNode, 1)
                textSize = text_Content:getContentSize()
			    text_Content:align(ViewChat.CHATITEM_ANCH_OTHER, ViewChat.CHATITEM_POSX_OTHER + 50, -5)

            end
			head:align(display.RIGHT_CENTER, ViewChat.CHATITEM_POSX_OTHER + 25, -10)
			name:align(display.LEFT_CENTER, ViewChat.CHATITEM_POSX_OTHER + 50, 15)
    	    bg = ccui.Scale9Sprite:create(cc.rect(16, 20, 16, 5), "cocostudio/game/image/chat/chat_bg_other.png")
		    :addTo(chatNode)
		    :align(ViewChat.CHATITEM_ANCH_OTHER, ViewChat.CHATITEM_POSX_OTHER + 25, 0)
		end
        offsetY = textSize.height + 10 > 30 and textSize.height + 10 or 30
        bg:setContentSize(cc.size(textSize.width + 40,offsetY))
		self.recordY = self.recordY + offsetY + 60
	end
    local size = self.scroll_ChatRecord:getContentSize()
    local offsetY = self.recordY
    if self.recordY < size.height then 
        offsetY = size.height
    end
    self.contrainerLayer:setPosition(cc.p(0, offsetY))
	self.scroll_ChatRecord:setInnerContainerSize(cc.size(self.contrainerLayer:getContentSize().width, offsetY))

    self.scroll_ChatRecord:jumpToBottom()
    
end



-------------------------------------send-----------------------------------------------
function ViewChat:sendPreChat(idx)
    print("sendPreChat"..self.PreChatMsgData[idx])
    local content = APP.GD.LANG.CHAT_MSG[idx]
    APP:getCurrentController():chat(content)
    self:actionExit()
end 

function ViewChat:sendFace(idx)
    print("sendFace"..string.format("face_default_%d.png",idx))
    local content = string.format("face_default_%d",idx)
    APP:getCurrentController():chat(content)
    self:actionExit()
end

function ViewChat:sendCustomChat(content)
    APP:getCurrentController():chat(content)    
end

function ViewChat:onMsg(fromServer, subCmd, content)
	if subCmd == CMD.GAME_CHAT_RESP then
        local msg = {
            fromId = content.from_uid_,
            nickName = content.nickname_,
            text = content.content_,
        }
        self:addChatRecords({msg})
	end
end

----------------------------------------------------------------------------------------
return ViewChat