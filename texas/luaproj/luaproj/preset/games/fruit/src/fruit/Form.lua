local utils = require("utils")
Form = {}
--msg_common_reply
--通用回应包
--{"rp_cmd_": "992","err_": "-999","des_": ""}
Form[1001] = function(t)
    local rp_cmd = tonumber(t.rp_cmd_)
    local code = tonumber(t.err_)
    if code == -1000 then           --签名错误
        ccerr("签名错误")
    elseif code == -999 then        --密码错误
        ccerr("密码错误")
        disconnect()
        msgbox.showOk("账号或密码错误！")
    elseif code == -998 then        --sql语句执行失败
        ccerr("sql语句执行失败")
    elseif code == -997 then        --数据库中没有相应记录
        ccerr("账号不存在")
        disconnect()
        msgbox.showOk("账号不存在！")
    elseif code == -996 then        --用户被禁止
        ccerr("用户被禁止")
        msgbox.showOk("您被禁止登录！")
    elseif code == -995 then        --注册账户名已存在
        ccerr("注册账户名已存在")
    elseif code == -994 then        --服务器正忙
        ccerr("服务器正忙")
        msgbox.showOk("服务器繁忙，请稍后再试！")
    elseif code == 11 then          --协同服务器不可用
        local errmsg = string.format("未知错误：rp_cmd:%d err:%d", rp_cmd, code)
        if rp_cmd == 992 then
            errmsg = "协同服务器不可用"
        end
        ccerr(errmsg)
        disconnect()
        msgbox.showOk(errmsg)
    elseif code == 3002 then        --进入房间成功
        
    elseif code == 100010 then
        cpn.game.isCanSetBet = false
        msgbox.showOk("您今天的游戏状况已经超过限制，为保护您的账户安全，请明日再来继续游戏")
        if cpn.game then
            cpn.game.center:stopRepeatTimers()
        end
    else
        ccerr("未知错误 %s", json.encode(t))
    end
end

--msg_server_parameter
--服务器场次列表
--{"min_guarantee_": "50000","is_free_": "0","banker_set_": "200000","low_cap_": "899","player_tax_": "5001","enter_scene_": "3"}
Form[1107] = function(t)
end

--msg_user_login_ret
--登录回应
--{"exp_":0,"iid_":20000002,"lv_":1,"head_pic_":"","exp_max_":1800,"uid_":"kokod107741d-a57e-11e6-9ed2-14187748a4aa","uname_":"来宾42600","currency_":0}
Form[1000] = function(t)
    --保存玩家信息
    Game.Player = 
    {
        ["UID"] = t.uid_,
        ["IID"] = tonumber(t.iid_),
        ["Exp"] = tonumber(t.exp_),
        ["ExpMax"] = tonumber(t.exp_max_),
        ["Level"] = tonumber(t.lv_),
        ["HeadPic"] = t.head_pic_,
        ["NickName"] = t.uname_,
        ["Gold"] = t.currency_,
    }
    
    Platform.OnLoginRet()
end

--msg_low_currency
--金币不足
--{"require_": "1000"}
Form[1109] = function(t)
    --金币不足
    msgbox.showOk(string.format("您K豆不足%s，无法进入该房间！", t.require_))
end

--msg_currency_change
--金币变化
--{"credits_":"7862626","why_":"0"}
Form[1007] = function(t)
    local why = tonumber(t.why_)
    if why == 0 then
        Game.Player.Gold = t.credits_
        
    elseif why == 5 then
        Game.Player.Gold = t.credits_
        Platform.OnLoginComplete()  --登录完成，交由平台接管
    else
        ccwrn("未处理的金币变化 why_:"..t.why_)
    end

    if IsInGame() then
        cpn.game:onRefreshPlayerGold(Game.Player.Gold)
    end
end

--msg_player_seat
--玩家坐下
--{"gun_level_":0,"gun_type_":"","head_pic_":"","iid_":4322068,"lv_":0,"pos_":0,"uid_":"koko08976f84-af60-11e5-b129-000c29755f94","uname_":"来宾31410"}
Form[1110] = function(t)
end

--msg_player_leave
--玩家离开
--{"pos_":"1","why_":"1"}   why_:0 玩家主动退出游戏, 1 换桌退出游戏, 2 游戏结束清场退出游戏, 3 T出游戏
Form[1112] = function(t)
end

--msg_deposit_change2
--座位玩家金币或保证金变化
--{"credits_":7862626,"display_type_":0,"pos_":0,"why_":0}      display_type_:0金币变化 1飘字 2保证金变化
Form[1113] = function(t)
end

--msg_state_change
--状态变化  1-下注, 2-转圈, 3-结算
--{"change_to_":"2","time_left_":"7"}
Form[10] = function(t)
    Game.CurState = tonumber(t.change_to_)
    Game.CurStateTime = tonumber(t.time_left)
    if IsInGame() and not reconnect:isReconnecting() then
        if Game.CurState == 1  or Game.CurState == 3 then
            cpn.game:onStateChanged(Game.CurState, Game.CurStateTime)
        elseif not IsInGame() and Game.CurState == 1 then
            Game.StateChangeWrong = true
        end
    end
end

--msg_rand_result
--当前开奖结果
--{"rand_result_","4"}
Form[11] = function(t)
    Game.RandResult = tonumber(t.rand_result_)
    if IsInGame() and not reconnect:isReconnecting() then
        cpn.game:onRandResult(Game.RandResult)
        if Game.CurState == 2 or Game.CurState == 3 then
            cpn.game:onStateChanged(Game.CurState, Game.CurStateTime)
        end
    end
end

--msg_last_random
--开奖记录
--{"r_":"4,1,0,0,0,0,0,0,0,0,","t_":"2,1,0,0,0,0,0,0,0,0,"}
Form[19] = function(t)
    local tmp = utils.stringSplit(t.r_, ",")
    Game.LastRandom = {}
    for i=1,#tmp do
        table.insert(Game.LastRandom, tonumber(tmp[i]))
    end
    if IsInGame() and not reconnect:isReconnecting() then
        cpn.game:onLastRandom(Game.LastRandom)
    end
end

--msg_player_setbet
--玩家下注
--{"pid_":"1","present_id_":"1","max_setted_":"103000"}
--pid_:筹码id present_id_:押注id max_setted_:总共下注
Form[17] = function(t)
    table.insert(Game.Bets, {tonumber(t.pid_),tonumber(t.present_id_),tonumber(t.max_setted_)})
    if IsInGame() and not reconnect:isReconnecting() then
        cpn.game:onPlayerSetBets()
    end
end

--msg_my_setbet
--自己下注
--{"present_id_":"1","set_":"10000"}
--present_id_:押注id set_:押注大小
Form[18] = function(t)
    table.insert(Game.MyBets, {tonumber(t.present_id_), tonumber(t.set_)})
    if IsInGame() and not reconnect:isReconnecting() then
        cpn.game:onMySetBets()
    end
end

--msg_game_report
--获奖结果
--{"pay_":"10000","actual_win_":"40000"}
Form[13] = function(t)
    Game.Report.Pay = tonumber(t.pay_)
    Game.Report.ActualWin = tonumber(t.actual_win_)
    --弹出结算面板
    if IsInGame() and not reconnect:isReconnecting() then
        cpn.game:delayFlipBalance(Game.CurStateTime)
    end
end


--msg_logout
Form[1034] = function(t)
    --Platform.OnNotifyLogout()
end

if kkPlatform then return end

