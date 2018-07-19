local _G = _G
local config = require("config")
local json = json
local CC = require("comm.CC")

module("web")
--添加推广信息（如果有的话）到登录参数中
local function _addPromotionInfo(loginparam)
    local str = _G.get_promotion_id()
    if str ~= "" then
        local t = json.decode(str)
        loginparam.iid = t.iid
        loginparam.file = t.file
    end
end

function sendPhoneCodeReq(phone, callback)
    local url = config.webHost .. "login/sendCode.htm"
    local t = 
    {
        mobile = phone,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

function sendRegisterReq(account, password, phone, secureCode, callback)
    local url = config.webHost .. "login/register.htm"
    local t = {
        uname = account,
        pwd = password,
        mobile = phone,
        code = secureCode,
        uid = "",
        machine = _G.get_device_code(),
        clientld = "",
        bindProxy = "",
        action = "kokoLogin",
        spreadFrom = _G.get_channel_id(),
        appVersion = _G.kk.util.getAppVersion(),
    }
    _G.kk.ql.httpPost(url, t, callback)
end

function sendAccountLoginReq(acc, pwd, callback, delay)
    local url = config.webHost .. "login/login1.htm"
    local t = {
        name = acc or "",
        pwd = pwd or "", 
        uid = "",
        clientId = "",
        bindProxy = "",
        action = "kokoLogin",
        machine = _G.get_device_code(),
        spreadFrom = _G.get_channel_id(),
        appVersion = _G.kk.util.getAppVersion(),
    }
    _addPromotionInfo(t)
    _G.kk.ql.httpPostWithRetry(url, t, callback, delay)
end

function sendDeviceLoginReq(deviceCode, callback, delay)
     local url = config.webHost .. "login/login1.htm"
     local t = {
        name = "",
        pwd = "", 
        clientId = "",
        bindProxy = "",
        action = "tourist",
        machine = deviceCode,
        spreadFrom = _G.get_channel_id(),
        appVersion = _G.kk.util.getAppVersion(),
     }
     _addPromotionInfo(t)
     _G.kk.ql.httpPostWithRetry(url, t, callback, delay)
end

function sendAppkeyUidLoginReq(appkey, uid, callback)
    local url = config.webHost .. "user/info.htm"
    local t = {
        appKey = appkey,
        uid = uid,
    }
    if _G.platform_iswin32() then
        t.Type = "lua"
    end
    _G.kk.ql.httpPostWithRetry(url, t, callback)
end

--action:qq wx
function sendThirdLoginReq(action, authId, nickName, callback, delay, unionId)
     local url = config.webHost .. "login/login1.htm"
     local t = {
        partyUid = authId,
        unionId = unionId,
        nickname = nickName,
        action = action,
        machine = _G.get_device_code(),
        spreadFrom = _G.get_channel_id(),
        appVersion = _G.kk.util.getAppVersion(),
     }
     _addPromotionInfo(t)
     _G.kk.ql.httpPostWithRetry(url, t, callback, delay)
end

--给控件绑定验证码
function bindCodeWithControl(ctrl)
    local path = ctrl:getPath()
    local url = config.webHost .. "login/getVerifyPicture.htm"
    local t = {
        uid = CC.Player.uid,
    }
    _G.kk.ql.httpPost(url, t, function(t)
        if t.success then
            local c = _G.findChild(path)
            if c then
                local url2 = config.webUrl .. t.data.path
                CC.Image:Web(c, url2)
            end
        else
            _G.kk.msgup.show(t.message)
        end
    end)
end

--独立判断验证码的合法性
function sendVerifyCode(code, callback)
    local url = config.webHost .. "login/verificationImg.htm"
    local t = {
        uid = CC.Player.uid,
        code = code,
    }
    _G.kk.ql.httpPost(url, t, callback)
end


--[[
@desc:绑定手机的网络请求
author:{whb}
time:2017-09-05 11:42:35
--@mobile:手机号码
--@code:验证码
--@appKey:用户的appKey(登录之后会返回在用户信息里面)
--@uid:用户id
--@callback: 回调函数
]]
function sendBindPhoneReq(mobile, code, appKey, uid, callback)
    local url = config.webHost .. "user/boundMobile.htm"
    local t = {
        appKey = appKey,
        uid = uid,
        mobile = mobile,
        code = code,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--修改密码请求
function sendChangePwdReq(acc, pwd, phone, phoneCode, callback)
    local url = config.webHost .. "login/findPwd.htm"
    local t = {
        uname = acc,
        pwd = pwd,
        mobile = phone,
        code = phoneCode,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--[[
@desc: 解绑手机的网络请求
author:{whb}
time:2017-09-05 11:49:16
--@code:验证码
--@appKey:用户appKey
--@mobile:手机号码
--@uid:用户id
--@callback:回调函数 
]]
function sendReleasePhoneReq(code, appKey, mobile, uid, callback)
    local url = config.webHost .. "user/unBoundMobile.htm"
    local t = {
        code = code,
        appKey = appKey,
        mobile = mobile,
        uid = uid,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--[[
@desc:获取邮箱验证码 
author:{whb}
time:2017-09-05 15:56:27
--@email:邮箱
--@appKey:用户appKey
--@callback: 回调函数
]]
function sendEmailCodeReq(email, appKey, callback)
    local url = config.webHost .. "login/sendEmailCode.htm"
    local t = {
        email = email,
        appKey = appKey,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--[[
@desc: 绑定邮箱的请求
author:{whb}
time:2017-09-05 15:47:15
--@email:邮箱
--@code:验证码
--@uid:用户id
--@appKey:用户appKey
--@callback:回调函数
]]
function sendBindEmailReq(email, code, uid, appKey, callback)
    local url = config.webHost .. "user/boundEmail.htm"
    local t = {
        email = email,
        code = code,
        uid = uid,
        appKey = appKey,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--[[
@desc: 解绑邮箱
author:{whb}
time:2017-09-06 09:53:50
--@email:邮箱
--@code:验证码
--@uid:用户uid
--@appKey:用户appKey
--@callback: 回调函数
]]
function sendReleaseEmailReq(email, code, uid, appKey, callback)
    local url = config.webHost .. "user/unBoundEmail.htm"
    local t = {
        email = email,
        code = code,
        uid = uid,
        appKey = appKey,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--[[
@desc: 修改密码请求
author:{whb}
time:2017-09-09 10:29:58
--@appKey:~~
--@uname:用户名（账号）
--@mobile:~~
--@pwd:密码
--@clientId:注册个推成功后返回的 cid 
--@code:~~
--@callback:~~ 
    return
]]
function sendModifyPwdReq(appKey, uname, mobile, pwd, clientId, code, callback)
    local url = config.webHost .. "login/findPwd.htm"
    local t = {
        appKey = appKey,
        uname = uname,
        mobile = mobile,
        pwd = pwd,
        clientId = clientId,
        code = code,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--[[
@desc: 绑定身份证请求
author:{whb}
time:2017-09-09 10:29:58
--@idnumber:身份证号码
--@name:真实姓名
--@code:验证码
--@uid:~~
--@appKey:~~
--@callback:~~ 
    return
]]
function sendBindIdnumberReq(idnumber, name, code, uid, appKey, callback)
    local url = config.webHost .. "user/boundIdnumber.htm"
    local t = {
        idnumber = idnumber,
        name = name,
        code = code,
        uid = uid,
        appKey = appKey,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--[[
@desc: 设置保险箱密码
author:{whb}
time:2017-09-14 17:02:36
--@pwd:密码
--@mobile:~~
--@uid:~~
--@appKey:~~
--@callback:~~ 
    return
]]
function sendSetBoxPwdReq(pwd, mobile, code, uid, appKey, callback)
    local url = config.webHost .. "login/setBankPwd.htm"
    local t = {
        pwd = pwd,
        mobile = mobile,
        code = code,
        uid = uid,
        appKey = appKey,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--[[
@desc: 进入金库
author:{whb}
time:2017-09-21 19:12:01
--@pwd:金库密码
--@uid:~~
--@appKey:~~
--@callback:~~ 
    return
]]
function sendEnterTreasuryReq(pwd, uid, appKey, callback)
    local url = config.webHost .. "user/loginBank.htm"
    local t = {
        pwd = pwd,
        uid = uid,
        appKey = appKey,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--[[
@desc: 存入金库
author:{whb}
time:2017-09-21 19:17:51
--@appKey:~~
--@uid:~~
--@count:存入数额
--@type:存入类型 0：钻石 1：K豆
--@callback: ~~
    return
]]
function saveToBankReq(appKey, uid, count, type, callback)
    local url = config.webHost .. "user/saveToBank.htm"
    local t = {
        appKey = appKey,
        uid = uid,
        count = count,
        type = type,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--[[
@desc:取出钻石或k豆 
author:{whb}
time:2017-09-21 19:22:41
--@appKey:~~
--@uid:~~
--@count:~~
--@type:~~
--@callback:~~ 
    return
]]
function takeFromBankReq(appKey, uid, count, type, callback)
    local url = config.webHost .. "user/getFromBank.htm"
    local t = {
        appKey = appKey,
        uid = uid,
        count = count,
        type = type,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--[[
    检测用户是否已经被注册
]]
function sendCheckUnameReq(name, callback)
    local url = config.webHost.."login/checkUname.htm"
    local t= {
        uname = name
    }
    _G.kk.ql.httpPost(url, t, callback)
end

---测试用的登录方法(后期删除)
function login(acc, psw, callback)
    local url = config.webHost .. "login/login1.htm"
    local t = {
        name = acc,
        pwd = psw,
        machine = _G.get_device_code(),
        action = "kokoLogin",
        clientId = "atestloginrequestandhavenotclientid",
        iosVersion = "",
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--  意见反馈
function sendComplaintReq(appKey, uid, str, callback)
    local url = config.webHost .. "gameList/complaints.htm"
    local t = {
        appKey = appKey,
        uid = uid,
        content = str,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

--  充值钻石
function sendRechargeZSReq(uid, appKey, cny, methodCode, isCashKbean, callback)
    local url = config.webHost .. "recharge/add.htm"
    local t = {
        uid = uid,
        appKey = appKey,
        cny = cny,
        methodCode = methodCode,
        isCashKbean = isCashKbean,
    }

    if methodCode == "WeChatPay" then
        if _G.platform_isios() and _G.type(_G.is_appmall) == "function" and not _G.is_appmall() then
            t.WeChatPay = "2"
        else
            t.WeChatPay = "1"
        end
    end

    _G.kk.ql.httpPost(url, t, callback)
end
-- 更新公告
function sendNoticeReq(uid, appKey, type, callback)
    local url = config.webHost .. "userUpdate/luaUpdate.htm"
    local t = {
        appKey = appKey,
        uid = uid,
        type = type,
    }
    _G.kk.ql.httpPost(url, t, callback)
end
-- 活动内容
function sendGetActivityReq(uid, appKey, callback)
    local url = CC.Config.webUrl .. "mobile/activity/hitThEeggActivity.htm"
    local t = {
        appKey = appKey,
        uid = uid,
    }
    _G.kk.ql.httpPost(url, t, callback)
end
--修改用户名
function sendModifyUnameReq(uid, appKey, uname, pwd, callback)
    local url = config.webHost .. "user/modifyUname.htm"
    local t = {
        uid = uid,
        appKey = appKey,
        pwd = pwd,
        uname = uname,
    }
    _G.kk.ql.httpPost(url, t, callback)
end
--修改昵称
function sendSetNickName(uid, appKey, nickname,gender, callback)
    local url = config.webHost.."user/setNickname.htm"
    local t = {
        uid = uid,
        appKey = appKey,
        nickname = nickname,
        gender = gender,
    }
    _G.kk.ql.httpPost(url, t, callback)
end
--检查昵称--敏感词过滤 Keywords（传入值） style验证类型名称比如是用户名就传入：用户名
function sendCheckNickNameReq(uid, appKey, Keywords, style, callback)
    local url = config.webHost.."user/checkFilter.htm"
    local t = {
        uid = uid,
        appKey = appKey,
        Keywords = Keywords,
        style = style,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

-- 充值钻石表
function sendRechargeListReq(callback)
    local url = config.webHost.."recharge/rechargeRate.htm"
    local t = {
        uid = CC.Player.uid,
        appKey = CC.Player.appKey,
    }
    _G.kk.ql.httpPost(url, t, callback)
end

-- 首充礼包列表
function sendFirstRechargeGiftReq(callback)
    local url = config.webHost.."receive/liBaoRech.htm"
    local t = {
        uid = CC.Player.uid,
        appKey = CC.Player.appKey,
    }
    _G.kk.ql.httpPost(url, t, callback)
end
-- 领取首充礼包
function sendGetFirstRechargeGiftReq(id, callback)
    local url = config.webHost.."receive/rechReceive.htm"
    local t = {
        uid = CC.Player.uid,
        appKey = CC.Player.appKey,
        baoId = id,
    }
    _G.kk.ql.httpPost(url, t, callback)
end
-- lua 人气
function sendGetLuaGamePeopleReq(callback)
    local url = config.webHost.."gameList/gamePopu.htm"
    local t = {
        uid = CC.Player.uid,
        appKey = CC.Player.appKey,
    }
    _G.kk.ql.httpPost(url, t, callback)
end
-- 充值记录
function sendRechargeRecordReq(page, pageSize, callback)
    local url = config.webHost.."recharge/list.htm"
    local t = {
        uid = CC.Player.uid,
        appKey = CC.Player.appKey,
        page = page,
        pageSize = pageSize,
    }
    _G.kk.ql.httpPost(url, t, callback)
end
-- 商城购买记录 
function sendShopBuyRecordReq(page, pageSize, callback)
    local url = config.webHost.."UserPrize/itembuyPage.htm"
    local t = {
        uid = CC.Player.uid,
        appKey = CC.Player.appKey,
        page = page,
        pageSize = pageSize,
    }
    _G.kk.ql.httpPost(url, t, callback)
end
-- 商城物品列表
function sendShopListReq(callback)
    local url = config.webHost.."UserPrize/goosList.htm"
    local t = {
        uid = CC.Player.uid,
        appKey = CC.Player.appKey,
    }
    _G.kk.ql.httpPost(url, t, callback)
end