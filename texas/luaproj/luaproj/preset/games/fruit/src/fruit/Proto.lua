

local sendTable = SOCKET_MANAGER.sendToGameServer

--平台账号登录
function SendPlatformAccountLoginReq(account, password)
    local t =
    {
        acc_name_ = account,
        pwd_ = mdstring(password),
        platform_id = "koko",
    }
    cclog("发送协议[登录]：msg_platform_account_login  ↓↓↓")
    sendTable(992, t)
end

--平台参数登录
function SendPlatformLoginReq(uid, head, uname, token, plat, IID, sn)
    local t = 
    {
        uid_ = uid,
        head_ico_ = head,
        uname_ = uname,
        vip_lv_ = 0,
        platform_ = plat,
        sn_ = sn,
        iid_ = IID,
        url_sign_ = token,
    }
    cclog("发送协议[登录]：msg_platform_login_req  ↓↓↓")
    sendTable(994, t)
end

--进入房间协议
function SendEnterRoomReq(extra, room)
    local t = 
    {
        room_id_ = bit32bor(bit32lshift(extra, 24), room),
    }
    cclog("发送协议[进入房间]：msg_enter_game_req  ↓↓↓")
    sendTable(502, t)
end

--离开房间
function SendLeaveRoomReq()
    local t =
    {
    }
    cclog("发送协议[离开房间]：msg_leave_room  ↓↓↓")
    sendTable(505, t)
end

--自己下注
function SendSetBetsReq(bet_id, present_id)
    local t = 
    {
        pid_ = bet_id,
        present_id_ = present_id,
    }
    cclog("发送协议[下注请求]：msg_set_bets_req  ↓↓↓")
    sendTable(5, t)
end

