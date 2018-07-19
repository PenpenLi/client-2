-----------------------------------------------------------------------------------
-- 玩家类  2017.9
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
local proto2 = require("koko.proto2")
module "koko.data.PlayerMgr"
-----------------------------------------------------------------------------------
Player = CC.Class({iID = 0, tProperty = {}}, "Player")
function Player:Create(iID)
    local kClass = self:__New()
    kClass.iID = iID
    return kClass
end
function Player:Name()
    return self:Property(0)
end
function Player:Property(iIndex, _iVal)
    local tProperty = CC.Table:At(self.tProperty, iIndex, {kStep = CC.Step(3), kVal = self:Default():Name()})
    if tProperty.kStep:Try(1) then
        if self.iID == 0 then
            return self:Property(iIndex, "")
        else
            CC.Send(1032, {data_id_ = iIndex, params = self.iID}, "获取玩家["..self.iID.."]属性")
        end
    elseif _iVal and tProperty.kStep:Try(2) then
        tProperty.kVal = _iVal
    end
    return tProperty.kVal
end
function Player:Default()
    local kClass = {tParent = self}
    function kClass:Name()
        return "["..self.tParent.iID.."]"
    end
    return kClass
end
-----------------------------------------------------------------------------------
Manager = {tPlayer = {}}
function Manager:Load()
    self:Unload()
    Invite:Load()
    IconBack:Load()
    Server:Load()
    Setting:Load()
    EverydayLoginInfo:Load()
    Mail:Load()
    Turntable:Load()
    Gift:Load()
    Time:Load()
end

function Manager:Update(fDelta)
    -- body
end

function Manager:Get(iID)
    iID = iID or 0
    return CC.Table:At(self.tPlayer, iID, Player:Create(iID))
end

function Manager:Test()
    Mail:Test()
end

function Manager:Unload()
    tPlayer = {}
    Time:Unload()
end
-----------------------------------------------------------------------------------
local LC_InviteGift = {iInvite = 0, tGift = {}, bRedPoint = false, NE_COUNT = 4}
function LC_InviteGift:Load()
    self:Num(0)
end
function LC_InviteGift:Num(iVal)
    self.iInvite = iVal
    self.tGift = self.tGift or {}
    for i=1,self.NE_COUNT do
        local kExcel = CC.Excel.InviteGift[i]
        self:Gift(kExcel.ID, kExcel.InviteNum <= iVal and 2 or 1, false)
    end
    self:Refresh()
end
function LC_InviteGift:Test()
    if CC.Debug then 
        self:Num(CC.Math:Random(30))
    end
end
function LC_InviteGift:Gift(iID, iStep, bRefresh)
    self.tGift[iID] = _G.math.max(self.tGift[iID] or 1, iStep)
    if bRefresh ~= false then
        self:Refresh()
    end
end
function LC_InviteGift:Refresh()
    self.bRedPoint = false
    for k,v in _G.pairs(self.tGift) do
        if v == 2 then
            self.bRedPoint = true
        end
    end
    CC.Event("RefreshInvite")
end

----------------------------------------
local LC_InviteList = {Step = 1--[[1正常2有码3已领4临时账号]], bRedPoint = false, tData = {iAll = 0, iGot = 0, iCan = 0}}
function LC_InviteList:Load()
end
function LC_InviteList:Sync()
    CC.SendWeb("promotion/PromotionCun.htm", {}, function (tVal)
        if tVal.success then
            local kData = tVal.data.result
            self.tData.iPlayer = kData.Promotion_total
            self.tData.iGot = kData.Promotion_true
            self.tData.iCan = kData.Promotion_false
            self.bRedPoint = kData.Promotion_false > 0
            CC.Event("RefreshInvite")
        end
    end)
end
----------------------------------------
Invite = {}
function Invite:Load()
    self.Gift = LC_InviteGift
    self.List = LC_InviteList
    self.Gift:Load()
    self.List:Load()
end
function Invite:Test()
    self.Gift:Test()
end
function Invite:RedPoint()
    return self.Gift.bRedPoint or self.List.bRedPoint
end
-----------------------------------------------------------------------------------
IconBack = { iIcon = 0, iIconBack = 1, tData = {}, tIconData = {}}
function IconBack:Load()
    self.iIconBack = 1
    self.iIcon = 0
    self.tData = {[1] = true}
    for i = 0, CC.Excel:Param("UIPersonalInfoIcon", "HeadIconCount") - 1 do
        if i >= 6 then
            self.tIconData[i] = {id = i, value = "不可用"}
        else
            self.tIconData[i] = {id = i, value = "永久可用"}
        end
    end
end
function IconBack:Add(iVal)
    self.tData[iVal] = true
    CC.Event("RefreshPlayer")
end
function IconBack:AddIcon(iVal, iSec)
    local tab = _G.os.date("*t", _G.tonumber(iSec) + _G.os.time())
    local time_stamp = _G.string.format("%04d年%02d月%02d日", tab.year, tab.month, tab.day)..[[前可用]]
    for k, v in _G.pairs(self.tIconData) do
        if v.id == iVal then
            v.value = time_stamp
            CC.Event("RefreshPlayer")
            return
        end
    end
end
function IconBack:HasById(id)
    for k, v in _G.pairs(self.tIconData) do
        if v.id == id then
            return v
        end
    end
    return self.tIconData[0]
end
function IconBack:Has(iVal)
    return self.tData[iVal]
end
function IconBack:Image(tVal)
    if tVal.Icon then
        local path = "koko/atlas/head_ico/"..(tVal.iIcon or self.iIcon)..".png"
        if _G.cc.SpriteFrameCache:getInstance():getSpriteFrame(path) then
            tVal.Icon:loadTexture(path, 1)
        end
    end
    if tVal.Back then
        --tVal.Back:loadTexture(CC.Excel.PlayerIconBack[(tVal.iBack or self.iIconBack)].Icon, 1)
    end
end
--游戏中 使用时判断非空 如果为空 就使用游戏中默认的 
function IconBack:getHeadImgPath(imgNum)
    local path = "koko/atlas/head_ico/".._G.tostring(imgNum)..".png"
    if not _G.cc.SpriteFrameCache:getInstance():getSpriteFrame(path) then
        path = "koko/atlas/head_ico/4.png"
    end
    return path
end
function IconBack:getHeadBackImgPath(imgNum)
    local path = CC.Excel.PlayerIconBack[1].Icon
    if _G.type(imgNum) == "number" then
        local tbl = CC.Excel.PlayerIconBack[imgNum]
        if tbl and _G.cc.SpriteFrameCache:getInstance():getSpriteFrame(tbl.Icon) then
            path = tbl.Icon
        end
    end
    return path
end
-----------------------------------------------------------------------------------
--  活动公告
Activity = {tNotice = {}, tActive = {}, iNoticeRedNum = 0, iActiveRedNum = 0, NoticeTxt = {}, HintTxt = {}}
function Activity:Load()
    self.iNoticeRedNum = 0
    self.tNotice[1] = false
    self.tNotice[2] = false
    self.NoticeTxt = {"", ""}
    self.HintTxt = {"", ""}
    for i = 1, 8 do
        self.tActive[i] = false
    end
    self.iActiveRedNum = 0
end
function Activity:Sync()
    local function callback1(t)
        if t.success then
            if t.data.result == nil then return end
            self.NoticeTxt[1] = t.data.result.title or "更新公告"
            self.NoticeTxt[2] = t.data.result.content or "当前无更新公告"
            local txtmd5 = _G.mdstring(self.NoticeTxt[2])
            local md5 = _G.kk.xml.getString("ActivityNoticeMd5")
            if txtmd5 == md5 then
                self.tNotice[1] = false
            else    
                self.tNotice[1] = true
                self.iNoticeRedNum = self.iNoticeRedNum + 1
            end
        end    
    end
    local function callback2(t)
        if t.success then
            if t.data.result == nil then return end
            self.HintTxt[1] = t.data.result.title
            self.HintTxt[2] = t.data.result.content
            local txtmd5 = _G.mdstring(self.HintTxt[2])
            local md5 = _G.kk.xml.getString("ActivityHintMd5")
            if txtmd5 == md5 then
                self.tNotice[2] = false
            else    
                self.tNotice[2] = true
                self.iNoticeRedNum = self.iNoticeRedNum + 1
            end
        end  
    end
    _G.web.sendNoticeReq(CC.Player.uid, CC.Player.appKey, "Update", callback1)
    _G.web.sendNoticeReq(CC.Player.uid, CC.Player.appKey, "Warmth", callback2)
end
function Activity:writeNociceMd5()
    local md5 = _G.kk.xml.getString("ActivityNoticeMd5")
    local txtmd5 = _G.mdstring(self.NoticeTxt[2])
    if md5 ~= txtmd5 then
        _G.kk.xml.setString("ActivityNoticeMd5", txtmd5)
    end    
end
function Activity:writeHintMd5()
    local md5 = _G.kk.xml.getString("ActivityHintMd5")
    local txtmd5 = _G.mdstring(self.HintTxt[2])
    if md5 ~= txtmd5 then
        _G.kk.xml.setString("ActivityHintMd5", txtmd5)
    end 
end
function Activity:ChangeNoticeRedState(iVal, f)
    if self.tNotice[iVal] == f then return end
    self.tNotice[iVal] = f
    local n = f and 1 or -1
    self.iNoticeRedNum = self.iNoticeRedNum + n
    CC.Event("ActivityRedPoint", {RedPoint = true})
end
function Activity:ChangeActiveRedState(iVal, f)
    if self.tActive[iVal] == f then return end
    self.tActive[iVal] = f
    local n = f and 1 or -1
    self.iActiveRedNum = self.iActiveRedNum + n
    CC.Event("ActivityRedPoint", {RedPoint = true})
end
function Activity:Has(tVal, iVal)
    return tVal[iVal]
end
function Activity:getNoticeRedState()
    return self.iNoticeRedNum ~= 0
end
function Activity:getActiveRedState()
    return self.iActiveRedNum ~= 0
end
function Activity:getRedState()
    return self.iNoticeRedNum ~= 0 or self.iActiveRedNum ~= 0
end
-----------------------------------------------------------------------------------
--  每日登陆奖励领取状态
EverydayLoginInfo = { iSerialDay = 0, iSerialState = {}, iloginDay = 1, iLoginState = 0, bRedPoint = false, bFirstLoad = true} --  0 未领取   1 已领取
function EverydayLoginInfo:Load()
    self.iSerialDay = 0
    for i = 1, 3 do
        self.iSerialState[i] = 0
    end
    self.iloginDay = 1
    self.iLoginState = 0
    self.bRedPoint = false
    self.bFirstLoad = true
end
function EverydayLoginInfo:Sync()
    proto2.sendLoginPrizeListReq()
end    
function EverydayLoginInfo:setInfo(SerialDay, SerialState, loginDay, LoginState, RedPoint)
    self.iSerialDay = SerialDay
    self.iSerialState = SerialState
    self.iloginDay = loginDay
    self.iLoginState = LoginState
    self.bRedPoint = RedPoint
end
function EverydayLoginInfo:setSerialState(i, ival)
    if self.iSerialState[i] == ival then return end
    self.iSerialState[i] = ival
    for x = 1, i do
        if self.iSerialState[x] == 0 or self.iLoginState == 0 then
            self.bRedPoint = true
            break
        else
            self.bRedPoint = false    
        end
    end
end
function EverydayLoginInfo:setLoginState(ival)
    if self.iLoginState == ival then return end
    self.iLoginState = ival
    if self.iSerialState[1] == 0 or self.iSerialState[2] == 0 or self.iSerialState[3] == 0 or self.iLoginState == 0 then
        self.bRedPoint = true
    else
        self.bRedPoint = false
    end
end
function EverydayLoginInfo:test()
    self.iSerialDay = 0
    self.iSerialState[1] = CC.Math:Random(10)%2
    self.iSerialState[2] = CC.Math:Random(10)%2
    self.iSerialState[3] = CC.Math:Random(10)%2
    self.iloginDay = 4
    self.bRedPoint = true
    self.iLoginState = CC.Math:Random(10)%2
    CC.PlayerMgr.Activity:ChangeActiveRedState(3, true)
    CC.Event("ActivityRedPoint")
end
-----------------------------------------------------------------------------------
--
Server = {bKick = false}
function Server:Load()
    self.bKick = false
end
function Server:Logout()
    CC.GameMgr.Scene:Set("Login")
end
-----------------------------------------------------------------------------------
Setting = {}
function Setting:Load()
    self:Music(self:Music())
end

function Setting:Music(tVal)
    if tVal then
        if tVal.Background ~= nil then
            self:Set("Music.Background", tVal.Background)
            _G.cc.SimpleAudioEngine:getInstance():setMusicVolume(tVal.Background and 1 or 0)
        end
        if tVal.Effect ~= nil then
            self:Set("Music.Effect", tVal.Effect)
            _G.cc.SimpleAudioEngine:getInstance():setEffectsVolume(tVal.Effect and 1 or 0)
            if not tVal.Effect then
                _G.cc.SimpleAudioEngine:getInstance():stopAllEffects()
            end
        end
    else
        return {Background = self:Get("Music.Background", true), Effect = self:Get("Music.Effect", true)}
    end
end

function Setting:Get(kKey, kVal)
    return self:__Call(kKey, kVal, true)
end

function Setting:Set(kKey, kVal)
    CC.Print("设置 "..kKey.."->"..CC.ToString(kVal))
    return self:__Call(kKey, kVal, false)
end

function Setting:__Call(kKey, kVal, bGet)
    local kType = _G.type(kVal)
    local kCall = bGet and "get" or "set"
    local kCall2 = (kType == "boolean" and "Bool") or (kType == "number" and "Double") or "String"
    local kClass = _G.cc.UserDefault:getInstance()
    return kClass[kCall..kCall2.."ForKey"](kClass, kKey, kVal)
end
----------------------------------------------------------------
Mail = {tData = {}}
function Mail:Load()
    self.tData = {}
end
function Mail:Test()
    for i=1,59 do
        local kData = {iID = 2000+i, bOpen = CC.Math:Random(3) == 1, kTitle = "标题啊啊啊啊啊 啊啊啊啊啊  "..i, eType = CC.Math:Rate(0.7) and "System" or "Gift", iTime = 12345, 
            kInfo = "大姐哇哦会犯傻了你就考虑的撒娇额我回家地方就是卡了JFK到了洒家分厘卡但是就考虑的撒艰苦奋斗拉沙扣两分的杀了飞机离开的沙发利空打击斯洛伐克大厦的离开沙发了看到啥法律的",
            tItem = {}, kLink = nil, bCanGetItem = CC.Math:Rate(0.1), eTitle = 1}

        for j=1,6 do
            if CC.Math:Random(5) < 5 then
                local kItem = CC.Excel.Item.Random
                _G.table.insert(kData.tItem, {iID = kItem.ID, iNum = CC.Math:Random(13999)})
            end
        end
        if CC.Math:Random(3) == 3 then
            kData.kLink = "Haha"
        end
        self:Add(kData)
    end
end
function Mail:Add(kMail)
    if kMail and kMail.iID then
        self.tData[kMail.iID] = self:__Class(kMail)
    else
        CC.Print("Mail:Add invalid parameter")
    end
end
function Mail:Del(iID)
    self.tData[iID] = nil
end
function Mail:GetMail(iID)
    return iID and self.tData[iID]
end
function Mail:GetMails(eType)
    local tTemp = {}
    for k,v in _G.pairs(self.tData) do
        if eType == nil or v.eType == eType then
            _G.table.insert(tTemp, v)
        end
    end
    _G.table.sort(tTemp, function (a,b)
        return a.iID > b.iID
    end)
    return tTemp
end
function Mail:RedPoint()
    for k,v in _G.pairs(self.tData) do
        if v:RedPoint() then
            return true
        end
    end
    return false
end
function Mail:__Class(kData)
    local kClass = kData
    function kClass:Title()
        local tTemp = {"系统","更新","记录","活动","补偿","奖励","礼物","好友"}        
        return "【"..(tTemp[self.eTitle + 1] or "未知").."】"..self.kTitle
    end
    function kClass:Time()
        return CC.String:Time(self.iTime or 0, "TimeToIntervalDay")
    end
    function kClass:HasInfo()
        return self.kInfo ~= nil
    end
    function kClass:RedPoint()
        return not self.bOpen or self.bCanGetItem
    end
    return kClass
end
-----------------------------------------------------------------------------------
Lobby = {kSwitchFirstLoad = CC.Switch(), tDownloadInfo = {}, tGamePeople = {}}   --state  1:未下载  2：未更新  3：已更新  4:错误
function Lobby:Load()
    self.kSwitchFirstLoad:TryOff()
    self.tDownloadInfo = {}
    self.tGamePeople = {}
    local gamelist = CC.Excel.GameList
    for i = 1, gamelist:Count() do
        local function callback(code, size, runlog)
            self.tDownloadInfo[gamelist:At(i).Name] = {state = code, size = size}
        end
        if CC.LoginMgr.tData.GM or not gamelist[i].Visible then
            callback(3, 0)
        else
            _G.need_download_task(gamelist[i].LocalDir, gamelist[i].RemoteDir, callback)
        end
    end
end
function Lobby:SyncGamePeople()
    self.tGamePeople = {}
    local function callback(t)
        --_G.cclog("在线人数请求_%s", _G.json.encode(t))
        if t.success then
            local tData = t.data.result or {}
            local tlist = CC.Excel.GameList
            for i = 1, tlist:Count() do
                local flg = true
                for k, v in _G.ipairs(tData) do 
                    if tlist[i].Name == v.NAME then
                        flg = false                   
                        self.tGamePeople[v.NAME] = {display = v.display}                    
                        break
                    end
                end
                if flg then
                    self.tGamePeople[tlist[i].Name] = {display = _G.math.random(3000, 5000)}
                end
            end

            CC.UIMgr:Do("UILobbyKOKO", "refreshGamePeople")
        else
            _G.cclog("在线人数请求失败"..t.message)
        end 
    end
    CC.Web.sendGetLuaGamePeopleReq(callback)
end    
-----------------------------------------------------------------------------------
RechargeList = {kmoney = 0, propo = 0, toKbean = 0 }
function RechargeList:Load()
    local function callback(t)
        if t.success then
            self.kmoney = t.data.result.kmoney
            self.propo = t.data.result.propo
            self.toKbean = t.data.result[1].toKbean
        else
            _G.ccerr("RechargeList__%s", _G.json.encode(t))
        end    
    end
    CC.Web.sendRechargeListReq(callback)
end
-----------------------------------------------------------------------------------
FirstChargeGift = {iOpenType = 0, bStatus = false, tData = {}}   --bStatus 是否显示首充按钮
function FirstChargeGift:Load()
    self.bStatus = false
    self.iOpenType = 0        -- 0：首充按钮打开  1：充值按钮打开
    self.tData = {}
end
function FirstChargeGift:Sync()
    local function callback(t)
        if t.success then
            self.tData = {}
            for k, v in _G.ipairs(t.data.result) do
                _G.ccerr("首充礼包_invite_status = %s__status =  %s", v.invite_status, v.status)
                if v.invite_status ~= "true" then
                    self.bStatus = true
                    _G.table.insert(self.tData, v)
                end
                CC.UIMgr:Do("UILobby", "Refresh")
                CC.UIMgr:Do("UIFirstCharge", "Refresh")
            end
        else
            _G.ccerr("首充礼包列表请求失败"..t.message)
        end    
    end
    CC.Web.sendFirstRechargeGiftReq(callback)
end
function FirstChargeGift:getBaoId()
    if #self.tData ~= 0 then
        return self.tData[1].baoId
    end    
end
function FirstChargeGift:getBaoStatus()
    if #self.tData ~= 0 then
        return self.tData[1].invite_status
    end    
end
function FirstChargeGift:deleteOne()
    if #self.tData ~= 0 then
        _G.table.remove(self.tData, 1)
        if #self.tData == 0 then
            self.bStatus = false
            CC.UIMgr:Do("UILobby", "Refresh")
        end
    end  
end
function FirstChargeGift:getOpenType()
    return self.iOpenType
end
function FirstChargeGift:setOpenType(i)
    self.iOpenType = i
end
function FirstChargeGift:getOneBaoInfo()
    if #self.tData ~= 0 then
        local tVal = self.tData[1].koko_value
        local str = ""
        for k, v in _G.ipairs(tVal) do
            if k == #tVal then
                str = str.._G.string.format("%d,%d", v.prizeId, v.prizeCoun)
                return str
            end    
            str = str.._G.string.format("%d,%d|", v.prizeId, v.prizeCoun)
        end    
    end    
end   
-----------------------------------------------------------------------------------
Time = {fTime = 0}
function Time:Load()
    self.fTime = 0
    self.Timer = CC.Timer:Create(self)
    self.Timer:Load()
    self.bLoad = true
end
function Time:Update(fDelta)
    self.fTime = self.fTime + fDelta
end
function Time:Get()
    return _G.math.floor(self.fTime)
end
function Time:Set(iTime)
    self.fTime = iTime
    CC.Event("RefreshTime")
end
function Time:Unload()
    if self.bLoad then
        self.bLoad = nil
        self.Timer:Unload()
    end
end
-----------------------------------------------------------------------------------
Turntable = {iLucky = 0, iCount = 0, iTimeRefresh = 0}
function Turntable:Load()
    self.iLucky = 0
    self.iCount = 0
    self.iTimeRefresh = 0
end
function Turntable:RedPoint()
    return CC.ItemMgr.Manager:Check(CC.ItemMgr.Item:Create(CC.Excel:Param("UITurntable", "TurnFree")[2]))
end
-----------------------------------------------------------------------------------
Gift = {tGift = {}}
function Gift:Load()
    self.tGift = {}
end
function Gift:Set(tVal)--{iStatus = X, iID = X}
    local kClass = tVal
    function kClass:Status()
        return self.iStatus == 1 and "OK" or self.iStatus == 2 and "End" or "Start" 
    end
    self.tGift[kClass.iID] = kClass
end
function Gift:Get(iID)
    if not self.tGift[iID] then
        self:Set({iID = iID, iStatus = 0})
    end
    return self.tGift[iID]
end
-----------------------------------------------------------------------------------
Shop = {ShopList = {}, ShopBuyNum = {}, bExit = false}
function Shop:Load()
    self.ShopList = {}
    self.ShopBuyNum = {}
    self.bExit = false
end
function Shop:setBuyNum(pid, num)
    _G.table.insert(self.ShopBuyNum, {pid = pid, num = num})
end
function Shop:Sync()
    if self.bExit then return end
    local function callback(t)
        local imagePath = {  --BuyType 2：券   1：k豆  0：钻石 
        {path = "koko/atlas/shop/2003.png", name = "k豆"},
        {path = "koko/atlas/lobby/1011.png", name = "奖券"},}
        imagePath[0] = {path = "koko/atlas/lobby/1030.png", name = "钻石"}
        if t.success then
            self.bExit = true
            local res = t.data.result or {}
            --_G.cclog("商城物品:%s", _G.json.encode(res))
            for k, v in _G.ipairs(res) do
                if v.isshow then
                    local tData = CC.String:Split(v.item, ",")  --"0,2,5000,1,2,1000"  物品类型 物品id  物品数量  
                    local tGive = {iType = 0, iID = 0, iCount = 0, sPath = "koko/atlas/shop/2003.png", sName = "k豆"}
                    local iMax = #tData - 1
                    if v.type == "ShopXX" and iMax >= 6 then
                        local tv = imagePath[CC.ToNumber(tData[5])]
                        tGive = {iType = CC.ToNumber(tData[4]), iID = CC.ToNumber(tData[5]), iCount = CC.ToNumber(tData[6]), sPath = tv.path, sName = tv.name}
                    end
                    self.ShopList[v.pid] = {type = v.type, price = v.price, give = tGive, pid = v.pid, name = v.name, describe = v.describe, sign = v.sign, ico = v.ico, validday = v.validday, dayLimit = v.dayLimit}
                end
            end
            _G.kk.uimgr.call("kkShop", "refreshScrollView")
        else
            _G.cclog("商城物品列表请求失败:%s", _G.json.encode(message))         
        end
    end
    CC.Web.sendShopListReq(callback)
end
function Shop:getDataByType(type)
    local data = {}
    for k, v in _G.pairs(self.ShopList) do
        if v.type == type then
            _G.table.insert(data, v)
        end
    end
    _G.table.sort(data, function(a, b)
        return a.pid < b.pid
    end)
    return data
end
