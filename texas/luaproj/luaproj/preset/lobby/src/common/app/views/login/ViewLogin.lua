local UIHelper = require("app.common.UIHelper")
local exclusiveSelect = require("app.common.exclusiveSelect")

local ViewLogin = class("ViewLogin", cc.mvc.ViewBase)
local csbnode = nil;
local container = nil;

function ViewLogin:ctor(ctrl)
	math.randomseed(os.time());
	self.super.ctor(self);

	csbnode = cc.CSLoader:createNode("login/login_frame.csb"):addTo(self);
	container = UIHelper.seekNodeByName(csbnode, "login_frame");
	container:setVisible(false);
    
	local btn_guest_login = UIHelper.seekNodeByName(csbnode, "btn_guest_login");
	btn_guest_login:addTouchEventListener(function(ref, t)
		if t ~= ccui.TouchEventType.ended then return end;
		self:guestLogin();
	end);

	local btn_showlogin = UIHelper.seekNodeByName(csbnode, "btn_user_login");
	btn_showlogin:addTouchEventListener(function(ref, t)
		if t ~= ccui.TouchEventType.ended then return end;
		--显示登录注册输入界面
		container:setVisible(true);
		self:showLogin();
	end);
	
	local btn_login_page  = UIHelper.seekNodeByName(csbnode, "btn_login_page");
	local btn_showregister = UIHelper.seekNodeByName(container, "btn_register_page");
	
	self.exc1 = exclusiveSelect.new();
	self.exc1:addItem(btn_login_page, function()
		--显示登录注册输入界面
		container:setVisible(true);
		btn_showregister:setSelected(false);
		self:showLogin();
	end);

	self.exc1:addItem(btn_showregister, function()
		self:showRegister();
		btn_login_page:setSelected(false);
	end);

	local btn_close = UIHelper.seekNodeByName(csbnode, "btn_close");
	btn_close:addTouchEventListener(function(ref, t)
		if t ~= ccui.TouchEventType.ended then return end;
		container:setVisible(false);
	end)

	local btn_sendcode = UIHelper.seekNodeByName(container, "btn_send_code");
	btn_sendcode:addTouchEventListener(function(ref, t)
		if t ~= ccui.TouchEventType.ended then return end;
		self:sendCode();
	end)

	local btn_register = UIHelper.seekNodeByName(csbnode, "btn_register");
	btn_register:addTouchEventListener(function(ref, t)
		if t ~= ccui.TouchEventType.ended then return end;
		self:register();
	end)


	local acc_ctrl = UIHelper.seekNodeByName(UIHelper.seekNodeByName(container, "login_page"), "input_account");
	local psw_ctrl = UIHelper.seekNodeByName(UIHelper.seekNodeByName(container, "login_page"), "input_psw");

	local btn_dologin = UIHelper.seekNodeByName(container, "btn_login");
		btn_dologin:addTouchEventListener(function(ref, t)
		if t ~= ccui.TouchEventType.ended then return end;
		local acc = acc_ctrl:getString();
		local psw = psw_ctrl:getString();

		self:accountLogin(acc, psw);
	end);
   
	--上次保存登录账号显示
	local acc = cc.UserDefault:getInstance():getStringForKey("user_account");
	if acc then
		acc_ctrl:setString(acc);
	end
	
	local bg = UIHelper.seekNodeByName(csbnode, "bg0");
	if bg then
		local skeleton = sp.SkeletonAnimation:createWithJsonFile("effect/girl/renwu.json", "effect/girl/renwu.atlas", 1)
		skeleton:setAnimation(0, "idle", true)
		bg:addChild(skeleton)	
	end
end

function ViewLogin:resetView()
    if container == nil then return end;
    local rp =  UIHelper.seekNodeByName(container, "register_page");
    local lp = UIHelper.seekNodeByName(container, "login_page");
    rp:setVisible(false);
    lp:setVisible(false);
end

function ViewLogin:accountLogin(acc, psw)
	local login_options = {
			account = acc,
			pwd = psw,
			machine_mark = "0"
		};
        
	APP.lc:netSendLogin(login_options);
end

function ViewLogin:guestLogin()
    local acc = cc.UserDefault:getInstance():getStringForKey("guest_account");
 
    --如果游客账号存在，使用游客账号登录
    if acc and acc ~= "" then
		login_options = {
			account = acc,
		 	pwd = "123456",
		 	machine_mark = "unset"
		};
        APP.lc:netSendLogin(login_options);
    --如果游客账号不存在，则创建一个游客账号
    else
        acc = "GUEST_" .. string.format("%d", math.random(1, 999999)) .. string.format("%d", math.random(1, 999999))
	    self:doRegister(acc, "123456", "unset", 0, "");
    end
end

function ViewLogin:showLogin()
    self:resetView();

    local lp = UIHelper.seekNodeByName(container, "login_page");
    lp:setVisible(true);

end

function ViewLogin:sendCode()
    local lp = UIHelper.seekNodeByName(UIHelper.seekNodeByName(container, "register_page"), "input_account"):getString();
    if lp == "" then return end;
	APP.lc:netSendCode(lp);
end


function ViewLogin:doRegister(acc, psw, mm, tp, code)

    APP.GD.accinfo = {
		account = acc,
		pwd = psw,
		machine_mark = mm
	};

    local sign = sign_varibles(acc, psw, mm);
    local register_options = {
        sign_ = sign,
        acc_name_ = acc,
        pwd_hash_ = md5string(psw),
        machine_mark_ = mm,
        type_ = tp,
        verify_code = code,
        spread_from_ = "",
    }
    APP.lc:netSendRegister(register_options);
end

function ViewLogin:register()
    local ct = UIHelper.seekNodeByName(container, "register_page");
    local acc = UIHelper.seekNodeByName(ct, "input_account"):getString();
    if acc == "" then return end;
    
    local psw = UIHelper.seekNodeByName(ct, "input_psw1"):getString();
    if psw == "" then return end;
    
    local psw2 = UIHelper.seekNodeByName(ct, "input_psw2"):getString();
    if psw2 == "" then return end;

    if psw ~= psw2 then return end;

    local code = UIHelper.seekNodeByName(ct, "input_code"):getString();
    if code == "" then return end;

    self:doRegister(acc, psw, "unset", 1, code);
end

function ViewLogin:showRegister()
    self:resetView();

    local rp = UIHelper.seekNodeByName(container, "register_page");
    rp:setVisible(true);
end

function ViewLogin:onEnter()
	ViewLogin.super.onEnter(self)
end

function ViewLogin:onExit()
    ViewLogin.super.onExit(self)
end

return ViewLogin