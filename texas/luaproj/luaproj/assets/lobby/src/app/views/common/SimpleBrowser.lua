local UIHelper = require("app.common.UIHelper")

local SimpleBrowser = class("SimpleBrowser", cc.mvc.ViewBase)

function SimpleBrowser:ctor(options)
	SimpleBrowser.super.ctor(self)

    self.loadedUrl = ""

    local csbnode = cc.CSLoader:createNode("cocostudio/common/BrowserLayer.csb")
    csbnode:addTo(self)

    self.btn_Back = UIHelper.seekNodeByName(csbnode, "Button_Back")
    self.btn_Back:addTouchEventListener(function(ref, t)
        if t == ccui.TouchEventType.ended then
            if self.webview then
                self.webview:goBack()
            end
        end
    end)
    self.btn_Back:setTouchEnabled(false)
    self.btn_Back:setEnabled(false)

    self.btn_Front = UIHelper.seekNodeByName(csbnode, "Button_Front")
    self.btn_Front:addTouchEventListener(function(ref, t)
        if t == ccui.TouchEventType.ended then
            if self.webview then
                self.webview:goForward()
            end
        end
    end)
    self.btn_Front:setTouchEnabled(false)
    self.btn_Front:setEnabled(false)

    self.btn_Refresh = UIHelper.seekNodeByName(csbnode, "Button_Refresh")
    self.btn_Refresh:addTouchEventListener(function(ref, t)
        if t == ccui.TouchEventType.ended then
            if self.webview then
                self.webview:reload()
            end
        end
    end)

    self.btn_ReturnGame = UIHelper.seekNodeByName(csbnode, "Button_ReturnGame")
    self.btn_ReturnGame:addTouchEventListener(function(ref, t)
        if t == ccui.TouchEventType.ended then
            self:removeSelf()
        end
    end)

    local function onDidFinishLoading(webview, url)
        print("onDidFinishLoading:" .. tostring(url))
        if self.loadedUrl == url then
            return
        end
        self.loadedUrl = url
        self:checkStatus()
    end

    local function onDisFailLoading(webview, url)
        print("onDisFailLoading:" .. tostring(url))
    end
	local container = UIHelper.seekNodeByName(container);
    if device.platform == "ios" or device.platform == "android" then
	    self.webview = ccexp.WebView:create()
        self.webview:align(container.CENTER, container.width / 2, container.height / 2)
        self.webview:setContentSize(container:contentSize())
        self.webview:setScalesPageToFit(true)
        self.webview:loadURL(options.url)
        self.webview:addTo(container)

        self.webview:setOnDidFinishLoading(onDidFinishLoading)
        self.webview:setOnDidFailLoading(onDisFailLoading)
    end
end

function SimpleBrowser:onEnter()
	SimpleBrowser.super.onEnter(self)
end

function SimpleBrowser:onExit()
	SimpleBrowser.super.onExit(self)
end

function SimpleBrowser:checkStatus()
    if self.webview then
        if self.webview:canGoBack() then
            self.btn_Back:setTouchEnabled(true)
            self.btn_Back:setEnabled(true)
        else
            self.btn_Back:setTouchEnabled(false)
            self.btn_Back:setEnabled(false)
        end
        if self.webview:canGoForward() then
            self.btn_Front:setTouchEnabled(true)
            self.btn_Front:setEnabled(true)
        else
            self.btn_Front:setTouchEnabled(false)
            self.btn_Front:setEnabled(false)
        end
    end
end

return SimpleBrowser