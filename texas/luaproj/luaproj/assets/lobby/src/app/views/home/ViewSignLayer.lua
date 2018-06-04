local GameConfig = require("app.core.GameConfig")
local UIHelper = require("app.common.UIHelper")
local ViewSignLayer = class("ViewSignLayer", cc.mvc.ViewBase)

function ViewSignLayer:ctor(signInfoTable)
    ViewSignLayer.super.ctor(self)

    local  csbnode = cc.CSLoader:createNode("cocostudio/home/Sign.csb")
        :addTo(self)
        
    self.serial_days = signInfoTable.serial_days
    self.serial_state = signInfoTable.serial_state
    self.login_day = signInfoTable.login_day
    self.login_state = signInfoTable.login_state
    dump(signInfoTable) 

   
    local btn_Sure = UIHelper.seekNodeByName(csbnode, "Btn_sure")
	btn_Sure:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			--self:removeSelf()
            self:getAward()
		end
	end)
    ------------------------  test  --------------- 
    self.fullDaysN = 9 --满值天数
    self.serial_days = 3  --连续登入天数
    self.serial_state = 11 --登录奖励状态

    self.login_day = 4 --当前第几天
    -------------------------------------

   
   
   --美术资源给的是checkbox 看后面需求改
    for i = 1, 7 do
       local check_str = string.format("Btn_d%d",i)
       local check_coin = UIHelper.seekNodeByName(csbnode,check_str) 

       local sprite_str = string.format("Sprite_%d",i)
       sprite_shade = UIHelper.seekNodeByName(csbnode,sprite_str) 


       local sprite_got_str = string.format("Sprite_g_%d",i)
       sprite_got = UIHelper.seekNodeByName(csbnode,sprite_got_str)

       if i< self.serial_days+1 then 
           check_coin:setEnabled(false)

           sprite_shade:setVisible(true)
           sprite_got:setVisible(true)
       elseif(i == self.serial_days+1  )then
        
           sprite_shade:setVisible(false)
           sprite_got:setVisible(false)
          -- btn_coin:addTouchEventListener(function(ref, t)
		  -- if t == ccui.TouchEventType.ended then
			   -- self:getAward()         
           --     end 
	     --  end)
        else 
    
            check_coin:setEnabled(false)
            check_coin:setBright(true) 
            sprite_shade:setVisible(false)
            sprite_got:setVisible(false)
        end
    
    end 


    self._precent = self.serial_days*100/self.fullDaysN 
    local loadBar = UIHelper.seekNodeByName(csbnode,"LoadingBar_1")
    loadBar:setPercent(self._precent)

    --连续奖励 默认为0
    self.continuousAward = 0 
    local numberD =  self.serial_state
    local numberComplement = 0
    for i = 1,3 do
       local checkbox_award_str = string.format("CheckBox_%d",i)
       local checkbox_award = UIHelper.seekNodeByName(csbnode,checkbox_award_str)
       print("numberD=",numberD,"i=",i)
       
       numberComplement = numberD%10
        print("numberComplement=",numberComplement)
       if numberComplement == 0   then 
           checkbox_award:setSelected(false) 

           if(self.login_day == 3) then 
           self.continuousAward = 1
           elseif (self.login_day == 6) then
           self.continuousAward = 2
           elseif (self.login_day == 9) then
           self.continuousAward = 3
           end 
       else  
       print("  checkbox_award:setSelected(true)",checkbox_award_str)
           checkbox_award:setSelected(true)
       end

       --checkbox_award:setSelected(true)
       numberD = (numberD -numberD%10)/10
      
    end 

    print("=============== end")
end

function ViewSignLayer:onEnter()
    ViewSignLayer.super.onEnter(self)

end

function ViewSignLayer:onExit()
   ViewSignLayer.super.onExit(self)
end

 
function ViewSignLayer:getAward()
print("==============getAward==================")
 if(self.login_day - 1 == self.serial_days) then 
      APP.hc:retSignAward(0);
     print("retSignAward paraketer=",0)
    end 

  if self.continuousAward ~= 0 then
    print("retSignAward paraketer=",self.continuousAward)
      APP.hc:retSignAward(self.continuousAward)
  end 
     self:removeSelf()
--   print("gettttttttttttttttt",index) 
end


return ViewSignLayer