
local _G = _G
local CC = require "comm.CC"
module "koko.ui.login.UIServerSelect"

UIServerSelect = CC.UI:Create{
    Path = "koko/ui/login/server_select.csb",
    Key = "UIServerSelect",
}

function UIServerSelect:Load()
    C("btClose"):Close()
end

function UIServerSelect:Refresh()
    if true then
        local tExcel = CC.Excel.ServerList
        C("btServer1"):Array{Y = tExcel:Count()}
        for i=1,tExcel:Count() do
            local kExcel = tExcel[i]
            local kC = C("btServer"..i)
            kC:C("txInfo"):Text(kExcel.Name.."  "..kExcel.IP)
            kC:Param(i):Click("OnClickServer")
        end
        C("rScroll"):Scroll():Fix()
    end

    if true then
        local tExcel = CC.Excel.Hacker
        C("btAction1"):Array{Y = tExcel:Count()}
        for i=1,tExcel:Count() do
            local kExcel = tExcel[i]
            local kC = C("btAction"..i)
            kC:C("txInfo"):Text(kExcel.Name)
            kC:Param(i):Click("OnClickAction")
        end
        C("rScroll"):Scroll():Fix()
    end

end

function UIServerSelect:OnClickServer(kNode)
    local kExcel = CC.Excel.ServerList[C(kNode):Param()]
    CC.Config.WORLDADDR = kExcel.IP
    CC.Config.WORLDPORT = kExcel.Port
    CC.Config.webUrl = kExcel.Web    
    CC.Config.webHost = kExcel.Web.."app/"
    CC.Message{Tip = "已经切换到【"..kExcel.Name.."】"}
    _G.kk.uimgr.call("kkLogin", "setServer", {SetServer = true, Name = kExcel.Name,IP = kExcel.IP})
    CC.UIMgr:Unload(self)
end

function UIServerSelect:OnClickAction(kNode)
    local kExcel = CC.Excel.Hacker[C(kNode):Param()]
    CC.Debug = CC.Debug or {}
    _G.CCDebug = CC.Debug
    CC.Debug[kExcel.Key] = kExcel.Value
    CC.Message{Tip = "已执行命令【"..kExcel.Name.."】"}    
end