local _G = _G

module("comm.kk.uimgr")

local ui = {}

function load(pathOrClass, parent, ...)
    local cls = nil
    local obj = nil

    if _G.type(pathOrClass) == "string" then
        local tt = _G.require(pathOrClass)
        if tt and _G.iskindof(tt, "kk.view") then
            cls = tt
        end
    elseif _G.type(pathOrClass) == "table" and _G.iskindof(pathOrClass, "kk.view") then
        cls = pathOrClass
    end

    if cls then
        local clsName = cls:getClassName()
        obj = ui[clsName]
        if not obj then
            obj = cls:create(...)
            ui[clsName] = obj
            _G.cclog("[uimgr.load] %s", _G.tostring(clsName))
            obj:install(parent)
        end
    else
        _G.ccerr("[uimgr.load] load ui error! param:%s traceback:%s", _G.tostring(pathOrClass), _G.debug.traceback())
    end

    return obj
end

function get(nameOrClass)
    if _G.type(nameOrClass) == "string" then
        return ui[nameOrClass]
    elseif _G.type(nameOrClass) == "table" and _G.iskindof(nameOrClass, "kk.view") then
        return ui[nameOrClass:getClassName()]
    else
        return nil
    end
end

function unload(nameOrClass)
    local obj = get(nameOrClass)
    if obj then
        ui[obj:getClassName()] = nil
        obj:close()
        local str = ""
        if _G.type(nameOrClass) == "string" then
            str = nameOrClass
        elseif _G.type(nameOrClass) == "table" and _G.iskindof(nameOrClass, "kk.view") then
            str = nameOrClass:getClassName()
        end
        _G.cclog("[uimgr.unload] %s", str)
    end
end

function refresh(nameOrClass)
    local obj = get(nameOrClass)
    if obj and obj.refresh then
        obj:refresh()
    end
end

function call(nameOrClass, method, ...)
    local obj = get(nameOrClass)
    if obj and obj[method] then
        obj[method](obj, ...)
    end
end

function sendData(nameOrClass, ...)
    local obj = get(nameOrClass)
    if obj and obj.sendData then
        obj:sendData(...)
    end
end

function exitAll()
    while true do
        local key = _G.next(ui)
        if not key then
            break
        end

        _G.cclog("[uimgr.exitAll] destroy:%s", key)
        ui[key]:destroy()
        ui[key] = nil
    end
end
