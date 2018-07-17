
Platform = {}

--解析命令行参数
Platform.ParseCommandLine = function()
    local envir = envir_gettable()
    cclog("[命令行参数] %s", json.encode(envir))
end

--创建OpenGL设备窗口
Platform.CreateOpenGLView = function()
    local rc = cc.rect(0, 0, Config.ResolutionWidth, Config.ResolutionHeight)
    local envir = envir_gettable()

    --分析缩放比例
    local scale = 1.0
    if envir.SIZE then
        local tsize = splitstr(envir.SIZE, "*")
        if #tsize == 2 and tonumber(tsize[2]) > 0 then
            scale = tonumber(tsize[2]) / Config.ResolutionHeight
        end
    end
    
    if platform_iswin32() then
        --解析父窗口
        local hwnd = envir.PHWND and tonumber(envir.PHWND) or 0
        if hwnd ~= 0 then
            Game.IsAttached = true
            return cc.GLViewImpl:createWithRect(Config.Title, rc, scale, hwnd)
        else
            return cc.GLViewImpl:createWithRect(Config.Title, rc, scale)
        end
    else
        return cc.GLViewImpl:createWithRect(Config.Title, rc, scale)
    end
end

function Platform.LoginByAccountPassword(account, password)
    local r = require("net_bridge").loginWithAccount(account, password, Platform.OnLoginReply, Platform.OnLoginProgress)
    if r then
        loading.show("正在登录")
    end
end
function Platform.LoginByPlatformParams()
    loading.show("正在登录")
    DelayCallOnce(0.1, function()
        require("net_bridge").loginWithPlatformParams(Platform.OnLoginReply, Platform.OnLoginProgress)
    end)
end
function Platform.OnLoginProgress(rate)
    loading.setProgress(0.6 * rate)
end
function Platform.OnLoginReply(tbl)
    if tbl.isSuccess then
        local ip = tbl.IP
        local port = tonumber(tbl.Port)
        local r = connect(ip, port)
        if r ~= 0 then
            ccerr("无法连接游戏服务器，请检查网络设置！[%s:%d]", ip, port)
            msgbox.showOk("无法连接游戏服务器，请检查网络设置！", Platform.OnLoginErrorCallback)
            return
        end
        Game.isCoordinateConnected = true
        --loading.setProgress(0.6)
        --CC.LoginMgr.setShadeProgressRate(0.7)
        --SendPlatformLoginReq(tbl.UID, "", tbl.UNAME, tbl.TOKEN, "koko", tbl.IID, tbl.SN)
        --require("net_bridge").beginCheckLoginTimeoutTimer(function()
        --    _G.disconnect()
        --    msgbox.showOk("游戏登录请求超时!", function() exitGame(false) end)
        --end)
    else
        msgbox.showOk(tbl.errMessage, Platform.OnLoginErrorCallback)
    end
end
function Platform.OnLoginErrorCallback()
    local envir = require("net_bridge").getLoginEnvir()
    if not kkPlatform and envir.isAccountLogin then
        local loading = findChild("Loading")
        if loading then
            loading:removeFromParent()
        end
    else
        --exitGame(false)
    end
end

--登录回应
Platform.OnLoginRet = function()
--if reconnect:isReconnecting() then
--    return
--end
--
--loading.setProgress(0.9)
--CC.LoginMgr.setShadeProgressRate(0.8)
end

--登录完成
Platform.OnLoginComplete = function()
--	require("net_bridge").cancelCheckLoginTimeoutTimer()
--	if reconnect:isReconnecting() then
--	    reconnect:onLoginComplete()
--	    return
--	end
    
    --loading.setProgress(1, true)
    --CC.LoginMgr.setShadeProgressRate(1)
    local function enter_game()
        --进入游戏界面
        if Game then
            SwitchToUIGame()
        end
    end
    DelayCallOnce(1.5, enter_game)
end

--网络发生错误
Platform.OnNetError = function()
    if reconnect:isReconnecting() then
        reconnect:onLostConnect()
    else
        reconnect:beginReconnect(Platform.OnReconnectResult)
    end
end

Platform.OnReconnectResult = function(is_success)
    if is_success then
        if not Game.isCoordinateConnected then
            disconnect()
            msgbox.showOk("与协同服务器断开连接", function() exitGame(true) end)
        end
    else
        if not kkPlatform and Game.isCoordinateConnected then
            disconnect2()
        end
        
        msgbox.showOk("网络重连失败！", function() exitGame(not Game.isCoordinateConnected) end)
    end
end
Platform.OnNotifyLogout = function()
    ccerr("您被游戏服务器踢下线")

    if not kkPlatform and Game.isCoordinateConnected then
        Game.isCoordinateConnected = false
        disconnect2()
    end

    if isconnected() then
        disconnect()
        msgbox.showOk("账号可能在异地登录", function() exitGame(not Game.isCoordinateConnected) end)
    end
end

--充值
Platform.Recharge = function()
    if kkPlatform then
        CC.Sample.Recharge:KB({HideBar = true})
    else
        local uid = Game.Player.UID
        if platform_isandroid() or platform_isios() then
            charge(uid, 0, 0)
        else
            if string.sub(uid, 1, 4) == "koko" then
                uid = string.sub(uid, 5)
            end
            local envir = require("net_bridge").getLoginEnvir()
            local token = envir.TOKEN
            local sn = envir.SN
            if callweb then
                local params = string.format("?uid=%s&token=%s&et=%s&type=3", uid, token, sn)
                local url = Config.RechargeUrl..params
                callweb(url)
            end
        end
    end
end
