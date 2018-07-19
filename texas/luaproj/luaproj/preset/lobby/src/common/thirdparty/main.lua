--调试：去掉下面--，ZeroBrane里Project->StartDebuggerServer，然后运行游戏即可（【禁止】上传）。
--调试：全局变量CCDebug，用于一些测试功能
require ("comm.mobdebug").start()
--CCDebug = {Server = 32, Web = 2, AutoLogin = false, ClickLog = false, Welcome = false, GM = nil, AutoTest = false}
--CCDebug = {Server = nil, Web = nil, AutoLogin = true, ClickLog = false, Welcome = false, GM = nil, AutoTest = "DZ"}
--CCTest = true   --外网必须是false


--koko平台全局标记
kkPlatform = true
--CCVersion = {Gov = true}

require "cocos.init"
_G.kk = require("comm.kk")
_G.E = _G.kk.enum

require "trigger"
require "chat.init"

local _resolution_width = 1280
local _resolution_height = 720
local function initGLView()
    local director = cc.Director:getInstance()
    local glView = director:getOpenGLView()
    if not glView then
        local rc = cc.rect(0, 0, _resolution_width, _resolution_height)
        local envir = envir_gettable()
        local scale = 1.0
        if envir.SIZE then
            local tsize = splitstr(envir.SIZE, "*")
            if #tsize == 2 and tonumber(tsize[2]) > 0 then
                scale = tonumber(tsize[2]) / _resolution_height
            end
        end
        if platform_iswin32() then
            --解析父窗口
            local hwnd = envir.PHWND and tonumber(envir.PHWND) or 0
            if hwnd ~= 0 then
                glView = cc.GLViewImpl:createWithRect("", rc, scale, hwnd)
            else
                glView = cc.GLViewImpl:createWithRect("", rc, scale)
            end
        else
            glView = cc.GLViewImpl:createWithRect("", rc, scale)
        end
    end

    director:setOpenGLView(glView)
    glView:setDesignResolutionSize(_resolution_width, _resolution_height, cc.ResolutionPolicy.EXACT_FIT)
    --turn on display FPS
    director:setDisplayStats(false)
    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 60)
    --一小时内不断线
    set_reconnect_timeout(3600)
end

local function main()
    cclog("====================koko游戏启动====================")
    cclog("[命令行参数] %s", json.encode(envir_gettable()))

    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    -- 设置随机数种子
    math.newrandomseed()

    -- 初始化OpenGL视图
    initGLView()
    
    --创建场景
    cc.Director:getInstance():replaceScene(cc.Scene:create())
    

    local CC = require "comm.CC"
    CC.Load()
    CC.CC = CC
    CC.Event("Program",{Run = true})

    if CC.Debug and CC.Debug.ClickLog then
        set_widget_touch_listener(function(widget)
            print("点击："..CC.Node:Path(widget))
        end)
    end
    CC.Excel:Prepare()
    --登录
    CC.LoginMgr.Load()
end

xpcall(main, __G__TRACKBACK__)

