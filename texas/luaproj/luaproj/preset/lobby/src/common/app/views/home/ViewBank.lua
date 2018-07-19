local GameConfig = require("app.common.GameConfig")
local UIHelper = require("app.common.UIHelper")
local CMD = require("app.net.CMD")
local utils = require("utils")

local ViewBank = class("ViewBank", cc.mvc.ViewBase)
local exclusiveSelect = require("app.common.exclusiveSelect")

--CMD.COORDINATE_GETBANK_INFO = 122;
--CMD.COORDINATE_BANKOP = 124;
--CMD.COORDINATE_SETBANK_PSW = 123;
function ViewBank:ctor()
	self.super.ctor(self);
	self.csbnode = cc.CSLoader:createNode("cocostudio/home/Bank.csb"):addTo(self);
	
	self.netevt = addListener(self, "NET_MSG", handler(self, self.onMsg));

	local btnLogin = UIHelper.seekNodeByName(self.csbnode, "btnLogin");
	btnLogin:addTouchEventListener(function(target, eType)
		if eType == ccui.TouchEventType.ended then
			--int				func_;		//0-设置密码, 1-修改密码, 2-验证密码
			--std::string		old_psw_;
			--std::string		psw_;
			self.txtPsw = UIHelper.seekNodeByName(self.csbnode, "txtPsw");
			SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_SETBANK_PSW, {func_ = 2,old_psw_ = self.txtPsw:getString()});
        end
	end);

	self.ex1 = exclusiveSelect.new();
	self.ex2 = exclusiveSelect.new();

end

function ViewBank:onMsg(fromServer, subCmd, content)
	if fromServer == GameConfig.ID_COORDINATESERVER then
		APP:getCurrentController():hideWaiting();
		if subCmd == CMD.COORDINATE_COMMOM_REPLY then
			if content.rp_cmd_ == tostring(CMD.COORDINATE_SETBANK_PSW) then
				if tonumber(content.err_) < 0 then
					APP:getCurrentController():showAlertOK({desc = "登录失败!"});
				else
					self:showMainPage();
				end
			end
		elseif subCmd == CMD.COORDINATE_SYNC_ITEM then
			--int			item_id_;
			--__int64		count_;
			--金币变化
			if content.item_id_ == "5" then
				local txtBankGold = UIHelper.seekNodeByName(self.csbnode, "txtBankGold");
				txtBankGold:setString(content.count_);
			end

		elseif subCmd == CMD.COORDINATE_BANKINFO_RET then
			--__int64		bank_gold_;
			--__int64		bank_gold_game_;
			--int			psw_set_;
			local txtBankGold = UIHelper.seekNodeByName(self.csbnode, "txtBankGold");
			txtBankGold:setString(content.bank_gold_game_);

		end
	elseif fromServer == GameConfig.ID_GAMESERVER then
		if subCmd == CMD.GAME_COMMOM_REPLY then
			
		elseif subCmd == CMD.GAME_CURRENCY_CHANGE then
			local txtMyGold = UIHelper.seekNodeByName(self.csbnode, "txtMyGold");
			txtMyGold:setString(content.credits_);
		end
	end
end

function ViewBank:showMainPage()
	local login = UIHelper.seekNodeByName(self.csbnode, "login");
	login:setVisible(false);

	local main = UIHelper.seekNodeByName(self.csbnode, "main");
	main:setVisible(true);

	
	local txtMyGold = UIHelper.seekNodeByName(self.csbnode, "txtMyGold");
	txtMyGold:setString(tostring(APP.GD.GameUser.gold_game));
	
	--取款
	local chkTake = UIHelper.seekNodeByName(self.csbnode, "chkTake")
	local chkPut = UIHelper.seekNodeByName(self.csbnode, "chkPut");
	self.ex1:addItem(chkTake, function()
		local put = UIHelper.seekNodeByName(self.csbnode, "put");
		put:setVisible(false);

		local take = UIHelper.seekNodeByName(self.csbnode, "take");
		take:setVisible(true);

		local txtInput = UIHelper.seekNodeByName(self.csbnode, "txtInput");
		txtInput:setString("");
	end );

	self.ex1:addItem(chkPut, function()
		local put = UIHelper.seekNodeByName(self.csbnode, "put");
		put:setVisible(true);

		local take = UIHelper.seekNodeByName(self.csbnode, "take");
		take:setVisible(false);
		local txtInput = UIHelper.seekNodeByName(self.csbnode, "txtInput");
		txtInput:setString("0");
	end);


	local chkSave = UIHelper.seekNodeByName(self.csbnode, "chkSave")
	local chkModPsw = UIHelper.seekNodeByName(self.csbnode, "chkModPsw");

	local bankop = UIHelper.seekNodeByName(self.csbnode, "bankop")
	local modpsw = UIHelper.seekNodeByName(self.csbnode, "modpsw");

	self.ex2:addItem(chkSave, function()
		bankop:setVisible(true);
		modpsw:setVisible(false);
	end);

	self.ex2:addItem(chkModPsw, function()
		bankop:setVisible(false);
		modpsw:setVisible(true);
	end);

	--发送请求
	local btnOK = UIHelper.seekNodeByName(self.csbnode, "btnOK");
	btnOK:addTouchEventListener(touchHandler(function()
		self:sendOp();
	end) );

	local btnMax = UIHelper.seekNodeByName(self.csbnode, "btnMax");
	btnMax:addTouchEventListener(touchHandler(function()
		self:MaxValue();
	end) );
	

	local btnModPsw = UIHelper.seekNodeByName(self.csbnode, "btnModPsw");
	btnModPsw:addTouchEventListener(touchHandler(function()
		self:ModPsw();
	end) );

	--请求银行数据
	SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_GETBANK_INFO, {});
end

function ViewBank:sendOp()
	local chkTake = UIHelper.seekNodeByName(self.csbnode, "chkTake");
	local txtInput = UIHelper.seekNodeByName(self.csbnode, "txtInput");

	local ival = tonumber(txtInput:getString());
	--如果是取款
	if chkTake:isSelected() then
		--std::string		psw_;		//密码
		--short				op_;		//0,提取,1存入
		--short				type_;		//0,K币,1K豆
		--__int64			count_;
		APP:getCurrentController():showWaiting();
		local txtBankGold = UIHelper.seekNodeByName(self.csbnode, "txtBankGold");
		if ival > tonumber(txtBankGold:getString()) then
			return;
		end

		SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_BANKOP, 
			{psw_ = self.txtPsw:getString(), op_ = 0, type_ = 1, count_ = txtInput:getString()});
	--如果是存款,发送到游戏服务器，请求把金币兑回平台。
	else
		local txtMyGold = UIHelper.seekNodeByName(self.csbnode, "txtMyGold");
		if ival > tonumber(txtMyGold:getString()) then
			return;
		end
		SOCKET_MANAGER.sendToGameServer(CMD.GAME_RESTORE_GOLD, {count_ = txtInput:getString()});
	end

end

function ViewBank:ModPsw()
	local txtOldPsw = UIHelper.seekNodeByName(self.csbnode, "txtOldPsw");
	local txtNewPsw = UIHelper.seekNodeByName(self.csbnode, "txtNewPsw");
	local txtNewPswConfirm = UIHelper.seekNodeByName(self.csbnode, "txtNewPswConfirm");

	if txtNewPswConfirm:getString() ~= txtNewPsw:getString() then
		APP:getCurrentController():showAlertOK({desc = APP.GD.LANG.ERR_PSW_NOTMATCH});
		return;
	end

	if string.len(txtNewPsw:getString()) < 6 then
		APP:getCurrentController():showAlertOK({desc = APP.GD.LANG.ERR_PSW_NEEDMORE_LENGTH});
		return;
	end
	
	--int				func_;		//0-设置密码, 1-修改密码, 2-验证密码
	--std::string		old_psw_;
	--std::string		psw_;
	SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_SETBANK_PSW, 
		{func_ = 1, old_psw_ = txtOldPsw:getString(), psw_ = txtNewPsw:getString()});


end

function ViewBank:MaxValue()
	local txtInput = UIHelper.seekNodeByName(self.csbnode, "txtInput");
	local chkTake = UIHelper.seekNodeByName(self.csbnode, "chkTake");
	--如果是取款
	if chkTake:isSelected() then
		local txtBankGold = UIHelper.seekNodeByName(self.csbnode, "txtBankGold");
		txtInput:setString(txtBankGold:getString());
	else
		local txtMyGold = UIHelper.seekNodeByName(self.csbnode, "txtMyGold");
		txtInput:setString(txtMyGold:getString());
	end
end

function ViewBank:onExit()
	ViewBank.super.onExit(self);
	removeListener(self.netevt);
end

return ViewBank;