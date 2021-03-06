#include "AppDelegate.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "cocos2d.h"
#include "scripting/lua-bindings/manual/lua_module_register.h"


#include "lua_extensions_more.h"
#include "crypto/lua_crypto.h"
#include "dragonBones/auto/dragonBones_auto.hpp"
#include "iversion_compare.h"

#if CC_TARGET_PLATFORM != CC_PLATFORM_WIN32
#include "libs/system/src/error_code.cpp"
#include "libs/iostreams/src/file_descriptor.cpp"
#include "libs/iostreams/src/mapped_file.cpp"
#include "libs/iostreams/src/zlib.cpp"
#include "libs/iostreams/src/gzip.cpp"
#include "libs/filesystem/src/path.cpp"
#include "libs/filesystem/src/operations.cpp"
#include "libs/filesystem/src/utf8_codecvt_facet.cpp"
#include "libs/thread/src/pthread/thread.cpp"
#include "libs/thread/src/pthread/once.cpp"
#include "libs/chrono/src/thread_clock.cpp"
#include "libs/chrono/src/chrono.cpp"
#include "libs/chrono/src/process_cpu_clocks.cpp"

#endif
#include "libs/locale/src/encoding/conv.hpp"
#include "libs/locale/src/encoding/codepage.cpp"

// #define USE_AUDIO_ENGINE 1
// #define USE_SIMPLE_AUDIO_ENGINE 1

#if USE_AUDIO_ENGINE && USE_SIMPLE_AUDIO_ENGINE
#error "Don't use AudioEngine and SimpleAudioEngine at the same time. Please just select one in your game!"
#endif

#if USE_AUDIO_ENGINE
#include "audio/include/AudioEngine.h"
using namespace cocos2d::experimental;
#elif USE_SIMPLE_AUDIO_ENGINE
#include "audio/include/SimpleAudioEngine.h"
using namespace CocosDenshion;
#endif

USING_NS_CC;
using namespace std;

static int tolua_Cocos2d_Function_loadChunksFromZIP(lua_State* tolua_S)
{
	return LuaEngine::getInstance()->getLuaStack()->luaLoadChunksFromZIP(tolua_S);
}

void luaopen_lua_load_chunks(lua_State *tolua_S)
{
	tolua_module(tolua_S, "cc", 0);
	tolua_beginmodule(tolua_S, "cc");
	tolua_function(tolua_S, "LuaLoadChunksFromZIP", tolua_Cocos2d_Function_loadChunksFromZIP);
	tolua_endmodule(tolua_S);
}

vsp::iversion_compare* vcp = nullptr;
AppDelegate::AppDelegate()
{
	vcp = vsp::iversion_compare::create_instance();
}

AppDelegate::~AppDelegate()
{
	if (vcp){
		delete vcp;
		vcp = nullptr;
	}

#if USE_AUDIO_ENGINE
    AudioEngine::end();
#elif USE_SIMPLE_AUDIO_ENGINE
    SimpleAudioEngine::end();
#endif

#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
    // NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
    RuntimeEngine::getInstance()->end();
#endif

}

// if you want a different context, modify the value of glContextAttrs
// it will affect all platforms
void AppDelegate::initGLContextAttrs()
{
    // set OpenGL context attributes: red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};

    GLView::setGLContextAttrs(glContextAttrs);
}

// if you want to use the package manager to install more packages, 
// don't modify or remove this function
static int register_all_packages()
{
    return 0; //flag for packages manager
}

bool AppDelegate::applicationDidFinishLaunching()
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32
	FileUtils::getInstance()->setWritablePath("./");
#endif

    // set default FPS
    Director::getInstance()->setAnimationInterval(1.0 / 30.0f);

    // register lua module
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    lua_State* L = engine->getLuaStack()->getLuaState();
    lua_module_register(L);
	luaopen_lua_extensions_more(L);
	register_lua_api(L);
	luaopen_lua_load_chunks(L);
    register_all_packages();

    LuaStack* stack = engine->getLuaStack();
    //stack->setXXTEAKeyAndSign("__8fssd_JKDddds", strlen("__8fssd_JKDddds"), "x5y6w1l0_", strlen("x5y6w1l0_"));

    //register custom function
    //register_custom_function(stack->getLuaState());
    
    // use luajit bytecode package
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
	engine->executeScriptFile("bootstart/bootstart.lua");
#elif CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
	engine->executeScriptFile("bootstart/bootstart.lua");
#elif CC_TARGET_PLATFORM == CC_PLATFORM_WIN32
	engine->executeScriptFile("bootstart/bootstart.lua");
#elif CC_TARGET_PLATFORM == CC_PLATFORM_MAC
	engine->executeScriptFile("bootstart/bootstart.lua");
#endif
    
//#if CC_64BITS
//    FileUtils::getInstance()->addSearchPath("src/64bit");
//#endif
//    FileUtils::getInstance()->addSearchPath("src");
//    FileUtils::getInstance()->addSearchPath("res");
//    if (engine->executeScriptFile("main.lua"))
//    {
//        return false;
//    }

    return true;
}

// This function will be called when the app is inactive. Note, when receiving a phone call it is invoked.
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();
	Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("APP_ENTER_BACKGROUND_EVENT");

#if USE_AUDIO_ENGINE
    AudioEngine::pauseAll();
#elif USE_SIMPLE_AUDIO_ENGINE
    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
    SimpleAudioEngine::getInstance()->pauseAllEffects();
#endif
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();
	Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("APP_ENTER_FOREGROUND_EVENT");

#if USE_AUDIO_ENGINE
    AudioEngine::resumeAll();
#elif USE_SIMPLE_AUDIO_ENGINE
    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
    SimpleAudioEngine::getInstance()->resumeAllEffects();
#endif
}
