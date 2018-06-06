local UIHelper = require("app.common.UIHelper")
local LeftBaseLayer = require("app.views.common.LeftBaseLayer")
local ViewPersonal = class("ViewPersonal", LeftBaseLayer)
local constUtils = require("app.common.ConstUtils")
local GameConfig = require("app.common.GameConfig")
local CMD = require("app.net.CMD")

local head_icon = constUtils.head_icon

function ViewPersonal:ctor()
	ViewPersonal.super.ctor(self)
    APP:addListener(self, "NET_MSG", handler(self, self.onMsg));


	local csbnode = cc.CSLoader:createNode("cocostudio/home/PersonalLayer.csb")
	csbnode:addTo(self)

	local TextNickname = UIHelper.seekNodeByName(csbnode, "Text_Nickname")
    self.TextNickname = TextNickname
	local TextID = UIHelper.seekNodeByName(csbnode, "Text_ID")
	local TextGold = UIHelper.seekNodeByName(csbnode, "Text_Gold")
	--local TextDiamond = UIHelper.seekNodeByName(csbnode, "Text_Diamond")
	local TextWinRate = UIHelper.seekNodeByName(csbnode, "Text_WinRate")
	local TextAllCount = UIHelper.seekNodeByName(csbnode, "Text_AllCount")
    self.Image_icon = csbnode:getChildByName("Image_icon")


	local gameUser = APP.GD.GameUser
	TextNickname:setString(gameUser.uname)
	TextID:setString(gameUser.iid)
	TextGold:setString(tostring(gameUser.gold_game))
	--TextDiamond:setString(tostring(gameUser.gold))
	TextWinRate:setString(tostring(gameUser.winrate))
	TextAllCount:setString(tostring(gameUser.total_played))
    local headID = tonumber(gameUser.head_pic) == 0 and 1 or tonumber(gameUser.head_pic)
    self.Image_icon:loadTexture(string.format("cocostudio/common/image/%s",head_icon[headID]))

	local btn_Modify = UIHelper.seekNodeByName(csbnode, "Button_Modify")
	btn_Modify:addTouchEventListener(function(ref, t)
		if t == ccui.TouchEventType.ended then
			if APP:getCurrentController().showModifyPersonal then
				APP:getCurrentController():showModifyPersonal()
			end
		end
	end)
	self:initBestCards()
end

-- 显示最佳牌型
function ViewPersonal:initBestCards()
	local cards = {}
	local gameUser =APP.GD.GameUser
	local mainCards = string.split(gameUser.maincards, ",")
	local attachmentCards = string.split(gameUser.attachment, ",")
	for i = 1, #mainCards do
		cards[#cards + 1] = tonumber(mainCards[i])
	end
	for i = 1, #attachmentCards do
		cards[#cards + 1] = tonumber(attachmentCards[i])
	end
	dump(cards)
	cards = {50, 45, 20, 1, 18}
	for i = 1, #cards do
		local cardSprite = display.newSprite(string.format("#image/card_%d.png", cards[i]))
			:addTo(self)
			:move(cc.p(-340 + (i - 1) * 65, 705))
		cardSprite:setScale(0.7)
	end
end

function ViewPersonal:updateUserInfo(msg)
    self.Image_icon:loadTexture(string.format("cocostudio/common/image/%s",head_icon[msg.headId]))	
    self.TextNickname:setString(msg.nickName)
end

function ViewPersonal:onEnter()
    ViewPersonal.super.onEnter(self)
end

function ViewPersonal:onExit()
    ViewPersonal.super.onExit(self)
end





function ViewPersonal:onMsg(fromServer, subCmd, content)
    if fromServer ~= GameConfig.ID_COORDINATESERVER  then 
        return 
    end
	if subCmd == CMD.GAME_USERINFO_SET_RESP then
        local msg = {
            headId =tonumber(content.head_ico_),
            nickName =content.nickname_,
        }
        self:updateUserInfo(msg)
	end

end

return ViewPersonal