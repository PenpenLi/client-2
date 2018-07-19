-----------------------------------------------------------------------------------
-- 游戏管理类  2017.9
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
local NetBridge = require("net_bridge")
local Waygate = require "koko.form2".Waygate
local UILobby = require "koko.ui.lobby.UILobby".UILobby
local UILobbyKOKO = require "koko.ui.lobby.UILobbyKOKO".UILobbyKOKO
module "koko.data.GameMgr"
-----------------------------------------------------------------------------------
Game = CC.Class({}, "Game")
function Game:__Load()
    self.t = {}

    --GameStyle
    local kExcelStyle = CC.GameMgr.GameStyle:Excel()
    CC.UIMgr:LayoutMap():Set(kExcelStyle.GameLayoutMap)

    CC.Audio:Music()
    if CC.UIMgr:Get(self.Key) then
        CC.Print("Game:__Load "..self.Key.." twice")
        return
    end
    local kExcel = self:Excel()
    CC.Print("================================================================ Load "..self.Key)
    _G.add_search_path(kExcel.LocalDir)
    CC.UIMgr:Set(self.Key, self)
    Waygate:Load(_G.require(kExcel.LocalDir.."."..kExcel.NetFile), 1)
    RoomCenter:__Load()

    if self.Load then
        self:Load()
    end

    self:TryLogin{ kCallBack = function (bOK)        
        if not bOK then
            CC.Message("登陆游戏失败", function()
                CC.Event("Game", {LoginResult = false, LoadingName = "UILoading_mj"})
            end)
        end
    end}
end

function Game:TryLogin(tVal)
    tVal = tVal or {}
    local kExcel = self:Excel()
    NetBridge.getGameConnection(kExcel.GameId, function (bOK, kData)
        if bOK then
            bOK = _G.connect(kData.ip_, CC.ToNumber(kData.port_))
            if bOK then
                CC.SendGame(994, {uid_ = CC.Player.uid, head_icon_ = "", uname_ = CC.Player.nickName, vip_lv_ = 0, platform_ = "koko", sn_ = CC.Player.sequence,
                    iid_ = CC.Player.iid, url_sign_ = CC.Player.token, head_ico_ = CC.PlayerMgr.IconBack.iIcon, headframe_id_ = CC.PlayerMgr.IconBack.iIconBack}, "登入游戏服务器")
            end
        end
        if tVal.kCallBack then
            tVal.kCallBack(bOK)
        end        
    end)
end

function Game:UIMgr(tUI)
    local kClass = {}
    kClass.kPartner = self
    kClass.tUI = tUI or self.UI or {}
    function kClass:Load()
        self:__Do(function (kUI)
            CC.UIMgr:Load(kUI)
        end, true)
    end
    function kClass:Unload()
        self:__Do(function (kUI)
            CC.UIMgr:Unload(kUI)
        end)
    end
    function kClass:Do(kFunc, tVal)
        self:__Do(function (kUI)
            CC.UIMgr:Do(kUI.Key, kFunc, tVal)
        end)
    end
    function kClass:__Do(kCallBack, bLoad)
        for k,v in _G.pairs(self.tUI) do
            local kGame = (v == "UILobby" and UILobby) or (bLoad and _G.require (self.kPartner.Dir.."."..v)[v]) or CC.UIMgr:Get(v)
            if kGame then
                kCallBack(kGame)
            end
        end
    end
    return kClass
end

function Game:Excel()
    return CC.Excel.GameList[self.iGame]
end

function Game:__Unload()
    if not CC.UIMgr:Get(self.Key) then
        CC.Print("GameMgr.Manager:UnloadGame "..kGame.__kName.." not existed")
        return
    end

    if self.Unload then
        self:Unload()
    end
    self.t = nil
    CC.UIMgr:Set(self.Key, nil)
    Waygate:Unload(1)
    RoomCenter:__Unload()
    if not CC.Version then
        _G.remove_search_path(self:Excel().LocalDir)
    end
    _G.disconnect()
    CC.Audio:Music()

    --GameStyle
    CC.UIMgr:LayoutMap():Reset()
    CC.Print("================================================================ Unload "..self.Key)
end

function Game:Create(tVal)
    if tVal and tVal.Dir and tVal.Key then
        return CC.Class(tVal, tVal.Key, Game):__New()
    end
end

-----------------------------------------------------------------------------------
Manager = CC.BoxMgr:Create()
function Manager:Load()
    self.kGameKey = nil
end

function Manager:Unload()
    -- body
end

function Manager:LoadGame(kGame)
    if CC.IsClass(kGame, "Game") then
        if self.kGameKey then
            CC.Print("GameMgr:LoadGame error "..kGame.Key .. "("..self.kGameKey..")")
        else
            kGame:__Load()
            self.kGameKey = kGame.Key
            CC.UIMgr:Set("Game", kGame)
        end
    end
end

function Manager:UnloadGame()
    if self.kGameKey then
        CC.UIMgr:Do(self.kGameKey, "__Unload")
        CC.UIMgr:Set("Game", nil)
        self.kGameKey = nil
    end
end
-----------------------------------------------------------------------------------
Scene = {kKey = "Null", iGame = nil}
function Scene:Set(kKey, tVal)
    local kOld = self.kKey
    CC.Assert(kKey ~= kOld, "Scene "..kKey.." is existed already")
    local kData = CC.Excel.Scene.Key[kKey]:At(1)
    CC.Assert(kData, "Scene "..kKey.." not existed")
    local bOK = false
    local iGame = nil
    local kOldGameExcel = self:GameExcel()
    -- Old
    if kOld == "Game" then
        -- 老游戏兼容
        if kOldGameExcel.Generation == 1 then
            _G.remove_search_path(self:GameExcel().LocalDir)
        end
    end


    -- New
    if kKey == "Login" then
        if kOld == "Null" then
            bOK = true
            _G.kk.uimgr.load("koko.ui.login.ui_login")
        elseif kOld == "Lobby" then
            bOK = true
            _G.disconnect2()
            CC.Event("Logout")
            _G.kk.uimgr.exitAll()
            CC.UIMgr:ExitAll()
            _G.kk.msgbox.closeAll()
            if CC.LoginMgr.tData.isAutologin then
                _G.exit(0)
            else
                _G.kk.uimgr.load("koko.ui.login.ui_login")
            end
        elseif kOld == "Game" then
            bOK = true
            self:Set("Lobby")
            self:Set("Login")
        end
    elseif kKey == "Lobby" then
        if kOld == "Login" then
            bOK = true
            --_G.kk.uimgr.unload("kkLogin")
            --_G.kk.uimgr.unload("kkAccLogin")
            _G.kk.uimgr.exitAll()
            CC.UIMgr:Unload("UILoading")
            CC.UIMgr:Load(UILobbyKOKO)
            CC.UIMgr:Load(UILobby)
            _G.kk.waiting.close()
        elseif kOld == "Game" then
            bOK = true
            CC.GameMgr.Manager:UnloadGame()
            local kData = CC.Excel.GameList[self.iGame]
            _G.require("koko.data.online_timer").stop()
            _G.set_reconnect_timeout(3600)
            CC.UIMgr:Unload(UILobbyKOKO)
            CC.UIMgr:Load(UILobbyKOKO)
            CC.UIMgr:Unload(UILobby)
            CC.UIMgr:Load(UILobby)
            _G.kk.waiting.close()
        end
    elseif kKey == "Game" then
        if kOld == "Lobby" then
            bOK = true
            iGame = tVal.kGame and CC.Excel.GameList.Name[tVal.kGame]:At(1).ID  or tVal.iGame
            local kData = CC.Excel.GameList[iGame]
            if kData then
                if not _G.platform_iswin32() then
                    _G.set_reconnect_timeout(3)
                end
                local iGeneration = kData and kData.Generation or 1
                if iGeneration == 1 then
                    _G.add_search_path(kData.LocalDir)
                    _G.require(kData.MainFile)
                    if CC.LoginMgr.getLoginMgrPLATFORM() == "koko" then
                        _G.kk.waiting.show("")
                    end
                    _G.require("net_bridge").dispatchEvent("onSyncItem", 0, CC.Player.diamond)
                    _G.require("net_bridge").dispatchEvent("onSyncItem", 2, CC.Player.ticket)
                elseif iGeneration == 2 then
                    CC.UIMgr:Unload(UILobby)
                    CC.UIMgr:Unload("UILobbyKOKO")
                    local kGame = _G.require(kData.LocalDir.."."..kData.MainFile)[kData.MainFile]
                    kGame.iGame = iGame
                    CC.GameMgr.Manager:LoadGame(kGame)
                end

                --在线时长
                _G.require("koko.data.online_timer").start(kData.GameId)
            else
                CC.Print("SwitchGame error:"..(iGame or ""))
            end
        end
    end
    if bOK then
        self.kKey = kKey
        self.iGame = iGame
        CC.Print("Scene to "..kKey)
    else
        CC.Assert(false, "Scene:Set you can't change scene from "..kOld.. " to ".. kKey)
    end
end

function Scene:Excel()
    return CC.Excel.Scene.Key[self.kKey]:At(1)
end

function Scene:GameExcel()
    return CC.Excel.GameList[self.iGame]
end

-----------------------------------------------------------------------------------
RoomCenter = CC.Box:Create()
function RoomCenter:Load()
    self.t.tList = {}
    self.t.kMe = nil
    self.t.iJoinID = nil
end

function RoomCenter:Add(tVal) -- iType : 0-金币场玩法,1-积分场,2-私人场 100排位赛
    _G.assert(tVal.iID, "MJ RoomCenter:Add iID is nil")
    local tTemp = {iType = 0, iCostMin = 0, iScore = 0, iCostMax = 0, bMe = false}
    local kClass = CC.Upgrade(tTemp, tVal)
    function kClass:Join()
        RoomCenter.t.iJoinID = self.iID
        RoomCenter:Rejoin()
    end
    function kClass:Check(iVal)
        return iVal >= self.iCostMin and (iVal <= self.iCostMax or self.iCostMax == 0)
    end
    if kClass.bMe then
        self.t.kMe = kClass
        self.t.iJoinID = kClass.iID
    end
    if kClass.iType == 0 then
        _G.table.insert(self.t.tList, kClass)
    elseif kClass.iType == 1 then
        self.t.kRelaxation = self.t.kRelaxation or kClass
    end
end

function RoomCenter:Count()
    return #self.t.tList
end

function RoomCenter:At(i)
    return self.t.tList[i]
end

function RoomCenter:Me()
    return self.t.kMe
end

function RoomCenter:Rejoin()
    if self.t.iJoinID then
        CC.SendGame(502, {room_id_ = CC.Math:LeftMove(self.t.iJoinID, 24) + 0}, "进入房间")
        return true
    end
end

function RoomCenter:Relaxation()
    return self.t.kRelaxation
end

-----------------------------------------------------------------------------------
GameStyle = CC.Box:Create()
function GameStyle:Load()
    self.t.kStyle = _G.envir_gettable().PLATFORM
end

function GameStyle:Excel()
    return CC.Excel.GameStyle.Platform[self.t.kStyle]:At(1)
end