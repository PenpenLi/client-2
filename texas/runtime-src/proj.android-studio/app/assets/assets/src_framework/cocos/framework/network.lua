require "cocos.network.DeprecatedNetworkFunc"

local network = {}

function network.crateHttpRequest(callback, url, method)
    if not method then method = "GET" end
    local xhr = cc.XMLHttpRequest:new()
    xhr:open(string.upper(tostring(method)), url)
    xhr:registerScriptHandler(function()
        callback(xhr)
    end)
    return xhr
end

return network