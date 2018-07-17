
var_ui_login        = "登录"
var_ui_game         = "游戏"

cpn = {}
function cpn:clear()
    for _,v in pairs(self) do
        if type(v) == "table" then
            v:destroy()
        end
    end
end

--全局table变量，不受重载影响
Game = 
{
    ["UI"]              = var_ui_login,     --当前界面 [登录][大厅][场次][游戏]
    ["Account"]         = "",               --当前登录账号
    ["Password"]        = "",               --当前登录密码
    ["IsAttached"]      = false,            --是否依附于其他窗体上
    ["RandResult"]      = 4,                --当前开奖结果
    ["CurState"]        = 0,                --当前状态机状态 1-下注, 2-转圈, 3-休息等待
    ["CurStateTime"]    = 8,                --当前状态机剩余时间
    ["StateChangeWrong"] = false,           --状态已发送界面未创建
    ["LastRandom"]      = {},               --开奖记录
    ["Bets"]            = {},               --玩家下注情况 {{1,1,103000},{2,3,103000}}
    ["MyBets"]          = {},               --自己下注情况
    ["Report"]          = {},               --结算数据 Pay:付出了多少 ActualWin:赢了多少
    ["Player"]          =                   --玩家实体
        {
            ["UID"] = "",
            ["IID"] = 0,
            ["Exp"] = 0,
            ["ExpMax"] = 0,
            ["Level"] = 0,
            ["HeadPic"] = "",
            ["NickName"] = "",
            ["Gold"] = "",
        },
        
    isCoordinateConnected = false,
}
