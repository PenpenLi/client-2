reconnect = {}

function reconnect:beginReconnect(func)
    if self.IsReconnecting then
        return false
    end

    local rcn = g_Require("fruit/ui_reconnect"):show()
    rcn:setCancelHandler(handler(self, self.onCancelReconnect))
    rcn:setTimeoutHandler(handler(self, self.onReconnectTimeout))
    self.Rcn = rcn
    self.IsReconnecting = true
    self.ReconnectResultHandler = func
    self.DelayStartReconnectId = 0
    self.IsReconnectSuccess = false
    self.IsTcpConnected = false

    if IsInGame() then
        cpn.game:initForReconnectBegin()
    end

    self:_delayStartReconnect()
    return true
end


function reconnect:isReconnecting()
    return self.IsReconnecting
end

function reconnect:onLostConnect()
    if self.IsTcpConnected then
        ccwrn("断开连接...")
        self.IsTcpConnected = false
        disconnect()
        self:_delayStartReconnect()
    end
end

function reconnect:onCancelReconnect()
    self:_stopReconnect()
end

function reconnect:onReconnectTimeout()
    self:_stopReconnect()
end

function reconnect:onLoginComplete()
    cpn.game:initForReconnectEnd()
    self.IsReconnectSuccess = true
    self:_stopReconnect()
end

function reconnect:_startReconnect()
    self.DelayStartReconnectId = 0
    
    ccwrn("开始重连...")
    local envir = require("net_bridge").getLoginEnvir()
    local ip = envir.IP
    local port = envir.Port
    local r = connect(ip, port)
    if r ~= 0 then
        ccwrn("连接服务器失败：[%s:%d]", ip, port)
        self:_delayStartReconnect()
        return
    end

    self.IsTcpConnected = true
    SendPlatformLoginReq(envir.UID, "", envir.UNAME, envir.TOKEN, "koko", envir.IID, envir.SN)
end

function reconnect:_delayStartReconnect()
    self.DelayStartReconnectId = DelayCallOnce(1, handler(self, self._startReconnect))
end

function reconnect:_stopReconnect()
    if self.DelayStartReconnectId ~= 0 then
        CancelCall(self.DelayStartReconnectId)
        self.DelayStartReconnectId = 0
    end

    if not self.IsReconnectSuccess then
        self.IsTcpConnected = false
        disconnect()
    end

    self.IsReconnecting = false
    self.Rcn:destroy()
    self.Rcn = nil
    TryInvoke(self.ReconnectResultHandler, self.IsReconnectSuccess)
end
