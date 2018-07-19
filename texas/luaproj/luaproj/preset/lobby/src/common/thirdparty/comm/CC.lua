module ("comm.CC", package.seeall)
-----------------------------------------------------------------------------------
-- Chris Class
-----------------------------------------------------------------------------------
-- String
-- Node
-- Nine
-- Union
-- ScrollView
-- Timer
-- LC_Control
-- UI
-- UIMgr
-- Check
-- Math
-- Table
-- Image
-- Creator
-- Physical
-- Audio
-- Motion
-- Box
-- BoxMgr
-----------------------------------------------------------------------------------

Color = 
{
    --RGBA
    Purple = cc.c4b(0x4B, 0x00, 0x91, 0xff),
    Red = cc.c4b(0xff, 0x00, 0x00, 0xff),
    Green = cc.c4b(0x00, 0xff, 0x00, 0xff),
    Blue = cc.c4b(0x00, 0x00, 0xff, 0xff),
    Black = cc.c4b(0x00, 0x00, 0x00, 0xff),
    White = cc.c4b(0xff, 0xff, 0xff, 0xff),
    Gray = cc.c4b(0x80, 0x80, 0x80, 0xff),
}
function Load()
    Assert = assert
    Debug = CCDebug
    Version = CCVersion
    DebugCheck = function (kParam, kVal)
        return Debug and Debug[kParam] and (kVal == nil or Debug[kParam] == kVal)
    end
    KK = _G.kk

    function IsClass(obj, classname)
        local function iskindof_(cls, name)
            local __index = rawget(cls, "__index")
            if __index == nil then return false end
            if type(__index) == "table" and rawget(__index, "__cname") == name then return true end

            if rawget(cls, "__cname") == name then return true end
            local __supers = rawget(__index, "__supers")
            if not __supers then return false end
            for _, super in ipairs(__supers) do
                if iskindof_(super, name) then return true end
            end
            return false
        end
        local t = type(obj)
        if t ~= "table" and t ~= "userdata" then return false end

        local mt
        if t == "userdata" then
            if tolua.iskindof(obj, classname) then return true end
            mt = tolua.getpeer(obj)
        else
            mt = getmetatable(obj)
        end
        if mt then
            return iskindof_(mt, classname)
        end
        return false
    end
    ToString = tostring
    Excel = require "Excel".Excel
    Player = require "koko.data".playerself
    Data = require "koko.data"
    Sample = require "comm.Sample"
    Web = require "web"
    proto2 = require "koko.proto2"
    Send = proto2.Send
    SendGame = proto2.SendGame
    PlayerMgr = require "koko.data.PlayerMgr"
    ItemMgr = require "koko.data.ItemMgr"
    GameMgr = require "koko.data.GameMgr"
    Net = require "koko.net"
    Config = require "config"
    Component = require "comm.Component"
    Cover = require "koko.ui.lobby.UICover".Cover
    LoginMgr = require "LoginMgr"
    function LF_Event()
        local kEvent = require "Event".Event
        local function LF_Temp(kKey, tVal)
            if string.find(kKey, "Refresh") then
                kEvent:Refresh(kKey, tVal)
            else
                kEvent:Call(kKey, tVal)
            end
        end
        return LF_Temp
    end
    Event = LF_Event()
    Game = false
    function ToNumber(kVal) 
        local kRt = tonumber(kVal)
        if not kRt then
            kRt = 0
        end
        return kRt
    end
end
-----------------------------------------------------------------------------------
-- Function
-----------------------------------------------------------------------------------
function DebugAssert(kVal, kMessage)
    if CCTest then
        Assert(kVal, kMessage)
    elseif not kVal then
        Print("[DebugAssert] "..kMessage)
    end
end
function ToBool(kVal)
    if kVal then
        return true
    else
        return false
    end
end
function SendWeb(kURL, tVal, kCallBack, kCallBack2) 
    tVal.appKey = tVal.appKey or Player.appKey
    tVal.uid = tVal.uid or Player.uid
    function LF_CallBack(tVal)
        Print("Web >> "..kURL..Table:ToString(tVal))
        if kCallBack then
            if kCallBack2 then
                UIMgr:Do(kCallBack, kCallBack2, tVal)
            else
                kCallBack(tVal)
            end
        else
            Message(tVal.success and {Tip = tVal.message} or {Text = tVal.message})
        end
    end
    Print("ClientW << "..kURL..Table:ToString(tVal))
    kk.ql.httpPost(require("config").webHost .. kURL, tVal, LF_CallBack)
end

function Copy(kOld, tLookup)
    tLookup = tLookup or {}
    if _G.type(kOld) ~= "table" then
        return kOld
    elseif tLookup[kOld] then
        return tLookup[kOld]
    else        
        local tNew = {}
        tLookup[kOld] = tNew
        for i,v in _G.pairs(kOld) do
            tNew[Copy(i)] = Copy(v)
        end  
        return _G.setmetatable(tNew, Copy(_G.getmetatable(kOld)))
    end 
end

function SimpleCopy(tVal)
    if type(tVal) == "table" then
        local tRt = {}
        for k,v in pairs(tVal) do
            tRt[k] = v
        end
        _G.setmetatable(tRt, _G.getmetatable(tVal))
        return tRt
    else
        return tVal
    end
end
-----------------------------------------------------------------------------------
function SimpleUpgrade(tOld, tAdd)
    tOld = tOld or {}
    if tAdd then
        for k,v in _G.pairs(tAdd) do
            tOld[k] = v
        end
    end
    return tOld
end
-----------------------------------------------------------------------------------
function Upgrade(tOld, tAdd)
    tOld = tOld or {}
    local tLookup = {}
    if tAdd then
        for k,v in _G.pairs(tAdd) do
            tOld[Copy(k, tLookup)] = Copy(v, tLookup)
        end
    end
    return tOld
end
-----------------------------------------------------------------------------------
function Class(tVal, kName, ... )
    local kClass = class(kName, ...)
    kClass.__tVal = tVal
    kClass.__kName = kName
    function kClass:__New( ... )
        local kTemp = kClass.new(...)
        if kTemp.__supers then
            for i,v in ipairs(kTemp.__supers) do
                Upgrade(kTemp, v.__tVal)
            end
        end
        Upgrade(kTemp, self.__tVal)
        return kTemp
    end

    local bCreate = false
    for k,v in pairs({...}) do
        if v.Create ~= v.__New then
            bCreate = true
        end
    end
    if not bCreate then
        kClass.Create = kClass.__New
    end
    return kClass
end
-----------------------------------------------------------------------------------
function Switch()
    local kClass = {__bOn = false}
    function kClass:TryOn()
        if not self.__bOn then
            self.__bOn = true
            return true
        end
        return false
    end
    function kClass:TryOff()
        if self.__bOn then
            self.__bOn = false
            return true
        end
        return false
    end
    function kClass:IsOn()
        return self.__bOn
    end
    function kClass:Toggle()
        self.__bOn = not self.__bOn
    end
    return kClass
end
-----------------------------------------------------------------------------------
function Step(i, tStep)
    i = i or 999999
    if tStep then
        tStep[0] = "Null"
    end
    local kClass = {__iStep = i, __iMax = i}
    function kClass:Load()
        self.__tStep = Table:Inverse(tStep)
    end
    function kClass:Try(i)
        i = self:__Change(i)
        if self.__iStep + 1 == i or (i == 1 and self.__iStep == self.__iMax) then
            self.__iStep = i
            return true
        end
        return false
    end
    function kClass:Jump(i)
        i = self:__Change(i)
        self.__iStep = i
    end
    function kClass:Is(i)
        i = self:__Change(i)
        i = i == 0 and self.__iMax or i
        return self.__iStep == i
    end
    function kClass:Get()
        return self.__iStep
    end
    function kClass:Name()
        Assert(self.__tStep, "Step:Name name map isn't existed")
        return self.__tStep[self.__iStep]
    end
    function kClass:__Change(i)
        if not self.__bInit then
            self.__bInit = true
            self:Load()
        end
        return self.__tStep and type(i) == "string" and self.__tStep[i] or i
    end
    return kClass
end
-----------------------------------------------------------------------------------
function Function(kClass, kFunc)
    local kClassTemp, kFuncTemp = kClass, kFunc
    function LF_Action(...)
        return kFuncTemp(kClassTemp, ...)
    end
    return LF_Action
end
-----------------------------------------------------------------------------------
function ClassFunction(kClass, kFunc)
    if kFunc then
        return ClassFunction(Function(kClass, kFunc))
    end
    local kFuncTemp = kClass
    function LF_Action(kClass, ...)
        return kFuncTemp(...)
    end
    return LF_Action
end
-----------------------------------------------------------------------------------
function UIFunction(kVal, kVal2)
    return function (...)
        UIMgr:Do(kVal, kVal2, ...)
    end
end

-----------------------------------------------------------------------------------
function Print( ... )
    printLog("CC", ...)
end

function Message(tVal, kFunc)
    if type(tVal) == "string" then
        return Message({Excel = tVal, CallBack = kFunc})
    end
    if tVal.Excel then
        local kExcel = Excel.Message.Key[tVal.Excel]:At(1)
        if kExcel then
            local tValTemp = {CallBack = tVal.CallBack}
            if string.find(kExcel.Type, "无") then
                return
            elseif string.find(kExcel.Type, "弹窗") then
                tValTemp.Text = kExcel.Text
                if string.find(kExcel.Type, "可取消") then
                    tValTemp.Cancel = true
                end
            elseif string.find(kExcel.Type, "飘字") then
                tValTemp.Tip = kExcel.Text
            end
            return Message(tValTemp)
        else
            Print("CC.Message {Excel = "..tVal.Excel.."} dosn't existed")
        end
    elseif tVal.Tip then
        CC.Print("Message "..tVal.Tip)
        KK.msgup.show(tVal.Tip)
    elseif tVal.Text then
        CC.Print("Message "..tVal.Text)
        KK.msgbox[tVal.Cancel and "showOkCancel" or "showOk"](tVal.Text, tVal.CallBack, tVal.Time)
    else
        Print("CC.Message: invalid parameter")
    end
end
-----------------------------------------------------------------------------------
-- Class
-----------------------------------------------------------------------------------
local LC_String = {}
function LC_String:FindIndex(kString)
    local iFix = 0
    while true do        
        local iLength = string.len(kString)
        local iA, iB = string.find(kString, "%d+")
        if not iA then
            return iA
        elseif iB == iLength then
            return iFix + iA, iFix + iB
        end
        kString = string.sub(kString, iB + 1)
        iFix = iFix + iB
    end
end
-----------------------------------------------------------------------------------
-- String
String = {}
function String:GetPrefix(kString)-- "Item1" -> "Item"
    local iA, iB = LC_String:FindIndex(kString)
    return (iA and string.sub(kString, 1, iA - 1)) or kString
end

function String:GetIndex(kString)-- "Item1" -> 1
    local iA, iB = LC_String:FindIndex(kString)
    return (iA and tonumber(string.sub(kString, iA, iB))) or 0
end

function String:Split(kString, kSeprator)
    local iFirst = 1
    local iSep = string.len(kSeprator)
    local t = {}
    if #kString > 0 then
      while true do
          local iLast = string.find(kString, kSeprator, iFirst)
          if not iLast then
              table.insert(t, string.sub(kString, iFirst))
              break
          else
              table.insert(t, string.sub(kString, iFirst, iLast - 1))
              iFirst = iLast + iSep
          end          
      end
    end
    return t
end

function String:Format( ... )
    return string.format(...)
end

function String:Length( ... )
    return string.len(...)
end

function String:NumFix(kVal)
    if type(kVal) == "number" then
        if kVal >= 100000000 then
            kVal = math.floor(kVal / 100000000).."亿"
        elseif kVal >= 10000 then
            kVal = math.floor(kVal / 10000).."万"
        end
    end
    return kVal
end

function String:Time(iTime, eType)
    local kString = ""
    if eType == "TimeToIntervalDay" then
        local iDayD = math.floor(iTime/(3600*24)) - math.floor(PlayerMgr.Time:Get()/(3600*24))
        if iDayD == 0 then
            kString = "今天"
        elseif iDayD > 0 then
            kString = iDayD.."天后"
        elseif iDayD < 0 then
            kString = -iDayD.."天前"
        end
    elseif eType == "TimeToInterval" then
        local iTimeD = iTime - PlayerMgr.Time:Get()
        if iTimeD > 0 then
            return self:Time(iTimeD, "Interval").."后"
        else
            return self:Time(-iTimeD, "Interval").."前"
        end
    elseif eType == "Interval" then
        iTime = _G.math.max(0, iTime)
        local iTemp = _G.math.floor(iTime / 3600 / 24)
        iTime = iTime % (3600 * 24)
        function LF_Check()
            return iTemp > 0 or kString ~= ""
        end
        if LF_Check() then
            kString = kString..iTemp.."天"
        end
        iTemp = _G.math.floor(iTime / 3600)
        iTime = iTime % 3600
        local iHour = iTemp
        iTemp = _G.math.floor(iTime / 60)
        iTime = iTime % 60
        local iMunite = iTemp
        iTemp = _G.math.floor(iTime / 60)
        iTime = iTime % 60
        local iSecond = iTime
        kString = kString..string.format("%02d:%02d:%02d", iHour, iMunite, iSecond)
    elseif eType == "TimeHourMinute" then
        local tTime = os.date("*t", tonumber(iTime))
        kString = string.format("%02d:%02d", tTime.hour, tTime.min)
    else
        local tTime = os.date("*t", tonumber(iTime))
        kString = string.format("%04d年%02d月%02d日 %02d:%02d", tTime.year, tTime.month, tTime.day, tTime.hour, tTime.min)
    end
    return kString
end
-----------------------------------------------------------------------------------
-- Node
Node = {}
function Node:GetNamePair(kNode)
    local kName = kNode:getName()
    return String:GetPrefix(kName), String:GetIndex(kName)
end
function Node:Root(tVal)
    tVal = tVal or {}
    if tVal.All then
        return findChild("")
    end
    return findChild("")
end
function Node:Del(kNode)    
    local kParent = kNode:getParent()
    if kParent then
        kParent:removeChild(kNode, false)
    end
end
function Node:Copy(tVal)--{Node = N, Parent = }
    local kRight = tVal.Node
    local kCopy = kRight:clone()
    local kTemp = tVal.Parent or kRight:getParent()
    kTemp:addChild(kCopy)
    return kCopy
end

function Node:Array(tVal)--{Node = N, X = , Y = , XD = , YD = , ZD = , Adapt = , Keep =}
    local kNode, X, Y = tVal.Node, tVal.X or 1, tVal.Y or 1
    local kParent = kNode:getParent()
    local kMePrefix, iMeIndex = self:GetNamePair(kNode)
    local iMeZ = kNode:getLocalZOrder()
    local tMe = {X = kNode:getPositionX(), Y = kNode:getPositionY()}
    local function LF_GetXD()
        if tVal.XD then
            return {X = tVal.XD, Y = 0}
        end
        local kRight = kParent:getChildByName(kMePrefix..(iMeIndex + 1))
        if kRight then
            return {X = kRight:getPositionX() - kNode:getPositionX(), Y = kRight:getPositionY() - kNode:getPositionY()}
        elseif tVal.Adapt then
            local kNine = Nine:Create{Node = kNode}
            return {X = X > 1 and (kParent:getContentSize().width - kNine.X * 2 - kNine.W) / (X - 1) or 0, Y = 0}
        end
        return {X = kNode:getContentSize().width, Y = 0}
    end
    local function LF_GetYD()        
        if tVal.YD then
            return {X = 0, Y = tVal.YD}
        end
        local kBottom = kParent:getChildByName(kMePrefix..(iMeIndex + X))
        if kBottom then
            return {X = kBottom:getPositionX() - kNode:getPositionX(), Y = kNode:getPositionY() - kBottom:getPositionY()}
        elseif tVal.Adapt then
            local kNine = Nine:Create{Node = kNode}
            local fPH = kParent:getContentSize().height
            return {X = 0, Y = Y > 1 and (fPH - (fPH - kNine.Y) * 2 - kNine.H) / (Y - 1) or 0}
        end 
        return {X = 0, Y = kNode:getContentSize().height}
    end
    local tXD = LF_GetXD()
    local tYD = LF_GetYD()
    local kPos0 = {X = tMe.X - tXD.X * ((iMeIndex - 1) % X) - tYD.X * (math.floor((iMeIndex - 1) / X)), Y = tMe.Y + tXD.Y * ((iMeIndex - 1) % X) + tYD.Y * (math.floor((iMeIndex - 1) / X))}
    for i=1,X do
        for j=1,Y do
            local iIndex = (j - 1) * X + i
            local kName = kMePrefix..iIndex
            local kChild = kParent:getChildByName(kName)
            if iIndex ~= iMeIndex and (not tVal.Keep or not kChild) then
                if kChild then
                    kChild:removeFromParent()
                end
                kChild = self:Copy{Node = kNode, Parent = kParent}
            end
            kChild:setName(kName)
            kChild:setPosition(cc.p(kPos0.X + (i - 1) * tXD.X + (j - 1) * tYD.X, kPos0.Y - (j - 1) * tYD.Y - (i - 1) * tXD.Y))
            if tVal.ZD then
                kChild:setLocalZOrder(iMeZ + (iIndex - iMeIndex) * tVal.ZD)
            end
        end
    end    
end
function Node:Move(tVal)--{Node = N, XD = , YD = }
    local kNode = tVal.Node
    kNode:setPositionX(kNode:getPositionX() + tVal.XD)
    kNode:setPositionY(kNode:getPositionY() + tVal.YD)
end
function Node:Progeny(kNode, kName)
    local function LF_Temp(kNode, kName, bFirst)   
        if (kNode:getName() == kName and not bFirst) or kName == "" then
            return kNode
        else
            local tChildren = kNode:getChildren()     
            for k,v in pairs(tChildren) do
                local kTemp = LF_Temp(v, kName)
                if kTemp then
                    return kTemp
                end 
            end
        end
    end
    local kTemp = LF_Temp(kNode, kName, true)
    assert(kTemp, "CC.UI:Control "..(kNode and kNode:getName() or "").." has no progeny node "..kName)
    return kTemp
end
function Node:Path(kNode)
    local kPath = ""
    while kNode do
        kPath = kNode:getName().."/"..kPath
        kNode = kNode:getParent()
    end
    return kPath
end
function Node:Debug(kNode)
    if kNode then
        local tVal = {}
        tVal.Name = kNode:getName()
        tVal.Path = self:Path(kNode)
        tVal.Position = kNode:getPosition()
        CC.Print(CC.Table:ToString(tVal))
        return tVal
    end
end
function Node:SetParent(kNode, kParent2)
    local kParent = kNode:getParent()
    if kParent then
        if kParent == kParent2 then
            return
        end
        kParent:removeChild(kNode, false)
    end
    kParent2:addChild(kNode)
end
-----------------------------------------------------------------------------------
-- Nine
Nine = Class({X = 0, Y = 0, W = 0, H = 0, t = {}}, "Nine")
function Nine:Create(tVal)--{X = , Y = , W = , H = , Node = }
    local kClass = self:__New()    
    if tVal.Node then
        kClass.Node = tVal.Node
        kClass:Refresh()
    else
        Upgrade(kClass, tVal)
    end
    return kClass
end
function Nine:Refresh()
    if self.Node then
        local kAP = self.Node:getAnchorPoint()
        self.W = self.Node:getContentSize().width
        self.H = self.Node:getContentSize().height
        self.X = self.Node:getPositionX() - kAP.x * self.W
        self.Y = self.Node:getPositionY() + (1 - kAP.y) * self.H
    end
end
function Nine:GetX(iNine)
    return self.X + ((iNine - 1) % 3) * (self.W / 2)
end
function Nine:GetY(iNine)
    return self.Y - (2 -  math.floor((iNine - 1) / 3)) * (self.H / 2)
end
function Nine:Get(iNine)
    return self:GetX(iNine), self:GetY(iNine)
end
function Nine:Attach(iNine, kNine, iNine2)
    if kNine == nil then
        iNine, kNine, iNine2 = 5, iNine, 5
    end
    local fX1, fY1 = self:Get(iNine)
    local kWP = self.Node:getParent():convertToWorldSpace(cc.p(fX1, fY1))
    local kN2P = kNine.Node:getParent():convertToNodeSpace(kWP)
    kNine:Move(iNine2, kN2P.x, kN2P.y)
end
function Nine:Move(iNine, fX, fY)
    local fX1, fY1 = self:Get(iNine)
    local fX0, fY0 = self.Node:getPosition()
    self.Node:setPosition(fX0 + (fX - fX1), fY0 + (fY - fY1))
    self:Refresh()
end
function Nine:Size()
    local kClass = {Node = self.Node, t = self.t, Nine = self}
    function kClass:Load()
        self.t.tSize = {}
        local tData = self.t.tSize
        local kInner, kMe = Union:Create{Parent = self.Node}:GetNine(), self.Nine
        tData.tEdge = {fLeft = kInner.X, fTop = kMe.H - kInner.Y, fRight = kMe.W - kInner:GetX(3), fBottom = kInner:GetY(1)}
    end
    function kClass:Fix()
        local tEdge = self.t.tSize.tEdge
        local kUnion = Union:Create{Parent = self.Node}
        local kInner, kMe = kUnion:GetNine(), self.Nine
        kUnion:Move{XD = tEdge.fLeft - kInner.X, YD = tEdge.fBottom - kInner:GetY(1)}
        self.Node:setContentSize{width = kInner.W + tEdge.fLeft + tEdge.fRight, height = kInner.H + tEdge.fTop + tEdge.fBottom}
    end
    return kClass
end
-----------------------------------------------------------------------------------
-- Union
Union = Class({tNode = {}}, "Union")
function Union:Create(tVal)--{Parent = }
    local kClass = self:__New()
    if tVal.Parent then
        for _, kChild in ipairs(tVal.Parent:getChildren()) do
            kClass:Add(kChild)
        end
    end
    return kClass
end
function Union:Add(kNode)
    table.insert(self.tNode, kNode)
end
function Union:GetNine()
    local iTop, iBottom, iLeft, iRight
    for _, kChild in ipairs(self.tNode) do
        if kChild:isVisible() then
            local kChild9 = Nine:Create({Node = kChild})
            local iL, iT = kChild9.X, kChild9.Y
            local iR, iB = kChild9:GetX(3), kChild9:GetY(3)
            if not iTop then
                iTop, iBottom, iLeft, iRight = iT, iB, iL, iR
            else
                iTop = math.max(iT, iTop)
                iBottom = math.min(iBottom, iB)
                iLeft = math.min(iLeft, iL)
                iRight = math.max(iRight, iR)
            end
        end
    end
    if iTop == nil then
        iTop, iBottom, iLeft, iRight = 0,0,0,0
    end
    return Nine:Create{X = iLeft, Y = iTop, W = iRight - iLeft, H = iTop - iBottom}
end
function Union:Move(tVal)--{XD = , YD = }
    for _, kChild in ipairs(self.tNode) do
        Node:Move({Node = kChild, XD = tVal.XD, YD = tVal.YD})
    end
end
function Union:Do(kFunc, ... )
    for _, kChild in ipairs(self.tNode) do
        kChild[kFunc](kChild, ...)
    end
end
function Union:Align(tVal)--{XI,YI}
    local fX = false
    for _, kChild in ipairs(self.tNode) do
        local kNine = Nine:Create{Node = kChild}
        if fX then
            fX = fX + tVal.XI
            kNine:Move(7, fX, kNine:GetY(7))
        end
        fX = kNine:GetX(3)
    end
end
-----------------------------------------------------------------------------------
-- ScrollView
ScrollView = Class({}, "ScrollView")
function ScrollView:Create(tVal)--{Node = X}
    local kClass = self:__New()
    kClass.kNode = tVal.Node
    return kClass
end
function ScrollView:Fix(tVal)--自动适配大小{Top = , Bottom = , Left = , Right =}
    local bLeftFix = not tVal or not tVal.Left
    local bTopFix = not tVal or not tVal.Top
    tVal = Upgrade({Top = 0, Bottom = 0, Left = 0, Right = 0, Keep = false}, tVal)
    local kP7 = self.kNode:getInnerContainerPosition()
    kP7.y = kP7.y + self.kNode:getInnerContainerSize().height
    local kUnion = Union:Create({Parent = self.kNode})
    local kNine = kUnion:GetNine()
    if bLeftFix then
        tVal.Left = kNine.X
    end
    if bTopFix then
        tVal.Top = self.kNode:getInnerContainerSize().height - kNine.Y
    end
    local iW = kNine.W + tVal.Right + tVal.Left
    local iH = kNine.H + tVal.Top + tVal.Bottom
    local iWFix = math.max(iW, self.kNode:getContentSize().width)
    local iHFix = math.max(iH, self.kNode:getContentSize().height)
    self.kNode:setInnerContainerSize(cc.size(iWFix, iHFix))
    kUnion:Move{XD = tVal.Left - kNine.X, YD = tVal.Bottom + kNine.H + iHFix - iH - kNine.Y}
    kNine = kUnion:GetNine()

    if tVal.Keep then
        self.kNode:setInnerContainerPosition{x = kP7.x, y = math.min(0, kP7.y - iHFix)}
    else
        self.kNode:stopAutoScroll()
    end

end
function ScrollView:Child(kPath)
    return self.kNode:findChild(kPath)
end
function ScrollView:Next()
    return self.kNode:getInnerContainerPosition().y >= -10
end
-----------------------------------------------------------------------------------
-- Timer
Timer = Class({}, "Timer")
function Timer:Create(kPartner)
    assert(kPartner, "Timer:Create no partner")
    local kClass = self:__New()
    kClass.kPartner = kPartner
    return kClass
end
function Timer:Load()
    self:Unload()
    self.iScheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(Function(self, self.__Update), 0, false)
end
function Timer:Add(kKey, fDelta, iCount, fDelay)
    fDelay = fDelay or fDelta
    self.tTimer[kKey] = {Delta = fDelta, Max = iCount or 1, Time = self.fTime + fDelay, Count = 0}
end
function Timer:__Update(fDelta)
    self.fTime = self.fTime + fDelta
    if self.kPartner then
        if self.kPartner.__Update then
            self.kPartner:__Update(fDelta)
        elseif self.kPartner.Update then
            self.kPartner:Update(fDelta)
        end
    end
end
function Timer:Check(kKey)
    if kKey == nil then
        for k,v in pairs(self.tTimer) do
            if self:Check(k) then
                return k
            end    
        end
    else
        local tVal = self.tTimer[kKey]
        if tVal and (tVal.Max == -1 or tVal.Max > tVal.Count) and tVal.Time <= self.fTime then
            tVal.Time = tVal.Time + tVal.Delta
            tVal.Count = tVal.Count + 1
            if tVal.Count == tVal.Max then
                self:Del(kKey)
            end
            return true
        end
    end
end
function Timer:Has(kKey)
    return self.tTimer[kKey] ~= nil
end
function Timer:Del(kKey)
    self.tTimer[kKey] = nil
end
function Timer:CD(kKey, fDelta)
    local bOK = not self:Has(kKey) or self:Check(kKey)
    if bOK then
        self:Add(kKey, fDelta)
        return true
    end
end
function Timer:Unload()
    self.fTime = 0
    self.tTimer = {}
    if self.iScheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.iScheduler)
    end
end
-----------------------------------------------------------------------------------
-- LC_Control
local LC_Control = {}
function LC_Control:Create(kNode, kUI)
    local kClass = Copy(LC_Control)
    kClass.kNode = kNode
    kClass.kUI = kUI
    kClass.st = {}
    kClass.tCChildren = {}
    local mt = {}
    function mt:__index(kKey)
        function LF_Do(kClass, tVal, ...)
            return kClass:Do(kKey, tVal, ...)
        end
        local kFunc = LF_Do
        rawset(self, kKey, kFunc)
        return kFunc
    end
    setmetatable(kClass, mt)
    kClass:Reset()
    kClass:Refresh()
    return kClass
end
function LC_Control:Refresh()
    local tC = {}
    tC[""] = self
    tC[self.kNode] = self
    if self.kNode.getChildren then
        local tChildren = self.kNode:getChildren()     
        for k,v in pairs(tChildren) do
            local kCOld = self.tCChildren[v]
            if kCOld then
                kCOld:Refresh()
            end
            local kC = kCOld or LC_Control:Create(v, self.kUI)
            tC[v:getName()] = kC
            for k0,v0 in pairs(kC.tCChildren) do
                if tC[k0] == nil then
                    tC[k0] = v0
                end
            end
        end
    end
    self.tCChildren = tC
end

function LC_Control:UserData()
    return json.decode(self.kNode:getComponent("ComExtensionData"):getCustomProperty()) or {}
end

function LC_Control:Do(kKey, kVal, ...)
    if kKey == "Format" then
        return self:Do("Text", string.format(kVal,...))
    elseif kKey == "Show" then
        return self:Do("Visible", true)
    elseif kKey == "Hide" then
        return self:Do("Visible", false)
    end

    local kNode = self.kNode
    local kRt = "__Nil"
    if kKey == "Text" then
        if kVal then
            if self.t.Fix then
                kVal = String:NumFix(kVal)
            end
            kNode:setString(tostring(kVal))
        else
            kRt = kNode:getString()
        end
    elseif kKey == "C" then
        local kC = self.tCChildren[kVal]
        if kC == nil then
            self:Refresh()
            kC = self.tCChildren[kVal]
        end
        kRt = kC
    elseif kKey == "Image" then
        if self.t.Fix then
            kNode:ignoreContentAdaptWithSize(true)
        end
        if self.t.Web then
            Image:Web(kNode, self.t.Web)
        else
            kNode:loadTexture(tostring(kVal), 1)
        end
    elseif kKey == "Close" then
        self.kUI:RegClose(kNode)
    elseif kKey == "Click" then
        local tSize = kNode:getContentSize()
        local fL = math.max(tSize.height, tSize.width)
        local fLFix = math.min(fL * 1.08, fL + 12)
        kNode:onClick(Function(self.kUI, self.kUI[kVal]), self.t.Scale or (fLFix / fL), nil, nil, nil, self.t.CD)
    elseif kKey == "Open" then
        self.kUI:RegOpen(kNode, kVal)
    elseif kKey == "Event" then
        local kFunc = ...
        kNode:addEventListener(function (kNode, eType)
            if eType == kVal then
                self.kUI[kFunc](self.kUI, kNode)
            end
        end)
    elseif kKey == "Touch" then
        kNode:setTouchEnabled(true)
        kNode:addTouchEventListener(function (kNode, eType)
            local tParam = {Node = kNode, Down = eType == ccui.TouchEventType.began, Move = eType == ccui.TouchEventType.moved, 
                Up = eType == ccui.TouchEventType.ended or eType == ccui.TouchEventType.canceled,
                OK = eType == ccui.TouchEventType.ended, Cancel = eType == ccui.TouchEventType.canceled}
            self.kUI[kVal](self.kUI, tParam)
        end)
    elseif kKey == "Index" then
        kRt = String:GetIndex(kNode:getName())
    elseif kKey == "Nine" then
        self.kNine = rawget(self, "kNine") or Nine:Create({Node = kNode})
        kRt = self.kNine
    elseif kKey == "Union" then
        kRt = Union:Create{Parent = kNode}
    elseif kKey == "Visible" then
        if self.t.Get then
            kRt = kNode:isVisible()
        else
            kNode:setVisible(ToBool(kVal))
        end
    elseif kKey == "Position" then
        if self.t.Get then
            kRt = {X = kNode:getPositionX(), Y = kNode:getPositionY()}
        else
            kNode:setPositionX(kVal.X)
            kNode:setPositionY(kVal.Y)
        end
    elseif kKey == "Color" then
        kNode:setColor(kVal)
    elseif kKey == "Alpha" then
        kNode:setOpacity(math.floor(kVal * 255))
    elseif kKey == "Gray" then
        kNode:setColor(kVal and Color.Gray or Color.White)
    elseif kKey == "Progress" then
        local fVal = Math:Clamp(kVal, 0, 1)
        if kNode.setPercent then
            kNode:setPercent(fVal * 100)
        else
            local kVec = kNode:getSizePercent()
            kVec.x = fVal
            kNode:setSizePercent(kVec)
        end
    elseif kKey == "Param" then
        local tTemp = self.kUI.tParam
        local tParam = tTemp[kNode]
        if self.t.Del then
            tTemp[kNode] = nil
        elseif self.t.Get or kVal == nil then
            kRt = tParam
        else
            tTemp[kNode] = kVal
        end            
    elseif kKey == "Enabled" then
        if self.t.Get then
            return kNode:isEnabled()
        else
            kNode:setEnabled(ToBool(kVal))
        end
    elseif kKey == "ChildrenCount" then
        kRt = kNode:getChildrenCount()
    elseif kKey == "Node" then
        kRt = kNode
    elseif kKey == "Array" then
        kRt = Node:Array(Upgrade({Node = kNode}, kVal))
    elseif kKey == "Scroll" then
        kRt = ScrollView:Create{Node = kNode}
    elseif kKey == "LineSpacing" then
        kNode:getVirtualRenderer():setLineSpacing(kVal)
    elseif kKey == "Component" then
        kRt = self.kUI.Component:Get(kNode:getName())
    elseif kKey == "Motion" then
        if self.t.Has then
            kRt = self.kUI.kMotion:Has{kNode = kNode, kType = kVal}
        elseif self.t.Del then
            kRt = self.kUI.kMotion:Del{kNode = kNode, kType = kVal}
        else
            self.kUI.kMotion:Add{kNode = kNode, kType = kVal, fFrom = self.t.From, fTo = self.t.To, fDelay = self.t.Delay,
                iRepeat = self.t.Repeat, bLoop = self.t.Loop, fTime = self.t.Time, kName = self.t.Name, kCallBack = self.t.CallBack, kC = self}
        end
    elseif kKey == "DragonBones" then
        local tCustom = self:UserData()
        local kTemp = sp.SkeletonAnimation:createWithJsonFile(tCustom.龙骨动画..".json", tCustom.龙骨动画..".atlas", 1)
        if self.t.Animation then
            kTemp:setAnimation(0, self.t.Animation, self.t.Loop)
        end
        kNode:addChild(kTemp)
    elseif kKey == "Action" then
        local tCustom = self:UserData()
        if not self.st.kAction then
            self.st.kAction = cc.CSLoader:createTimeline(self.kUI.Path)
            kNode:runAction(self.st.kAction)
        end
        if self.t.CallBack then
            self.st.kAction:setLastFrameCallFunc(
				function ()
					self.t.CallBack()
				end
			)
        end
        local fD1, fD2 = tCustom.动画时长, self.st.kAction:getDuration()
        local fDuration = fD1 and _G.math.min(fD1, fD2) or fD2
        if self.t.From and self.t.From == self.t.To then
            self.st.kAction:gotoFrameAndPause(self.t.From * fDuration)
        else
            self.st.kAction:gotoFrameAndPlay(self.t.From and self.t.From * fDuration or 0, self.t.To and self.t.To * fDuration or fDuration, self.t.Loop or false)
        end
    elseif kKey == "Debug" then
        kRt = CC.Node:Debug(kNode)
    elseif kKey == "Parent" then
        Node:SetParent(kNode, kVal:Node())
    else
        self.t[kKey] = kVal == nil and true or kVal
        return self
    end
    self:Reset()
    if kRt ~= "__Nil" then
        return kRt
    end
    return self
end
function LC_Control:Reset()
    self.t = {}
end
-----------------------------------------------------------------------------------
-- UI
local LC_UI_StepEnum = {On = 1, AnimOff = 2, Off = 3}

UI = Class({kStep = Step(LC_UI_StepEnum.Off), CCRefresh = {}}, "UI")
function UI:Create(tVal)
    if tVal and tVal.Path and tVal.Key then
        return Class(tVal, tVal.Key, UI):__New()
    end
end

function UI:__Update(fDelta)
    self.kMotion:Update(fDelta)
    if self.Update then
        self:Update(fDelta)
    end
end

function UI:__Path()
    local kMap = UIMgr:LayoutMap():Get()
    return kMap[self.Key] or self.Path
end

function UI:__Load()
    if not self.kStep:Try(LC_UI_StepEnum.On) then
        return false
    end
    self.kNode = cc.CSLoader:createNode(self:__Path())
    local kParent = Node:Root{All = self.Root}
    local kSize = kParent:getContentSize()
    self.kNode:setPosition(cc.p(kSize.width / 2, kSize.height / 2))
    kParent:addChild(self.kNode, 0)
    self.Timer = Timer:Create(self)
    self.Timer:Load()
    --Timeline
    if self.Play then
        local t = self.Play
        if type(t)~= "table" then
            t = {}
        end 
        local kAction = cc.CSLoader:createTimeline(self:__Path())
        self.kNode:runAction(kAction)
        kAction:gotoFrameAndPlay(0, kAction:getDuration(), t.Loop == true)
    end
    if self.Animation ~= false then
        self.AnimScale = KK.animScale:create()
        self.AnimScale:onAnimationEnter(self.kNode)
    end

    self.t = {}
    self.tParam = {}
    self.tC = {}
    self.kMotion = Motion:Create()

    local function LF_FuncSet(v)
        local LC_Param = {}
        local kUI = self
        local lmt = {}
        function lmt:__index(kKey)
            return kUI:Param(kKey)
        end
        setmetatable(LC_Param, lmt)
        local tVal = {C = Function(self, self.Control), P = LC_Param, _G = _G}
        setfenv(v, tVal)
    end
    for k,v in pairs(self) do
        if type(v) == "function" and k ~= "Public" then
            LF_FuncSet(v)
        end
    end
    for k,v in pairs(self.CCRefresh) do
        LF_FuncSet(v)
    end

    if self.Public then
        self:Public()
    end

    if self.Prepare then
        self:Prepare()
    end
    
    self.Component = Component.Component:Create(self)
    self.Component:Load()

    if self.Load then
        self:Load()
    end  
    if self.Refresh then
        self:Refresh()
    end

    return true
end
function UI:__Unload()
    if not self.kStep:Try(LC_UI_StepEnum.AnimOff) then
        return false
    end
    if self.AnimScale then
        self.AnimScale:onAnimationExit(self.kNode, Function(self, self.__Exit))
    else
        self:__Exit()
    end
    return true
end
function UI:__Exit()
    self.kStep:Try(LC_UI_StepEnum.AnimOff)
    if not self.kStep:Try(LC_UI_StepEnum.Off) then
        return false
    end

    self.Component:Unload()

    if self.Unload then
        self:Unload()
    end
    self.Timer:Unload()
    self.kNode:removeFromParent()
    self.t = nil
    self.tParam = nil
    UIMgr:Unload(self) 
    return true
end
function UI:__Open(kNode)
    UIMgr:Load(self.tParam[kNode])
end
function UI:Component()
    return self.Component
end
function UI:Child(kPath)
    return (type(kPath) == "string" and self.kNode:findChild(kPath)) or kPath
end
function UI:Control(kName, iA, iB)
    _G.assert(iA ==nil and iB == nil, "C 现在不支持多个参数")
    self.t.__tC = self.t.__tC or LC_Control:Create(self.kNode, self)
    return self.t.__tC:C(kName)
end
function UI:RegClick(kNode, kFunc)
    assert(kFunc, "UI:RegClick -> No callback")
    self:Child(kNode):onClick(handler(self, kFunc))
end
function UI:RegClose(kNode)
    self:RegClick(kNode, self.__Unload)
end
function UI:RegOpen(kNode, kUI)
    self.tParam[self:Child(kNode)] = kUI
    self:RegClick(kNode, self.__Open)
end
function UI:RegEdit(kNode, kFunc)    
    local function LF_CallBack(eEvent, kNode)
        if eEvent == "ended" then
            Print("EditBox ["..kNode:getName().."]"..tostring(kNode:getText()))
            kFunc(self, kNode)
        end
    end 
    self:Child(kNode):registerScriptEditBoxHandler(LF_CallBack)
end
function UI:RegCheck(kNode, kFunc)    
    self:Child(kNode):addEventListener(handler(self, kFunc))
end
function UI:SetVisible(tVal)
    self.kNode:setVisible(tVal)
end
function UI:SetParent(kNode, tVal)
    if kNode == nil then
        Print("UI:SetParent parameter is nil")
        return
    end    
    if self.kNode == nil then
        Print("UI:SetParent self.kNode is nil")
        return
    end
    local kParent = self.kNode:getParent()
    if kParent then
        kParent:removeChild(self.kNode, false)
    end
    kNode:addChild(self.kNode)
    if tVal and tVal.Attach then
        Nine:Create{Node = kNode}:Attach(tVal.Attach, Nine:Create{Node = self.kNode}, tVal.Attach)
    end
end
function UI:Param(kKey)
    if not self.t.__tParam then
        local t = {}
        local kParam = Excel.Parameter.Key[self.Key]
        if kParam then
            local iCount = kParam:Count()
            for i=1,iCount do            
                local kExcel = kParam:At(i)
                t[kExcel.Param] = kExcel.Value
            end
        end
        self.t.__tParam = t
    end
    return self.t.__tParam[kKey]
end
function UI:Refresh(tVal)
    for k,v in _G.pairs(self.CCRefresh) do
        if tVal == nil or tVal[k] then
            v(self, tVal)
        end
    end
end
-----------------------------------------------------------------------------------
-- UIMgr
local function LF_UIMgr()
    local kClass = {}
    local tWindow = {}
    local tLayoutMap = {}
    function kClass:Load(kTemp, kName)
        if iskindof(kTemp, "UI") and kTemp.Key then
            local kKey = kName and kTemp.Key.."."..kName or kTemp.Key
            local kLast = tWindow[kKey]
            if kLast and not self:Get(kKey) then
                kLast:__Exit()
            end
            if kLast == nil then
                tWindow[kKey] = kTemp
                if kTemp:__Load() and kTemp.Log ~= false then
                    Print("Load "..kKey)
                end                
            end
        else
            Print("UIMgr:Load Error ")
        end
    end
    function kClass:Unload(kTemp)
        local kKey = (type(kTemp) == "string" and kTemp) or (iskindof(kTemp, "UI") and kTemp.Key) or nil
        if kKey and tWindow[kKey] then       
            local bLog =   tWindow[kKey].Log
            if tWindow[kKey]:__Unload() and bLog ~= false then
                Print("Unload "..kKey)
            end
            tWindow[kKey] = nil
        end
    end

    function kClass:Set(kKey, kClass)
        tWindow[kKey] = kClass
        if kClass then
            Print("Load+ "..kKey)
        else
            Print("Unload+ "..kKey)
        end
    end

    function kClass:Call(kKey, ...)
        local kClass = tWindow[kKey]
        if kClass and kClass.Call then
            return kClass:Call(...)
        end
    end

    function kClass:Do(kKey, kFunc, ...)
        local kClass = tWindow[kKey]
        if kClass and kClass[kFunc] then
            --Print(kKey..":"..kFunc)
            return kClass[kFunc](kClass, ...)
        end
    end

    function kClass:Get(kKey)
        local kRt = tWindow[kKey]
        if kRt and iskindof(kRt, "UI") and not kRt.kStep:Is(LC_UI_StepEnum.On) then
            kRt = nil
        end
        return kRt 
    end

    function kClass:ExitAll()
        Print("UIMgr:ExitAll")

        local i = 1
        for i=1,100 do
            if _G.next(tWindow) == nil then
                break
            end
            local tmpWindow = {}
            for k,v in _G.pairs(tWindow) do
                tmpWindow[k] = v
            end
            for k,v in _G.pairs(tmpWindow) do
                if iskindof(v, "UI") then
                    Print("Unload "..k)
                    v:__Exit()
                end
                tWindow[k] = nil
            end
        end
        _G.assert(i < 100, "<UIMgr:ExitAll> 有些界面不能释放完成 %s", 
            _G.json.encode(_G.table.select(tWindow, function(k, v) return k end))
        )
    end

    function kClass:LayoutMap()
        local kClass = {}
        function kClass:Reset()
            tLayoutMap = {}
        end
        function kClass:Set(tMap)
            tLayoutMap = tMap or {}
        end
        function kClass:Get()
            return tLayoutMap
        end
        return kClass
    end

    return kClass
end
UIMgr = LF_UIMgr()
-----------------------------------------------------------------------------------
-- Check
Check = {Tip = {
    Account = "请输入6-12位字母和数字组合",
    Password = "请输入6-12位字母或数字",
    Name = "请输入4到18个字符",
    RealName = "请输入2到8个汉字",
    Email = "请输入电子邮箱",
    Phone = "请输入手机号",
    IDCard = "请输入身份证",
}}
function Check:Account(kName)--账号必须是6-12位之间，字母加上数字的组合
    return self:__Check(kName, "Both", 6, 12)
end
function Check:Password(kName)--密码必须是6-12位之间，字母或数字
    return self:__Check(kName, "Either", 6, 12)
end
function Check:Name(kName)--昵称4到18个字符,特殊字符只能是_和-
    return self:__Check(kName, "Name", 4, 18)
end
function Check:RealName(kName)--真实姓名2到8个汉字
    return self:__Check(kName, "Chinese", 2, 8)
end
function Check:Email(kName)--邮箱
    return self:__Check(kName, "Mail", 0, 50)
end
function Check:Phone(kName)--手机号必须是11位的数字
    return self:__Check(kName, "Number", 11, 11)
end
function Check:IDCard(kName)--身份证15位或18位，如果是18位，最后一位可以是字母Xx，其余必需是数字
    if string.len(kName) == 18 then
        return self:__Check(string.sub(kName, 1, 17), "Number") and self:__Check(string.sub(kName, 18, 18), "Number2")
    end
    return self:__Check(kName, "Number", 15, 15)
end
function Check:__Check(kName, kType, iCountMin, iCountMax)
    local bOK = true
    local kErr = nil
    if kType == "Both" then
        bOK = string.match(kName, "[%a0-9]+") == kName and string.match(kName, "%a+") ~= kName and string.match(kName, "[0-9]+") ~= kName
    elseif kType == "Either" then
        bOK = string.match(kName, "^[0-9a-zA-Z~`!@#$%%^&*()_+-=%[%]{};:'\"?,./<>|\\]+") == kName
    elseif kType == "Name" then
        bOK = string.match(kName, "[%P_%-]+") == kName
    elseif kType == "Number" then
        bOK = string.match(kName, "[0-9]+") == kName
    elseif kType == "Number2" then
        bOK = string.match(kName, "[0-9Xx]+") == kName
    elseif kType == "Letter" then
        bOK = string.match(kName, "%a+") == kName
    elseif kType == "Mail" then
        bOK = string.match(kName, "%w+@%w+.%w+") == kName      
    elseif kType == "Chinese" then
        local iMax = string.len(kName)
        for i=1,iMax do
            if string.byte(string.sub(kName, i, i)) <= 127 then
                bOK = false
                break
            end
        end
    end
    if not bOK then
        kErr = "ErrorType"
    end
    if bOK and iCountMin and iCountMax then
        local iLength = string.len(kName)
        if kType == "Chinese" then
            iLength = string.utf8len(kName)
        elseif kType == "Name" then
            local iMax = string.len(kName)
            local cnt = 0
            for i=1,iMax do
                local asc = string.byte(kName, i, i)
                if asc <= 127 then
                    cnt = cnt +1
                end
            end
            local cLen = (string.utf8len(kName) - cnt) * 2
            iLength = cLen + cnt
        end
        bOK = iLength >= iCountMin and iLength <= iCountMax
    end
    if not bOK then
        kErr = kErr or "ErrorLength"
    end
    return bOK, kErr
end
-----------------------------------------------------------------------------------
-- Math
Math = {tMove = {}}
function Math:Random(iNum)
    if iNum then
        return math.random(1, iNum)
    else
        return math.random()
    end
end
function Math:Min(iA, iB)
    return (iA < iB and iA) or iB
end
function Math:Max(iA, iB)
    return (iA > iB and iA) or iB
end
function Math:Clamp(iM, iA, iB)
    if iA > iB then
        iA,iB = iB,iA
    end
    if iM < iA then
        return iA
    end
    if iM > iB then
        return iB
    end
    return iM
end
function Math:Rate(fVal)
    return math.random() < fVal
end
function Math:LeftMove(i, iMove)    
    return i * self:__GetMove(iMove) 
end
function Math:RightMove(i, iMove)
    return math.floor(i / self:__GetMove(iMove))
end
function Math:__GetMove(iMove)
    local i = self.tMove[iMove]
    if i == nil then
        i = 2 ^ iMove
        self.tMove[iMove] = i
    end
    return i
end
-----------------------------------------------------------------------------------
-- Table
Table = {}
function Table:Vector(tVal)
    local tTemp = {}
    for k,v in pairs(tVal) do
        table.insert(tTemp, {Key = k, Value = v})
    end
    table.sort(tTemp, function (a,b)
        return a.Key < b.Key
    end)
    return tTemp
end
function Table:Insert(...)
    return table.insert(...)
end
function Table:ToString(tVal)
    local kString = tVal
    if type(tVal) == "table" then
        kString = "{ "
        local bFirst = true
        for k,v in pairs(tVal) do
            if not bFirst then
                kString = kString..", "
            else
                bFirst = false
            end
            if type(v) == "boolean" then
                v = v and "true" or "false"
            end
            kString = kString..self:ToString(k).." = "..self:ToString(v).." "
        end
        kString = kString.."}"
    else
        kString = ToString(kString)
    end
    return kString
end
function Table:At(tVal, kVal, tDefault)
    local kRt = rawget(tVal, kVal)
    if not kRt then
        kRt = tDefault or {}
        rawset(tVal, kVal, kRt)
    end
    return kRt
end
function Table:Empty(tVal)
    for k,v in pairs(tVal) do
        return false
    end
    return true
end
function Table:Append(tVal, tAppend)
    if tVal and tAppend then
        for i,v in _G.ipairs(tAppend) do
            table.insert(tVal, v)
        end
    end
end
function Table:Inverse(tVal)
    if tVal then
        local tTemp = {}
        for k,v in _G.pairs(tVal) do
            tTemp[v] = k
        end
        return tTemp
    end
end
-----------------------------------------------------------------------------------
-- Image
Image = {}
function Image:Web(kNode, kURL)
    local path = kNode:getPath()
    local function LF_CallBack(kKey, kMessage)
        if kKey == "" then
            Print("Image:Web download error "..kURL.." "..kMessage)
        else
            --local kTemp = cc.Director:getInstance():getTextureCache():getTextureForKey(kKey)
            local node = findChild(path)
            if node then
                node:loadTexture(kKey, 0)
            end
        end
    end
    cc.Director:getInstance():getTextureCache():loadImageFromUrl(kURL, LF_CallBack)
end
-----------------------------------------------------------------------------------
-- Creator
Creator = {}
function Creator:Image(tVal)
    tVal = tVal or {}
    local kImage = _G.ccui.ImageView:create()
    if tVal.Parent then
        tVal.Parent:addChild(kImage)
    end
    if tVal.XP and tVal.YP and tVal.Parent then
        local sz = tVal.Parent:getContentSize()
        kImage:setPosition(cc.p(sz.width * tVal.XP, sz.height * tVal.YP))
    end
    if tVal.X and tVal.Y then
        kImage:setPosition(tVal.X, tVal.Y)
    end
    if tVal.Image then
        kImage:loadTexture(tVal.Image, 1)
    end
    if tVal.Name then
        kImage:setName(tVal.Name)
    end
    return kImage
end
-----------------------------------------------------------------------------------
-- Physical
Physical = {}
function Physical:Move()
    local kClass = {S = 0, V = 0, A = 0, T = 0, V2 = nil, S2 = nil}
    function kClass:Update(fDelta)
        local S0, V0 = self.S, self.V
        self.T = self.T + fDelta
        self.V = self.V + self.A * fDelta
        if self.V2 and ((V0 < self.V2 and self.V > self.V2) or (V0 > self.V2 and self.V < self.V2)) then
            self.V = self.V2
            self.A = 0
        end
        self.S = self.S + (self.V + V0) * fDelta / 2
        if self.S2 and ((S0 < self.S2 and self.S > self.S2) or (S0 > self.S2 and self.S < self.S2)) then
            self.S = self.S2
            self:Stop()
        end
    end
    function kClass:Stop()
        self.A = 0
        self.V = 0
        self.V2 = nil
    end
    return kClass
end
-----------------------------------------------------------------------------------
-- Audio
Audio = {}
function Audio:Music(kPath, bLoop)
    if kPath then
        cc.SimpleAudioEngine:getInstance():playMusic(kPath, ToBool(bLoop))
    else
        cc.SimpleAudioEngine:getInstance():stopMusic()
    end
end

function Audio:Effect(kPath)
    cc.SimpleAudioEngine:getInstance():playEffect(kPath)
end
-----------------------------------------------------------------------------------
-- Motion
Motion = Class({tMotion = {}}, "Motion")
Motion.tAction = { PosX = "setPositionX", PosY = "setPositionY", Alpha = "setOpacity", 
    Scale = "setScale", SkewX = "setSkewX", SkewY = "setSkewY"}
function Motion:Add(tVal)
    assert(tVal and tVal.kType and tVal.kNode and tVal.fTime ~= 0, "Motion:Add error, no kNode or no kType or fTime is 0")
    local tTemp = {kNode = nil, kName = "", kType = nil, fFrom = 0.0, fTo = 0.0, fTime = 1.0, fDelay = 0.0, iRepeat = 1, bLoop = false, kCallBack = nil}
    local kClass = {t = SimpleUpgrade(tTemp, tVal), kMove = Physical:Move(), fDelay = 0.0, kParent = self}
    function kClass:Load()
        local t = self.t
        local kMove = self.kMove
        local tMotion = self.kParent.tMotion
        kMove.S = t.fFrom
        t.fV = (t.fTo - t.fFrom) / t.fTime
        kMove.V = t.fV
        kMove.S2 = t.fTo
        self.bRevert = false
        tMotion[t.kNode] = tMotion[t.kNode] or {}
        tMotion[t.kNode][t.kType] = self
        self:Update(0, {Init = true})
    end
    function kClass:Set(fVal)
        local kType = self.t.kType
        local kNode = self.t.kNode
        if kType == "Alpha" then
            kNode:setOpacity(math.floor(fVal * 255))
            kNode:setVisible(fVal > 0)
        elseif kType == "Scale" then
            kNode:setScale(fVal, fVal)
        else
            local kFunc = Motion.tAction[kType]
            if kFunc then
                kNode[kFunc](kNode, fVal)
            end
        end
    end
    function kClass:Update(fDelta, tVal)
        tVal = tVal or {}
        local t = self.t
        if tVal.Init then
        else
            if self.t.fDelay > self.fDelay then
                self.fDelay = self.fDelay + fDelta
                if self.t.fDelay > self.fDelay then
                    return
                end
            end
        end

        local kMove = self.kMove
        kMove:Update(fDelta)
        self:Set(self.kMove.S)      

        if kMove.S2 == kMove.S then
            if t.iRepeat > 0 then
                t.iRepeat = t.iRepeat - 1
            end
            if t.iRepeat == 0 then
                if t.kCallBack then
                    t.kCallBack()
                end
                self:Unload()
            else
                if t.bLoop then
                    self.bRevert = not self.bRevert
                    kMove.V =  self.bRevert and -self.t.fV or self.t.fV
                    kMove.S2 = self.bRevert and t.fFrom or t.fTo
                else
                    kMove.S = t.fFrom
                    kMove.V = self.t.fV
                end
            end
        end
    end
    function kClass:Unload()
        local t = self.t
        local tTemp = self.kParent.tMotion[t.kNode]
        tTemp[t.kType] = nil
        if Table:Empty(tTemp) then
            self.kParent.tMotion[t.kNode] = nil
        end
    end
    kClass:Load()
end
function Motion:__Get(tVal)    
    local tMotion = self.tMotion
    local tTemp = tMotion[tVal.kNode]
    return tTemp and tTemp[tVal.kType]
end
function Motion:Has(tVal)  
    assert(tVal and tVal.kType and tVal.kNode, "Motion:Has error, no kNode or no kType")  
    if self:__Get(tVal) then
        return true
    end
end
function Motion:Del(tVal)
    assert(tVal and tVal.kType and tVal.kNode, "Motion:Del error, no kNode or no kType")
    local k = self:__Get(tVal)
    if k then
        k:Unload()
    end
end
function Motion:Update(fDelta)
    for k,v in pairs(self.tMotion) do
        for _,v2 in pairs(v) do
            v2:Update(fDelta)
        end
    end
end
-----------------------------------------------------------------------------------
-- Box
Box = Class({},"Box")
function Box:__Load()
    self.t = {}
    if self.Load then
        self:Load()
    end
end
function Box:__Unload()
    self.t = nil
    if self.Unload then
        self:Unload()
    end
end
-----------------------------------------------------------------------------------
-- BoxMgr
BoxMgr = Class({}, "BoxMgr")
function BoxMgr:Create(tVal)
    tVal = tVal or {}
    local kClass = self:__New()
    if tVal.Timer then
        self.Timer = true
    end
    return kClass
end

function BoxMgr:Init(kParent)
    assert(kParent)
    if self.__bInit then
        return
    end
    self.__bInit = true
    self.kParent = kParent
    self.__Load = self.Load
    self.__Unload = self.Unload
    self.Load = function (kClass, ...)
        self.__bLoad = true
        if self.Timer then
            self.Timer = Timer:Create(self)
            self.Timer:Load()
        end
        for k,v in pairs(kClass.kParent) do
            if CC.IsClass(v, "Box") then
                v:__Load()
            end
        end
        if kClass.__Load then
            kClass:__Load(...)
        end
    end
    self.Unload = function (kClass, ...)
        if self.__bLoad then
            self.__bLoad = nil
            if kClass.__Unload then
                kClass:__Unload(...)
            end
            for k,v in pairs(kClass.kParent) do
                if CC.IsClass(v, "Box") then
                    v:__Unload()
                end
            end
            if self.Timer then
                self.Timer:Unload()
            end
        end
    end
end
-----------------------------------------------------------------------------------
-- List
List = Class({tData = {}}, "List")
function List:Add(tVal)
    table.insert(self.tData, tVal)
end

function List:Count()
    return #self.tData
end

function List:At(iVal)
    return self.tData[i]
end
