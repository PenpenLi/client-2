
local _G = _G
local CC = require "comm.CC"
module "koko.ui.login.UIWebView"

UIWebView = CC.UI:Create{
    Path = "koko/ui/login/webView.csb",
    Key = "UIWebView",
}

function UIWebView:Load()
    C("close"):Close()
    if _G.platform_iswin32() then
        CC.UIMgr:Unload(self)
    end
    C("btnBack"):Click("onBtnBack")
    C("btnReload"):Click("onBtnReload")
end

function UIWebView:Refresh()
    if self.t.WebUrl then
        local webNode = _G.ccexp.WebView:create()
        C("panel"):Node():addChild(webNode)
        webNode:setScalesPageToFit(true)
        webNode:loadURL(self.t.WebUrl)
        webNode:setPosition(C("tmp"):Node():getPosition())
        webNode:setContentSize(C("tmp"):Node():getContentSize())
        self.t.webNode = webNode
    end
end

function UIWebView:Call(tVal)
    if tVal and tVal.WebUrl then
        self.t.WebUrl = tVal.WebUrl
        self:Refresh()
    end
end

function UIWebView:onBtnBack()
    local node = self.t.webNode
    if node then
        if node:canGoBack() then
             node:goBack()
        end
    end
end

function UIWebView:onBtnReload()
    local node = self.t.webNode
    if node then
        node:reload()
    end
end