local enum = require("koko.enum")
local config = require("config")
local entryCache = require("koko.data").entryCache
local CC = require("comm.CC")
local LoginMgr = require("LoginMgr")
local UIServerSelect = require("koko.ui.login.UIServerSelect").UIServerSelect
local cls = class("kkLogin", kk.view)

function cls:ctor()
    self:setCsbPath("koko/ui/login/login.csb")
    self.loginUid = ""
end

function cls:setServer(tVal)
    _G.ccerr(" ---- >" .. tVal.Name)
    _G.kk.xml.setString("serverName", tVal.Name)
    self:getNode():findChild("panel/addressTxt"):setString(tVal.Name .. ":" .. tVal.IP)
end

function cls:onInit(node)
    --清空缓存
    entryCache:logout()

    local panel = node:findChild("panel")
    --注册按钮事件
    panel:findChild("btnClose"):onClick(handler(self, self.onBtnCloseClicked))
    panel:findChild("btnCustom"):onClick(handler(self, self.onBtnCustomClicked))
    panel:findChild("btnRegister"):onClick(handler(self, self.onBtnRegisterClicked))
    panel:findChild("btnAccLogin"):onClick(handler(self, self.onBtnAccLoginClicked))
    --panel:findChild("btnKOKO"):onClick(handler(self, self.onBtnKOKOClicked))
    local kNodeServerSelect = panel:findChild("btServerSelect")
    local kAddressTxt = panel:findChild("addressTxt")
    if _G.CCTest then
        -- 从缓存中获取上一次选的服务器地址
        local addressName = _G.kk.xml.getString("serverName")
        local kArray = CC.Excel.ServerList.Name[addressName]
        local addressTable = nil
        if kArray and kArray:Count() > 0 then
            addressTable = kArray:At(1)
        end
        if not addressTable then
            addressTable = CC.Excel.ServerList[1]
        end

        CC.Config.WORLDADDR = addressTable.IP
        CC.Config.WORLDPORT = addressTable.Port
        CC.Config.webUrl = addressTable.Web    
        CC.Config.webHost = addressTable.Web.."app/"

        kAddressTxt:setText(addressTable.Name .. ":" .. addressTable.IP)
        kNodeServerSelect:onClick(handler(self, self.OnClickServerSelect))
    else
        kNodeServerSelect:hide()
        kAddressTxt:hide()
    end

    local sptAcc = panel:findChild("sptAcc")
    sptAcc:findChild("btnSwitchAcc"):onClick(handler(self, self.onBtnSwitchAccClicked), 1.06)
    sptAcc:findChild("accLayout"):onClick(handler(self, self.onBtnAccLoginClicked))
    local layout = panel:findChild("layout")
    layout:findChild("btnQQ"):onClick(handler(self, self.onBtnQQClicked))

    layout:findChild("btnBegin"):onClick(handler(self, self.onBtnBeginClicked))
    layout:findChild("btnWeChat"):onClick(handler(self, self.onBtnWeChatClicked))

    panel:findChild("backLayer/Text_1"):getVirtualRenderer():setLineSpacing(2)
    panel:findChild("txtVerson"):setString("版本号：" .. config.version)
    -----------------------------------------------------------------------------------
    if platform_isios() then
        panel:findChild("btnClose"):setVisible(false)
        panel:findChild("btnCustom"):setPositionX(1186)
        panel:findChild("btnAccLogin"):setPositionX(1076)
        panel:findChild("btnRegister"):setPositionX(963)
    end
    layout:findChild("btnQQ"):setVisible(not platform_iswin32())
    layout:findChild("btnWeChat"):setVisible(not platform_iswin32())

    --读配置 有账号显示 无显示默认
    local entry = entryCache:getDataTable()
    self:setLoginEntry(entry and #entry ~= 0 and entry[1].uid or nil)

    CC.PlayerMgr.Lobby:Load()
    -----------------------------------------------------------------------------------
    if CC.LoginMgr.getLoginMgrPLATFORM() == "koko" then
        -- 骨骼动画 spine
        local skeleton = sp.SkeletonAnimation:createWithJsonFile("koko/spines/heguan.json", "koko/spines/heguan.atlas", 1)
        skeleton:setAnimation(0, "stand", true)
        panel:findChild("spineAnim"):addChild(skeleton)

        --[[
        --龙骨动画 dragonBones
        local factory = db.CCFactory:getFactory()
        --这里第二个参数是文件名_ske前面的部分
        factory:loadDragonBonesData("koko/spines/heguan_ske.json", "heguan")
        factory:loadTextureAtlasData("koko/spines/heguan_tex.json")
        --这里第一个参数是龙骨软件中指定的骨架数据名称，需对应上
        local node = factory:buildArmatureDisplay("armatureName", "heguan")
        node:getAnimation():play("stand", 0)
        panel:findChild("spineAnim"):addChild(node)
        ]]
    end
    --panel:setTexture("koko/bg1.jpg")
    -- 测试模式下自动登录
    if CCDebug and (CCDebug.AutoLogin) then
        self:onBtnBeginClicked()
    end

    -- q版本
    local loginData = CC.LoginMgr.tData
    if loginData.isAutologin then
        if loginData.APPKEY and loginData.UID then
            CC.LoginMgr.AppkeyUidLogin(loginData.APPKEY, loginData.UID)
        elseif loginData.USERNAME and loginData.PASSWORD then
            CC.LoginMgr.Accountlogin(loginData.USERNAME, loginData.PASSWORD)
        end
    else
        CC.LoginMgr.CheckAccountFromLocalFile()
    end
    if CC.Version and CC.Version.Gov then
        self:CCVersion()
    end
end

function cls:isInstalledThirdPlatform()
    if type(is_installed_third_platform) == "function" then
        return is_installed_third_platform()
    end
    return true
end

function cls:onBtnCloseClicked(sender)
    local function exit_func(is_ok)
         if is_ok then
            CC.Event("Program", {Exit = true})
        end
    end
    kk.msgbox.showOkCancel("确定退出游戏吗？", exit_func)
end

--客服
function cls:onBtnCustomClicked(sender)
    kk.uimgr.load("koko.ui.lobby.ui_customer_service")
end

--注册
function cls:onBtnRegisterClicked(sender)
    kk.uimgr.load("koko.ui.login.ui_create_account")
end

--切换账号
function cls:onBtnSwitchAccClicked(sender)
    kk.uimgr.load("koko.ui.login.ui_switch_account")
end

--QQ
function cls:onBtnQQClicked(sender)
    LoginMgr.ThirdLogin(2)
end

--微信
function cls:onBtnWeChatClicked(sender)
    LoginMgr.ThirdLogin(1)
end
--登录
function cls:onBtnBeginClicked(sender)
    local entry = nil
    if self.loginUid and self.loginUid ~= "" then
        entry = entryCache:getEntryByUid(self.loginUid)
    end

    if not entry then
        --登录信息不存在， 直接弹出登录面板
        self:flipLoginPanel()
        return
    end
    if entry.type == enum.Entry.Device then
        --设备登录
        LoginMgr.DdeviceLogin(entry.value)
    elseif entry.type == enum.Entry.Account then
        local t = string.split(entry.value, "|")
        LoginMgr.Accountlogin(t[1], t[2])
    end
end

function cls:OnLoginProgress(rate)
    CC.LoginMgr.setProgressRate(rate)
end

--账号登录
function cls:onBtnAccLoginClicked(sender)
    self:flipLoginPanel()
end

--官方专区
function cls:onBtnKOKOClicked(sender)
    callweb("http://www.koko.com")
end

--弹出登录界面
function cls:flipLoginPanel()
    kk.uimgr.load("koko.ui.login.ui_acc_login")
end

--设置登录入口框中的账号
function cls:setLoginEntry(uid)
    local node = self:getNode()
    if not node then return end
    local txtAcc = node:findChild("panel/sptAcc/txtAcc")
    if uid == nil or uid == "" then
        txtAcc:setString("请输入账号")
        return
    end
    local entry = entryCache:getEntryByUid(uid)
    if entry then
        txtAcc:setString(entry.name)
        self.loginUid = uid
    end
end

--设置版本号
function cls:setTxtVersion()
    local panel = self:getNode():findChild("panel")
    panel:findChild("txtVersion"):setString(config.Version)
end

function cls:CCVersion()
    local panel = self:getNode():findChild("panel")
    panel:findChild("layout/btnQQ"):setVisible(false)
    panel:findChild("layout/btnWeChat"):setVisible(false)
    panel:findChild("btnCustom"):setVisible(false)
    panel:findChild("btnRegister"):setPosition(panel:findChild("btnAccLogin"):getPosition())
    panel:findChild("btnAccLogin"):setPosition(panel:findChild("btnCustom"):getPosition())
    panel:findChild("btnKOKO"):setVisible(false)
end

function cls:OnClickServerSelect()
    CC.UIMgr:Load(UIServerSelect)
end
return cls
