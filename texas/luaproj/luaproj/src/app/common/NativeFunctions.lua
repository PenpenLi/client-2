-- 调用本地(Java/OC)方法

local luaoc
local luaj
if device.platform == "ios" then
	luaoc = require("cocos.cocos2d.luaoc")
elseif device.platform == "android" then
	luaj = require("cocos.cocos2d.luaj")
end

local NativeFunctions = {}

local NativeClassAndroid = "org/cocos2dx/utils/NativeToLua"
local NativeClassIOS = "NativeToLua"

function NativeFunctions.showNativeAlertOK(options)
	local LANG =APP.GD.LANG

	local options = options or {}
    local title = options.title or LANG.UI_ALERT_DEFAULT_TITLE
    local descText = options.desc or ""
    local okText = options.ok or LANG.UI_ALERT_DEFAULT_CONFIRM
    local okCallback = options.okCallback or 0

	if device.platform == "ios" then
		local args = {
	    	title = title,
	    	okText = okText,
	    	descText = descText,
	    	okCallback = okCallback
		}
     	luaoc.callStaticMethod(NativeClassIOS, "showAlertOK", args)
    elseif device.platform == "android" then
    	local args = {title, okText, descText, okCallback}
    	local sigs = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V"
    	luaj.callStaticMethod(NativeClassAndroid, "showAlertOKCancel", args, sigs)
    end
end

function NativeFunctions.showNativeAlertOKCancel(options)
	local LANG =APP.GD.LANG

	local options = options or {}
    local title = options.title or LANG.UI_ALERT_DEFAULT_TITLE
    local descText = options.desc or ""
    local okText = options.ok or LANG.UI_ALERT_DEFAULT_CONFIRM
    local cancelText = options.cancel or LANG.UI_ALERT_DEFAULT_CANCEL
    local okCallback = options.okCallback or 0
    local cancelCallback = options.cancelCallback or 0

    if device.platform == "ios" then
	    local args = {
	    	title = title,
	    	okText = okText,
	    	cancelText = cancelText,
	    	descText = descText,
	    	okCallback = okCallback,
	    	cancelCallback = cancelCallback
		}
	    luaoc.callStaticMethod(NativeClassIOS, "showAlertOKCancel", args)
	elseif device.platform == "android" then
		local args = {title, okText, cancelText, descText, okCallback, cancelCallback}
    	local sigs = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;II)V"
    	luaj.callStaticMethod(NativeClassAndroid, "showAlertOKCancel", args, sigs)
	end
end

function NativeFunctions.openURL(url)
	if device.platform == "ios" then
	    local args = {
	    	url = url
		}
	    luaoc.callStaticMethod(NativeClassIOS, "openURL", args)
	elseif device.platform == "android" then
		local args = {url}
    	local sigs = "(Ljava/lang/String;)V"
    	luaj.callStaticMethod(NativeClassAndroid, "openURL", args, sigs)
	end
end

function NativeFunctions.getMacAddress()
	if device.platform == "ios" then
	    local args = nil
	    return luaoc.callStaticMethod(NativeClassIOS, "getMacAddress", args)
	elseif device.platform == "android" then
		local args = {}
    	local sigs = "()Ljava/lang/String;"
    	return luaj.callStaticMethod(NativeClassAndroid, "getMacAddress", args, sigs)
	end
end

function NativeFunctions.getOpenUDID()
	if device.platform == "ios" then
	    local args = nil
	    return luaoc.callStaticMethod(NativeClassIOS, "getOpenUDID", args)
	elseif device.platform == "android" then
		local args = {}
    	local sigs = "()Ljava/lang/String;"
    	return luaj.callStaticMethod(NativeClassAndroid, "getOpenUDID", args, sigs)
	end
end

function NativeFunctions.getDeviceName()
	if device.platform == "ios" then
	    local args = nil
	    return luaoc.callStaticMethod(NativeClassIOS, "getDeviceName", args)
	elseif device.platform == "android" then
		local args = {}
    	local sigs = "()Ljava/lang/String;"
    	return luaj.callStaticMethod(NativeClassAndroid, "getDeviceName", args, sigs)
	end
end

-- 震动，time单位毫秒
function NativeFunctions.vibrate(time)
	if not APP.GD:vibrateOn() then
		return
	end
	if device.platform == "ios" then
	    local args = {
	    	time = time
		}
	    luaoc.callStaticMethod(NativeClassIOS, "vibrate", args)
	elseif device.platform == "android" then
		local args = {time}
    	local sigs = "(J)V"
    	luaj.callStaticMethod(NativeClassAndroid, "vibrate", args, sigs)
	end
end

return NativeFunctions