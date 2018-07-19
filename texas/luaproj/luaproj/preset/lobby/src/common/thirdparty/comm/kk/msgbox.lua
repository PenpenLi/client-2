local _G = _G
local msgbox_ = import(".msgbox_")

module("comm.kk.msgbox")

local views = {}

function showNull(text, callback, time)
    local box = nil
    box = msgbox_.showNull(_G.findChild(""), "koko/ui/common/msgbox.csb", text, function(...)
        _G.table.removebyvalue(views, box)
        _G.tryInvoke(callback, ...)
    end, time)
    _G.table.insert(views, box)
    return box
end

function showOk(text, callback, time, key)
    local box = nil
    box = msgbox_.showOk(_G.findChild(""), "koko/ui/common/msgbox.csb", text, function(...)
        _G.table.removebyvalue(views, box)
        _G.tryInvoke(callback, ...)
    end, time, key)
    _G.table.insert(views, box)
    return box
end

function showOkCancel(text, callback, time, key)
    local box = nil
    box = msgbox_.showOkCancel(_G.findChild(""), "koko/ui/common/msgbox.csb", text, function(...)
        _G.table.removebyvalue(views, box)
        _G.tryInvoke(callback, ...)
    end, time, key)
    _G.table.insert(views, box)
    return box
end

function hasBox()
    return #views > 0
end

function closeTop()
    if #views > 0 then
        local c = views[#views]
        views[#views] = nil
        c:close()
    end
end

function closeBox(box)
    local idx = _G.table.indexof(views, box)
    if idx then
        views[idx]:close()
        _G.table.remove(views, idx)
    end
end

function closeAll()
    for _, c in _G.pairs(views) do
        c:destroy()
    end
end
