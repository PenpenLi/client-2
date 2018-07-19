local CC = require("comm.CC")
local cls = _G.class("kkErrorLog", kk.view)

function cls:ctor(strUI, strWeb)
    self:setCsbPath("koko/ui/common/err_log.csb")
    self:setAnimation(kk.animScale:create())
    self:setZOrder(999)
    self.strUI = strUI
    self.strWeb = strWeb
end

function cls:onInit(node)
    node:setName("errlog")
    local panel = node:findChild("panel")
    panel:findChild("panel1"):setVisible(false)
    panel:findChild("panel2"):setVisible(true)
    panel:findChild("close"):onClick(mkfunc(kk.uimgr.unload, self))
    panel:findChild("panel1/btnBack"):onClick(_G.handler(self, self.onBack), 1.03)
    panel:findChild("panel2/detail"):onClick(_G.handler(self, self.onDetail), 1.03)
    panel:findChild("panel2/confirm"):onClick(_G.handler(self, self.onSendLog), 1.03, nil, nil, nil, 30)
    local sv = panel:findChild("panel1/scrollView")
    sv:setScrollBarEnabled(false)

    --文本大小适配
    local textNode = sv:findChild("text")
    local width = textNode:getContentSize().width
    textNode:ignoreContentAdaptWithSize(true)
    textNode:setTextAreaSize(_G.cc.size(width, 0))
    textNode:setString(self.strUI)
    local height = textNode:getAutoRenderSize().height
    textNode:ignoreContentAdaptWithSize(false)
    textNode:setContentSize(_G.cc.size(width, height))

    local sz = sv:getInnerContainerSize()
    sz.height = _G.math.max(sv:getContentSize().height, height) - 10
    sv:setInnerContainerSize(sz)
    textNode:setPositionY(sz.height - 5)
    sv:jumpToBottom()

    local platstr = "IOS"
    if _G.platform_iswin32() then
        platstr = "WIN32"
    elseif _G.platform_isandroid() then
        platstr = "ANDROID"
    end
    platstr = platstr .. string.format("__%s", CC.Player.uid)
    panel:findChild("panel2/platInfo"):setString(platstr)
    local timestr = _G.os.date("%Y-%m-%d-%H:%M:%S", _G.os.time())
    panel:findChild("panel2/time"):setString(timestr)

    --主动发送错误报告
    local errType = 3
    local uid = CC.Player.uid
    local gameStr = "platform"
    local gameId = CC.GameMgr.Scene.iGame
    if gameId then
        local tbl = CC.Excel.GameList[gameId]
        if tbl then
            gameStr = tbl.LocalDir
        end
    end
    kk.util.sendErrorReport(errType, uid, gameStr, self.strWeb, "执行时遇到脚本报错")
end

function cls:onBack()
    self:getNode():findChild("panel/panel1"):setVisible(false)
    self:getNode():findChild("panel/panel2"):setVisible(true)
end
function cls:onDetail()
    self:getNode():findChild("panel/panel1"):setVisible(true)
    self:getNode():findChild("panel/panel2"):setVisible(false)
end
function cls:onSendLog()
    _G.upload_game_log("koko游戏", "来宾655400", function(result)
        -- if result == 1 then
        --     _G.kk.msgup.show("发送成功")
        -- else
        --     _G.kk.msgup.show("发送失败")
        -- end
    end)

    --屏蔽真实的发送错误报告按钮的功能，改为界面打开立即发送
    kk.uimgr.unload(self)
    kk.timer.delayOnce(0.4, function()
        _G.kk.msgup.show("错误信息已发送完成！")
    end)
end

return cls
