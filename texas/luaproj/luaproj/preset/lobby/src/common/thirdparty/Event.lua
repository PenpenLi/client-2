-----------------------------------------------------------------------------------
-- 事件  2017.9
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
local UILobby = require("koko.ui.lobby.UILobby").UILobby
local UIReconnectGame = require("koko.ui.game.UIReconnectGame").UIReconnectGame

module "Event"
-----------------------------------------------------------------------------------
-- 注册事件参考下面Call函数内容，调用事件方法如下
-- CC.Event(事件名，参数table[可空])
-- 示例：CC.Event("RefreshItem")
-- 示例：CC.Event("RefreshItem", {RedPoint = true})

-- 重要提示：如果事件名称包含"Refresh"将会优化，比如一次性收到200次，只执行2次有效刷新
Event = {}
function Event:Call(kKey, tVal)
    tVal = tVal or {}    
    CC.Print("Event "..(tVal.__EventDelayCall and "=> " or "-> ")..kKey)
    -----------------------------------------------------------------------------------
    -- 刷新物品
    if kKey == "RefreshItem" then
        if tVal.RedPoint then
            CC.UIMgr:Do("UILobby", "Refresh")
        else
            CC.UIMgr:Do("UILobby", "Refresh")
            CC.UIMgr:Do("UIBag", "Refresh")
        end
    -- 刷新玩家信息
    elseif kKey == "RefreshPlayer" then
        CC.UIMgr:Do("UILobby", "Refresh")
        CC.UIMgr:Do("UIPersonalInfo", "Refresh")
        CC.UIMgr:Do("UIPersonalInfoIcon", "Refresh")
        CC.UIMgr:Do("UIWelcomeGift", "Refresh")
        CC.Data.entryCache:setCurrentNickName(CC.Player.nickName)
    --邮件
    elseif kKey == "RefreshMail" then
        CC.UIMgr:Do("UILobby", "Refresh")
        CC.UIMgr:Do("UIMail", "Refresh")
        CC.UIMgr:Do("UIMailInfo", "Refresh")     
    --时间
    elseif kKey == "RefreshTime" then
        self:Call("RefreshMail")
    --邀请
    elseif kKey == "RefreshInvite" then
        CC.UIMgr:Do("UILobby", "Refresh")
        CC.UIMgr:Do("UIInvite", "Refresh")            
        CC.UIMgr:Do("UIInviteGift", "Refresh")       
        CC.UIMgr:Do("UIInviteGiftList", "Refresh")
    --礼物
    elseif kKey == "Gift" then
        if tVal.Got then
            if tVal.kKey == "Mail" then
                CC.UIMgr:Call("UIMail", {AutoGet = 2, iID = _G.tonumber(tVal.kValue1)})
            end
        end
    --礼包
    elseif kKey == "RefreshGift" then
        self:Call("RefreshTurntable")
    --转盘
    elseif kKey == "RefreshTurntable" then
        CC.UIMgr:Do("UITurntable", "Refresh")
    -- 活动小红点
    elseif kKey == "ActivityRedPoint" then
        if tVal.RedPoint then
            _G.kk.uimgr.call("kkActivity", "refreshRedPoint")
            _G.kk.uimgr.call("kkLimitTimeActive", "refreshRedPoint")       
            CC.UIMgr:Do("UILobby", "Refresh")
        else 
            CC.UIMgr:Do("UIEverydayLogin", "Refresh")
        end
    -- 登陆
    elseif kKey == "Login" then
        if tVal.Before then
            CC.GameMgr.Manager:Init(CC.GameMgr)
            CC.GameMgr.Manager:Load()
            CC.ItemMgr.Manager:Load()
            CC.PlayerMgr.Manager:Load()
            CC.PlayerMgr.Lobby.kSwitchFirstLoad:TryOff()
        elseif tVal.After then
            CC.PlayerMgr.Invite.List:Sync()
            CC.PlayerMgr.Activity:Load()
            CC.PlayerMgr.Activity:Sync()
            CC.PlayerMgr.FirstChargeGift:Load()
            CC.PlayerMgr.FirstChargeGift:Sync()
            CC.PlayerMgr.RechargeList:Load()
            CC.PlayerMgr.Shop:Load()
            CC.PlayerMgr.Shop:Sync()
        end
    -- 退大厅
    elseif kKey == "Logout" then
        CC.UIMgr:Unload("UILobby")
        CC.ItemMgr.Manager:Unload()
        CC.PlayerMgr.Manager:Unload()
        CC.GameMgr.Manager:Unload()
    -- 重连
    elseif kKey == "Reconnect" then
        if tVal.OK then
            --成功
        else
            --失败
            if CC.GameMgr.Scene.kKey == "Lobby" then
                _G.kk.msgbox.showOk("连接服务器失败", function ()
                    CC.PlayerMgr.Server:Logout()
                end)
            else
                _G.require("net_bridge").dispatchEvent("onCoordinateDisconnect", "重连协同服务器失败！")
            end
        end
    -- 断线
    elseif kKey == "Disconnected" then
        if tVal.Kick then
            CC.Print("Server:Disconnected 被服务器踢了")
            CC.PlayerMgr.Server.bKick = true
            if CC.GameMgr.Scene.kKey == "Lobby" then
                CC.Message{Text = "您的账号已在其他设备登录!", CallBack = function ()
                    CC.PlayerMgr.Server:Logout()
                end}
            elseif CC.Game then
                _G.disconnect()
                CC.Event("GameDisconnected", {Kick = true})
            else
                _G.require("net_bridge").dispatchEvent("onCoordinateDisconnect", "您的账号已在其他设备登录!")
            end
        else
            --开始重连
            if not CC.Data.ReconnectMgr.isReconnecting() then
                CC.Data.ReconnectMgr.startReconnect()
            end
        end
    -- 游戏断线
    elseif kKey == "GameDisconnected" then
        if CC.Game then
            if tVal.Kick then
                CC.Message("游戏被踢下线", function()
                    CC.GameMgr.Scene:Set("Login")
                end)
            else
                CC.UIMgr:Unload(UIReconnectGame)
                CC.UIMgr:Load(UIReconnectGame)
            end
        end
    -- 游戏重连
    elseif kKey == "GameReconnect" then
        CC.UIMgr:Call("Game", {Event = "GameReconnect"})
    -- 程序
    elseif kKey == "Program" then      
        if tVal.Run then
            Event:Load()
            CC.Data.StartupParamMgr.load()
        elseif tVal.Exit then
            Event:Unload()
            CC.Data.StartupParamMgr.clearParam()
            _G.exit(0)
        end
    -- 游戏 ClickClose点击退出游戏   LoginResult登陆退游戏or进游戏
    elseif kKey == "Game" then
        if tVal.LoginResult ~= nil then
            if tVal.LoginResult then
                CC.UIMgr:Do(tVal.LoadingName, "setProgress", 1)
                _G.kk.timer.delayOnce(0.3, function()
                    CC.UIMgr:Unload(tVal.LoadingName)
                end)
            else
                if CC.GameMgr.Scene.kKey == "Game" then
                    CC.GameMgr.Scene:Set("Lobby")
                end
                if CC.LoginMgr.tData.GM then
                    CC.GameMgr.Scene:Set("Login")
                end
                CC.UIMgr:Unload(tVal.LoadingName)
            end
        elseif tVal.ClickClose then
            CC.GameMgr.Scene:Set("Lobby")
            if CC.LoginMgr.tData.GM then
                CC.GameMgr.Scene:Set("Login")
            end
        end
    elseif kKey == "CLZB" then
        
    end
end
----------------------------------------------------------------
function Event:Load()
    self.Timer = CC.Timer:Create(self)
    self.tVal = {}
    self.Timer:Load()
end
function Event:Unload()
    self.tVal = nil
    self.Timer:Unload()
end
function Event:Update(fDelta)
    while true do
        local kKey = self.Timer:Check()
        if kKey then
            local tChild = CC.String:Split(kKey, "_")
            if tChild[1] == "T2" then
                local kFix = tChild[2]
                self:Refresh(kFix, self.tVal[kFix])
                self.tVal[kFix] = nil
            end
        else
            break
        end
    end
end
function Event:Refresh(kKey, tVal)
    local bT1 = self.Timer:Has("T1_"..kKey)
    local bT2 = self.Timer:Has("T2_"..kKey)
    if not bT2 then
        if bT1 then
            self.tVal[kKey] = CC.SimpleCopy(tVal) or {}
            self.tVal[kKey].__EventDelayCall = true
            self.Timer:Add("T2_"..kKey, 0.1)
            self.Timer:Del("T1_"..kKey)
        else
            self:Call(kKey, tVal)
            self.Timer:Add("T1_"..kKey, 1)
        end         
    end    
end