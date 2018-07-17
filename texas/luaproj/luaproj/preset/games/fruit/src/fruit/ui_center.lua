
local ctrl = createView("Game/center", "fruit/UILogic/Game/Center.csb", nil)

local _time2order = 
{
    {6,1},
    {11,2},
    {15,3},
    {18,4},
    {21,5},
    {61,86},
    {63,88},
    {66,90},
    {70,92},
    {75,94},
    {80,96},
    {90,98},
    {100,100},
}



function ctrl:show()
    self.LastBet = {}   --{pid,num}
    self.CurBet = {}    --{pid,num}
    self.TotalBet = {0,0,0,0,0,0,0,0}  --{total1,total2, total3, total4, total5, total6, total7, total8}
    self.Pos = 0        --1~24
    self.Result = 0     --1~8
    self.ResultPos = 0  --1~24
    self.List = {}      --序列
    self.Elapse = 0     --流逝时间
    self.BetIdx = 0     --当前投注大小 1~5
    self.AcceptBet = false      --是否接受下注
    self.Timer = {}     --重复下注定时器列表
    self.isCanRepeat = true
    return self:create()
end

function ctrl:onInit(node)
    self:hideAllText()
    self:resetBoard(false)

    --创建圆圈特效控件
    local csb = "fruit/UILogic/Game/Ring.csb"
    local ring = cc.CSLoader:createNode(csb)
    node:addChild(ring)
    local action = cc.CSLoader:createTimeline(csb)
    ring:runAction(action)
    action:gotoFrameAndPlay(0, true)
    ring:setVisible(false)
    self.Ring = ring

    --添加点击事件
    for i=1,8 do
        local r = node:findChild("r"..i)
        r:onClick(handler(self, self.onClickedBoard), 1, false, nil, nil, 0)
    end
end

--desc:隐藏所有文本控件
function ctrl:hideAllText()
    local node = self:getNode()
    if node then
        for i=1,8 do
            local r = node:findChild("r"..i)
            r:findChild("txtTotal"):setVisible(false)
            r:findChild("back"):setVisible(false)
            r:findChild("txtBet"):setVisible(false)
        end
    end
end

--desc:重置底板状态
--@is_accept    是否可接受押注
function ctrl:resetBoard(is_accept)
    local node = self:getNode()
    if node then
        local img = is_accept and "fruit/atlas/Game/img17.png" or "fruit/atlas/Game/img16.png"
        for i=1,8 do
            node:findChild("r"..i):loadTexture(img, 1)
        end
    end
end

--desc:清空下注控件
function ctrl:resetLayer()
    local node = self:getNode()
    if node then
        for i=1,8 do
            node:findChild("r"..i.."/layer"):removeAllChildren()
        end
    end
end

--desc:设置是否接受下注
--@is_accept     是否接受下注
function ctrl:setAcceptBet(is_accept)
    self.AcceptBet = is_accept
end

--desc:新一轮重置所有状态
function ctrl:reset()
    --重置数据
    self.LastBet = self.CurBet
    self.CurBet = {}
    self.TotalBet = {0,0,0,0,0,0,0,0}
    self.BetIdx = 0
    self.AcceptBet = true
    self.Timer = {}
    self.isCanRepeat = true
    --重置控件
    self:hideAllText()
    self:resetBoard(true)
    self:resetLayer()
end

--desc:时间百分比转换为序列百分比
function ctrl:convTime2Order(rate)
    rate = rate * 100
    rate = math.min(rate, 100)
    rate = math.max(rate, 0)

    local t1 = nil
    local t2 = nil
    for i=1,#_time2order do
        local t = _time2order[i]
        if rate <= t[1] then
            t2 = t
            t1 = _time2order[i-1]
            break
        end
    end
    if not t1 then
        t1 = {0, 0}
    end
    if not t2 then
        return 1
    end

    return (t1[2] + (t2[2] - t1[2]) * ((rate - t1[1]) / (t2[1] - t1[1]))) / 100
end

--desc:设置结果
function ctrl:setRandomResult(result)
    local node = self:getNode()
    if not node then
        return
    end

    self.Result = result
    
    local tmp = {3,6,5,8,7,2,1,4}
    --计算ResultPos
    local n = math.random(1,3)
    local x = 1
    local num = tonumber(result)
    for i=1,24 do
        local p = node:findChild("p"..i)
        if tmp[(i-1)%8+1] == num then
            if n == x then
                self.ResultPos = i
                break
            end
            x = x + 1
        end
    end
end

--desc:设置当前投注索引
function ctrl:setBetIndex(bet_idx)
    self.BetIdx = bet_idx
end

--desc:开始播放
function ctrl:startAnimation(left_time)
    local node = self:getNode()
    if not node then
        return
    end

    local elapse = Config.RandomTotalTime - tonumber(left_time)
    elapse = math.max(elapse, 0)
    self.Elapse = elapse
    --生成序列
    if self.Pos == 0 then
        self.Pos = math.random(1,24)
    end
    self.List = {}
    for i=self.Pos,24 do
        table.insert(self.List, i)
    end
    for j=1,3 do
        for i=1,24 do
            table.insert(self.List, i)
        end
    end
    for i=1,self.ResultPos do
        table.insert(self.List, i)
    end
    --添加定时器
    node:schedule(handler(self, self.update), 0, "center.update")
end

--desc:停止动画
--@force_pos    是否强制固定终点位置
function ctrl:stopAnimation(force_pos)
    local node = self:getNode()
    if node then
        node:unschedule("center.update")
        if force_pos then
            local p = node:findChild("p"..self.ResultPos)
            self.Ring:setPosition(p:getPosition())
            self.Ring:setVisible(true)
            self.Pos = self.ResultPos
        end
    end
end

--desc:定时器更新函数
--@dt   流逝时间间隔
function ctrl:update(dt)
    local node = self:getNode()

    self.Elapse = self.Elapse + dt
    local rate = self.Elapse / Config.RandomTotalTime
    rate = self:convTime2Order(rate)
    local idx = math.ceil(#self.List * rate)
    idx = self.List[idx]
    local p = node:findChild("p"..idx)
    self.Ring:setPosition(p:getPosition())
    self.Ring:setVisible(true)
    self.Pos = idx

    if self.TmpPos ~= self.Pos then
        self.TmpPos = self.Pos
        sound.playRandomEffect()
    end

    if self.Elapse >= Config.RandomTotalTime then
        self:stopAnimation(true)
        sound.playRewardEffect()
    end
end

function ctrl:onClickedBoard(sender)
    if not self.AcceptBet then
        return
    end
    if self.BetIdx < 1 or self.BetIdx > 5 then
        msgup.show("请选择押注大小！")
        return
    end
    
    --判断钱是否足够
    local gold = tonumber(Game.Player.Gold)
    if not gold or gold < Config.Bets[self.BetIdx] then
        msgbox.showOk("您的K豆不足，无法押注，请充值!", Platform.Recharge, 1)
        return
    end

    local idx = tonumber(string.sub(sender:getName(), -1, -1))
    sound.playBetEffect()
    SendSetBetsReq(self.BetIdx, idx)
end

function ctrl:addBoardBetImage(board_idx, bet_idx, total)
    local node = self:getNode()
    if not node then
        ccerr("node 尚未创建！")
        return
    end

    local img_config = 
    {
        "fruit/atlas/Game/img45.png",
        "fruit/atlas/Game/img46.png",
        "fruit/atlas/Game/img47.png",
        "fruit/atlas/Game/img48.png",
        "fruit/atlas/Game/img49.png",
    }
    local layer = node:findChild(string.format("r%d/layer", board_idx))
    local sprite = cc.Sprite:create()
    local sz = layer:getContentSize()
    local ss = cc.size(36, 37)
    sprite:setSpriteFrame(img_config[bet_idx])
    local x = ss.width / 2 + math.random(0, sz.width - ss.width)
    local y = ss.height / 2 + math.random(0, sz.height - ss.height)
    sprite:setPosition(cc.p(x, y))
    layer:addChild(sprite)

    self.TotalBet[board_idx] = total
    ctrl:refreshLable(board_idx)
end

function ctrl:addBoardBetSelf(board_idx, bet_val)
    table.insert(self.CurBet, {board_idx, bet_val})
    ctrl:refreshLable(board_idx)
end

--desc:自己是否下过注
function ctrl:isSelfSetBet()
    return #self.CurBet > 0
end

function ctrl:refreshLable(board_idx)
    local node = self:getNode()
    if not node then
        return
    end
    local r = node:findChild(string.format("r%d", board_idx))

    local txtTotal = r:findChild("txtTotal")
    local total_val = self.TotalBet[board_idx]
    txtTotal:setString(GetShortGoldString(total_val))
    txtTotal:setVisible(total_val > 0)

    local self_val = 0
    for i=1,#self.CurBet do
        local t = self.CurBet[i]
        if t[1] == board_idx then
            self_val = self_val + t[2]
        end
    end
    local txtBet = r:findChild("txtBet")
    txtBet:setString(GetShortGoldString(self_val))
    txtBet:setVisible(self_val > 0)
    r:findChild("back"):setVisible(self_val > 0)

    --更新界面底板
    if self_val > 0 then
        r:loadTexture("fruit/atlas/Game/img18.png", 1)
    end
end

--desc:重复上轮下注
function ctrl:onRepeatSetBets()
    local node = self:getNode()
    if self.isCanRepeat then
        self.isCanRepeat = false
    end
    self:setRepeatEnable(self.isCanRepeat)

    if #self.LastBet < 1 then
        msgup.show("重复上次下注失败，您上次未下注")
    end
    if not cpn.game.isCanSetBet then
        msgbox.showOk("您今天的游戏状况已经超过限制，为保护您的账户安全，请明日再来继续游戏!!")
        return
    end
    local timer_key = "Center.Repeat"..(#self.Timer)
    local rpt_index = 1
    local function timer_func()
        --是否可下注？
        if not self.AcceptBet then
            node:unschedule(timer_key)
            return
        end

        --是否已重复完毕？
        local t = self.LastBet[rpt_index]
        if not t then
            node:unschedule(timer_key)
            return
        end

        --判断钱是否足够
        local gold = tonumber(Game.Player.Gold)
        if not gold or gold < t[2] then
            node:unschedule(timer_key)
            return
        end

        --是否找到下注所对应的索引？
        local bet_idx = table.indexof(Config.Bets, t[2])
        local present_idx = t[1]
        if not bet_idx then
            ccerr("can't find the index of bet while repeating!")
            node:unschedule(timer_key)
            return
        end

        --发送下注请求
        sound.playBetEffect()
        SendSetBetsReq(bet_idx, present_idx)
        rpt_index = rpt_index + 1
    end
    
    node:schedule(timer_func, 0.1, timer_key)
    table.insert(self.Timer, timer_key)
end

--终止重复下注定时器
function ctrl:stopRepeatTimers()
    local node = self:getNode()
    if not node then
        return
    end

    for _,v in pairs(self.Timer) do
        node:unschedule(v)
    end
    self.Timer = {}
end

function ctrl:setRepeatEnable(is_enable)
    if cpn.game and cpn.game.bottombar then
        cpn.game.bottombar:setRepeatEnable(is_enable)
    end
end


return ctrl
