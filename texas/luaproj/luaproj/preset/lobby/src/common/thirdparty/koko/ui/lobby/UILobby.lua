-----------------------------------------------------------------------------------
-- 大厅  2017.11
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
local UIMail = require "koko.ui.lobby.UIMail".UIMail
local UISetting = require "koko.ui.lobby.UISetting".UISetting
local UIBag = require "koko.ui.lobby.UIBag".UIBag
local UIInvite = require "koko.ui.lobby.UIInvite".UIInvite
local UITurntable = require "koko.ui.lobby.UITurntable".UITurntable
local UIEverydayLogin = require "koko.ui.lobby.UIEverydayLogin".UIEverydayLogin
local UIFirstCharge = require "koko.ui.lobby.UIFirstCharge".UIFirstCharge
local WelcomeManager = require "koko.ui.lobby.UIWelcome".WelcomeManager
local UIWelcomeGift = require "koko.ui.lobby.UIWelcome".UIWelcomeGift
local UIWelcomeRegIDCard = require "koko.ui.lobby.UIWelcome".UIWelcomeRegIDCard


module "koko.ui.lobby.UILobby"
UILobby = CC.UI:Create{
    Path = "koko/ui/lobby/lobby.csb", 
    Key = "UILobby", 
    Animation = false,
}
function UILobby:Prepare()
    -- 按钮和界面映射
    self.t.tUI = {
        btMail = UIMail, btTurntable = UITurntable, btSetting = UISetting, btBag = UIBag, 
        btWelfare = UIInvite, btEverydayLogin = UIEverydayLogin, btFirstCharge = UIFirstCharge,
        btCustom = "ui_customer_service", btActivity = "ui_activity", 
        btShop = "ui_shop"}
end

function UILobby:Dirty()
    ----------------------------------------------------------------
    -- 【错误】【错误】【错误】【错误】【错误】：逻辑不要依赖界面，移到该功能的数据类里, 并在Event.Login.After里触发
    --  【这代码不应该出现在大厅界面】
    --判断是不是游客账或第三方登录
    if _G.tostring(CC.Player.partyName) ~= "kokoLogin" then
        WelcomeManager:TryLoad()
        return
    end
    local function checkNickNameRep(t)
        _G.ccwrn(_G.json.encode(t))
        if not t.success and t.status and t.status == 26 then
            _G.ccwrn("uid:".._G.tostring(CC.Player.uid).."-----------appKey:".._G.tostring(CC.Player.appKey).."---------------nickName:".._G.tostring(CC.Player.nickName))
            _G.kk.uimgr.load("koko.ui.lobby.ui_player_info_change", "", 2)
        else
            WelcomeManager:TryLoad()
        end
    end
    local isOK,err = CC.Check:Account(CC.Player.uname)
    if isOK then
        CC.Web.sendCheckNickNameReq(CC.Player.uid, CC.Player.appKey, CC.Player.nickName, "昵称", checkNickNameRep)
    else
        _G.kk.uimgr.load("koko.ui.lobby.ui_player_info_change", "", 1)
    end
end

function UILobby:Load()
    self.t.bFunctionVisible = true
    
    C("btClose"):Click("OnClickClose")
    C("btRecharge"):Click("OnClickRecharge")
    C("btPersonal"):Click("OnClickPersonal")
    for k,v in _G.pairs(self.t.tUI) do
        C(k):Param(v):Click("OnClickFunction")
    end
    C("btWelfare"):To(200/317):Loop():Action()
    C("btRecharge"):From(0):To(317/317):Loop():Action()
    C("btFirstCharge"):To(65/317):Loop():Action()
    -- 测试
    if _G.CCTest then        
        C("btTest"):Click("OnClickTest")
        self.kEditTest = CC.Sample.Edit:Create({Node = C("btTest"):C("rPanel"):Node(), Any = true})
        if CC.DebugCheck("GM") then
            self.kEditTest:Text(CC.Debug.GM)
            self:OnClickTest()
        end
    end
    C("btTest"):Visible(_G.CCTest)
    --Welcome
    WelcomeManager:Load()
    if CC.DebugCheck("Welcome", false) then
    else
        if CC.PlayerMgr.Lobby.kSwitchFirstLoad:TryOn() then
            WelcomeManager:Add(UIWelcomeGift)
            WelcomeManager:Add(UIWelcomeRegIDCard)
        end
        --Name check
        self:Dirty()
    end

    CC.PlayerMgr.EverydayLoginInfo:Sync()

    --AutoTest
    if CC.DebugCheck("AutoTest") then
        self.Timer:Add("AutoTest", 0.01)
    end
    if CC.Version and CC.Version.Gov then
        self:CCVersion()
    end
    C("btTurntable"):Visible(false)
end

function UILobby:Update()
    if self.Timer:Check("AutoTest") then
        if CC.DebugCheck("AutoTest", "MJ") then
            if CC.GameMgr.Scene.kKey == "Lobby" then
                CC.GameMgr.Scene:Set("Game", {kGame = "麻将"})
            end
        end
        if CC.DebugCheck("AutoTest", "DZ") then
            if CC.GameMgr.Scene.kKey == "Lobby" then
                CC.GameMgr.Scene:Set("Game", {kGame = "德州扑克"})
            end
        end
    end
end

function UILobby:Refresh()
    --RedPoint
    C("btWelfare"):Component():C():Visible(CC.PlayerMgr.Invite:RedPoint())
    C("btActivity"):Component():C():Visible(CC.PlayerMgr.Activity:getRedState())
    C("btMail"):Component():C():Visible(CC.PlayerMgr.Mail:RedPoint())
    C("btBag"):Component():C():Visible(CC.ItemMgr.Manager.bRedPoint)
    C("btTurntable"):Component():C():Visible(CC.PlayerMgr.Turntable:RedPoint())
    C("btEverydayLogin"):Component():C():Visible(CC.PlayerMgr.EverydayLoginInfo.bRedPoint)
    --Functions
    C("btFirstCharge"):Visible(CC.PlayerMgr.FirstChargeGift.bStatus)
    C("rFunctions"):Visible(self.t.bFunctionVisible)
    --Player
    CC.PlayerMgr.IconBack:Image{Back = C("btPersonal"):C("iIconBack"):Node(), Icon = C("btPersonal"):C("iIcon"):Node()}
    C("txPlayerName"):Text(CC.Player.nickName)
    C("txPlayerLevel"):Text(CC.Player.level)
    --Money
    C("txKB"):Text(CC.Player.gold)
    C("txDiamond"):Text(CC.Player.diamond)
    C("txTicket"):Text(_G.math.floor(CC.Player.ticket / 100))
    C("rKB"):Param("KB"):Click("OnClickAdd")
    C("rDiamond"):Param("Diamond"):Click("OnClickAdd")
    C("rTicket"):Param("Ticket"):Click("OnClickAdd")
end

function UILobby:Unload()    
    WelcomeManager:Unload()
    for k,v in _G.pairs(self.t.tUI) do
        CC.UIMgr:Unload(v)
    end
end

function UILobby:OnClickTest()
    local k = self.kEditTest:Text()
    local t = CC.String:Split(k, " ")
    k = t[1]
    if k == "load" then
        CC.UIMgr:Load(_G.require("koko.ui.lobby."..t[2])[t[3] or t[2]])  
    elseif k == "id" then        
        CC.UIMgr:Load(UIWelcomeRegIDCard)
    elseif k == "item" then        
        CC.ItemMgr.Manager:Test()
    elseif k == "every" then
        CC.UIMgr:Load(UIEverydayLogin)   
    elseif k == "aa" then
         _G.kk.uimgr.call("kkShop", "refreshGold")
    elseif k == "invite" then
        CC.PlayerMgr.Invite:Test()
    elseif k == "vip" then
        CC.UIMgr:Load(ui_vip_privilege)
    elseif k == "EV" then
        CC.PlayerMgr.EverydayLoginInfo:test()  
        CC.UIMgr:Load(UIEverydayLogin)    
    elseif k == "reconnect" then
        CC.UIMgr:Load(UIReconnect)
    elseif k == "reconnectgame" then
        _G.disconnect()
        CC.Event("GameDisconnected")
    elseif k == "fi" then
        CC.UIMgr:Load(UIFirstCharge)
    elseif k == "mj" then 
        CC.GameMgr.Scene:Set("Game", {kGame = "麻将"}) 
    elseif k == "web" then
        local kUI = _G.require("koko.ui.login.UIWebView").UIWebView
        CC.UIMgr:Load(kUI) 
        CC.UIMgr:Call("UIWebView", {WebUrl = t[2] or "http://192.168.17.47/index.html"})
    elseif k == "dz" or true then 
        CC.GameMgr.Scene:Set("Game", {kGame = "德州扑克"}) 
    end
end

function UILobby:OnClickFunction(kNode)
    local kUI = C(kNode):Param()
    if CC.IsClass(kUI, "UI") then
        CC.UIMgr:Load(kUI)
    else
        _G.kk.uimgr.load("koko.ui.lobby."..kUI)
    end
end

function UILobby:OnClickClose()
    if self.t.kPartner then
        CC.UIMgr:Unload(self.t.kPartner)
        self:Call{setFunctionVisible = true}
        
        self.t.kPartner = nil
    else
        local kScene = CC.GameMgr.Scene.kKey
        if kScene == "Lobby" then
            CC.Message{Text = "是否退出界面？", Cancel = true, CallBack = function (bOK)
                if bOK then
                    CC.Data.downloadMgr:removeAllTask()
                    CC.PlayerMgr.Server:Logout()
                end
            end}
        elseif kScene == "Game" then
            local iGeneration = CC.GameMgr.Scene:GameExcel().Generation
            if iGeneration == 1 then
                _G.kk.event.dispatch(_G.E.EVENTS.lobby_click_back)
            elseif iGeneration == 2 then
                CC.Event("Game", {ClickClose = true})
            end
        end  
    end
end

function UILobby:Call(tVal)
    if tVal.setFunctionVisible ~= nil then
        self.t.bFunctionVisible = tVal.setFunctionVisible
        self:Refresh()
    end
    if tVal.Partner then
        self.t.kPartner = tVal.Partner
    end
end    
function UILobby:OnClickRecharge()
    local fg = CC.PlayerMgr.FirstChargeGift
    if fg.bStatus and fg:getBaoStatus() == "" then
        fg:setOpenType(1)
        CC.UIMgr:Load(UIFirstCharge)
    else
        _G.kk.uimgr.load("koko.ui.lobby.ui_recharge")
    end
end
function UILobby:OnClickPersonal()
    if CC.Player:IsAccountNeedUpgrate() then
        _G.kk.msgbox.showOk("游客账号无法进入个人中心")
        return
    end
    _G.kk.uimgr.load("koko.ui.lobby.ui_personal")
end

function UILobby:OnClickAdd(kNode)
    local kKey = C(kNode):Param()
    local kRecharge = CC.Sample.Recharge
    kRecharge[kKey](kRecharge)
end

function UILobby:CCVersion()
    if CC.Version and CC.Version.Gov then
        for k,v in _G.pairs(self.t.tUI) do
            C(k):Visible(false)
        end
        C("btSetting"):Visible(true)
        C("rTicket"):Visible(false)
        C("rDiamond"):Visible(false)
        C("btPersonal"):Visible(true)
        C("btPersonal"):Enabled(false)
        C("btRecharge"):Visible(false)
        C("rDiamond"):Nine():Attach(C("rKB"):Nine())
        WelcomeManager:Unload()
    end
end