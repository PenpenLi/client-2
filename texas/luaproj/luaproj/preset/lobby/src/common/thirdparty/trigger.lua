local form2 = require("koko.form2")
local CC = require("comm.CC")
local bridge = require("net_bridge")
addtrigger(trigger_form_ack, "Trigger_FormAckNewGame")
addtrigger(trigger_form_ack2, "Trigger_FormAck2")
addtrigger(trigger_net_error, "Trigger_GameDisconnected")
addtrigger(trigger_net_error2, "Trigger_Disconnected")
addtrigger(trigger_lua_error, "Trigger_lua_error")
addtrigger(trigger_startup_param_changed or 16, "Trigger_StartupParamChanged")
function Trigger_FormAckNewGame(t)
    form2.Waygate:Do(t.command, t.content, 1)
end

form2.Waygate:Load(form2, 2)
function Trigger_FormAck2(t)
    if form2.Waygate:Do(t.command, t.content, 2) then
    else
        local key = string.format("recv_%d", t.command)
        local callback = form2[key]
        local tVal = json.decode(t.content)
        if callback then
            callback(tVal)
        end
    end

    --notify bridge
    bridge.notifyFormAck(t.command, t.content)
end

function Trigger_Disconnected(tVal)
    CC.Print("Trigger_Disconnected:协同服务器断开连接")
    CC.Event("Disconnected")
end

function Trigger_GameDisconnected(tVal)
    CC.Print("Trigger_GameDisconnected:游戏服务器断开连接")
    CC.Event("GameDisconnected")
end

function Trigger_lua_error()
    if not kk.uimgr.get("kkErrorLog") then
        local strUI = read_latest_log(4096)
        local strWeb = read_latest_log(20480)
        kk.uimgr.load("comm.errlog", nil, strUI, strWeb)
    end
end

function Trigger_StartupParamChanged()
    CC.Print("Trigger_StartupParamChanged:启动参数发生变化")
    CC.Data.StartupParamMgr.onParamChanged()
end
--------------测试代码------------
local ProtoHideIds = 
{
    [1000] = {"msg_user_login_ret"},
    [1001] = {"common_reply"},
    [1002] = {"msg_player_info"},
    [1005] = {"msg_same_account_login"},
    [1009] = {"msg_channel_server"},
    [1016] = {"msg_sync_item"},
    [1033] = {"msg_sync_item_data"},
}
function IsShowProtocolLogByCommand(id)
    return ProtoHideIds[id] == nil or ProtoHideIds[id][2] ~= nil or ProtoHideIds[id][2] ~= false  and true or false
end

function GetMsgString(id)
    return ProtoHideIds[id] ~= nil and ProtoHideIds[id][1] or "未知"
end