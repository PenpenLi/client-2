
function Trigger_NetError(t)
    ccwrn("网络发生错误！")
    if IsInLogin() then
        
    else
        Platform.OnNetError()
    end
end

function Trigger_FormAck(command, content)
    local func = Form[command]
    
    if type(func) ~= "function" then
        return
    end
   
    func(content)
end

function Trigger_QueryExit(t)
    if msgbox.hasOpenedBox() then
        return
    end

    local function exit_func(is_ok)
        if is_ok then
            exitGame(false)
        end
    end
    msgbox.showOkCancel("确定退出游戏吗？", exit_func)
end



--------------测试代码------------
local ProtoHideIds = 
{
    17,
    1110,

}
function IsShowProtocolLogByCommand(command)
    for i=1,#ProtoHideIds do
        if ProtoHideIds[i] == command then
            return false
        end
    end
    return true
end

local ProtoNames={}
local ProtoNum=10
local pp = function(str,num)
    if num then ProtoNum=tonumber(num) end
    ProtoNames[ProtoNum]=str; ProtoNum=ProtoNum+1;
end
pp("msg_ping", 0xffff)
pp("msg_user_login_ret", 1000)
pp("msg_common_reply", 1001)
pp("msg_logout", 1034)
pp("msg_currency_change", 1007)
pp("msg_server_parameter", 1107)
pp("msg_low_currency", 1109)
pp("msg_player_seat", 1110)
pp("msg_room_info")
pp("msg_player_leave")
pp("msg_deposit_change2")
pp("msg_chat_deliver")
pp("msg_everyday_gift")
pp("msg_levelup")
pp("msg_set_account_ret")
pp("msg_recommend_data")
pp("msg_trade_data")
pp("msg_game_info")
pp("msg_server_info")
pp("msg_rank_data")
pp("msg_everyday_sign_info")
pp("msg_everyday_sign_rewards")
pp("msg_luck_wheel_info")
pp("msg_luck_wheel_record")
pp("msg_subsidy_info")
pp("msg_subsidy_result")
pp("msg_match_info", 1500)
pp("msg_ask_for_join_match")
pp("msg_prepare_enter")
pp("msg_time_left")
pp("msg_match_result")
pp("msg_match_progress")
pp("msg_broadcast_info")
pp("msg_state_change", 10)
pp("msg_rand_result")
pp("msg_banker_promote")
pp("msg_game_report")
pp("msg_banker_deposit_change")
pp("msg_new_banker_applyed")
pp("msg_apply_banker_canceled")
pp("msg_player_setbet")
pp("msg_my_setbet")
pp("msg_last_random")
pp("msg_return_player_count")
pp("msg_return_lottery_record")
pp("msg_broadcast_msg")
pp("msg_banker_ranking_ret")
pp("msg_chat_result")
function GetMsgString(id)
    return ProtoNames[id] ~= nil and ProtoNames[id] or "未知"
end
