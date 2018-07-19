local _G = _G
local CC = require "comm.CC"
module ("comm.Sample")
-----------------------------------------------------------------------------------
-- 例子
Edit = CC.Class({kNode = nil, txInfo = "请输入"}, "Edit")
function Edit:Create(tVal) -- {Node = X, Info = , Password =, Any =, Size = , Color = , TipColor =}
    local kClass = self:__New()
    local kNode = tVal.Node
    kClass.txInfo = tVal.Info or kClass.txInfo
    local kFunc = (tVal.Any and "createAnyWithParent") or (tVal.Password and "createPasswordWithParent") or "createNumberWithParent"
    kClass.kNode = _G.kk.edit[kFunc](kNode, "eText", kClass.txInfo, tVal.Size)
    if tVal.Color then
        kClass.kNode:setFontColor(tVal.Color)
    end
    if tVal.TipColor then
        kClass.kNode:setPlaceholderFontColor(tVal.TipColor)
    end
    return kClass
end
function Edit:Text(kText)
    if kText then
        kText = _G.tostring(kText)
        if self.kNode:getText() ~= kText then
		  self.kNode:setText(kText)
        end
	else
    	return self.kNode:getText()
    end
end
function Edit:CallBack(kFunc)
    self.kNode:registerScriptEditBoxHandler(kFunc)
end
EditMax = {}
EditEx = {}

Check = {}
function Check:KB(iVal, bMsg)
    if CC.Player.gold >= iVal then
        return true
    end
    if bMsg then
        function LF_CallBack(bOK)
            if bOK and not _G.kk.uimgr.get("kkRecharge") then
                Recharge:KB()
            end
        end
        CC.Message{Text = "K豆不足，是否购买K豆？", Cancel = true, CallBack = LF_CallBack}
    end
end
function Check:Diamond(iVal, bMsg)
    if CC.Player.diamond >= iVal then
        return true
    end
    if bMsg then
        function LF_CallBack(bOK)
            if bOK and not _G.kk.uimgr.get("kkRecharge") then
                Recharge:Diamond()
            end
        end
        CC.Message{Text = "钻石不足，是否购买钻石？", Cancel = true, CallBack = LF_CallBack}
    end
end
function Check:Ticket(iVal, bMsg)
    if _G.tonumber(CC.Player.ticket) >= _G.tonumber(iVal) then
        return true
    end
    if bMsg then
        _G.kk.msgup.show("奖券不足!")
        return false
    end
end
function Check:VIP(iVal, bMsg)
    if CC.Player.vipLevel >= iVal then
        return true
    end
    if bMsg then
        CC.Message{Text = "VIP等级未到"..iVal.."级"}
    end
end
function Check:Item(kItem, bMsg)
    local kRt = false
    if CC.IsClass(kItem, "Item") then
        if kItem.iID == 0 then
            return self:Diamond(kItem.iNum, bMsg)
        elseif kItem.iID == 1 then
            return self:KB(kItem.iNum, bMsg)
        end
    end
    kRt = CC.ItemMgr.Manager:Check(kItem)
    if bMsg and not kRt then
        CC.Message{Text = kItem:Excel().Name.."不足"}
    end
    return kRt
end

Recharge = {}
function Recharge:Diamond()
    _G.kk.uimgr.load("koko.ui.lobby.ui_recharge")
    _G.kk.uimgr.call("kkRecharge", "showPage", 1)
end

function Recharge:KB(tVal)
    if _G.CCVersion and _G.CCVersion.Gov then
        _G.kk.uimgr.load("koko.ui.lobby.ui_recharge")
        _G.kk.uimgr.call("kkRecharge", "showPage", 1)
        return
    end
    local shop = _G.kk.uimgr.load("koko.ui.lobby.ui_shop", "")
    _G.kk.uimgr.call(shop, "showPage", 1)
    if tVal and tVal.HideBar then
        _G.kk.uimgr.call(shop, "HideBar", false)
    end
end

function Recharge:Ticket()
    local shop = _G.kk.uimgr.load("koko.ui.lobby.ui_shop", "")
    _G.kk.uimgr.call(shop, "showPage", 3)
end