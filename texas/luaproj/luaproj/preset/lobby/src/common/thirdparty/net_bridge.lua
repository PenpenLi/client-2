
local CC = require "comm.CC"
local proto2 = require("koko.proto2")
module("net_bridge", package.seeall)


----------------------------------------------------------------------------
--功能接口
----------------------------------------------------------------------------

--发送协议给当前连接的游戏服务器
local _sequenceId = 1
function sendTable(command, t, showlog)
    t.sequence_1_ = _sequenceId
    _sequenceId = _sequenceId + 1
    local str = json.encode(t)
    if _G.send(command, str) == 0 then
        if showlog ~= false then
            cclog("-->> %s", str)
        end
    else
        ccerr("发送失败： %s", str)
    end
end

--切换场景
function replaceScene(scene)
    --Unload所有界面
    _G.kk.msgbox.closeAll()
    _G.kk.waiting.close()
    _G.kk.uimgr.exitAll()
    CC.UIMgr:ExitAll()
    cc.Director:getInstance():replaceScene(scene)
end

--根据命令行参数判断是否是自动登录
function isAutoLoginByCommandLine()
    assert(false, debug.traceback())
end

--获取登录成功后的环境参数
--@return               {isAccountLogin,coordinateIP,coordinatePort,UID,UNAME,IID,TOKEN,SN,IP,Port}
local _serverIp = ""
local _serverPort = 0
function getLoginEnvir()
    local envir = require("koko.net").getEnvir()
    return {
        isAccountLogin = false,
        UID = envir.uid,
        UNAME = envir.uname,
        IID = envir.iid,
        TOKEN = envir.token,
        SN = envir.sn,
        IP = _serverIp,
        Port = _serverPort,
    }
end

--使用账号密码登录
--@result_callback      function result_callback(tbl)
--@progress_callback    function progress_callback(rate)  rate
function loginWithAccount(account, password, result_callback, progress_callback)
    assert(false, debug.traceback())
end

--使用平台参数
--@result_callback      function result_callback(tbl)
--@progress_callback    function progress_callback(rate)  rate
function loginWithPlatformParams(result_callback, progress_callback)
    assert(false, debug.traceback())
end

--获取服务器连接方式
--@gameId               游戏Id
--@callback             function callback(success, data) data:ip_ port_
function getGameConnection(gameId, callback)
    proto2.sendServerConnectionReq(gameId, function(success, data)
        if success then
            _serverIp = data.ip_
            _serverPort = tonumber(data.port_)
        else
            _serverIp = ""
            _serverPort = 0
        end
        callback(success, data)
    end)
end

--添加延迟检查登陆定时器
local _loginTimeoutTimerId = 0
function beginCheckLoginTimeoutTimer(callback, ...)
    cancelCheckLoginTimeoutTimer()
    _loginTimeoutTimerId = _G.kk.timer.delayOnce(7, callback, ...)
end
function cancelCheckLoginTimeoutTimer()
    if _loginTimeoutTimerId ~= 0 then
        _G.kk.timer.cancel(_loginTimeoutTimerId)
        _loginTimeoutTimerId = 0
    end
end

--使用物品
--@itemId               物品Id
--@count                数量
function usePresent(itemId, count)
	CC.Send(1031, {present_id_ = itemId, count_ = count}, "使用物品")
end

--购买物品
--@itemId               物品Id
--@count                数量
--@comment              附加信息
function buyItem(itemId, count, comment)
    CC.Send(128, {item_id_ = itemId, item_count_ = count, comment_ = comment}, "购买物品")
end

--赠送物品
--@gameId               游戏Id
--@itemId               物品Id
--@count                数量
--@to                   赠送玩家数字Id
function sendPresent(gameId, itemId, count, to)
    CC.Send(114, {channel_ = gameId, present_id_ = itemId, count_ = count, to_ = to}, "购买物品")
end

--请求玩家昵称
--@iid                  玩家数字Id
--@callback             function(iid, nickname)
local _nicknameCallback = nil
function queryNickName(iid, callback)
    _nicknameCallback = callback
    CC.Send(1032, {data_id_ = 0, params = iid}, "获取玩家["..iid.."]昵称属性")
end
function notifyNickName(iid, nickname)
    if _nicknameCallback then
        _nicknameCallback(iid, nickname)
        _nicknameCallback = nil
    end
end

--请求赠送纪录
--@type                 1赠送纪录 2接收纪录
function queryGiftRecord(type)
    CC.Send(1033, {type_ = type}, "背包礼物列表")
end

--请求购买记录
--@gameId               游戏Id
function queryBuyItemRecored(gameId)
    CC.Send(1034, {game_id_ = gameId}, "获取购买历史")
end

--请求好友房房间列表
--@gameId               游戏Id
function queryPrivateRoomRecored(gameId)
    CC.Send(129, {game_id_ = gameId}, "请求好友房房间列表")
end

--请求好友房间信息并占位
--@gameId               游戏Id
--@roomId               房间Id
--@pwd                  房间密码
--@callback             function callback({gameid_, roomid_, succ_, ip_, port_}) succ_:0不存在 1有空位 2房间已满 3密码不正确 4系统错误 ip_ port_
local _enterPrivateRoomCallback = nil
function queryEnterPrivateRoom(gameId, roomId, pwd, callback)
    _enterPrivateRoomCallback = callback
    CC.Send(120, {gameid_ = gameId, roomid_ = roomId, pwd = pwd or ""}, "请求好友房房间列表")
end
function notifyEnterPrivateRoom(t)
    if _enterPrivateRoomCallback then
        if type(t) ~= "table" then
            t = {
                gameid_ = gameId,
                roomid_ = roomId,
                succ_ = 4,
            }
        end
        _enterPrivateRoomCallback(t)
        _enterPrivateRoomCallback = nil
    end
end

--行为纪录
--                            int      int        int           int        string       string       string
function queryActionRecorder(opType, actionId, actionData1, actionData2, actionData3, actionData4, actionData5)
    cclog("插入行为数据：optype:%s action:%s data1:%s data2:%s data3:%s data4:%s data5:%s", tostring(opType), tostring(actionId), 
        tostring(actionData1), tostring(actionData2), tostring(actionData3), tostring(actionData4), tostring(actionData5))
    proto2.sendMsgActionRecorder(opType, actionId, actionData1, actionData2, actionData3, actionData4, actionData5)
end
--分享行为
function notifyActionShare(gameId, typeNum, isSuccess, matchInstance, matchRank)
    queryActionRecorder(0, 2, gameId, typeNum, isSuccess and "1" or "0", matchInstance or "", tostring(matchRank or ""))
end
--在线时长
function notifyActionOnline(opType, gameId, timeInSeconds)
    queryActionRecorder(opType, 1000, gameId, timeInSeconds, "", "", "")
end






----------------------------------------------------------------------------
--触发事件
----------------------------------------------------------------------------

--设置事件处理对象
local evtHandler = nil
function setEventHandler(obj)
    evtHandler = obj
end

--触发事件
--onSendItemNotify          赠送礼物通知          @msg:内容文本
--onSyncItem                同步物品通知          @itemid:物品Id        @count:数量
--onBuyItemError            购买物品失败          @msg:失败原因
--onSendItemError           赠送物品失败          @msg:失败原因
--onUseItemError            使用物品失败          @msg:失败原因
--onUseItemNotify           使用物品通知          @present_id:物品Id    @data:奖励列表及数量       @count:使用数量
--onCoordinateDisconnect    协同断开通知          @msg:断开原因
--onSyncSendGiftRecordItem  赠送纪录回应          @t:纪录列表
--onSyncItemData            同步物品属性          @itemId:物品Id        @key:属性名称             @value:属性值
--onBuyItemRecordAck        购买纪录回应          @t:纪录列表
--onPrivateRoomRecordAck    好友房间纪录          @t:数据
--onMessageEnd              列表结束通知          @t:数据
function dispatchEvent(evtName, ...)
    if evtHandler and type(evtHandler) == "table" and evtHandler[evtName] then
        evtHandler[evtName](evtHandler, ...)
    end
end


function processCommonReply(rp_cmd, err)
    if rp_cmd == 120 then
        notifyEnterPrivateRoom(nil)
    elseif rp_cmd == 114 then
        if err == -993 then
            dispatchEvent("onSendItemError", "赠送失败，找不到该玩家！")
        elseif err == -983 then
            dispatchEvent("onSendItemError", "系统错误，该物品不存在！")
        elseif err == 3 then
            dispatchEvent("onSendItemError", "赠送失败，您的物品数量不足！")
        elseif err == 1 then
            dispatchEvent("onSendItemError", "")
        elseif err == 9 then
            dispatchEvent("onSendItemError", "您无法使用赠送功能！")
        elseif err == 10 then
            dispatchEvent("onSendItemError", "无法赠送目标用户！")
        elseif err ~= 0 then
            dispatchEvent("onSendItemError", "赠送失败，未知的错误码："..err)
        end
    elseif rp_cmd == 128 then
        if err == -983 then
            dispatchEvent("onBuyItemError", "系统错误，该物品不存在！")
        elseif err == 3 then
            dispatchEvent("onBuyItemError", "购买失败，钻石或K豆不足！")
        elseif err == 1 then
            dispatchEvent("onBuyItemError", "")
        elseif err == 11 then
            dispatchEvent("onBuyItemError", "购买失败，货币不足！")
        elseif err ~= 0 then
            dispatchEvent("onBuyItemError", "购买失败，未知的错误码："..err)
        end
    elseif rp_cmd == 1031 then
        local msg = "使用物品失败，错误码："..err
        if err == 11 then
            msg = "使用失败，物品数量不足！"
        end
        dispatchEvent("onUseItemError", msg)
    end
end

function notifyFormAck(command, content)
    if not evtHandler then return end

    local t = json.decode(content)
    if command == 1001 then
        processCommonReply(tonumber(t.rp_cmd_), tonumber(t.err_))
    elseif command == 1016 then
        dispatchEvent("onSyncItem", tonumber(t.item_id_), tonumber(t.count_))
    elseif command == 1004 then
        local msgtype = tonumber(t.msg_type_)
        if msgtype == 5 then
            local params = string.split(t.content_, "|")
            local itemId = tonumber(params[1])
            local count = tonumber(params[2])
            local itemName = params[3]
            local itemIcon = params[4]
            local gold = params[5]
            local tab = os.date("*t", tonumber(t.time_stamp_))
            local time_stamp = string.format("%04d年%02d月%02d日 %02d:%02d", tab.year, tab.month, tab.day, tab.hour, tab.min)
            local content = string.format("[系统提示]: 玩家 %s(%s) 在 %s 赠送您%d个%s", t.nickname_, t.iid_, time_stamp, count, itemName)
           -- dispatchEvent("onSendItemNotify", content)
        end
    elseif command == 1029 then
        if tonumber(t.data_id_) == 0 then
            notifyNickName(t.params_, t.data_)
        end
    elseif command == 1023 then
        notifyEnterPrivateRoom(t)
    elseif command == 1030 then --msg_use_present_ret {"present_id_":"16","data_":"220000"}
        local present_id = tonumber(t.present_id_)
        local count = tonumber(t.count_)
        local data = t.prize_item_
        dispatchEvent("onUseItemNotify", present_id, data, count)
    elseif command == 1031 then --msg_get_present_record_ret 赠送、获取礼物记录
        dispatchEvent("onSyncSendGiftRecordItem", t)
    elseif command == 1033 then --msg_sync_item_data key = 0 剩余时长
        local itemId = tonumber(t.item_id_)
        local key = tonumber(t.key_)
        local leftTime = tonumber(t.value_)
        dispatchEvent("onSyncItemData", itemId, key, leftTime)
    elseif command == 1032 then --msg_get_buy_item_record_ret) = 1032, 购买历史记录
        dispatchEvent("onBuyItemRecordAck", t)
    elseif command == 1036 then --msg_get_private_room_record_ret = 1036 好友房列表
        dispatchEvent("onPrivateRoomRecordAck", t)
    elseif command == 1026 then
        dispatchEvent("onRemovePrivateRoom", t)
    elseif command == 997 then --msg_is_end
        dispatchEvent("onMessageEnd", t)
    end
end