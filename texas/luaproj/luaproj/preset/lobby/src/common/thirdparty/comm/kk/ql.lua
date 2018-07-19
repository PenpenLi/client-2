
local _G = _G
local json = json
local timer = import(".timer")

module("comm.kk.ql")

function httpPost(url, tbl, callback)
    _G.cclog("[Web:httpPost]:%s %s", url, _G.json.encode(tbl))
    _G.http_post(url, tbl, callback)
end

function httpPostWithCd(url, tbl, callback, cd)
    _G.cclog("[Web:httpPostWithCd]:%s %s", url, _G.json.encode(tbl))
    _G.http_post(url, tbl, function(rsp)
        timer.delayOnce(cd or 0.5, callback, rsp)
    end)
end

function httpPostWithRetry(url, tbl, callback, cd, maxRetry)
    _G.cclog("[Web:httpPostWithRetry]:%s %s", url, _G.json.encode(tbl))
    maxRetry = maxRetry or 3
    local function innerCallback(rsp, curRetry)
        if not rsp.success and rsp.message == "网络异常，请检查本地网络设置。" and curRetry < maxRetry then
            _G.http_post(url, tbl, function(rsp2)
                innerCallback(rsp2, curRetry + 1)
            end)
        else
            timer.delayOnce(cd or 0.5, callback, rsp)
        end
    end
    _G.http_post(url, tbl, function(rsp)
        innerCallback(rsp, 1)
    end)
end

function createSuccess()
    return { success = true, message = "" }
end

function createError(msg)
    return { success = false, message = msg }
end
