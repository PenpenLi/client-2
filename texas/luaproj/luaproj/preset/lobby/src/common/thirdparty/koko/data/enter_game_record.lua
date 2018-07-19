
local _G = _G
local cc = cc
local json = json

module("koko.data.enter_game_record")

local data = nil
local strKey = "Logic.EnterGameRecord"
local function _readFromFile()
    data = _G.kk.xml.getTable(strKey)
end
local function _writeToFile()
    _G.kk.xml.setTable(strKey, data)
end

function isEntered(gamestr)
    if not data then
        _readFromFile()
    end
    return not not data[gamestr]
end

function setEntered(gamestr, val)
    if not data then
        _readFromFile()
    end
    data[gamestr] = val
    _writeToFile()
end
