
local _G = _G
local cc = cc
local json = json

module("comm.kk.xml")

--string
function getString(key)
    return cc.UserDefault:getInstance():getStringForKey(key) or ""
end
function setString(key, str)
    cc.UserDefault:getInstance():setStringForKey(key, str)
end

--table
function getTable(key)
    local content = cc.UserDefault:getInstance():getStringForKey(key)
    return content ~= "" and json.decode(content) or {}
end
function setTable(key, tbl)
    cc.UserDefault:getInstance():setStringForKey(key, tbl and json.encode(tbl) or "")
end

--clear
function clear(key)
    cc.UserDefault:getInstance():setStringForKey(key, "")
end
