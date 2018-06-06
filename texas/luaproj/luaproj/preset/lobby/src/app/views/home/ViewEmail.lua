--region *.lua
--Date
--WuShaoMing
--此文件由[BabeLua]插件自动生成
--endregion
local CMD = require("app.net.CMD")
local utils = require("app.common.utils")
local UIHelper = require("app.common.UIHelper")
local PopBaseLayer = require("app.views.common.PopBaseLayer")

local ViewEmail = class("ViewEmail",cc.mvc.ViewBase)

function ViewEmail:ctor()
    ViewEmail.super.ctor(self)

	local csbnode = cc.CSLoader:createNode("cocostudio/home/MailLayer.csb")
	csbnode:addTo(self)

    local Panel_email = csbnode:getChildByName("Panel_email")
    self:initMailView(Panel_email)
end

function ViewEmail:onEnter()
    ViewEmail.super.onEnter(self)
end

function ViewEmail:onExit()
    ViewEmail.super.onExit(self)
end
function ViewEmail:initMailView(Panel_email)
    local size = Panel_email:getContentSize()

    local emailTableView = cc.TableView:create(size) 
                                 :align(display.CENTER,0,0)
    emailTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)      
    emailTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)   
    emailTableView:setDelegate()  
    Panel_email:addChild(emailTableView)  

    emailTableView:registerScriptHandler(handler(self,ViewEmail.mailCellTouched), cc.TABLECELL_TOUCHED)  
    emailTableView:registerScriptHandler(handler(self,ViewEmail.mailSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)  
    emailTableView:registerScriptHandler(handler(self,ViewEmail.mailCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)  
    emailTableView:registerScriptHandler(handler(self,ViewEmail.mailNumberOfCell), cc.NUMBER_OF_CELLS_IN_TABLEVIEW) 


    emailTableView:reloadData()
    self.emailTableView = emailTableView
end

function ViewEmail:mailCellTouched(view,cell)

end

function ViewEmail:mailSizeForTable(view, idx)
    return 626,152
end

function ViewEmail:mailCellAtIndex(view, idx)
    idx = idx + 1
    local cell = view:dequeueCell()
    if nil == cell then 
        cell = cc.TableViewCell:new() 
        self:createViewCell(self.dataList[idx])
            :addTo(cell)
            :align(display.CENTER,626 * 0.5,152 * 0.5)

    else
        self:updataViewCell(cell,dataList[idx])
    end
    cell:setTag(idx)
    return cell
end

function ViewEmail:mailNumberOfCell(view)
    return self.dataListNum
end

function ViewEmail:createViewCell(data)
    if not self.mailCell then 
        local csbnode = cc.CSLoader:createNode("cocostudio/home/MailNode.csb")
        self.mailCell = csbnode:getChildByName("bg")
        self.mailCell:retain()
        self.mailCell:removeFromParent()
    end
    local cell = self.mailCell:clone()
    self:updataViewCell(cell,data)
    return cell
end

function ViewEmail:btnTouchEvent(sender,eventType)
    if ccui.TouchEventType.ended == eventType then 
        if self.bMove == false then 
            print("btnTouchEvent"..sender:getTag())
        end
    elseif ccui.TouchEventType.moved == eventType then 
        self.bMove = true
    else
        self.bMove = false
    end
end

function ViewEmail:updataViewCell(cell,data)
    local Text_content = UIHelper.seekNodeByName(cell,"Text_content")
    Text_content:setString(utils.checkStr(data.title, 20))
    local Text_date = UIHelper:seekNodeByName(cell,"Text_date")
    local Y,M,D = utils.date
    Text_date:setString(string.format("%d月%d日",M,D))
    local Btn_get = UIHelper:seekNodeByName(cell,"Btn_get")
    Btn_get:addTouchEventListener( function(sender , eventType)
        if ccui.TouchEventType.ended == eventType then 
            APP:getCurrentController():sendUserInfo(self.dataList[sender:getTag()])
        end
    
    end)
end

function ViewEmail:reloadList()
    local gameUser = APP.GD.GameUser
    self.dataList = {}
    self.dataListNum = 0
    for k,v in pairs(gameUser:getMailList()) do
        if v then 
             self.dataListNum =  self.dataListNum + 1
            table.insert(self.dataList,v)
        end 
    end
    self.emailTableView:reloadData()
end


function ViewEmail:onMsg(fromServer, subCmd, content)
    if fromServer ~= GameConfig.ID_COORDINATESERVER  then 
        return 
    end
	if subCmd == CMD.GAME_USER_MAIL_LIST_RESP or subCmd == CMD.GAME_USER_MAIL_OP_RESP  then
        self:reloadList()
    end
end

return ViewEmail