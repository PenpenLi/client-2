
--销毁当前场景UI并重新创建
function RebuildUI()
    local s = Game.UI
    if s == var_ui_login then
        SwitchToUILogin()
    elseif s == var_ui_game then
        SwitchToUIGame()
    end
end

--创建登录
function SwitchToUILogin()
    require("net_bridge").replaceScene(cc.Scene:create())
    Game.UI = var_ui_login
    cpn:clear()
    g_Require("fruit/ui_login"):show()
end

--创建游戏
function SwitchToUIGame()
    Game.UI = var_ui_game
end










--是否在登录界面
function IsInLogin()
    return Game.UI == var_ui_login
end
--是否在游戏界面
function IsInGame()
    return Game.UI == var_ui_game and cpn.game
end
