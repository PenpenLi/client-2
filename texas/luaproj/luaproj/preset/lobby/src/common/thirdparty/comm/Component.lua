local _G = _G
local CC = require "comm.CC"
local UIItemTips = require "koko.ui.lobby.UIItem".UIItemTips
module ("comm.Component")
-----------------------------------------------------------------------------------
-- 组件
Component = CC.Class({}, "Component")
function Component:Create(kUI)
    local kClass = self:__New()
    kClass.kUI = kUI
    kClass.C = CC.ClassFunction(kClass.kUI, kClass.kUI.Control)
    return kClass
end
function Component:Load()
    self.t = {}
    self.tComponent = {}
    local kName = self.kUI.kNode:getName()
    local kExcel = CC.Excel.Component.Root[kName]
    if kExcel then
        for i=1,kExcel:Count() do
            local kData = kExcel:At(i)
            local kComponent = CC.Component[kData.Type]
            if kComponent and CC.IsClass(kComponent, "ComponentBase") then                
                local kTemp = kComponent:Create(self, kData, CC.Excel["Component_"..kData.Type][kData.TypeID])
                kTemp:__Load()
                self.tComponent[kData.Control] = kTemp
            end
        end
    end
end
function Component:Get(kName)
    return self.tComponent[kName]
end
function Component:Unload()
    for k,v in _G.pairs(self.tComponent) do
        v:__Unload()
    end
    self.tComponent = nil
    self.t = nil
end
function Component:Check(tVal)
    local tOK = {}
    if tVal then
        for k,v in _G.pairs(tVal) do
            _G.table.insert(tOK, self.tComponent[v])            
        end
    else
        for k,v in _G.pairs(self.tComponent) do
            _G.table.insert(tOK, v)            
        end
    end
    _G.table.sort(tOK, function (a,b)
        return a.kData2.ID < b.kData2.ID
    end)
    for k,v in _G.pairs(tOK) do
        if v.Check and not v:Check() then
            return false
        end
    end
    return true
end
----------------------------------------------------------------
Base = CC.Class({}, "ComponentBase")
function Base:Create(kComponent, kData1, kData2)
    local kClass = self:__New()
    kClass.kUI = kComponent.kUI
    kClass.kComponent = kComponent
    kClass.kData1 = kData1
    kClass.kData2 = kData2
    kClass.kC = kClass.kUI:Control(kData1.Control)
    return kClass
end
function Base:__Load()
    self.t = {}
    if self.Load then
        self:Load()
    end
    if self.Refresh then
        self:Refresh()
    end
end
function Base:__Unload()
    if self.Unload then
        self:Unload()
    end
    self.t = nil
end
----------------------------------------------------------------
EditBox = CC.Class({}, "ComponentEditBox", Base)
function EditBox:Load()
    local kEdit = CC.Sample.Edit:Create({Node = self.kC:Node(), Info = self.kData2.Tip, Any = self.kData2.Type == "文本", 
        Password = self.kData2.Type == "密码", Size = 18, Color = CC.Color.Gray, TipColor = CC.Color.Gray})
    self.t.kEdit = kEdit
end
function EditBox:Refresh()
    local kIcon = self.kData2.IconError
    local bFirst = not self.t.kIconError
    if bFirst then
        local kImage = _G.ccui.ImageView:create()
        self.t.kEdit.kNode:getParent():addChild(kImage)
        CC.Nine:Create{Node = self.t.kEdit.kNode}:Attach(7,CC.Nine:Create{Node = kImage},7)   
        CC.Node:Move{Node = kImage, XD = kIcon.XD, YD = kIcon.YD}     
        self.t.kIconError = kImage
    end
    self.t.kIconError:loadTexture(self:Check() and (kIcon.PathOK or "") or (kIcon.Path or ""), 1)
    self.t.kIconError:setVisible(not bFirst)
end
function EditBox:Unload()
    self.t = nil
end
function EditBox:SetCheck(kFunc)
    local function LF_Check()
        local kText = self.t.kEdit:Text()
        if kText == "" then
            if self.kData2.TipEmpty then
                CC.Message{Tip = self.kData2.TipEmpty}
            end
        elseif not kFunc(kText) then
            if self.kData2.TipError then
                CC.Message{Tip = self.kData2.TipError}
            end
        else
            return true
        end
    end
    local function LF_Temp(eEvent, kNode)
        if eEvent == "ended" then
            LF_Check()
            self:Refresh()
        end
    end
    self.t.kEdit:CallBack(LF_Temp)
    self.t.Check = LF_Check
end
function EditBox:Text(...)
    return self.t.kEdit:Text(...)
end
function EditBox:Check()
    return self.t.Check == nil or self.t.Check()
end
----------------------------------------------------------------
Item = CC.Class({}, "ComponentItem", Base)
function Item:Load()    
    function self.kUI:ComponentItem_OnTouchItem(tVal)
        local iID = self:Control(tVal.Node):Param()
        if tVal.Down and iID then
            CC.UIMgr:Load(UIItemTips)
            CC.UIMgr:Call("UIItemTips", {SetItem = true, iID = iID, Node = tVal.Node, UI = self.Key})
        elseif tVal.Up then
            CC.UIMgr:Unload(UIItemTips)
        end
    end
end
function Item:Refresh()
    local kItem = self.t.kItem
    if kItem then
        local kExcel = self.t.kItem:Excel()
        if self.kData2.Background ~= "无" then
            self.kC:C("iBack"):Show()
        end
        if self.kData2.Name ~= nil then
            self.kC:C("txName"):Visible(self.kData2.Name):Text(kExcel.Name)
        end
        self.kC:C("iItem"):Show():Image(kExcel.Icon)
        self.kC:C("txNum"):Show():Fix(self.kData2.Fix):Text(kItem.iNum)
        if self.kData2.Tip then
            self.kC:Param(kExcel.ID):Touch("ComponentItem_OnTouchItem")
        end
    else        
        if self.kData2.Background ~= "无" then
            self.kC:C("iBack"):Visible(self.kData2.Background == "显示")
        end
        if self.kData2.Name ~= nil then
            self.kC:C("txName"):Hide()
        end
        self.kC:C("iItem"):Hide()
        self.kC:C("txNum"):Hide()
        self.kC:Del():Param()
    end
end
function Item:Set(kItem)
    self.t.kItem = CC.IsClass(kItem, "Item") and kItem or nil
    self:Refresh()
end
----------------------------------------------------------------
RedPoint = CC.Class({}, "ComponentRedPoint", Base)
function RedPoint:Load()
    local tVal = CC.Upgrade({Name = "iRedPoint", Parent = self.kC:Node(), Image = "koko/atlas/common/RedPoint.png"}, self.kData2.Position)
    self.t.kImage = CC.Creator:Image(tVal)
end
function RedPoint:Refresh()
end
function RedPoint:C()
    return self.kC:C("iRedPoint")
end