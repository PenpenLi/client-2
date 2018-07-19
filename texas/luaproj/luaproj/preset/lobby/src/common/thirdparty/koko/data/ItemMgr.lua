-----------------------------------------------------------------------------------
-- 物品管理类  2017.9
-- By Chris
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
module "koko.data.ItemMgr"
-----------------------------------------------------------------------------------
Item = CC.Class({iID = 0, iNum = 0, kTimeLeft = nil}, "Item")
function Item:Create(kVal)
    local kClass = self:__New()
    local kType = _G.type(kVal)
    if kType == "number" then
        kClass.iID = kVal
    elseif kType == "string" then
        local tVal = CC.String:Split(kVal, ",")
        local iCount = #tVal
        if iCount >= 1 then
            kClass.iID = CC.ToNumber(tVal[1])
        end
        if iCount >= 2 then
            kClass.iNum = CC.ToNumber(tVal[2])
        end
    end
    return kClass
end
function Item:Excel()
    return CC.Excel.Item[self.iID]
end
-----------------------------------------------------------------------------------
Manager = {tItem = {}, bRedPoint = false, bIgnoreRedPoint = true, tGiftSetting = {}}
function Manager:Load()
    self.tItem = {}
    self.bRedPoint = false
    self.bIgnoreRedPoint = true
    self.tGiftSetting = {}
end

function Manager:Unload()
    
end

function Manager:CreateItems(kString)    
    local tItem = CC.String:Split(kString, "|")
    local tItem2 = {}
    for i,v in _G.ipairs(tItem) do
        _G.table.insert(tItem2, CC.ItemMgr.Item:Create(v))
    end
    return tItem2
end

function Manager:Test()
    -----------------------------------------------------------------------------------
    -- 测试
    if CC.Debug then    
        for i=1,10 do
            local tItemExcel = CC.Excel.Item.Random
            local kItem = Item:Create(tItemExcel.ID)
            kItem.iNum = CC.Math:Random(20000)
            kItem.kTimeLeft = _G.require("comm.clock"):create(3650)
            self:Set(kItem)
        end
        CC.Event("RefreshItem")
    end
    -----------------------------------------------------------------------------------
end
function Manager:Set(tItem)
    if CC.IsClass(tItem, "Item") then
        local iID = tItem.iID
        if iID and CC.Excel.Item[iID] then
            local tOld = self.tItem[iID]
            if tOld == nil or tItem.iNum > tOld.iNum or (tItem.kTimeLeft and tOld.kTimeLeft and tItem.kTimeLeft:getLeftTime() > tOld.kTimeLeft:getLeftTime())then
                self:Call({RedPoint = true})
            end
            self.tItem[iID] = tItem
        end
    else
        CC.Print("ItemMgr.Manager:Set -> Type error")
    end
end
function Manager:Check(tItem)
    if CC.IsClass(tItem, "Item") then
        local kItem = self.tItem[tItem.iID]
        return kItem and kItem.iNum >= tItem.iNum
    end
end
function Manager:Del(iID)
    self.tItem[iID] = nil
end
function Manager:Unload()
    self.tItem = {}
end
function Manager:Vector()
    return CC.Table:Vector(self.tItem)
end
function Manager:Call(tVal)
    if tVal.RedPoint ~= nil and tVal.RedPoint ~= self.bRedPoint and not self.bIgnoreRedPoint then
        self.bRedPoint = tVal.RedPoint
        CC.Event("RefreshItem", {RedPoint = true})

        if tVal.Sync ~= false then
            CC.Send(1054, {key_ = "Bag.RedPoint", value_ = _G.tostring(self.bRedPoint)}, "设置数据：背包红点")
        end
    end
end

