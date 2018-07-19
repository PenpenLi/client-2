local data = require("koko.data")
local CC = require "comm.CC"
local WelcomeManager = require("koko.ui.lobby.UIWelcome").WelcomeManager

local _CHANGEACCOUNT = 1
local _CHANGENICKNAME = 2
local _acc = nil
local _accIsok = false
local _nickname = nil
local _nicknameIsok = false

local ctrl = class("kkPlayerInfoChange", kk.view)
--page_type = 1  修改用户名  page_type 2 修改用户名
function ctrl:ctor(page_type)
    self.page_type = page_type
    self:setCsbPath("koko/ui/lobby/player_info_change.csb")
end

function ctrl:onInit(node)
    local panel = node:findChild("panel")
    self:switchPage()
    panel:findChild("panelAccount/btnConfirm"):onClick(handler(self, self.onBtnConfirmHandler))
    panel:findChild("panelNickName/btnChange"):onClick(handler(self, self.onBtnChangeHandler))
end

function ctrl:setTitle()
    local node = self:getNode()
    local title = node:findChild("panel/title")
    local sptPath = "koko/atlas/all_common/title/6001.png"
    if self.page_type == _CHANGENICKNAME then
        sptPath = "koko/atlas/all_common/title/txNickName.png"
    end
    title:setSpriteFrame(sptPath)
end

function ctrl:switchPage()
    local panel = self:getNode():findChild("panel")
    local panelAccount = panel:findChild("panelAccount")
    local panelNickName = panel:findChild("panelNickName")
    self:setTitle()
    if self.page_type == _CHANGEACCOUNT then
        panelAccount:setVisible(true)
        panelNickName:setVisible(false)
        self:_initPageAccount()
    elseif self.page_type == _CHANGENICKNAME then
        panelNickName:setVisible(true)
        panelAccount:setVisible(false)
        self:_initPageNickname()
    end
end

function ctrl:_initPageAccount()
    local panelAccount = self:getNode():findChild("panel/panelAccount")
    local sptAcc = panelAccount:findChild("panelAcc/sptAcc")
    local sptPwd = panelAccount:findChild("panelPwd/sptPwd")
    local editAcc = kk.edit.createAnyWithParent(sptAcc, "editAcc", "请输入用户名", 20)
    editAcc:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editAccHandle(eventname,sender) 
    end)
end

function ctrl:_initPageNickname()
    local panelNickName = self:getNode():findChild("panel/panelNickName")
    local sptNickName = panelNickName:findChild("panelNickName/sptNickName")
    editNickName = kk.edit.createAnyWithParent(sptNickName, "editNickName", "请输入昵称", 20)
    editNickName:registerScriptEditBoxHandler(function(eventname,sender) 
        self:editNickNameHandle(eventname,sender) 
    end)
end

function ctrl:editAccHandle(eventname, sender)
    if eventname == "ended" then
        local panelAcc =self:getNode():findChild("panel/panelAccount/panelAcc")
        local text = panelAcc:findChild("sptAcc/editAcc"):getText()
        local errnode = panelAcc:findChild("ico")
        if text == "" then
            self:refreshErrnode(errnode, false)
            kk.msgup.show("请输入账号")
            return 
        end
        local isOk,err = CC.Check:Account(text)
        if not isOk then
            kk.msgup.show("账号不符合要求，请输入6-12位字母加数字")
            self:refreshErrnode(errnode, isOk)
            return
        end
        if isOk then
            _acc = text
            _accIsok = isOk
            self:refreshErrnode(errnode, isOk)
        end
    end
end

function ctrl:editNickNameHandle(eventname, sender)
    if eventname == "ended" then
        local panelNickName =self:getNode():findChild("panel/panelNickName/panelNickName")
        local text = panelNickName:findChild("sptNickName/editNickName"):getText()
        local errnode = panelNickName:findChild("ico")
        if text == "" then
            self:refreshErrnode(errnode, false)
            kk.msgup.show("请输入昵称")
            return 
        end
        local isOk,err = CC.Check:Name(text)
        if not isOk then
            kk.msgup.show("您的昵称不符合要求")
            self:refreshErrnode(errnode, isOk)
            return
        end
        if isOk then
            _nicknameIsok = isOk
            _nickname = text
            self:refreshErrnode(errnode, isOk)
        end
    end
end

function ctrl:refreshErrnode(errnode, isOk)
    local sptPath = "koko/atlas/login/2003.png"
    if isOk then
       sptPath = "koko/atlas/login/2004.png"
    end
    errnode:setSpriteFrame(sptPath)
    errnode:setVisible(true)
end

function ctrl:onBtnConfirmHandler(sender)
    if not _acc then
        kk.msgup.show("请输入用户名")
        return
    end
    if not _accIsok then
        kk.msgup.show("您输入的用户名不符合格式")
        return
    end
    web.sendModifyUnameReq(CC.Player.uid, CC.Player.appKey, _acc, CC.Player.pwd, function(t)
        if t.success then
            CC.Data.entryCache:setCurrentWithUpgradeAccount(_acc, CC.Player.pwd)
            local function checkNickNameRep(t)
                if not t.success and t.status and t.status == 26 then
                    self.page_type = _CHANGENICKNAME
                    self:switchPage()
                else
                    WelcomeManager:TryLoad()
                    kk.uimgr.unload(self)
                end
            end
            web.sendCheckNickNameReq(CC.Player.uid, CC.Player.appKey, CC.Player.nickName, "昵称", checkNickNameRep)
        else
            kk.msgup.show(t.message)
        end
    end)

end

function ctrl:onBtnChangeHandler(sender)
    if not _nickname then
        kk.msgup.show("请输入昵称")
        return
    end
    if not _nicknameIsok then
        kk.msgup.show("您的昵称不符合要求")
        return
    end
    
    web.sendSetNickName(CC.Player.uid, CC.Player.appKey, _nickname,CC.Player.gender, function(t)
        if t.success then
            WelcomeManager:TryLoad()
            CC.Player:setPlayerselfInfo(t.data.result)
            CC.Data.entryCache:setCurrentNickName(t.data.result.nickname)
            kk.uimgr.unload(self)
        else
            kk.msgup.show(t.message)
        end
    end)
end

return ctrl