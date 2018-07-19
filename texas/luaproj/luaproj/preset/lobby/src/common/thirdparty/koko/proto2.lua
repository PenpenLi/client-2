local _G = _G
local json = json
local CC = require("comm.CC")
module("koko.proto2")

--[[****************************************************************************
需要的发送和接收消息在doc文件夹下
client 是客户端请求发送
sever 是服务器返回
每次发送消息都要讲消息体打印 方便排除错误
********************************************************************************]]
local _sequenceId = 1
function Send(iID, tVal, kLog)
    tVal.sequence_1_ = _sequenceId
    _sequenceId = _sequenceId + 1
    local iRt = _G.send2(iID, json.encode(tVal))
    if iRt ~= 0 then
        CC.Message{"发送协议失败"}
    end
    CC.Print("Client << "..iID.." "..(kLog or "").." "..((iRt == 0 and "") or "Error:"..iRt)..CC.Table:ToString(tVal))
end
function SendGame(iID, tVal, kLog)
    tVal.sequence_1_ = _sequenceId
    _sequenceId = _sequenceId + 1
    local iRt = _G.send(iID, json.encode(tVal))
    if iRt ~= 0 then
        CC.Message{"发送协议失败"}
    end
    CC.Print("ClientGame << "..iID.." "..(kLog or "").." "..((iRt == 0 and "") or "Error:"..iRt)..CC.Table:ToString(tVal))
end
-----------------------------------------------------------------------------------
function sendGameCoordinateReq(gameid)
    local device_type = ""
    if _G.platform_iswin32() then device_type = "PC"
    elseif _G.platform_isandroid() then device_type = "ANDROID"
    elseif _G.platform_isios() then device_type = "IOS" end
    Send(117, {gameid_ = gameid,
        device_type_ = device_type}, "获取协同服务器")
end

function sendCoordinateLoginReq(uid, sn, token)
    local device_type = ""
    if _G.platform_iswin32() then device_type = "PC"
    elseif _G.platform_isandroid() then device_type = "ANDROID"
    elseif _G.platform_isios() then device_type = "IOS" end
    Send(107, {uid_ = uid, sn_ = sn, token_ = token, device_ = device_type}, "登录协同服务器")
end

local channelSN = 1
function sendJoinChannelReq(gameid)    
    Send(102, {channel_ = gameid, sn_ = channelSN}, "加入频道")
    channelSN = channelSN + 1
end

function sendServerConnectionReq(gameId, callback)
    Send(1030, {game_id_ = gameId, params = ""}, "获取游戏服务器")
    _G.require("koko.form2").registerCallbackListenerWithTimeout(1030, callback, 5, false, "获取游戏连接失败")
end

--发送购买物品协议
--@callback         function callback(errcode, errmsg)  errcode:1代表成功 errmsg:错误信息
function sendBuyItemReq(item_id, item_count, item_comment, callback)
    Send(128, {item_id_ = item_id, item_count_ = item_count, comment_ = item_comment}, "购买物品")
    _G.require("koko.form2").registerCallbackListener(128, callback)
end
-- 获取购买历史消息
function sendMsgGetBuyItemRecord(game_id)
    Send(1034, {game_id_ = game_id}, "获取购买历史")
end
-- 钻石 转 k豆
function sendBuyGoldReq(count, callback)
    Send(126, {count_ = count}, "购买K豆")
    _G.require("koko.form2").registerCallbackListener(126, callback)
end
-- 每日登陆
function sendLoginPrizeListReq()
    Send(1039, {}, "每日登陆奖励列表")
end
-- 登陆奖励  --  type_ = 0:每日签到奖励  1:3天连续签到奖励  2:6天连续签到奖励  3:9天连续签到奖励
function sendGetLoginPrizeReq(type)
    Send(1040, {type_ = type}, "获取每日登陆奖励")
end
-- 活动兑换
--@callback      function callback()
function sendActivityBuyReq(activityid, n, callback)
    Send(1043, {activity_id_ = activityid, num_ = n}, "活动兑换")
    _G.require("koko.form2").registerCallbackListener(1043, callback)
end
-- 获取活动列表
function sendActivityListReq()
    Send(1044, {}, "获取我的活动列表")
end
-- 获取充值记录
function sendRechargeRecord()
    Send(1045, {}, "获取充值记录")
end
--用户信息记录
function sendMsgActionRecorder(opType, actionID, actionData1, actionData2, actionData3, actionData4, actionData5)
    local t = {
        op_type_ = opType,
        action_id_ = actionID,
        action_data_ = actionData1,
        action_data2_ = actionData2,
        action_data3_ = actionData3,
        action_data4_ = actionData4,
        action_data5_ = actionData5,
    }
    Send(116, t, "用户信息记录")
end