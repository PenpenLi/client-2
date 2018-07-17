
local ctrl = createView("", "fruit/UILogic/Game/Game.csb", nil)

function ctrl:show()
    cpn.game = self
    return self:create()
end

function ctrl:onInit(node)
    self:createScrollBar()
	local na = node:getName();
    self.topbar = g_Require("fruit/ui_topbar"):show()
    self.center = g_Require("fruit/ui_center"):show()
    self.bottombar = g_Require("fruit/ui_bottombar"):show()
    self.rightbar = g_Require("fruit/ui_rightbar"):show()
    self.countdown = g_Require("fruit/ui_countdown"):show()

    self.rightbar:setData({0,0,0,0,0,0,0,0,0})

    self.bottombar:setRepeatCallback(handler(self, self.onRepeatSetBets))
    self.bottombar:setSelectBetCallback(handler(self, self.onSelectBetCallback))

    --播放背景音乐
    --node:schedule(sound.playBackgroundMusic, 150, "play.background.music")
    sound.playBackgroundMusic()
    self.isCanSetBet = true

    node:findChild("clock"):setVisible(true)
    self:refreshClock()
    --node:schedule(handler(self, self.refreshClock), 1, "refresh.time")
    
end
function ctrl:onExit()
    if self.BalanceDelayTimeID then
        CancelCall(self.BalanceDelayTimeID)
        self.BalanceDelayTimeID = nil
    end
end

function ctrl:initForReconnectBegin()
end

function ctrl:initForReconnectEnd()
    self.rightbar:setData({0,0,0,0,0,0,0,0,0})
    self:onRandResult(Game.RandResult)      --设置开奖结果
    self:onLastRandom(Game.LastRandom)      --设置历史记录
    self:onStateChanged(Game.CurState, Game.CurStateTime)   --刷新当前状态
    self:onPlayerSetBets()                  --玩家下注
    self:onMySetBets()                      --自己下注
    self:setPlayerNickName(Game.Player.NickName)
    self:setPlayerIId(Game.Player.IID)
    self:onRefreshPlayerGold(Game.Player.Gold)
end

function ctrl:onSelectBetCallback(idx)
    self.center:setBetIndex(idx)
end

--desc:设置开奖结果
--@rand_result      开奖结果，1~8
function ctrl:onRandResult(rand_result)
    self.Result = rand_result
    self.center:setRandomResult(rand_result)
end

--desc:状态机发生变化
--@change_to    当前状态机状态 1-下注, 2-转圈, 3-休息等待
--@time_left    当前状态机剩余时间
function ctrl:onStateChanged(change_to, time_left)
    if change_to == 1 then
        --关闭上轮的结算面板
        if self.balance then
            self.balance:destroy()
            self.balance = nil
        end

        --初始化
        self.ResultValid = true
        self.center:setAcceptBet(true)
        self.center:reset()
        self.bottombar:resetBet(true)
        self.bottombar:setLayerVisible(false)
        self.bottombar:setRepeatEnable(true)
        self.countdown:resetTimer(1, time_left)
        sound.playStartEffect()
    elseif change_to == 2 then
        self.center:stopRepeatTimers()
        self.center:setAcceptBet(false)
        self.center:startAnimation(time_left)
        self.bottombar:resetBet(false)
        self.bottombar:setLayerVisible(true)
        self.countdown:resetTimer(2, time_left)
        self.bottombar:setRepeatEnable(false)
        if time_left > 3 then
            g_Require("fruit/ui_rotation"):show(2)
        end
    elseif change_to == 3 then
        self.center:setAcceptBet(false)
        self.center:stopAnimation(true)
        self.bottombar:resetBet(false)
        self.bottombar:setLayerVisible(true)
        self.bottombar:setRepeatEnable(false)
        self.countdown:resetTimer(3, time_left)
        if not self.center:isSelfSetBet() then
            self.center:resetBoard(false)
        end
        if self.ResultValid or Game.StateChangeWrong then
            self.ResultValid = false
            Game.StateChangeWrong = false
            --播放中奖结果特效
            g_Require("fruit/ui_fruit_win"):show(self.Result)

            self.rightbar:addData(self.Result)

            --考虑是否播放中大奖特效
            if table.indexof(Config.FruitFallTable, self.Result) then
                g_Require("fruit/ui_fruit_fall_layer"):show(self.Result)
            end
        end
    end
end

--desc:设置开奖记录
--@t    开奖记录列表
function ctrl:onLastRandom(t)
    self.rightbar:setData(t)
end

--desc:玩家下注
function ctrl:onPlayerSetBets()
    for i=1,#Game.Bets do
        local t = Game.Bets[i]
        self.center:addBoardBetImage(t[2], t[1], t[3])
    end
    Game.Bets = {}
end

--desc:自己下注
function ctrl:onMySetBets()
    for i=1,#Game.MyBets do
        local t = Game.MyBets[i]
        self.center:addBoardBetSelf(t[1], t[2])
    end
    Game.MyBets = {}
end

--desc:刷新玩家金币
function ctrl:onRefreshPlayerGold(gold)
    self.bottombar:refreshGold(tostring(gold))
end

--desc:设置玩家昵称显示
function ctrl:setPlayerNickName(nick_name)
    self.bottombar:refreshNickName(nick_name)
end
--desc:设置玩家数字ID
function ctrl:setPlayerIId(iid)
    self.bottombar:refresIId(iid)
end

--desc:重复上轮下注
function ctrl:onRepeatSetBets()
    self.center:onRepeatSetBets()
end

--延迟弹出结算界面
function ctrl:delayFlipBalance(time_left)
    --判断时间不足则不弹出结算界面
    if time_left < Config.BalanceDelayTime then
        return
    end
    
    local pay = 0
    local actual_win = 0
    if Game.Report.Pay and Game.Report.ActualWin then
        pay = Game.Report.Pay
        actual_win = Game.Report.ActualWin
    end
    Game.Report = {}

    self.BalanceDelayTimeID = DelayCallOnce(Config.BalanceDelayTime, function()
        self.BalanceDelayTimeID = nil
        if not self.balance then
            self.balance = g_Require("fruit/ui_balance"):show(pay, actual_win)
        else
            self.balance:refresh(pay, actual_win)
        end
    end)
end

function ctrl:createScrollBar()
        --显示滚动消息
 --chat:setScrollMsgPosition(640, 700)
 --chat:createScrollMsg()
 --chat:addScrollMsg("欢迎来到水果转转游戏，请尽情享受吧！")
 --chat:showScrollMsg()
end

function ctrl:refreshClock()
    local CC = require("comm.CC")
    local time = CC.PlayerMgr.Time:Get()
    local dateTime = os.date("%y/%m/%d %H:%M", time)
    local node = self:getNode()
    node:findChild("clock/txtTime"):setFontSize(19)
    node:findChild("clock/txtTime"):setString(dateTime)
end

return ctrl
