
local AppBase = class("AppBase")

AppBase.APP_ENTER_BACKGROUND_EVENT = "APP_ENTER_BACKGROUND_EVENT"
AppBase.APP_ENTER_FOREGROUND_EVENT = "APP_ENTER_FOREGROUND_EVENT"

function AppBase:ctor(appName, packageRoot)
    printLog("a","AppBase:ctor()")

    self.name = appName
    self.packageRoot = packageRoot or "app"
    self.sceneName_ = ""
	self.objects_ = {}

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    local customListenerBg = cc.EventListenerCustom:create(AppBase.APP_ENTER_BACKGROUND_EVENT,
                                handler(self, self.onEnterBackground))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerBg, 1)
    local customListenerFg = cc.EventListenerCustom:create(AppBase.APP_ENTER_FOREGROUND_EVENT,
                                handler(self, self.onEnterForeground))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerFg, 1)
end

function AppBase:exit()
    cc.Director:getInstance():endToLua()
    if device.platform == "windows" or device.platform == "mac" then
        os.exit()
    end
end

function AppBase:run()
end

function AppBase:removeObject(obj)
    if self.objects_[obj.__cname] == obj  then
        self.objects_[obj.__cname] = nil
    end
end

function AppBase:setObject(id, object)
    printInfo("[APP] setObject: %s", id)
    self.objects_[id] = object
end

function AppBase:getObject(id)
    assert(self.objects_[id] ~= nil, string.format("MyApp:getObject() - id \"%s\" not exists", id))
    return self.objects_[id]
end

function AppBase:isObjectExists(id)
    return self.objects_[id] ~= nil
end

function AppBase:enterScene(sceneName, transition, time, more)
    if self.sceneName_ == sceneName then return end
    self.sceneName_ = sceneName
    local scenePackageName = self.packageRoot .. ".scenes." .. sceneName
    printInfo(scenePackageName)
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(unpack(checktable(args)))
    display.runScene(scene, transitionType, time, more)
end

function AppBase:createView(name, viewController, ...)
    local packageName = string.format("app.views.%s", name)
    local status, view = xpcall(function()
            return g_Require(packageName)
        end, __G__TRACKBACK__)

    local t = type(view)
    if status and (t == "table" or t == "userdata") then
        return view.new(viewController, ...)
    end
end

function AppBase:command(commandName, ...)
    printInfo("[AppBase] COMMAND: %s", commandName)
    local commandPackageName = self.packageRoot .. ".commands." .. commandName
    local commandClass = require(commandPackageName)
    commandClass.execute(...)
end

function AppBase:onEnterBackground()
    printLog("a","AppBase:onEnterBackground()")
    self:dispatchEvent({name = AppBase.APP_ENTER_BACKGROUND_EVENT})
end

function AppBase:onEnterForeground()
    printLog("a","AppBase:onEnterForeground()")
    self:dispatchEvent({name = AppBase.APP_ENTER_FOREGROUND_EVENT})
end

function AppBase:onCreate()
end

return AppBase
