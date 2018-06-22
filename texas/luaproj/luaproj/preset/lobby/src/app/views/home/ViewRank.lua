--local GameConfig = require("app.common.GameConfig")
local UIHelper = require("app.common.UIHelper")
--local PopBaseLayer = require("app.views.common.PopBaseLayer")
--local ViewRank = class("ViewRank", PopBaseLayer)
local ViewRank = class("ViewRank",cc.mvc.ViewBase);
local headIcons = require("app.common.GameConfig")

function ViewRank:ctor()
    ViewRank.super.ctor(self)
    self.csbnode = cc.CSLoader:createNode("cocostudio/home/Rank.csb")
        :addTo(self)
    self.csbnode:setScale(0.01)
    self.rankIndex = 0
    self.rankType = 0
    local btn_closex = UIHelper.seekNodeByName( self.csbnode,"Btn_close")
    btn_closex:addTouchEventListener(function (ref,t)
        if t == ccui.TouchEventType.ended then 
            self:removeSelf()
        end 
    end)


  

    self._listView = UIHelper.seekNodeByName( self.csbnode,"ListView_rank")

    local listViewNode = UIHelper.seekNodeByName( self.csbnode,"Panel_rank_node")  
    self.listViewNode = listViewNode
    self.rankInfoTable ={} 
    APP.hc:ReqRankData(0) 

    self.Check_left = UIHelper.seekNodeByName( self.csbnode,"Check_1")
    self.Check_left:setSelected(true)
    self.Check_left:addTouchEventListener(function (sender,evt) 
          if evt == ccui.TouchEventType.ended  then
            
          
            self:checkEvent(sender) 
          -- self.rankIndex = 0
           -- self._listView:removeAllChildren()
            
            APP.hc:ReqRankData(0)
            
          end
    end)

    self.Check_right = UIHelper.seekNodeByName( self.csbnode,"Check_2")
    self.Check_right:setSelected(false)
    self.Check_right:addTouchEventListener(function (sender,evt)
		if evt == ccui.TouchEventType.ended  and self.Check_right:isSelected()== false then
			self:checkEvent(sender)
			APP.hc:ReqRankData(1)
		end
    end)
end

function ViewRank:onEnter()
    ViewRank.super.onEnter(self)  
    self.csbnode:runAction(cc.EaseBackInOut:create(cc.ScaleTo:create(0.15, 1)))
end

function ViewRank:onExit()
   self.item ={}
   ViewRank.super.onExit(self)

   self.csbnode:runAction(
		cc.Sequence:create(
			cc.EaseBackInOut:create(
				cc.ScaleTo:create(0.15, 0.01)
			), 
			cc.CallFunc:create(function()
				self:removeSelf()
			end)))
end



function ViewRank:upDateRankInfo(rankData) 
 
  if tonumber(rankData.tag) == 0 then 
       self.rankType = rankData.rank_type
       self.rankInfoTable ={} 
       self.rankIndex = 0
       self._listView:removeAllChildren()
  elseif  tonumber(rankData.tag) == 1 and self.rankType ~= rankData.rank_type then 
           return 
   end 
   
	table.insert(self.rankInfoTable,rankData)
	self.rankIndex = self.rankIndex+1;

    local rankNode = self.listViewNode:clone()
    local img_no = rankNode:getChildByName("Image_rank_n") 
    if(self.rankIndex<4)then 
		local img_no_str = string.format("cocostudio/home/image/Rank/rank_node%d.png",self.rankIndex)
		img_no:loadTexture(img_no_str) 
    else 
		img_no:setVisible(false)
    end 

    local img_head = rankNode:getChildByName("Image_head") 
    local img_head_str = string.format("image/%s", headIcons:HeadIco(rankData.head_ico))
 
    img_head:loadTexture(img_head_str)
     
    local  text_name = rankNode:getChildByName("Text_name")
    text_name:setString(tostring(rankData.uname))

    local  fnt_coin_number = rankNode:getChildByName("BitmapFontLabel_coin_number")

    fnt_coin_number:setString(rankData.data)
    
    self._listView:pushBackCustomItem(rankNode) 

end

function ViewRank:upDataMData(sel)
     
end

function ViewRank:checkEvent(sel)
    for i = 1, 2 do 
        local checkBtn = UIHelper.seekNodeByName(self.csbnode,"Check_"..tostring(i))
        if checkBtn ~=sel then 
            checkBtn:setSelected(false)
            checkBtn:setEnabled(true)
            else 
            checkBtn:setEnabled(false)
        end 
    end 
end 

return ViewRank