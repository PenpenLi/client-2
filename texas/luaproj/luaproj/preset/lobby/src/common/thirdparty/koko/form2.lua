local data = require("koko.data")
local CC = require("comm.CC")
local net = require("koko.net")
local UIEverydayLogin = require("koko.ui.lobby.UIEverydayLogin").UIEverydayLogin
module("koko.form2", package.seeall)
ItemMgr = require "koko.data.ItemMgr"

-----------------------------------------------------------------------------------
--注册回调监听，当收到相应消息时触发
local registerCallbackData = {}
local function _registerCallbackListenerImpl(sendMessageId, func, timeout, ...)
    local timerId = 0
    if timeout and timeout > 0 then
        local params = {...}
        timerId = _G.kk.timer.delayOnce(timeout, function()
            local tbl = registerCallbackData[sendMessageId] or {}
            for i=1,#tbl do
                if tbl[i][1] == func then
                    table.remove(tbl, i)
                    break
                end
            end
            _G.tryInvoke(func, _G.unpack(params))
        end)
    end
    local data = { func, timerId }
    if registerCallbackData[sendMessageId] then
        table.insert(registerCallbackData[sendMessageId], data)
    else
        registerCallbackData[sendMessageId] = { data }
    end
end
function registerCallbackListener(sendMessageId, func)
    _registerCallbackListenerImpl(sendMessageId, func, 0)
end
function registerCallbackListenerWithTimeout(sendMessageId, func, timeout, ...)
    _registerCallbackListenerImpl(sendMessageId, func, timeout, ...)
end
--触发
function triggerCallback(sendMessageId, ...)
    local tbl = registerCallbackData[sendMessageId]
    if tbl and #tbl > 0 then
        local data = tbl[1]
        table.remove(tbl, 1)
        if data[2] > 0 then
            _G.kk.timer.cancel(data[2])
        end
        _G.tryInvoke(data[1], ...)
    end
end
--清空
function clearAllCallback()
    registerCallbackData = {}
end
-----------------------------------------------------------------------------------
-- 传送门
Waygate = {
    tConnect = {},
    MsgHideIds = {1002,}--加入要屏蔽的消息Id
}
function Waygate:Load(kParent, iConnectID)
    if self.tConnect[iConnectID] == nil then
        local tWay = {}
        for k,v in pairs(kParent) do
            if type(v) == "table" and v.IDList then
                for k2,v2 in pairs(v.IDList) do
                    tWay[v2] = {Way = k, Key = k2}
                end
            end
        end
        self.tConnect[iConnectID] = {Parent = kParent, Way = tWay}
    end
end

function Waygate:Unload(iConnectID)
    if iConnectID then
        self.tConnect[iConnectID] = nil
    end
end

function Waygate:Do(iID, kVal, iConnectID)
    local kFrom = iConnectID == 2 and "Server" or "ServerGame"
    local tVal = json.decode(kVal)
    local tData = self.tConnect[iConnectID]
    if tData then
        local tTemp = tData.Way[iID]
        if tTemp then
            if iConnectID ~= 2 or not table.indexof(self.MsgHideIds, iID) then
                CC.Print(kFrom.." >> "..iID.." "..tTemp.Way..":"..tTemp.Key..CC.Table:ToString(tVal))
            end
            local tWay = tData.Parent[tTemp.Way]
            if tWay and tWay[tTemp.Key] then
                local kN = {t = tVal}
                local mtN = {}
                function kN:Table(kS, kSeprator)
                    local tVal = {}
                    local tTemp = CC.String:Split(kS, kSeprator or ",")
                    for i=1,#tTemp - 1 do
                        table.insert(tVal, CC.ToNumber(tTemp[i]))
                    end
                    return tVal
                end
                function mtN:__index(kKey)
                    return tonumber(self.t[kKey])
                end
                setmetatable(kN, mtN)
                tWay[tTemp.Key](tWay, tVal, kN)
            end
            return true
        end
        CC.Print(kFrom.." >> "..iID..CC.Table:ToString(tVal))
    end
end
-----------------------------------------------------------------------------------
-- 物品 （背包、商城）
Item = {IDList = {One = 1016, Param = 1033, GiftList = 1031, Use = 1030, ShopBuyChange = 1055}}
function Item:One(tVal)
    local iID, iNum = tonumber(tVal.item_id_), tonumber(tVal.count_)
    if not CC.Player:setPropertyByItemID(iID, iNum) then
        if iNum == 0 then
            ItemMgr.Manager:Del(iID)
        else
            local kItem = CC.SimpleCopy(ItemMgr.Manager.tItem[iID]) or ItemMgr.Item:Create(iID)
            kItem.iNum = iNum
            ItemMgr.Manager:Set(kItem)
        end
        CC.Event("RefreshItem")
    end
end
function Item:Param(tVal)
    local iID, iKey, iValue = tonumber(tVal.item_id_), tonumber(tVal.key_), tonumber(tVal.value_)
    local kItem = CC.SimpleCopy(ItemMgr.Manager.tItem[iID]) or ItemMgr.Item:Create(iID)
    kItem.kTimeLeft = require("comm.clock"):create(iValue)
    ItemMgr.Manager:Set(kItem)
    CC.Event("RefreshItem")
end
function Item:Use(s, n)
    local iItemID, iCount = n.present_id_, n.count_
    local kExcel = CC.Excel.ItemUse[iItemID]
    if kExcel then
        local kItem = CC.Excel.Item[iItemID]
        if kItem then
            CC.Message{Text = _G.string.format(kExcel.Tip, iCount, kItem.Name, iCount * kExcel.Num)}
        end
    end
end
function Item:ShopBuyChange(s, n) --  商品每日购买数量变化
    CC.PlayerMgr.Shop:setBuyNum(n.pid_, n.num_)
    kk.uimgr.call("kkShop", "RefreshScreen", n)
end
-----------------------------------------------------------------------------------
-- 通用
Common = {IDList = {Message = 1001, Broadcast = 1035, SequenceOver = 997, UserData = 1049, Time = 996}}
function Common:Message(s, n)
    local iID = n.rp_cmd_
    local iError = n.err_

    if iID == 117 then
        local msg = "无法获取协同服务器地址，错误码："..iError
        if iError == 6 then
            msg = "协同服务器不存在"
        end
        net.onRecvCoordinateError(msg)
    elseif iID == 107 then
        net.onRecvCoordinateLogin(iError == 0)
    elseif iID == 1030 then
        if iError ~= 0 then
            ccerr("无法获取游戏服务器地址："..iError)
            triggerCallback(1030, false, "无法获取游戏服务器地址："..iError)
        end
    elseif iID == 128 then
        local msg = "购买物品失败，错误码："..iError
        if iError == 3 then
            msg = "K豆不足"
        elseif iError == 1 then
            msg = "购买成功!"
        elseif iError == 13 then
            msg = "已经购买，不能再次购买!"
        elseif iError == -983 then
            msg = "无效或者数量无效!"
        elseif iError == 11 then
            msg = "道具不足!"
        elseif iError == 17 then
            msg = "超过今日上限"
        end
        triggerCallback(128, iError, msg)
    elseif iID == 126 then
        local msg = "购买物品失败，错误码："..iError
        if iError == 1 then
            msg = "购买成功!"
        end
        triggerCallback(126, iError, msg)
    elseif iID == 1037 then
        CC.Message{Tip = (iError == 1 and "赠送成功") or "赠送失败"}
    elseif iID == 1043 then
        triggerCallback(1043, iError)
    elseif iID == 1046 then
        CC.Message("转盘失败")
        CC.UIMgr:Call("UITurntable", {Failed = true})
    elseif iID == 994 then
        local kMsg = (iError == -996 and "您被禁止登录")
            or (iError == -994 and "服务器繁忙，请稍后再试")
            or (iError == 11 and "协同服务器不可用")
            or "登录失败，未知错误码："..iError
        CC.Message{Text = kMsg, CallBack = function (bOK)
            CC.GameMgr.Scene:Set("Lobby")
        end}

    end
end
function Common:Broadcast(s, n)
    local iKey = n.type_
    local tString = CC.String:Split(s.text_, "|")
    local iCount = #tString
    if iKey == 1 and iCount >= 5 then
        CC.Message{Text = string.format("玩家%s(%s)在%s赠送你%s个%s", tString[1], tString[2], CC.String:Time(tString[3]), tString[4], CC.Excel.Item[tString[5]].Name)}
    end
end
function Common:SequenceOver(s, n)
    local iCmd = n.cmd_
    if iCmd == Item.IDList.One then
        CC.Send(1053, {key_ = "Bag.RedPoint"}, "获取数据：背包红点")
    else
        CC.UIMgr:Do("ui_recharge_list", "Refresh")
    end
end
function Common:UserData(s, n)
    local kKey, kValue = s.key_, s.value_
    if kKey == "Bag.RedPoint" then
        CC.ItemMgr.Manager.bIgnoreRedPoint = false
        CC.ItemMgr.Manager:Call{RedPoint = kValue == "true", Sync = false}
    end
end
function Common:Time(s, n)
    CC.PlayerMgr.Time:Set(n.timestamp_)
end
-----------------------------------------------------------------------------------
-- 玩家
Player = {IDList = {OtherProperty = 1029, LoginPrizeList = 1037, LoginPrize = 1038, IconEx = 1040, IconBackList = 1039, IconList = 1054, ActivityList = 1041}}
function Player:OtherProperty(s, n)
    CC.PlayerMgr.Manager:Get(n.params_):Property(n.data_id_, s.data_)
end
--[[
    serial_days_     --连续登陆天数
    serial_state_    --最多三位数（个位-3天   十位-6天  百位-9天     0-未领取  1-领取）
    login_day_       --当前第几天（1 ~ 7）
    login_state_     --登陆奖励状态  0-未领取  1-领取
]]
function Player:LoginPrizeList(s, n)  -- 每日登陆奖励列表
    local loginInfo = CC.PlayerMgr.EverydayLoginInfo
    local bSerialState = true
    local serial_state = {}
    local x = n.serial_state_
    if math.floor(x%10) == 0 and n.serial_days_ >= 3 then bSerialState = false end
    serial_state[1] = math.floor(x%10)
    x = math.floor(x/10)

    if math.floor(x%10) == 0 and n.serial_days_ >= 6 then bSerialState = false end
    serial_state[2] = math.floor(x%10)
    x = math.floor(x/10)

    if math.floor(x%10) == 0 and n.serial_days_ >= 9 then bSerialState = false end
    serial_state[3] = math.floor(x%10)
    x = math.floor(x/10)

    local bRed = true
    if bSerialState and n.login_state_ == 1 then
        bRed = false
    end
    if loginInfo.bFirstLoad then
        if bRed then
            CC.UIMgr:Do("WelcomeManager", "Add", UIEverydayLogin)
        end
        loginInfo.bFirstLoad = false
    end
    loginInfo:setInfo(n.serial_days_, serial_state, n.login_day_, n.login_state_, bRed)
    CC.PlayerMgr.Activity:ChangeActiveRedState(3, bRed)
    CC.Event("ActivityRedPoint")
end
function Player:LoginPrize(s, n)  -- 0:每日签到奖励  1:3天连续签到奖励  2:6天连续签到奖励  3:9天连续签到奖励
    local loginInfo = CC.PlayerMgr.EverydayLoginInfo
    if n.prize_type_ == 0 then
        loginInfo:setLoginState(1)
    else
        loginInfo:setSerialState(n.prize_type_, 1)
    end

    CC.PlayerMgr.Activity:ChangeActiveRedState(3, loginInfo.bRedPoint)
    CC.Event("ActivityRedPoint")
end
function Player:IconEx(s, n)
    local kData = CC.PlayerMgr.IconBack
    kData.iIcon = (n.head_ico_ or n.head_icon_ or n.head_id_ or 0)
    kData.iIconBack = n.headframe_id_
    CC.Event("RefreshPlayer")
end
function Player:IconBackList(s, n)
    CC.PlayerMgr.IconBack:Add(n.headframe_id_)
    CC.Event("RefreshPlayer")
end
function Player:IconList(s ,n)
    CC.PlayerMgr.IconBack:AddIcon((n.head_ico_ or n.head_icon_ or n.head_id_ or 0), n.remain_sec_)
end
--[[
    activity_id_    -- 活动id
    state_          -- 0:激活  1:禁用
]]
function Player:ActivityList(s, n)  --活动状态列表
    _G.kk.uimgr.call("kkLimitTimeActive", "refreshAct1", n.activity_id_, n.state_)
end
-----------------------------------------------------------------------------------
-- 服务器
Server = {IDList = {Channel = 1009, Game = 1028, Disconnected = 1005, LoginGame = 1007}}
function Server:Channel(t)
    net.onRecvCoordinateConnection(t)
end
function Server:Game(t)
    triggerCallback(1030, true, t)
end
function Server:Disconnected(s, n)
    _G.disconnect2()
    CC.Event("Disconnected", {Kick = true})
end
function Server:LoginGame(s, n)--------------------------------------------------
    local bOK = n.why_ == 5
    CC.Message(bOK and "登陆游戏成功")
end

-----------------------------------------------------------------------------------
--聊天相关
Chat = {IDList = {ChatMsg = 1004, UserLoginRet = 1000, PlayerInfo = 1002,PlayerLeave = 1003}}
function Chat:ChatMsg(t)
    Trigger_ChatMsg(t)
end
function Chat:UserLoginRet(t)
    if net.connectionType == 1 then
        net:onRecvWorldLoginParams(t)
    else
        Trigger_UserLoginRetMsg(t)
    end
end
function Chat:PlayerInfo(t)
    Trigger_PlayerInfoMsg(t)
end
function Chat:PlayerLeave(t)
    Trigger_PlayerLeaveMsg(t)
end
-----------------------------------------------------------------------------------
--邮件
Mail = {IDList = {One = 1046, Info = 1047, Operator = 1048}}
function Mail:One(s, n)
    local tVal = {iID = n.id_, bOpen = n.state_ == 1, bCanGetItem = n.attach_state_ == 1, kTitle = s.title_, eTitle = n.title_type_, iTime = n.timestamp_,
        eType = n.mail_type_ == 0 and "System" or n.mail_type_ == 1 and "Gift" or n.mail_type_ == 2 and "Friend" or "Other", tItem = {}}
    CC.PlayerMgr.Mail:Add(tVal)
    CC.Event("RefreshMail")
end
function Mail:Info(s, n)
    local tMail = CC.PlayerMgr.Mail:GetMail(n.id_)
    if tMail then
        tMail.kInfo = s.content_
        tMail.kLink = s.hyperlink_
        tMail.tItem = CC.ItemMgr.Manager:CreateItems(s.attach_)
        CC.Event("RefreshMail")
    else
        CC.Print("Mail:Info There's no mail with id "..n.id_)
    end
end
function Mail:Operator(s, n)
    local tMail = CC.PlayerMgr.Mail:GetMail(n.id_)
    if tMail then
        local iOp = n.op_type_
        if iOp == 0 then
            tMail.bOpen = true
        elseif iOp == 1 then
            CC.PlayerMgr.Mail:Del(n.id_)
        end
        CC.Event("RefreshMail")
    else
        CC.Print("Mail:Operator There's no mail with id "..n.id_)
    end
end
-----------------------------------------------------------------------------------
--礼物
Gift = {IDList = {Got = 1050, All = 1051, One = 1052}}
function Gift:Got(s, n)
    local tType = CC.String:Split(s.type_, "|")

    --local tmp = CC.String:Split(s.item_, "|")
    --_G.ccwrn(tmp)
    -- for k, v in _G.ipairs(tmp) then
    --     local tbl = CC.String:Split(v, ",")
    -- end

    local tItem = CC.ItemMgr.Manager:CreateItems(s.item_)
    CC.UIMgr:Load(require ("koko.ui.lobby.UIGift").UIGift)
    CC.UIMgr:Call("UIGift", {Open = true, kKey = tType[1], tItem = tItem, kValue1 = tType[2]})
end

function Gift:All(s,n)
    local kMgr = CC.PlayerMgr.Gift
    kMgr:Load()
    local kGift = s.present_state_
    for i=1,#kGift do
        local kNow = _G.string.sub(kGift, i, i)
        kMgr:Set{iStatus = CC.ToNumber(kNow), iID = i}
    end
    CC.Event("RefreshGift")
end

function Gift:One(s,n)
    CC.PlayerMgr.Gift:Set{iStatus = n.state_, iID = n.present_id_}
    CC.Event("RefreshGift")
end
-----------------------------------------------------------------------------------
--转盘
Turntable = {IDList = {Info = 1044, Result = 1043}}
function Turntable:Info(s, n)
    local kMgr = CC.PlayerMgr.Turntable
    kMgr.iLucky = n.luck_value_
    kMgr.iCount = n.serial_times_
    kMgr.iTimeRefresh = n.reset_timestamp_
    CC.Event("RefreshTurntable")
end

function Turntable:Result(s, n)
    local tGift = {}
    local tTemp = CC.String:Split(s.lucky_id_, "|")
    for i,v in _G.ipairs(tTemp) do
        _G.table.insert(tGift, CC.ToNumber(v))
    end
    CC.UIMgr:Call("UITurntable", {Gift = tGift})
end