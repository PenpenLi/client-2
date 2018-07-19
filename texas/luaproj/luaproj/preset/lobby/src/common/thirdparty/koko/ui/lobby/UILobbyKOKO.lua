-----------------------------------------------------------------------------------
-- 大厅Koko  2017.12
-- By monkey256
-----------------------------------------------------------------------------------
local _G = _G
local kk = kk
local CC = require "comm.CC"
local cc = cc
local ccui = ccui
local handler = handler
local pairs = pairs
local data = require("koko.data")
local proto2 = require("koko.proto2")
local enterGameRecord = require("koko.data.enter_game_record")
local LT_Param = {iGamePage = 0, iTotalPage = 1} --当前游戏页签   iTotalPage 1 - n
local UIInvite = require("koko.ui.lobby.UIInvite").UIInvite
local UIReconnect = require "koko.ui.login.UIReconnect".UIReconnect

module "koko.ui.lobby.UILobbyKOKO"
UILobbyKOKO = CC.UI:Create{
    Path = "koko/ui/lobby/lobby_koko.csb", 
    Key = "UILobbyKOKO", 
    Animation = false,
}

function UILobbyKOKO:Load()
    --重连开始事件监听
    _G.kk.event.addListener(self.kNode, _G.E.EVENTS.coordinate_reconnect_begin, function()
        CC.UIMgr:Load(UIReconnect)
    end)

    --进入游戏事件监听
    _G.kk.event.addListener(self.kNode, _G.E.EVENTS.lobby_enter_game, handler(self, self.startGameWithDownload))

    --isReconnecting?
    if data.ReconnectMgr.isReconnecting() then
        CC.UIMgr:Load(UIReconnect)
    end

    --scroll message
    _G.chat:setScrollMsgWidth(500)
    _G.chat:setScrollMsgPosition(640, 600)
    _G.chat:setScrollMsgZOrder(0)
    _G.chat:createScrollMsg()
    _G.chat:showScrollMsg()
    self:addChatMesssageForUI()

    --左右翻页按钮
    C("btnLeft"):Click("OnBtnLeftClicked")
    C("btnRight"):Click("OnBtnRightClicked")

    self.t.tGameList = {}
    self.t.iCount = 0
    self:_initGamePage()
    
    CC.PlayerMgr.Lobby:SyncGamePeople()
    self.kNode:findChild("panel"):schedule(function() CC.PlayerMgr.Lobby:SyncGamePeople() end, 300, "TimerGamePeople")
    
    C("btInviteLink"):Click("OnClickInviteLink")
    -- local path = "koko/atlas/lobby/2003.png"
    -- C("img"):Image(kk.util.isExitPathOnPlist(path) and path or "koko/atlas/lobby/1017.png")
end

function UILobbyKOKO:Unload()
    --destroy message
    _G.chat:destroyScrollMsg()
    _G.chat:destroyChatMsg()
end

function UILobbyKOKO:_initGamePage()
    local pv = self.kNode:findChild("panel/panel1/pageView")
    local sz = pv:getContentSize()
    local layout = ccui.Layout:create()
    layout:setContentSize(sz)
    layout:setName("layPage0")

    local tlist = CC.Excel.GameList
    for i = 1, tlist:Count() do
        local tt = tlist:At(i)
        if tt.Visible then
            _G.table.insert(self.t.tGameList, {ID = tt.ID, Value = tt})
        end    
    end
    _G.table.sort(self.t.tGameList, function(a, b)
        local a_v = a.Value
        local b_v = b.Value
        if a_v.GamePage ~= b_v.GamePage then
            return a_v.GamePage < b_v.GamePage
        end
        return a_v.GameIndex < b_v.GameIndex
    end)
    self.t.iCount = #self.t.tGameList
    local pageIdx = 0
    for i = 1, self.t.iCount do
        local gameInfoTbl =  self.t.tGameList[i].Value
        if pageIdx ~= gameInfoTbl.GamePage then
            pageIdx = gameInfoTbl.GamePage
            LT_Param.iTotalPage = pageIdx + 1
            pv:addPage(layout)
            layout = ccui.Layout:create()
            layout:setContentSize(sz)
            layout:setName("layPage"..pageIdx)
        end
        local image = self:createImage(gameInfoTbl, sz)
        layout:addChild(image)
        if i == self.t.iCount then pv:addPage(layout) end  
    end
    pv:addEventListener(handler(self, self.onPageChanged))
    self:createDot()
    self:refreshGamePage()

    --添加定时刷新定时器
    self:refreshIcons()
    self.kNode:findChild("panel"):schedule(handler(self, self.refreshIcons), 0.5, "GameStatusTimer")
end

function UILobbyKOKO:createDot()
    local pos = cc.p(150, -245)
    local width, height = 20, 20
    local layout = ccui.Layout:create()
    layout:setContentSize(cc.size(width * LT_Param.iTotalPage, height))
    layout:setName("layoutDot")
    layout:setAnchorPoint(0.5, 0.5)
    layout:setPosition(pos)
    for i = 1, LT_Param.iTotalPage do
        local image = ccui.ImageView:create("koko/atlas/lobby/1016.png", 1)
        image:setAnchorPoint(0, 0)
        image:setName("dot"..i)
        local posX = (i - 1) * width
        local pos = cc.p(posX, 0)
        image:setPosition(pos)
        layout:addChild(image)
    end
    self.kNode:findChild("panel/panel1"):addChild(layout)
end

--刷新游戏页
function UILobbyKOKO:refreshGamePage()
    local pv = self.kNode:findChild("panel/panel1/pageView")
    local curidx = LT_Param.iGamePage
    pv:scrollToPage(curidx)
    self:_setPageIndex(curidx + 1)
end
function UILobbyKOKO:OnBtnLeftClicked(sender)
    local curidx = LT_Param.iGamePage
    if curidx > 0 then
        LT_Param.iGamePage = curidx - 1
        self:refreshGamePage()
    end
end
function UILobbyKOKO:OnBtnRightClicked(sender)
    local curidx = LT_Param.iGamePage
    if curidx < LT_Param.iTotalPage then
        LT_Param.iGamePage = curidx + 1
        self:refreshGamePage()
    end
end
function UILobbyKOKO:onPageChanged(sender)
    local idx = sender:getCurrentPageIndex()
    LT_Param.iGamePage = idx
    self:_setPageIndex(idx + 1)
end
function UILobbyKOKO:_setPageIndex(idx)
    --翻页按钮
    C("btnLeft"):Visible(idx ~= 1)
    C("btnRight"):Visible(idx ~= LT_Param.iTotalPage)
    --提示点
    local dots = {
        [false] = "koko/atlas/lobby/1016.png",
        [true] = "koko/atlas/lobby/1015.png",
    }
    for i = 1, LT_Param.iTotalPage do
        local dot = self.kNode:findChild("panel/panel1/layoutDot/dot"..i)
        dot:loadTexture(dots[idx == i], 1)
    end
end
-- 刷新在线人数
function UILobbyKOKO:refreshGamePeople()
    local node = C("pageView")
    local info = CC.PlayerMgr.Lobby.tGamePeople

    for i = 1, self.t.iCount do
        local tGamdList = self.t.tGameList[i].Value
        local txtNode = node:Node():findChild("layPage"..tGamdList.GamePage.."/Game"..tGamdList.GameIndex.."/layPeopleNum/peopleNum")
        txtNode:setString(_G.tostring(info[tGamdList.Name].display) .. "人")
    end
end
-- 创建黑色蒙版
function UILobbyKOKO:createBlackImage(sz, csb)
    local lay = ccui.Layout:create()
    lay:setContentSize(sz)

    local node = cc.CSLoader:createNode(csb)
	node:setAnchorPoint(0.5, 0.5)
    node:setPosition(sz.width / 2, sz.height / 2)
    lay:addChild(node)

    local render = cc.RenderTexture:create(sz.width, sz.height)
    render:beginWithClear(0,0,0,0)
    lay:visit()
    render:endToLua()

    local spr = cc.Sprite:createWithTexture(render:getSprite():getTexture())
    spr:setFlippedY(true)
    spr:setBlendFunc({src = _G.gl.ZERO, dst = _G.gl.SRC_ALPHA})
    spr:setAnchorPoint(cc.p(0,0))

    local render2 = cc.RenderTexture:create(sz.width, sz.height)
    render2:beginWithClear(0,0,0,0.3)
    spr:visit()
    render2:endToLua()

    local spr2 = cc.Sprite:createWithTexture(render2:getSprite():getTexture())
    spr2:setFlippedY(true)
    return spr2
end
-- 游戏图标
function UILobbyKOKO:createImage(tbl,sz)
    local _ = tbl.GameIndex

    local layout = ccui.Layout:create()
    local laysz = cc.size(sz.width/3, sz.height/2)
    layout:setContentSize(laysz)

    local node = _G.cc.CSLoader:createNode(tbl.CsbPath)
	node:setName("lobbyIcoTX")
	node:setAnchorPoint(0.5, 0.5)
	node:setPosition(laysz.width / 2, laysz.height / 2)
	layout:addChild(node)

    --创建半透明灰色蒙版
    local sprite = self:createBlackImage(laysz, tbl.CsbPath)
    sprite:setPosition(laysz.width / 2, laysz.height)
    sprite:setAnchorPoint(0.5, 1)
    sprite:setName("black")
    layout:addChild(sprite)

    --判断是否需要播放动画
    local info = CC.PlayerMgr.Lobby.tDownloadInfo
    if info[tbl.Name].state == 3 then
        local timeline = _G.cc.CSLoader:createTimeline(tbl.CsbPath)
        node:runAction(timeline)
        timeline:gotoFrameAndPlay(0, true)
    end

    --创建蒙版上的文字控件
    local ttf = {}
    ttf.fontFilePath = "font/systembd.ttf"
    ttf.fontSize = 20
    local txt1 = cc.Label:create()
    txt1:setTTFConfig(ttf)
    txt1:setAnchorPoint(0.5, 0.5)
    txt1:setName("blackText")
    txt1:setString("正在下载：50%")
    txt1:setTextColor(cc.c3b(0xff, 0xff, 0xff))
    txt1:enableOutline(cc.c3b(0x20, 0x2e, 0x20), 1)
    txt1:setPosition(laysz.width / 2, laysz.height / 2 - 20)
    layout:addChild(txt1)

    --创建绿点
    local green = self:GameGreenPoint()
    green:setName("greenPoint")
    layout:addChild(green)

    local txt3 = self:peopleNumTag()
    layout:addChild(txt3)
    
    layout:setAnchorPoint(0.5, 0.5)
    local posX = (_ > 3 and _ - 4 or _ - 1) * (sz.width/3) + sz.width/6
    local posY = (_ > 3 and 0 or 0.95) * (sz.height/2) + sz.height/4
    local pos = cc.p(posX + 2, posY - 10)
    layout:setPosition(pos)
    layout:setName("Game".._)
    layout:onClick(handler(self, self.onBeginGame), 1.03)

    return layout
end
-- 游戏下载状态
function UILobbyKOKO:refreshIcons()
    local pv = self.kNode:findChild("panel/panel1/pageView")
    local tVal = data.downloadMgr:getAllTaskStatus()
    local wait = tVal.wait
    local down = tVal.down
    local info = CC.PlayerMgr.Lobby.tDownloadInfo

    local tGameExcel = CC.Excel.GameList
    for i = 1, self.t.iCount do
        local tbl = self.t.tGameList[i].Value
        local t = info[tbl.Name]

        local layout = pv:findChild("layPage"..tbl.GamePage.."/Game"..tbl.GameIndex)
        local red = layout:findChild("lobbyIcoTX/Node_1/new")
        local green = layout:findChild("greenPoint")
        local black = layout:findChild("black")
        local blackText = layout:findChild("blackText")
        local peopleNum = layout:findChild("layPeopleNum")

        local t2 = _G.table.find(down, function(v) return v.gameId == i end)
        if _G.table.indexof(wait, i) then
            red:setVisible(false)
            green:setVisible(false)
            black:setVisible(true)
            blackText:setString("正在等待...")
            blackText:setVisible(true)
        elseif t2 ~= nil then
            red:setVisible(false)
            green:setVisible(false)
            blackText:setString(_G.string.format("%s：%d%%", t.state == 1 and "正在下载" or "正在更新", t2.rate * 100))
            blackText:setVisible(true)
            black:setVisible(true)
            local sz = layout:getContentSize()
            local h2 = sz.height * (1 - t2.rate)
            black:setTextureRect(cc.rect(0, sz.height - h2, sz.width, h2))
        else
            --t.state 1:未下载  2：未更新  3：已更新  4:错误
            if t.state == 1 or t.state == 4 then
                red:setVisible(false)
                green:setVisible(false)
                black:setVisible(true)
                blackText:setVisible(false)
                peopleNum:setVisible(false)
            elseif t.state == 2 then
                red:setVisible(true)
                green:setVisible(false)
                black:setVisible(true)
                blackText:setVisible(false)
                peopleNum:setVisible(true)
            elseif t.state == 3 then
                red:setVisible(false)
                green:setVisible(not enterGameRecord.isEntered(tbl.LocalDir))
                black:setVisible(false)
                blackText:setVisible(false)
                peopleNum:setVisible(true)
            end
        end  
    end
end
function UILobbyKOKO:GameGreenPoint()
    local node = ccui.ImageView:create()
    node:setName("GameGreenPoint")
    node:loadTexture("koko/atlas/common/GreenPoint.png", 1)
    node:setAnchorPoint(0.5, 0.5)
    node:setPosition(cc.p(50, 180))
    return node
end  
-- 在线人数Layout
function UILobbyKOKO:peopleNumTag()
    local layout = ccui.Layout:create()
    layout:setName("layPeopleNum")
    layout:setAnchorPoint(cc.p(0, 0))
    layout:setPosition(cc.p(50, 11))
    layout:setContentSize(cc.size(155,36))
    layout:setBackGroundImage("koko/atlas/lobby/2002.png", 1)
    layout:setBackGroundImageScale9Enabled(true)
    local ttf = {}
    ttf.fontFilePath = "font/system.ttf"
    ttf.fontSize = 22
    --创建人数
    local txt1 = cc.Label:create()
    txt1:setTTFConfig(ttf)
    txt1:setAnchorPoint(1, 0)
    txt1:setName("peopleNum")
    txt1:setString("3000人")
    txt1:setTextColor(cc.c3b(0x81, 0x2e, 0x03))
    txt1:setPosition(cc.p(100, 6))
    layout:addChild(txt1)
    --在玩
    local txt2 = cc.Label:create()
    txt2:setTTFConfig(ttf)
    txt2:setAnchorPoint(0, 0)
    txt2:setString("在玩")
    txt2:setTextColor(cc.c3b(0xFF, 0xFF, 0xFF))
    txt2:setPosition(cc.p(100, 6))
    txt2:enableOutline(cc.c3b(0x7F, 0x7F, 0x7F), 1)
    layout:addChild(txt2)

    return layout
end

--监听事件打开一个游戏
function UILobbyKOKO:startGameWithDownload(gameId)
    --判断游戏是否存在
    if gameId == 0 then
        kk.msgup.show("系统错误，游戏不存在！")
        return
    end

    local tbl = nil
    local tlist = CC.Excel.GameList
    for i = 1, tlist:Count() do
        if tlist:At(i).ID == gameId then
            tbl = tlist:At(i)
            break
        end    
    end

    if not tbl then
        kk.msgup.show("系统错误，游戏不存在。")
        return
    end
    _G.cclog("进入游戏：%s", tbl.LocalDir)

    --定义进入游戏函数
    local function enterGame(id)
        enterGameRecord.setEntered(tbl.LocalDir, true)
        CC.GameMgr.Scene:Set("Game", {iGame = id})
        self.autoEnterGameId = nil
    end

    --判断游戏是否是最新
    local info = CC.PlayerMgr.Lobby.tDownloadInfo[tbl.Name]
    if info.state == 3 then
        enterGame(gameId)
        return
    end

    --判断游戏是否正在下载队列
    if data.downloadMgr:getStatusByGameId(gameId) then
        local all = data.downloadMgr:getAllTaskStatus()
        if _G.table.indexof(all.wait, gameId) then
            kk.msgup.show("该游戏已加入下载队列，请稍后。")
        else
            kk.msgup.show("该游戏正在下载中，请稍后。")
        end
        return
    end

    --定义下载函数
    local function downloadGame(id)
        local function downloadCallback(id, is_success, msg)
            local t = CC.PlayerMgr.Lobby.tDownloadInfo[tbl.Name]
            if not t then return end
            if is_success then
                t.state = 3
                --判断是否自动进入游戏
                local lobby = CC.UIMgr:Get("UILobbyKOKO")
                if lobby then
                    --播放动画
                    local layout = self.kNode:findChild("panel/panel1/pageView/layPage"..tbl.GamePage.."/Game"..tbl.GameIndex)
                    local timeline = _G.cc.CSLoader:createTimeline(tbl.CsbPath)
                    layout:runAction(timeline)
                    timeline:gotoFrameAndPlay(0, true)

                    if lobby.autoEnterGameId then
                        enterGame(lobby.autoEnterGameId)
                    end
                end
            else
                t.state = 1
                kk.msgup.show(msg)
            end
        end
        
        --维护自动进入游戏Id
        local all = data.downloadMgr:getAllTaskStatus()
        self.autoEnterGameId = nil
        if #all.down == 0 and #all.wait == 0 then
            self.autoEnterGameId = id
        end
        enterGameRecord.setEntered(tbl.LocalDir, false)
        data.downloadMgr:addTask(gameId, downloadCallback)
    end

    --检查网络环境
    if _G.is_net_free() then
        downloadGame(gameId)
    else
        local ll = "一定"
        if info.state ~= 4 then
            ll = _G.kk.util.convertFileSize2String(info.size)
        end
        local s = _G.string.format("本次更新需要消耗%s流量，仍然继续吗？", ll)
        _G.kk.msgbox.showOkCancel(s, function(isok)
            if isok then
                downloadGame(gameId)
            end
        end)
    end
end

--点击游戏图标开始游戏
function UILobbyKOKO:onBeginGame(sender)
    local pv = self.kNode:findChild("panel/panel1/pageView")
    local curidx = pv:getCurrentPageIndex()
    local gameidx = _G.tonumber(_G.string.sub(sender:getName(), 5))

    --根据索引查找游戏Id
    local gameId = 0
    for i = 1, self.t.iCount do
        local gamelist = self.t.tGameList[i].Value
        local kGamePage = gamelist.GamePage
        local kGameIndex = gamelist.GameIndex
        if curidx == kGamePage and gameidx == kGameIndex then
            gameId = gamelist.ID
            break
        end
    end

    self:startGameWithDownload(gameId)
end

function UILobbyKOKO:addChatMesssageForUI()
    local len = #_G.chat.chatMessage
    if 0 == len then
        local s1 = "欢迎您进入KOKO游戏平台，KOKO游戏平台是一个聚娱乐和竞技于一体的交友平台。"
        local s2 = "在这里有休闲类、竞技类、棋牌类、娱乐类等各种各样的游戏，相信总有一款适合您。现在让我们开始游戏吧，提前预祝您，赢得盆满钵满~~~！"
        _G.chat:addChatMsg(true, "系统", s1)
        _G.chat:addChatMsg(true, "系统", s2)
        _G.chat:addScrollMsg(s1)
        _G.chat:addScrollMsg(s2)
    else
        for k = len, 1, -1 do
            local tbl = _G.chat.chatMessage[k]
            if tbl.official then
                _G.chat:addScrollMsg(tbl.content)
                break
            end    
        end    
    end
end

function UILobbyKOKO:OnClickInviteLink()
    CC.UIMgr:Load(UIInvite)
end
