
local _G = _G
local CC = require "comm.CC"
module "koko.ui.login.UILoading"

UILoading = CC.UI:Create{
    Path = "koko/ui/login/loading.csb",
    Key = "UILoading",
    Animation = false,
    Root = true,
    IsShade = false, 	--是否遮罩
}

function UILoading:Load()
    self.t.space = 500
    self.t.curspace = 0
    C(""):To(1):Loop():Action()
    self:Refresh({Rate = 0})
    if CC.LoginMgr.getLoginMgrGAME() == "" then
        C("txtVerson"):Text("版本号："..CC.Config.version)
    end
    if CC.Version and CC.Version.Gov then
        C("txtVerson"):Hide()
        C("btnserive"):Hide()
        C("btnKOKO"):Hide()
    end

    --添加事件监听
    _G.kk.event.addListener(self.kNode, _G.E.EVENTS.login_platform_progress, _G.handler(self, self.OnLoginPlatformProgress))
end

function UILoading:Prepare()
    if CC.LoginMgr.getLoginMgrGAME() == "" then
        local Content = {
            "在商城的道具页可以购买幸运骰子送给好友哦！",
        }
        local i = _G.math.random(1, #Content)
        self:Child("tishi/text"):setString(Content[i])
        self:Child("txtVerson"):setString("版本号："..CC.Config.version)

        --骨骼动画
        local skeleton = _G.sp.SkeletonAnimation:createWithJsonFile("koko/spines/heguan.json", "koko/spines/heguan.atlas", 1)
        skeleton:setAnimation(0, "stand", true)
        self:Child("spineAnim"):addChild(skeleton)

        --[[
        --龙骨动画 dragonBones
        local factory = _G.db.CCFactory:getFactory()
        --这里第二个参数是文件名_ske前面的部分
        factory:loadDragonBonesData("koko/spines/heguan_ske.json", "heguan")
        factory:loadTextureAtlasData("koko/spines/heguan_tex.json")
        --这里第一个参数是龙骨软件中指定的骨架数据名称，需对应上
        local node = factory:buildArmatureDisplay("armatureName", "heguan")
        node:getAnimation():play("stand", 0)
        self:Child("spineAnim"):addChild(node)
        ]]

    elseif self.Key == "UILoading_ddz" then
        self:onInit_ddz()
    end
    if self.Key ~= "UILoading" then
        if C("btnExit") then
            self:RegClick("btnExit", function() _G.exit(0) end)
        end
    end
end

function UILoading:Refresh(tVal)
    if tVal and tVal.Rate then
        local fore = self:Child("progress/back/fore")
        local board = self:Child("progress/back/board")
        local info = self:Child("progress/back/board/info")
        local attachnode = self:Child("progress/back/attachnode")
        local posx = fore:getContentSize().width * tVal.Rate

        fore:setPercent(tVal.Rate * 100)
        board:setPositionX(posx)
        local str = _G.string.format("正在加载%d%%", _G.math.floor(tVal.Rate * 100))
        if CC.LoginMgr.tData.GAME == "shz" then
            str = _G.string.format("%d%%", _G.math.floor(tVal.Rate * 100))
        end
        info:setString(str)
        attachnode:setPositionX(posx)
        self.t.curspace = _G.math.floor(tVal.Rate * 10000)
    end
end
--  0 - 1
function UILoading:setProgress(rate)
    self.t.space = rate * 10000 --+ _G.math.random(500) 去掉随机附加值
    if self.t.space >= 10000 then
        self.t.space = 10000
    end
end
function UILoading:OnLoginPlatformProgress(rate)
    if self.IsShade then
        self:setProgress(rate * 0.5)
    else
        self:setProgress(rate)
    end
end
function UILoading:Update()
    if self.t.space ~= self.t.curspace then
        local disp = self.t.space - self.t.curspace
        if disp >= -15 and disp <= 15 then
            self:Refresh{Rate = self.t.space / 10000}
        else
            self:Refresh{Rate = (self.t.curspace + 0.2 * disp) / 10000}
        end
    end
end
function UILoading:setZOrder(n)
    self.kNode:setLocalZOrder(n)
end

function UILoading:onInit_ddz()
    local Content = {
        "7、9、2是三张关键的牌，请特别关注。",
        "火箭：即双王，什么牌型都可打，是最大的牌。",
        "飞机带翅膀。三顺+同数量的单牌(或同数量的对牌)。",
        "当你是农民时，一定要做好和搭档的配合。",
        "逃跑扣的是双倍积分，划不来哦。",
        "判断力很重要，会受情绪所影响，心情不好时休息一下。",
        "将手上的牌打成出单或双都是你最大。",
        "拿到双王，牌不好时记得拆开来打，且要拆的及时哦。",
        "不到最后千万不要认输只要有一丝机会就要努力。",
        "打牌要注意抢先上手，很多时候输赢就在于关键的一张牌“2”。",
    }
    local function updateContent()
        C("txt"):Text(Content[_G.math.random(1, #Content)])
        local w = C("txt"):Node():getContentSize().width + C("ico"):Node():getContentSize().width
        C("panel"):Node():setContentSize(_G.cc.size(w, C("panel"):Node():getContentSize().height))
        C("panel"):Node():setPositionX(438)
    end
    updateContent()
    self.kNode:schedule(function() updateContent() end, 2, "loadingtxt.update")

    C("logo"):Visible(CC.LoginMgr.tData.PLATFORM ~= "single")
end