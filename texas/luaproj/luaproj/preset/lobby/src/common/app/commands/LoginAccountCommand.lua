local CMD = require("app.net.CMD")
local GameEnv = require("app.common.GameConfig")

local LoginAccountCommand = {}
local env = GameEnv.getSocketEnv()
-- 这里处理登陆的操作：
-- 1、连接账号服务器
-- 2、认证

function LoginAccountCommand.connect()
   
    SOCKET_MANAGER.connectToAccountServer(env.host, env.port, function()
        
    end)
end

function LoginAccountCommand.sendcode(mobile)
    local data = {
        sign_ = sign,
        type_ = 1,
        mobile_ = mobile
    }
	SOCKET_MANAGER.connectToAccountServer(env.host, env.port);
    SOCKET_MANAGER.sendToAccountServer(CMD.ACCOUNT_SENDCODE, data)
end

function LoginAccountCommand.login(login_options)
    local acc = login_options.account
    local pwd = login_options.pwd
    local machine_mark = login_options.machine_mark

    local sign = sign_varibles(acc, pwd, machine_mark)
    local data = {
        sign_ = sign,
        acc_name_ = acc,
        pwd_hash_ = md5string(pwd),
        machine_mark_ = machine_mark,
    }
	SOCKET_MANAGER.connectToAccountServer(env.host, env.port);
    return SOCKET_MANAGER.sendToAccountServer(CMD.ACCOUNT_USER_LOGIN_REQ, data)
end

function LoginAccountCommand.register(register_options)
	SOCKET_MANAGER.connectToAccountServer(env.host, env.port);
    SOCKET_MANAGER.sendToAccountServer(CMD.ACCOUNT_REGISTER, register_options)
end

return LoginAccountCommand