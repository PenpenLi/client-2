
local _G = _G
local cc = cc

module("comm.kk.event")

EVENT_AA = "AA"

--派发事件
function dispatch(evtName, ...)
    local e = cc.EventCustom:new(evtName)
    e.param = {...}
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    dispatcher:dispatchEvent(e)
end
