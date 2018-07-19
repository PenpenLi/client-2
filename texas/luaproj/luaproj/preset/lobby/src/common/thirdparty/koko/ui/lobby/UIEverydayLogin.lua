-----------------------------------------------------------------------------------
-- 每日登陆  2017.9.16
-- By zyq
-----------------------------------------------------------------------------------
local _G = _G
local CC = require "comm.CC"
local proto2 = require("koko.proto2")
module "koko.ui.lobby.UIEverydayLogin"
-----------------------------------------------------------------------------------
UIEverydayLogin = CC.UI:Create{
	Path = "koko/ui/lobby/everyday_login.csb",
	Key = "UIEverydayLogin",
}
function UIEverydayLogin:Load()
    local vipLevel = CC.Player.vipLevel
	self:RegClose("panel/close")
	self:RegClick("panel/btnget", self.OnClickOK)
	local kScroll = CC.ScrollView:Create{Node = self:Child("panel/panel/scrollView")}
    CC.Node:Array{Node = kScroll.kNode:findChild("item1"), X = 7, Y = 1, XD = 134}
    kScroll:Fix{Top = 5, Bottom = 5}
	for i = 1, 7 do
		local kData = CC.Excel.EveryLogin:At(i)
        local itemNode = self:Child("panel/panel/scrollView/item"..i)
		itemNode:findChild("image1"):loadTexture(kData.Icon, 1)
		itemNode:findChild("image2"):loadTexture(kData.Data, 1)
		itemNode:findChild("text2"):setString(kData.Award)
	end
	local mom = vipLevel == 0 and 0 or CC.Excel.VipList[vipLevel].SignAward
	local str = _G.string.format("%d  倍\t奖 励", mom)
    if vipLevel >= 10 then
        str = _G.string.format("%d 倍\t奖 励", mom)
	end
	self:Child("panel/panel/menu/image1/text"):setString(str)
    self:Child("panel/panel/menu/image1/text"):getVirtualRenderer():setLineSpacing(0)
	self:RegClick("panel/panel/menu/node1", self.OnGetSerialAward)
	self:RegClick("panel/panel/menu/node2", self.OnGetSerialAward)
	self:RegClick("panel/panel/menu/node3", self.OnGetSerialAward)
end

function UIEverydayLogin:Refresh()
	local loginInfo = CC.PlayerMgr.EverydayLoginInfo
	if loginInfo.iLoginState == 1 then
		self:Child("panel/btnget"):setEnabled(false)
		self:Child("panel/btnget"):loadTexture("koko/atlas/all_common/button/2027.png", 1)
	end
	for i = 1, 7 do
        local itemNode = self:Child("panel/panel/scrollView/item"..i)
		if itemNode:findChild("shineTX3") then itemNode:removeChildByName("shineTX3") end
		if i < loginInfo.iloginDay then
			self:setNodeColor(itemNode, _G.cc.c4b(181, 169, 169, 255))
		end
		if i == loginInfo.iloginDay and loginInfo.iLoginState == 1 then
		    self:setNodeColor(itemNode, _G.cc.c4b(181, 169, 169, 255))
		end
		if i == loginInfo.iloginDay and loginInfo.iLoginState == 0 then
		    self:hookLoginAnim(itemNode)
		end
        itemNode:findChild("image3"):setVisible(i < loginInfo.iloginDay or (i == loginInfo.iloginDay and loginInfo.iLoginState == 1))
	end
	local node1 = self:Child("panel/panel/menu/node1")
	local node2 = self:Child("panel/panel/menu/node2")
	local node3 = self:Child("panel/panel/menu/node3")
	self:setNodeState(node1, 3, 1)
	self:setNodeState(node2, 6, 2)
	self:setNodeState(node3, 9, 3)

	self:setProgress()
end
--  设置 上面三个奖品的状态
function UIEverydayLogin:setNodeState(node, n, idx)
    local nodex = CC.String:GetIndex(node:getName())
    local loginInfo = CC.PlayerMgr.EverydayLoginInfo
    local iday = loginInfo.iSerialDay
	local istate = loginInfo.iSerialState
	if node:findChild("shineTX") then node:removeChildByName("shineTX") end
	if iday >= n then    
	    if istate[nodex] ~= 0 then
			node:findChild("image"):setVisible(true)
			local path = "koko/atlas/everyday_login/k_01_01.png"
			if n == 6 then
				path = "koko/atlas/everyday_login/k_01_02.png"
			elseif n == 9 then
				path = "koko/atlas/everyday_login/k_01_03.png"
			end
			node:findChild("image"):loadTexture(path, 1)
			node:findChild("image"):setColor(_G.cc.c4b(181, 169, 169, 255))
		else
		    node:findChild("image"):setVisible(false)
			self:hookSerialAnim(node, idx)
		end	
	else
        node:findChild("image"):setVisible(true)
		node:findChild("image"):setColor(_G.cc.c4b(255, 255, 255, 255))
 	end
end

function UIEverydayLogin:setNodeColor(node, color)
    node:findChild("bg"):setColor(color)
	node:findChild("image1"):setColor(color)
	node:findChild("image2"):setColor(color)
	node:findChild("text2"):setColor(color)
end
--  设置滑块
function UIEverydayLogin:setProgress()
    local loginInfo = CC.PlayerMgr.EverydayLoginInfo
	local rate = loginInfo.iSerialDay/9 * 100
	local node = self:Child("panel/panel/menu/progress")
    node:findChild("slid"):setPercent(rate)
	local sz = node:getContentSize()
	if loginInfo.iSerialDay == 0 or loginInfo.iSerialDay == 9 then
        node:findChild("image"):setVisible(false)
	end
    node:findChild("image"):setPositionX(sz.width*rate/100 - 2)
end
--  挂接 连续登陆领奖动画
function UIEverydayLogin:hookSerialAnim(parent, idx)
    local sz = parent:getContentSize()
	local path = "koko/ui/lobby/everyday_login_tx.csb"
	if idx == 2 then
		path = "koko/ui/lobby/everyday_login_tx2.csb"
	else
		path = "koko/ui/lobby/everyday_login_tx4.csb"
	end
    local node = _G.cc.CSLoader:createNode(path)
	node:setName("shineTX")
	node:setAnchorPoint(0.5, 0.5)
	node:setPosition(_G.cc.p(sz.width/2, sz.height/2))
	parent:addChild(node)

	local timeline = _G.cc.CSLoader:createTimeline(path)
	node:runAction(timeline)
	timeline:gotoFrameAndPlay(0, true)
end
--  挂接 每日领奖动画
function UIEverydayLogin:hookLoginAnim(parent)
    if parent:findChild("shineTX3") then return end
    local sz = parent:getContentSize()
    local path = "koko/ui/lobby/everyday_login_tx3.csb"
    local node = _G.cc.CSLoader:createNode(path)
	node:setName("shineTX3")
	node:setAnchorPoint(0.5, 0.5)
	node:setPosition(_G.cc.p(sz.width/2, sz.height/2 + 6))
	parent:addChild(node)

	local timeline = _G.cc.CSLoader:createTimeline(path)
	node:runAction(timeline)
	timeline:gotoFrameAndPlay(0, true)
end
function UIEverydayLogin:OnClickOK()
    local loginInfo = CC.PlayerMgr.EverydayLoginInfo
	if loginInfo.iLoginState == 1 then
	    _G.kk.msgup.show("已经领取!")
        return
	end
	--  发送每日登陆请求
	proto2.sendGetLoginPrizeReq(0)
end

function UIEverydayLogin:OnGetSerialAward(sender)
    local idx = CC.String:GetIndex(sender:getName())
	local idxNum = 3
	if idx == 1 then
	    idxNum = 3
	elseif idx == 2 then
	    idxNum = 6
	else
	    idxNum = 9
	end

	local loginInfo = CC.PlayerMgr.EverydayLoginInfo
	if idxNum > loginInfo.iSerialDay then
        return
	else
	    if loginInfo.iSerialState[idx] == 1 then
		    _G.kk.msgup.show("已经领取!")
		else
		    --发送连续登陆奖励请求
	        proto2.sendGetLoginPrizeReq(idx)
		end	
	end
end