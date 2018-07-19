local GameConfig = require("app.common.GameConfig")
local GameSocket = require("app.net.GameSocket")

local SocketManager = {}

SOCKET_MANAGER = nil;
SocketManager.accountSocket = nil
SocketManager.coordinateSocket = nil
SocketManager.gameSocket = nil


function SocketManager.init()
    SOCKET_MANAGER = SocketManager
end

-- 连接到账号服务器
function SocketManager.connectToAccountServer(host, port, callback)
    if (not SocketManager.accountSocket) or (not SocketManager.accountSocket:isWorking()) then
        SocketManager.accountSocket = GameSocket.new(host, port, GameConfig.ACCOUNTSERVER, GameConfig.ID_ACCOUNTSERVER)
        SocketManager.accountSocket:connect(callback)
    else
        printInfo("account socket is already exists!")
    end
end

-- 断开连接到账号服务器
function SocketManager.closeToAccountServer()
    if SocketManager.accountSocket then
        SocketManager.accountSocket:close()
        SocketManager.accountSocket = nil
    end
    local handle = APP.GD:getPingHandleAccount()
    printInfo("unscheduleGlobal account ping handle:%d", handle)
    if handle > 0 then
        scheduler.unscheduleGlobal(handle)
    end

    APP.GD.ping_handle_account = 0
end

-- 发送数据到账号服务器
function SocketManager.sendToAccountServer(subCmd, data, isCompress)
    if SocketManager.accountSocket then
        return SocketManager.accountSocket:send(subCmd, data, isCompress)
    else
        printLog("a", "sendToAccountServer while accountSocket is nil");
        return -10;
    end
end

-- 连接到协同服务器
function SocketManager.connectToCoordinateServer(host, port, callback)
    if (not SocketManager.coordinateSocket) or (not SocketManager.coordinateSocket:isWorking()) then
        SocketManager.coordinateSocket = GameSocket.new(host, port, GameConfig.COORDINATESERVER, GameConfig.ID_COORDINATESERVER)
        SocketManager.coordinateSocket:connect(callback)
    else
        printInfo("coordinate socket is already exists!")
    end
end

-- 断开连接到协同服务器
function SocketManager.closeToCoordinateServer()
    if SocketManager.coordinateSocket then
        SocketManager.coordinateSocket:close()
        SocketManager.coordinateSocket = nil
    end
    local handle = APP.GD:getPingHandleCoordinate()
    printInfo("unscheduleGlobal coordinate ping handle:%d", handle)
    if handle > 0 then
        scheduler.unscheduleGlobal(handle)
    end

    APP.GD.ping_handle_coordinate = 0
end

-- 发送数据到协同服务器
function SocketManager.sendToCoordinateServer(subCmd, data, isCompress)
    if SocketManager.coordinateSocket then
        return SocketManager.coordinateSocket:send(subCmd, data, isCompress)
    else
        printInfo("Error:coordinate server is nil")
    end
end

-- 连接到游戏服务器
function SocketManager.connectToGameServer(host, port, callback)
    if (not SocketManager.gameSocket) or (not SocketManager.gameSocket:isWorking()) then
        SocketManager.gameSocket = GameSocket.new(host, port, GameConfig.GAMESERVER, GameConfig.ID_GAMESERVER)
        SocketManager.gameSocket:connect(callback)
    else
        printInfo("game socket is already exists!")
    end
end

-- 断开连接到游戏服务器
function SocketManager.closeToGameServer()
    if SocketManager.gameSocket then
        SocketManager.gameSocket:close()
        SocketManager.gameSocket = nil
    end
    local handle = APP.GD:getPingHandleGame()
    printInfo("unscheduleGlobal game ping handle:%d", handle)
    if handle > 0 then
        scheduler.unscheduleGlobal(handle)
    end
    APP.GD.ping_handle_game = 0
end

-- 发送数据到游戏服务器
function SocketManager.sendToGameServer(subCmd, data, isCompress)
    if SocketManager.gameSocket then
       return SocketManager.gameSocket:send(subCmd, data, isCompress)
    else
        printInfo("Error:game server is nil")
    end
end

-- 消息暂停接受
function SocketManager.pauseGameServer(time)
    
end

return SocketManager