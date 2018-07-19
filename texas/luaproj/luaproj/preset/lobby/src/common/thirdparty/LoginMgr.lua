
local _G = _G
local CC = require "comm.CC"
local entryCache = require("koko.data").entryCache
local UILoading = require "koko.ui.login.UILoading".UILoading

module ("LoginMgr", package.seeall)

local tGamePlist = {
    "koko/packages/activity.plist",
    "koko/packages/bag.plist",
    "koko/packages/Bag.plist",
    "koko/packages/common.plist",
    "koko/packages/customer_service.plist",
    "koko/packages/game_ico.plist",
    "koko/packages/lobby.plist",
    "koko/packages/personal.plist",
    "koko/packages/shop.plist",
    "koko/packages/all_button.plist",
    "koko/packages/all_kuang.plist",
    "koko/packages/all_title.plist",
}
local maxRetryCount = 3         --登录协同服务器失败时的最大重试次数

--LoginResult       web返回的玩家数据
--RetryCount        当前重试次数
tData = {GM = false, GameId = 4, isAutologin = false}
--[[
t    PLATFORM = "koko"  "embed"  "single"
t    GAME = "ddz"  "shz"  "niuniu"
f    APPKEY = "6d809281f95f9f5ecd34856da582b3b5"
f    UID = "9b00eaa5-bf75-11e7-befc-f01fafe9160b"
f    USERNAME
f    PASSWORD         sport:1     fruit:2     hddmx:3     ddz:4     niuniu:5      shz:6
]]
function Load()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("koko/packages/head_ico.plist")
    --ccerr("登陆参数envir_gettable:_%s", json.encode(envir_gettable()))
    parseEnvirTable()
    -- tData.GM = true
    -- tData.PLATFORM = "single"
    -- tData.GAME = "ddz"
    -- tData.GameId = 4

    -- tData.isAutologin = true
    -- tData.USERNAME = "qqq444"
    -- tData.PASSWORD = "123456"
    -- tData.APPKEY = "7df95793c0fd6f912a1783490a52f8b7"
    -- tData.UID = "bdb94693-db2c-11e7-befc-f01fafe9160b"

    if tData.isAutologin and tData.PLATFORM ~= "koko" then
        loadingShade()
    end
    CC.GameMgr.Scene:Set("Login")
end

function AppkeyUidLogin(appkey, uid)
    local function callback(t)
        if t.success then
            t.data.result.appKey = appkey
            webLoginCallback(t)
        else
            _G.kk.msgbox.showOk(t.message, function()
                _G.exit(0)
            end)
        end
    end
    CC.Web.sendAppkeyUidLoginReq(appkey, uid, callback)
end
function Accountlogin(acc, pwd)
    local function accCallback(t)
        if t.success then
            if t.data.choos then
                _G.kk.waiting.close()
                kk.uimgr.load("koko.ui.login.ui_acc_select", "", t.data.choos)
            else
                entryCache:addAccountEntry(t.data.result.uid, t.data.result.nickname, acc, pwd)
                webLoginCallback(t)
            end
        else
            _G.kk.waiting.close()
            _G.kk.msgbox.showOk(t.message, function()
                if tData.isAutologin then
                    _G.exit(0)
                else
                    CC.UIMgr:Unload("UILoading")
                    CC.UIMgr:Unload("UILoading_"..tData.GAME)
                end
            end)
        end
    end
    CC.Web.sendAccountLoginReq(acc, pwd, accCallback, 0.5)
    _G.kk.waiting.show("")
end

function DdeviceLogin(value)
    local function decCallback(t)
        if t.success then
            entryCache:addDeviceEntry(t.data.result.uid, t.data.result.nickname, value)
            webLoginCallback(t)
        else
            _G.kk.waiting.close()
            _G.kk.msgbox.showOk(t.message, function()
                if tData.isAutologin then
                    _G.exit(0)
                else
                    CC.UIMgr:Unload("UILoading")
                    CC.UIMgr:Unload("UILoading_"..tData.GAME)
                end
            end)
        end
    end
    CC.Web.sendDeviceLoginReq(value, decCallback, 0.5)
    _G.kk.waiting.show("")
end
function webLoginCallback(t)
    --加载进度界面
    if tData.PLATFORM ~= "koko" then
        loadingShade()
    end
    CC.UIMgr:Load(UILoading)

    --关闭等待界面
    _G.kk.waiting.close()

    --缓存数据
    tData.LoginResult = t.data.result
    tData.RetryCount = 0

    --登录平台·重试
    loginPlatformWithRetry()
end

--登录协同服务器，最多重试3次
function loginPlatformWithRetry()
    tData.RetryCount = tData.RetryCount + 1
    if tData.RetryCount > maxRetryCount then
        return false
    end

    cclog("[LoginMgr] ========================尝试登录协同服务器(%d)========================", tData.RetryCount)

    --10% ~ 20%  资源加载结束
    --20% ~ 80%  网络登录
    --80% ~ 100% 等待校验完成
    notifyPlatformProgress(0.1)

    cclog("[LoginMgr] 异步资源开始加载")
    _G.kk.util.asyncLoadResource(tGamePlist, function()
        notifyPlatformProgress(0.2)
        cclog("[LoginMgr] 资源加载完成")
        performLoginPlatformWithNet()
    end)
    return true
end

--执行网络模块登录协同服务器
function performLoginPlatformWithNet()
    notifyPlatformProgress(0.2)
    cclog("[LoginMgr] 使用网络模块登录平台服务器...")
    CC.Event("Login", {Before = true})
    local result = tData.LoginResult
    local ip = config.WORLDADDR
    local port = config.WORLDPORT
    local gameid = _G.kk.util.getCoordinateChannelId()
    local uid = result.uid
    local iid = result.iid
    local uname = result.nickname
    local sn = result.gameSn
    local token = result.gameKey
    CC.Net.loginPlatform(ip, port, gameid, uid, iid, uname, sn, token, 
    function(tbl)
        if not tbl.success then
            --失败，是否重试？
            _G.ccwrn("[LoginMgr] %s", tbl.message)
            if tData.RetryCount < maxRetryCount then
                _G.cclog("[LoginMgr] 正在重试...")
                _G.kk.timer.delayOnce(1, loginPlatformWithRetry)
            else
                _G.kk.msgbox.showOk(tbl.message, function()
                    if tData.isAutologin then
                        _G.exit(0)
                    else
                        CC.UIMgr:Unload("UILoading")
                        CC.UIMgr:Unload("UILoading_"..tData.GAME)
                    end
                end)
            end
        else
            --登录成功，准备数据
            _G.cclog("[LoginMgr] 网络模块登录平台成功，正在检查资源是否校验完成...")
            CC.Player:setPlayerselfInfo(result)
            entryCache:loginByUid(result.uid)
            entryCache:setCurrentNickName(result.nickname)
            CC.Event("Login", {After = true})

            --定义局部函数，用于检测是否资源已校验完毕
            local function isDownloadInfoComplete()
                local r = true
                local tinfo = CC.PlayerMgr.Lobby.tDownloadInfo
                local tGame = CC.Excel.GameList
                for i=1,tGame:Count() do
                    if not tinfo[tGame:At(i).Name] then
                        r = false
                        break
                    end
                end
                if not r then
                    ccwrn("正在等待下载信息校验：%s", json.encode(CC.PlayerMgr.Lobby.tDownloadInfo))
                end
                return r
            end

            --等待资源校验完毕
            if isDownloadInfoComplete() then
                performEnterLobby()
            else
                local timerKey = "ui.login.downloadinfo"
                local login = kk.uimgr.get("kkLogin")
                login:getNode():schedule(function()
                    if isDownloadInfoComplete() then
                        login:getNode():unschedule(timerKey)
                        performEnterLobby()
                    end
                end, 0.5, timerKey)
            end
        end
    end,
    function(rate)
        notifyPlatformProgress(0.2 + 0.6 * rate)
    end)
end

--进入大厅界面
function performEnterLobby()
    notifyPlatformProgress(1)
    cclog("[LoginMgr] 界面跳转到大厅")
    _G.kk.timer.delayOnce(0.3, function() CC.UIMgr:Do("UILoading", "Refresh", {Rate = 1}) end)
    _G.kk.timer.delayOnce(0.4, function()
        CC.GameMgr.Scene:Set("Lobby")
        if tData.GM then
            _G.kk.timer.delayOnce(0.1, function()
                --自动进入对应游戏
                _G.kk.event.dispatch(_G.E.EVENTS.lobby_enter_game, tData.GameId)
                if tData.PLATFORM == "single" then
                    CC.PlayerMgr.Lobby.kSwitchFirstLoad:TryOff()
                end
            end)
        else
            CC.Data.StartupParamMgr.analyzeParam()
        end
    end)
end

-- 第三方登陆
function ThirdLogin(n)
    if platform_iswin32() then
        _G.kk.msgup.show("该平台暂不支持第三方登录！")
        return
    end
    function callback(platform, state, authId, nickName, errormsg, unionId)
        _G.kk.waiting.close()
        _G.cclog("[第三方登录回调] platform:%s state:%s authId:%s nickName:%s errormsg:%s", tostring(platform), tostring(state), tostring(authId), tostring(nickName), tostring(errormsg))

        local function webCallback(t)
            if t.success then
                webLoginCallback(t)
            else
                _G.kk.msgbox.showOk(t.message)
                _G.kk.waiting.close("")
            end
        end
        local str = platform == 1 and "未安装微信，请安装后重试" or "未安装QQ，请安装后重试"
        if state == 3 then
            _G.kk.msgbox.showOk(str)
        elseif state == 5 then
            _G.kk.msgbox.showOk(str)
        elseif state == 2 then
            _G.kk.waiting.show("")
            local platformInfo = platform == 1 and "wx" or "qq"
            CC.Web.sendThirdLoginReq(platformInfo, authId, nickName, webCallback, 0.5, unionId)
        end
    end
    if not platform_isios() then -- 目前ios  登陆授权取消时 不会执行callback
        _G.kk.waiting.show("等待授权...")
    end
    third_login(n, callback)
end

--检查是否有本地账号信息，若不存在则生成游客账号
function CheckAccountFromLocalFile()
    local function callback(t)
        local is_succee = t.message
        if t.success then
            local result = t.data.result
            local name = result.nickname
            local deviceCode = result.machineMark
            local uid = result.uid
            entryCache:addDeviceEntry(uid, name, deviceCode)
            kk.uimgr.call("kkLogin", "setLoginEntry", uid)
        else
            _G.kk.msgbox.showOk("游客账号创建失败："..t.message)
        end
    end
    local tbl = entryCache:getDataTable()
    if tbl == nil or #tbl == 0 then
        CC.Web.sendDeviceLoginReq(get_device_code(), callback)
    end
end

function parseEnvirTable()
    local data = envir_gettable()
    tData.PLATFORM = data.PLATFORM
    tData.GAME = data.GAME
    tData.APPKEY = data.APPKEY
    tData.UID = data.UID
    tData.USERNAME = data.USERNAME
    tData.PASSWORD = data.PASSWORD

    if data.PLATFORM == "koko" then
        tData.GM = false
    else
        tData.GM = true
    end

    local excel = CC.Excel.GameList
    for i = 1, excel:Count() do
        if excel:At(i).LocalDir == tData.GAME then
            tData.GameId = i
            break
        end
    end

    local f = false
    if data.APPKEY and data.UID then
        f = true
    end
    if data.USERNAME and data.PASSWORD then
        f = true
    end
    tData.isAutologin = f
end
function getLoginMgrPLATFORM()
    return tData.PLATFORM or "koko"
end
function getLoginMgrGAME()
    return tData.GAME
end

--  加载遮罩进度界面
function loadingShade()
    local tExcel = CC.Excel.GameList
    local tVal = nil
    for i = 1, tExcel:Count() do
        if tExcel:At(i).LocalDir == tData.GAME then
            tVal = tExcel:At(i)
        end
    end
    if tVal == nil then return end
    if CC.UIMgr.Get(tVal.LoadingKey) then return end

    _G.add_search_path(tData.GAME)
    local kUI = clone(UILoading)
    kUI.Path = tVal.ShadeCsbPath
    kUI.Key = tVal.LoadingKey
    kUI.IsShade = true
    CC.UIMgr:Load(kUI)
    CC.UIMgr:Do(tVal.LoadingKey, "setZOrder", 501)
end

-- 通知进度
function notifyPlatformProgress(rate)
    _G.kk.event.dispatch(_G.E.EVENTS.login_platform_progress, rate)
end

-- 設置遮罩進度條
function setShadeProgressRate(rate)
    if tData.PLATFORM == "koko" then return end
    local key = "UILoading_"..tData.GAME
    CC.UIMgr:Do(key, "setProgress", rate)
end