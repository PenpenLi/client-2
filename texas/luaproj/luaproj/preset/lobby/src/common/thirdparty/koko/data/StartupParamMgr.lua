
local _G = _G

local CC = require "comm.CC"

module("koko.data.StartupParamMgr")

local _startupParam = nil

local function triggerEnterGame(params)
    local tExcel = CC.Excel.GameList.LocalDir[params.gameName]
    if tExcel:Count() > 0 then
        _G.kk.event.dispatch(_G.E.EVENTS.lobby_enter_game, tExcel:At(1).ID)
    end
end

-- CC.Excel.GameList.Name[tVal.kGame]:At(1).ID  or tVal.iGame
local function comfirmCloseCurrentGameCallBack(isOK)
    if isOK then
        local gameId = CC.GameMgr.Scene.iGame
        local row = CC.Excel.GameList[gameId]

        if not row then
            _G.kk.msgup("系统错误，当前运行的游戏未知")
            return
        end

        if row.Generation == 1 then
            if _G.exitGame then
                _G.exitGame(false)
            end
        else
            CC.GameMgr.Scene:Set("Lobby")
        end
        
        _G.ccerr("[StartupParamMgr.comfirmCloseCurrentGameCallBack] 当前界面：%s" .. CC.GameMgr.Scene.kKey)
        _G.kk.timer.delayOnce(0, triggerEnterGame, _startupParam)
    end
end

--从引擎中获取启动参数，保存到lua变量中
function load()
    local s = _G.get_startup_parameter and _G.get_startup_parameter() or ""
    _startupParam = _G.kk.util.analysisAppStr(s)
end

--获取启动参数
function getParam()
    return _startupParam
end

--清空lua中缓存的启动参数
function clearParam()
    _startupParam = nil
end

--启动参数发生变化，判断当前所处的游戏位置，做相应的处理
function onParamChanged()
    local s = _G.get_startup_parameter and _G.get_startup_parameter() or ""
    _G.cclog("[StartupParamMgr.onParamChanged] 启动参数发生变化：%s", s)
    _startupParam = _G.kk.util.analysisAppStr(s)
    analyzeParam()
end

function analyzeParam()
    if _startupParam == nil or _G.next(_startupParam) == nil then
        return
    end

    --判断平台
    local platform = _G.envir_gettable().PLATFORM
    if platform == "koko" then
       --lua大厅版本
       if CC.GameMgr.Scene.kKey == "Login" then
           --当前处于登录界面
           _G.cclog("[StartupParamMgr.onParamChanged] lua版大厅&登录界面")
           return
       elseif CC.GameMgr.Scene.kKey == "Lobby" then
           --当前处于大厅界面
           _G.cclog("[StartupParamMgr.onParamChanged] lua版大厅&大厅界面")
           triggerEnterGame(_startupParam)
       elseif CC.GameMgr.Scene.kKey == "Game" then
           --当前处于某个游戏界面
           _G.cclog("[StartupParamMgr.onParamChanged] lua版大厅&游戏中")
           _G.kk.msgbox.showOkCancel("是否退出当前游戏？", comfirmCloseCurrentGameCallBack)
       end 
    elseif platform == "single" then
       -- 单发
    elseif platform == "embed" then
       -- 内嵌
    else
       -- 其他
    end
end


