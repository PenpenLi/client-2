local _G = _G

module("comm.kk.enum")
  
EVENTS = 
{
    diamond_changed         = "diamond_changed",                    --钻石变化 number:钻石值
    gold_changed            = "gold_changed",                       --金币变化 number:金币值
    ticked_changed          = "ticked_changed",                     --奖券变化 number:奖券值
    goldGameLock_changed    = "goldGameLock_changed",               --已兑入游戏的货币量
    bank_diamond_changed    = "bank_diamond_changed",               --保险箱钻石变化 number:保险箱钻石值
    bank_gold_changed       = "bank_gold_changed",                  --保险箱金币变化 number:保险箱金币值
    phone_changed           = "phone_changed",                      --手机号码修改
    vip_value_changed       = "vip_value_changed",                  --vip经验值
    lobby_click_back        = "lobby_click_back",
    lobby_enter_game        = "lobby_enter_game",                   --大厅中监听此事件进入到对应游戏 gameId 游戏Id
    login_platform_progress = "login_platform_progress",            --登录大厅进度通知 rate

    coordinate_reconnect_begin  = "coordinate_reconnect_begin",     --协同服务器重连开始
    coordinate_reconnect_end    = "coordinate_reconnect_end",       --协同服务器重连结束 status 1成功2取消
}
