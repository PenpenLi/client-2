
local _G = _G

module("comm.kk.util", package.seeall)

--货币转换为短字符串一共保留4位数字
function convertMoneyToShortString(num)
    local str = ""
    num = tonumber(num)
    if num then
        str = tostring(math.floor(num))
    end
    local l = string.len(str)
    if l <= 5 then
        return str
    elseif l > 5 and l <= 8 then
        return string.format("%."..(8 - l).."f万", num / 10000)
    elseif l > 8 and l <= 12 then
        return string.format("%."..(12 - l).."f亿", num / 100000000)
    else
        return string.format("%d亿", math.floor(num / 100000000))
    end
    return str
end
--货币转换为短字符串不包含小数
function convertMoneyToShortStringInt(num)
    local str = ""
    num = tonumber(num)
    if num then
        str = tostring(math.floor(num))
    end
    local l = string.len(str)
    if l < 5 then
        return str
    elseif l < 9 then
        return string.sub(str, 1, -5).."万"
    end
    return string.sub(str, 1, -9).."亿"
end
--除以相应比例转换为rmb
function convertMoneyToRmb(num)
    return string.format(num % 100 == 0 and "%d" or "%d", math.floor(num / 100))
end
--文件大小转换为字符串
function convertFileSize2String(size)
    local s = ""
    local size = tonumber(size)
    if size and size > 0 then
        if size < 1024 then
            s = string.format("%dBytes", size)
        elseif size < 1024 * 1024 then
            s = string.format("%dKB", size / 1024)
        else
            s = string.format("%.1fMB", size / 1024 / 1024)
        end
    end
    return s
end

-- 异步资源加载
function asyncLoadResource(plists, callback)
    local count = #plists
    local loaded = 0
    local function loadResourceCallback(plist)
        loaded = loaded + 1
        cc.SpriteFrameCache:getInstance():addSpriteFrames(plist)
        if loaded == count then
            tryInvoke(callback)
        end
    end
    local texcache = cc.Director:getInstance():getTextureCache()
    for i=1,count do
        local plist = plists[i]
        local png = string.sub(plist, 1, -6) .. "png"
        texcache:addImageAsync(png, function(tex)
            loadResourceCallback(plist)
        end)
    end
end

-- 判断图片路径是否存在合图里
function isExitPathOnPlist(path)
    return not not _G.cc.SpriteFrameCache:getInstance():getSpriteFrame(path)
end

--获取平台类型字符串，返回：pc android ios
function getPlatformTypeString()
    if platform_iswin32() then
        return "pc"
    elseif platform_isandroid() then
        return "android"
    elseif platform_isios() then
        return "ios"
    end
end

--获取app版本号
function getAppVersion()
    local r = ""
    if _G.get_app_version then
        r = _G.get_app_version()
    end
    return r
end

--发送错误报告
--@errType              错误类型，1：下载遇到错误 2：登录遇到错误 3：游戏中遇到错误
--@uid                  玩家的UID
--@gameStr              所在的游戏，大厅：platform 斗地主：ddz 麻将：mj ...
--@errContent           错误信息内容
--@remark               备注信息
--@callback             上传结果回调函数
function sendErrorReport(errType, uid, gameStr, errContent, remark, callback)
    local url = config.reportErrorUrl
    if url == "" then return end

    errContent = errContent .. string.format("\r\n当前时间：%s", _G.os.date("%Y-%m-%d-%H:%M:%S"))

    local platstr = getPlatformTypeString()
    local deviceInfo = type(get_device_info) == "function" and get_device_info() or "未知"
    
    local t = {
        type = errType,
        uid = uid,
        plat = platstr,
        game = gameStr,
        device = deviceInfo,
        error = errContent,
        remark = remark,
    }
    http_post(url, t, function(rsp)
        if rsp.success then
            cclog("发送错误报告成功")
        else
            ccerr("上传日志失败：%s", rsp.message)
        end
        tryInvoke(callback, rsp)
    end)
end

--获取协同服务器加入频道的Id
function getCoordinateChannelId()
    if platform_iswin32() then
        return -101
    end
    return -100
end

function analysisAppStr(str)
    local tbl = string.split(str, "&")
    if #tbl < 1 then return end
    local gp = {}
    for i=1,#tbl do
        local item = tbl[i]
        local tbl2 = string.split(item, "=")
        gp[tbl2[1]] = tbl2[2]
    end
    return gp
end