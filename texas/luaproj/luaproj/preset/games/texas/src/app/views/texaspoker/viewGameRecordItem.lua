local UIHelper = require("app.common.UIHelper")
local GameConfig = require("app.common.GameConfig")
local utils = require("utils")

local viewGameRecordItem = class("viewGameRecordItem", cc.mvc.ViewBase)


--enum 
--{
--	result_samecolor_connects = 1,//皇家同花顺
--	result_4_1,	//四张
--	result_3_2,	//三张+1对
--	result_samecolor,	//同花
--	result_connects,	//顺子
--	result_3_1,			//三张
--	result_2_2_1,		//两对
--	result_2,			//一对
--	result_singles,		//散牌
--};

local ct = {
	[1] = "皇家",
	[2] = "四张",
	[3] = "葫芦",
	[4] = "同花",
	[5] = "顺子",
	[6] = "三张",
	[7] = "两对",
	[8] = "一对",
	[9] = "散牌"
}

--enum 
--{
--	takeop_none = -1,
--	takeop_check = 0,		//跟牌
--	takeop_fold,			//弃牌
--	takeop_call,			//跟注
--	takeop_raise,			//加注
--	takeop_allin,			//allin
--	takeop_blinds_s,		//小盲注
--	takeop_blinds_b,		//大盲注
--	takeop_bet,				//压注
--};

local takeop = {
	[-1] = "",
	[0] = "过",
	[1] = "弃",
	[2] = "跟",
	[3] = "加",
	[4] = "全",
	[5] = "小",
	[6] = "大",
	[7] = "压"
}

--content:
--	std::string uid_;
--	int			isbanker_;
--	std::string nickname_;
--	std::string headico_;
--	int		csf_val_;//牌型
--	__int64	win_;
--	std::string c1, c2, c3, c4;
--	int		op1, op2, op3, op4;
function viewGameRecordItem:ctor(content)
	self.super.ctor(self)
	self.csbnode = cc.CSLoader:createNode("cocostudio/game/GameRecordItem.csb")
	self.csbnode:addTo(self);
	self:setContentSize(self.csbnode:getContentSize());

	local headico = UIHelper.seekNodeByName(self.csbnode, "headIco");
	headico:loadTexture(string.format("image/%s",GameConfig:HeadIco(content.headico_)));

	local nickName = UIHelper.seekNodeByName(self.csbnode, "nickName");
	nickName:setString(content.nickname_);
	
	local bankerMark = UIHelper.seekNodeByName(self.csbnode, "bankerMark");
	if content.isbanker_ == "1"then
		bankerMark:setVisible(true);
	end

	local win = UIHelper.seekNodeByName(self.csbnode, "win");
	win:setString(content.win_);
	
	local cardType = UIHelper.seekNodeByName(self.csbnode, "cardType");
	cardType:setString(ct[tonumber(content.csf_val_)]);

	if content.c1 ~= "" then
		local vcards = UIHelper.newCard(content.c1, true, cc.p(0,0));

		local c1 = UIHelper.seekNodeByName(self.csbnode, "card1");
		c1:addChild(vcards[1], 0);

		c1 = UIHelper.seekNodeByName(self.csbnode, "card2");
		c1:addChild(vcards[2], 0);
	end
	
	if content.c2 ~= "" then
		local vcards = UIHelper.newCard(content.c2, true, cc.p(0,0));

		local c1 = UIHelper.seekNodeByName(self.csbnode, "pubcard1");
		c1:addChild(vcards[1], 0);

		c1 = UIHelper.seekNodeByName(self.csbnode, "pubcard2");
		c1:addChild(vcards[2], 0);

		c1 = UIHelper.seekNodeByName(self.csbnode, "pubcard3");
		c1:addChild(vcards[3], 0);
	end
	
	if content.c3 ~= "" then
		local vcards = UIHelper.newCard(content.c3, true, cc.p(0,0));

		local c1 = UIHelper.seekNodeByName(self.csbnode, "pubcard4");
		c1:addChild(vcards[1], 0);
	end

	if content.c4 ~= "" then
		local vcards = UIHelper.newCard(content.c4, true, cc.p(0,0));

		local c1 = UIHelper.seekNodeByName(self.csbnode, "pubcard5");
		c1:addChild(vcards[1], 0);
	end

	if content.op1 ~= "" then
		local takeop1 = UIHelper.seekNodeByName(self.csbnode, "takeop1");
		if content.bet1 ~= "0" then
			takeop1:setString(takeop[tonumber(content.op1)]..utils.convertNumberShort(tonumber(content.bet1)));
		else
			takeop1:setString(takeop[tonumber(content.op1)]);
		end
	end

	if content.op2 ~= "" then
		local takeop2 = UIHelper.seekNodeByName(self.csbnode, "takeop2");
		if content.bet2 ~= "0" then
			takeop2:setString(takeop[tonumber(content.op2)]..utils.convertNumberShort(tonumber(content.bet2)));
		else
			takeop2:setString(takeop[tonumber(content.op2)]);
		end
	end
	
	if content.op3 ~= "" then
		local takeop3 = UIHelper.seekNodeByName(self.csbnode, "takeop3");
		if content.bet3 ~= "0" then
			takeop3:setString(takeop[tonumber(content.op3)]..utils.convertNumberShort(tonumber(content.bet3)));
		else
			takeop3:setString(takeop[tonumber(content.op3)]);
		end
	end

	if content.op4 ~= "" then
		local takeop4 = UIHelper.seekNodeByName(self.csbnode, "takeop4");
		if content.bet4 ~= "0" then
			takeop4:setString(takeop[tonumber(content.op4)]..utils.convertNumberShort(tonumber(content.bet4)));
		else
			takeop4:setString(takeop[tonumber(content.op4)]);
		end
	end
end

return viewGameRecordItem