
local cls = class("fruit.bridge_handler")

function cls:ctor()
end

--协同断开通知          @msg:断开原因
function cls:onCoordinateDisconnect(msg)
    if  Game.isCoordinateConnected then
        Game.isCoordinateConnected = false
        disconnect2()
        if not reconnect:isReconnecting() and isconnected() then
            disconnect()
            msgbox.showOk(msg, function() exitGame(true) end)
        end
    end
end

return cls
