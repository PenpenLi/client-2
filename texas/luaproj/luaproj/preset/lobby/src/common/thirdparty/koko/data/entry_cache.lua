
local enum = require("koko.enum")
local cls = class("koko.data.entry_cache")

function cls:ctor()
    self.arrData = self:getDataFromFile()
    self.curEntry = nil
end

function cls:getDataFromFile()
    local jsonstr = kk.xml.getString("EntryCache")
    local str = kk.crypt.ca1Decode(jsonstr)
    return str ~= "" and json.decode(str) or {}
end

function cls:addDeviceEntry(Uid, nickname, deviceCode)
    local t =
    {
        uid = Uid,
        type = enum.Entry.Device,
        name = nickname,
        value = deviceCode,
        createtime = os.time(),
        logintime = 0,
    }
    self:addEntryWithCheck(t)
end

function cls:addQQEntry(Uid, nickname, qqKey)
    local t = 
    {
        uid = Uid,
        type = enum.Entry.QQ,
        name = nickname,
        value = qqKey,
        createtime = os.time(),
        logintime = 0,
    }
    self:addEntryWithCheck(t)
end

function cls:addWXEntry(Uid, nickname, wxKey)
    local t = 
    {
        uid = Uid,
        type = enum.Entry.WX,
        name = nickname,
        value = wxKey,
        createtime = os.time(),
        logintime = 0,
    }
    self:addEntryWithCheck(t)
end

function cls:addAccountEntry(Uid, nickname, account, password)
    local t = 
    {
        uid = Uid,
        type = enum.Entry.Account,
        name = nickname,
        value = string.format("%s|%s", account, password),
        createtime = os.time(),
        logintime = 0,
    }
    self:addEntryWithCheck(t)
end

function cls:addEntryWithCheck(tbl)
    local entry = self:getEntryByUid(tbl.uid)
    if entry then
        entry.type = tbl.type
        entry.name = tbl.name
        entry.value = tbl.value
    else
        table.insert(self.arrData, tbl)
    end
    self:_writeDataToFile(self.arrData)
end

function cls:_writeDataToFile(tdata)
    local jsonstr = json.encode(tdata)
    local str = kk.crypt.ca1Encode(jsonstr)
    kk.xml.setString("EntryCache", str)
end

function cls:isEmpty()
    return #self.arrData == 0
end

function cls:count()
    return #self.arrData
end

--设置当前缓存的登录账号
function cls:loginByUid(uid)
    for i = 1, #self.arrData do
        if self.arrData[i].uid == uid then
            self.curEntry = self.arrData[i]
            self.curEntry.logintime = os.time()
            self:_writeDataToFile(self.arrData)
            break
        end
    end
end

--登出
function cls:logout()
    self.curEntry = nil
end

--设置当前登录账号的新昵称
function cls:setCurrentNickName(nickname)
    if self.curEntry then
        self.curEntry.name = nickname
        self:_writeDataToFile(self.arrData)
    end
end

--账号升级
function cls:setCurrentWithUpgradeAccount(account, password)
    if self.curEntry then
        local t = self.curEntry
        t.type = enum.Entry.Account
        t.value = string.format("%s|%s", account, password)
        self:_writeDataToFile(self.arrData)
    end
end

function cls:getDataTable()
    local cArrData = clone(self.arrData)
    if self:count() > 1 then
        table.sort(cArrData, function(a, b)
            if a.logintime and b.logintime and a.logintime > 0 and b.logintime > 0 then
                return a.logintime > b.logintime
            elseif a.logintime and a.logintime > 0 then
                return true
            elseif b.logintime and b.logintime > 0 then
                return false
            else
                return a.createtime > b.createtime
            end
        end)
    end
    return cArrData
end

function cls:getEntryByUid(uid)
    return table.find(self.arrData, function(v) return v.uid == uid end)
end

function cls:removeEntryByUid(uid)
    for k, v in pairs(self.arrData) do
        if v.uid == uid then
            table.remove(self.arrData, k)
            self:_writeDataToFile(self.arrData)
            break
        end
    end
end

return cls
