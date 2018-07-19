local data = require("koko.data")
local proto2 = require("koko.proto2")
local config = require("config")
local CC = require "comm.CC"

local ctrl = class("kkActivity", kk.view)

local _text = {
    [false] = {{"对局结算说明",[[
亲爱的玩家：
    最近有很多玩家对于对局结算产生了疑问，这里咱给大家详细介绍一下咱们的结算规则：
1.	局费的扣除。系统会在每局开始后自动回收一部分K豆作为当局门票，如果对局没有开始，自动回收的局费会在玩家离开对局时自动退还。所以发现对局前K豆变少的玩家不用担心哦，那是系统帮您自动扣除了本局的局费。
2.	一般情况下农民和地主是单独分开进行结算的。两个农民之间没有任何的结算关系，所以并不会有一个农民替另外一个农民交K豆的事情发生。特殊情况：强行离开游戏场会导致处罚机制，强行离开的玩家需要承担所有玩家的损失。
3.	输赢封顶。为了防止以小博大、损害公平，玩家每局输或赢的K豆数量是不能超过自己所持有的K豆。
4.	结算倍数是根据玩家对局时的身份来决定的。地主的结算倍数是其他两个农民倍数之和，在界面中的倍数显示也是地主的结算倍数比单个农民的倍数要多。（即：农民A为6倍，农民B为3倍，地主为9倍）。
希望大家在了解了对局结算规则之后能够玩的开心。]]},
    {"反作弊声明",[[
尊敬的海象竞技玩家： 
    海象竞技一直致力于打造一个公平公正、绿色健康的游戏环境，为保证玩家的利益，运营团队听取各方面意见并经过多次讨论后，郑重决定通过封号等措施，全面打击非正常游戏的行为。具体措施如下：
一、非正常游戏的行为包括但不限于：
1．安装使用会影响海象竞技手机版游戏平衡的第三方软件；
2．利用游戏漏洞采用盗刷游戏币等方式，谋取游戏利益、破坏游戏的公平秩序；
3．同一玩家（或同一IP，或同一物理地址）注册或登录过多个账号角色；
4．在游戏内哄抬物价、直接或变相非法倒卖游戏币等行为；
5．对局中打联牌、故意输赢等；
6．在游戏内传播宣扬淫秽、色情、赌博、暴力，或者教唆他人犯罪等信息。
（海象竞技将根据监测到的游戏数据对以上行为进行独立自主的判断，从而判定是否构成非正常游戏行为。）
二、处罚力度包括但不限于：
凡是监测出非正常游戏的行为，将视情节严重程度取消该游戏账号由此获得的相关奖励（包括但不限于游戏币、实物奖品以及参赛资格），并作出暂时或永久性地禁止登录、删除游戏账号及游戏数据、删除相关信息等处理措施；情节严重的将移交有关行政管理机关给予行政处罚，或者追究刑事责任。
温馨提示：本公司对于用户所拥有的游戏币等均不提供任何形式的官方回购、直接或变相兑换现金或实物。本公司严禁用户之间在游戏中及线下进行任何相互叫卖、转让游戏币等行为。一经发现切经本公司评估后，有权采取封号处理；情节严重的，有权移交相关机构处理。
希望玩家朋友们注意保护自己的账号安全，切勿在游戏内或通过第三方平台交易。同时，也号召大家对非正常游戏账号开展举报，我们一起为净化游戏环境共同努力。
本通知自发布之日（即2017年10月1日）起生效。

海象竞技运营团队
2017-10-01]]},},
[true] = {{"对局结算说明",[[
亲爱的玩家：
    最近有很多玩家对于对局结算产生了疑问，这里咱给大家详细介绍一下咱们的结算规则：
1.	局费的扣除。系统会在每局开始后自动回收一部分K豆作为当局门票，如果对局没有开始，自动回收的局费会在玩家离开对局时自动退还。所以发现对局前K豆变少的玩家不用担心哦，那是系统帮您自动扣除了本局的局费。
2.	一般情况下农民和地主是单独分开进行结算的。两个农民之间没有任何的结算关系，所以并不会有一个农民替另外一个农民交K豆的事情发生。特殊情况：强行离开游戏场会导致处罚机制，强行离开的玩家需要承担所有玩家的损失。
3.	输赢封顶。为了防止以小博大、损害公平，玩家每局输或赢的K豆数量是不能超过自己所持有的K豆。
4.	结算倍数是根据玩家对局时的身份来决定的。地主的结算倍数是其他两个农民倍数之和，在界面中的倍数显示也是地主的结算倍数比单个农民的倍数要多。（即：农民A为6倍，农民B为3倍，地主为9倍）。
希望大家在了解了对局结算规则之后能够玩的开心。]]},
    {"反作弊声明",[[
亲爱的玩家：
    海象竞技-斗地主一直致力于打造一个公平公正、绿色健康的游戏环境，为保证玩家的利益，欢乐斗地主手机版运营团队听取各方面意见并经过多次讨论后，郑重决定通过封号等措施，全面打击非正常游戏的行为。具体措施如下：
一、	非正常游戏的行为包括但不限于：
1．	安装使用会影响海象竞技-斗地主手机版游戏平衡的第三方软件；
2．	利用游戏漏洞采用盗刷游戏币等方式，谋取游戏利益、破坏游戏的公平秩序；
3．	同一玩家（或同一IP，或同一物理地址）注册或登录过多个账号角色；
4．	在游戏内哄抬物价、直接或变相非法倒卖K豆等行为；
5．	对局中打联牌、故意输赢等；
6．	在游戏内传播宣扬淫秽、色情、赌博、暴力，或者教唆他人犯罪等信息。
（海象竞技将根据监测到的游戏数据对以上行为进行独立自主的判断，从而判定是否构成非正常游戏行为。）
二、	处罚力度包括但不限于：
凡是监测出非正常游戏的行为，将视情节严重程度取消该游戏账号由此获得的相关奖励（包括但不限于K豆、实物奖品以及参赛资格），并作出暂时或永久性地禁止登录、删除游戏账号及游戏数据、删除相关信息等处理措施；情节严重的将移交有关行政管理机关给予行政处罚，或者追究刑事责任。
温馨提示：本公司对于用户所拥有的K豆等均不提供任何形式的官方回购、直接或变相兑换现金或实物。本公司严禁用户之间在游戏中及线下进行任何相互叫卖、转让K豆等行为。一经发现切经本公司评估后，有权采取封号处理；情节严重的，有权移交相关机构处理。
希望玩家朋友们注意保护自己的账号安全，切勿在游戏内或通过第三方平台交易。同时，也号召大家对非正常游戏账号开展举报，我们一起为净化游戏环境共同努力。
本通知自发布之日（即2017年11月8日）起生效。
海象竞技斗地主运营团队]]},}
}
function ctrl:ctor()
    self:setCsbPath("koko/ui/lobby/activity.csb")
    self:setAnimation(kk.animScale:create())
end

function ctrl:onDestroy()
    kk.uimgr.unload("kkLimitTimeActive")
end
function ctrl:onInit(node)
    local panel2 = node:findChild("panel/panel2")
    kk.uimgr.load("koko.ui.lobby.ui_limit_time_active", panel2)
    node:findChild("panel/left_bar1"):onClick(function() self:showPage(1) end)
    node:findChild("panel/left_bar2"):onClick(function() self:showPage(2) end)
    node:findChild("panel/panel1/btn1"):onClick(handler(self, self.onNotice), 1.04)
    node:findChild("panel/panel1/btn2"):onClick(handler(self, self.onRemind), 1.04)
    node:findChild("panel/panel1/btn3"):onClick(handler(self, self.onBtn3), 1.04)
    node:findChild("panel/panel1/btn4"):onClick(handler(self, self.onBtn4), 1.04)
    node:findChild("panel/close"):onClick(mkfunc(kk.uimgr.unload, self))
    self:showPage(1)
    self:switchText(1)
    self:refreshRedPoint()
    CC.PlayerMgr.Activity:ChangeNoticeRedState(1, false)
    CC.PlayerMgr.Activity:writeNociceMd5()
    proto2.sendActivityListReq()
end
-- 刷新小红点
function ctrl:refreshRedPoint()
    local loginInfo = CC.PlayerMgr.Activity
    for i = 1, 2 do
        local redNode = self:getNode():findChild("panel/left_bar"..i.."/iRedPoint")
        local bRed = loginInfo:getNoticeRedState()
        if i == 2 then bRed =  loginInfo:getActiveRedState() end
        redNode:setVisible(bRed)
    end
    for i = 1, 2 do
        local redNode = self:getNode():findChild("panel/panel1/btn"..i.."/iRedPoint")
        redNode:setVisible(loginInfo.tNotice[i])
    end
end
function ctrl:showPage(index)
    local cfg = 
    {
        [true] = "koko/atlas/all_common/title/t1.png",
        [false] = "koko/atlas/all_common/title/t2.png",
    }
    for i = 1, 2 do
        local node = self:getNode():findChild("panel/left_bar"..i)
        local redNode = node:findChild("iRedPoint")
        local txt = node:findChild("text")
        txt:getVirtualRenderer():setLineSpacing(2)
        node:ignoreContentAdaptWithSize(true)
        if i == index then
            node:loadTexture("koko/atlas/all_common/title/0002.png", 1)
        else
            node:loadTexture("koko/atlas/all_common/title/0001.png", 1)
        end
        txt:setPositionX(node:getContentSize().width/2)
        redNode:setPositionX(node:getContentSize().width + 6)
        if i == 1 then
            CC.PlayerMgr.Activity:ChangeNoticeRedState(1, false)
        else 
            CC.PlayerMgr.Activity:ChangeActiveRedState(1, false)
        end
    end
    self:getNode():findChild("panel/panel1"):setVisible(index == 1)
    self:getNode():findChild("panel/panel2"):setVisible(index == 2)
    self:getNode():findChild("panel/Image"):loadTexture(cfg[index == 1], 1)
end

function ctrl:switchBtn(index)
    local cfg = 
    {
        [false] = "koko/atlas/all_common/button/left_selet.png",
        [true] = "koko/atlas/all_common/button/left.png",
    }
    local panel = self:getNode():findChild("panel/panel1")
    for i = 1, 4 do
        local node = panel:findChild("btn"..i)
        node:ignoreContentAdaptWithSize(true)
        node:loadTexture(cfg[index == i], 1)
    end    
end

function ctrl:switchText(index)
    local active = CC.PlayerMgr.Activity.NoticeTxt
    if index == 2 then
        active = CC.PlayerMgr.Activity.HintTxt
    end
    local imgTxtNode = self:getNode():findChild("panel/panel1/image4/text")
    local sv = self:getNode():findChild("panel/panel1/scrollView")
    local svTxtNode = sv:findChild("text")
    sv:setScrollBarOpacity(0)

    imgTxtNode:setString(active[1])
    local txtHeight = svTxtNode:setStringWithAutoHeight(active[2])
    local sz = sv:getInnerContainerSize()
    sz.height = math.max(txtHeight, sv:getContentSize().height)
    sv:setInnerContainerSize(sz)
    svTxtNode:setPositionY(sz.height)
end

function ctrl:onNotice(sender)
    CC.PlayerMgr.Activity:ChangeNoticeRedState(1, false)
    self:switchBtn(1)
    self:switchText(1)
end

function ctrl:onRemind(sender)
    CC.PlayerMgr.Activity:ChangeNoticeRedState(2, false)
    CC.PlayerMgr.Activity:writeHintMd5()
    self:switchBtn(2)
    self:switchText(2)
end
function ctrl:switchText2(index)   
    local imgTxtNode = self:getNode():findChild("panel/panel1/image4/text")
    local sv = self:getNode():findChild("panel/panel1/scrollView")
    local svTxtNode = sv:findChild("text")
    sv:setScrollBarOpacity(0)
    
    local b = CC.LoginMgr.tData.PLATFORM == "single"
    imgTxtNode:setString(_text[not b][index][1])
    local txtHeight = svTxtNode:setStringWithAutoHeight(_text[b][index][2])
    local sz = sv:getInnerContainerSize()
    sz.height = math.max(txtHeight, sv:getContentSize().height)
    sv:setInnerContainerSize(sz)
    svTxtNode:setPositionY(sz.height)
end
function ctrl:onBtn3(sender)
    self:switchBtn(3)
    self:switchText2(1)
end
function ctrl:onBtn4(sender)
    self:switchBtn(4)
    self:switchText2(2)
end
return ctrl