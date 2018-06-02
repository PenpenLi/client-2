#include "dragonBones_auto.hpp"
#include "dragonBones/cocos2dx/CCDragonBonesHeaders.h"
#include "dragonBones/DragonBonesHeaders.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_dragonBones_BaseObject_getClassTypeIndex(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseObject_getClassTypeIndex'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseObject_getClassTypeIndex'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->getClassTypeIndex();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseObject:getClassTypeIndex",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseObject_getClassTypeIndex'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseObject_returnToPool(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseObject_returnToPool'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseObject_returnToPool'", nullptr);
            return 0;
        }
        cobj->returnToPool();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseObject:returnToPool",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseObject_returnToPool'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseObject_clearPool(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"db.BaseObject",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseObject_clearPool'", nullptr);
            return 0;
        }
        dragonBones::BaseObject::clearPool();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1)
    {
        unsigned int arg0;
        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "db.BaseObject:clearPool");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseObject_clearPool'", nullptr);
            return 0;
        }
        dragonBones::BaseObject::clearPool(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "db.BaseObject:clearPool",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseObject_clearPool'.",&tolua_err);
#endif
    return 0;
}
int lua_dragonBones_BaseObject_setMaxCount(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"db.BaseObject",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        unsigned int arg0;
        unsigned int arg1;
        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "db.BaseObject:setMaxCount");
        ok &= luaval_to_uint32(tolua_S, 3,&arg1, "db.BaseObject:setMaxCount");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseObject_setMaxCount'", nullptr);
            return 0;
        }
        dragonBones::BaseObject::setMaxCount(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "db.BaseObject:setMaxCount",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseObject_setMaxCount'.",&tolua_err);
#endif
    return 0;
}
static int lua_dragonBones_BaseObject_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (BaseObject)");
    return 0;
}

int lua_register_dragonBones_BaseObject(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.BaseObject");
    tolua_cclass(tolua_S,"BaseObject","db.BaseObject","",nullptr);

    tolua_beginmodule(tolua_S,"BaseObject");
        tolua_function(tolua_S,"getClassTypeIndex",lua_dragonBones_BaseObject_getClassTypeIndex);
        tolua_function(tolua_S,"returnToPool",lua_dragonBones_BaseObject_returnToPool);
        tolua_function(tolua_S,"clearPool", lua_dragonBones_BaseObject_clearPool);
        tolua_function(tolua_S,"setMaxCount", lua_dragonBones_BaseObject_setMaxCount);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::BaseObject).name();
    g_luaType[typeName] = "db.BaseObject";
    g_typeCast["BaseObject"] = "db.BaseObject";
    return 1;
}

int lua_dragonBones_TextureAtlasData_createTexture(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::TextureAtlasData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.TextureAtlasData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::TextureAtlasData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_TextureAtlasData_createTexture'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_TextureAtlasData_createTexture'", nullptr);
            return 0;
        }
        dragonBones::TextureData* ret = cobj->createTexture();
        object_to_luaval<dragonBones::TextureData>(tolua_S, "db.TextureData",(dragonBones::TextureData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.TextureAtlasData:createTexture",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_TextureAtlasData_createTexture'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_TextureAtlasData_getTexture(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::TextureAtlasData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.TextureAtlasData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::TextureAtlasData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_TextureAtlasData_getTexture'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.TextureAtlasData:getTexture");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_TextureAtlasData_getTexture'", nullptr);
            return 0;
        }
        dragonBones::TextureData* ret = cobj->getTexture(arg0);
        object_to_luaval<dragonBones::TextureData>(tolua_S, "db.TextureData",(dragonBones::TextureData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.TextureAtlasData:getTexture",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_TextureAtlasData_getTexture'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_TextureAtlasData_addTexture(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::TextureAtlasData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.TextureAtlasData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::TextureAtlasData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_TextureAtlasData_addTexture'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::TextureData* arg0;

        ok &= luaval_to_object<dragonBones::TextureData>(tolua_S, 2, "db.TextureData",&arg0, "db.TextureAtlasData:addTexture");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_TextureAtlasData_addTexture'", nullptr);
            return 0;
        }
        cobj->addTexture(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.TextureAtlasData:addTexture",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_TextureAtlasData_addTexture'.",&tolua_err);
#endif

    return 0;
}
static int lua_dragonBones_TextureAtlasData_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (TextureAtlasData)");
    return 0;
}

int lua_register_dragonBones_TextureAtlasData(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.TextureAtlasData");
    tolua_cclass(tolua_S,"TextureAtlasData","db.TextureAtlasData","db.BaseObject",nullptr);

    tolua_beginmodule(tolua_S,"TextureAtlasData");
        tolua_function(tolua_S,"createTexture",lua_dragonBones_TextureAtlasData_createTexture);
        tolua_function(tolua_S,"getTexture",lua_dragonBones_TextureAtlasData_getTexture);
        tolua_function(tolua_S,"addTexture",lua_dragonBones_TextureAtlasData_addTexture);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::TextureAtlasData).name();
    g_luaType[typeName] = "db.TextureAtlasData";
    g_typeCast["TextureAtlasData"] = "db.TextureAtlasData";
    return 1;
}

int lua_dragonBones_DragonBonesData_setUserData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::DragonBonesData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.DragonBonesData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::DragonBonesData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_DragonBonesData_setUserData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::UserData* arg0;

        ok &= luaval_to_object<dragonBones::UserData>(tolua_S, 2, "db.UserData",&arg0, "db.DragonBonesData:setUserData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_DragonBonesData_setUserData'", nullptr);
            return 0;
        }
        cobj->setUserData(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.DragonBonesData:setUserData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_DragonBonesData_setUserData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_DragonBonesData_getUserData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::DragonBonesData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.DragonBonesData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::DragonBonesData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_DragonBonesData_getUserData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_DragonBonesData_getUserData'", nullptr);
            return 0;
        }
        const dragonBones::UserData* ret = cobj->getUserData();
        object_to_luaval<dragonBones::UserData>(tolua_S, "db.UserData",(dragonBones::UserData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.DragonBonesData:getUserData",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_DragonBonesData_getUserData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_DragonBonesData_getFrameIndices(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::DragonBonesData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.DragonBonesData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::DragonBonesData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_DragonBonesData_getFrameIndices'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_DragonBonesData_getFrameIndices'", nullptr);
            return 0;
        }
        std::vector<unsigned int, std::allocator<unsigned int> >* ret = cobj->getFrameIndices();
        object_to_luaval<std::vector<unsigned int, std::allocator<unsigned int> >>(tolua_S, "std::vector<unsigned int, std::allocator<unsigned int> >*",(std::vector<unsigned int, std::allocator<unsigned int> >*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.DragonBonesData:getFrameIndices",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_DragonBonesData_getFrameIndices'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_DragonBonesData_getArmature(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::DragonBonesData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.DragonBonesData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::DragonBonesData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_DragonBonesData_getArmature'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.DragonBonesData:getArmature");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_DragonBonesData_getArmature'", nullptr);
            return 0;
        }
        dragonBones::ArmatureData* ret = cobj->getArmature(arg0);
        object_to_luaval<dragonBones::ArmatureData>(tolua_S, "db.ArmatureData",(dragonBones::ArmatureData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.DragonBonesData:getArmature",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_DragonBonesData_getArmature'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_DragonBonesData_getArmatureNames(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::DragonBonesData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.DragonBonesData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::DragonBonesData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_DragonBonesData_getArmatureNames'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_DragonBonesData_getArmatureNames'", nullptr);
            return 0;
        }
        const std::vector<std::string>& ret = cobj->getArmatureNames();
        ccvector_std_string_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.DragonBonesData:getArmatureNames",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_DragonBonesData_getArmatureNames'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_DragonBonesData_addArmature(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::DragonBonesData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.DragonBonesData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::DragonBonesData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_DragonBonesData_addArmature'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::ArmatureData* arg0;

        ok &= luaval_to_object<dragonBones::ArmatureData>(tolua_S, 2, "db.ArmatureData",&arg0, "db.DragonBonesData:addArmature");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_DragonBonesData_addArmature'", nullptr);
            return 0;
        }
        cobj->addArmature(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.DragonBonesData:addArmature",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_DragonBonesData_addArmature'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_DragonBonesData_getTypeIndex(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"db.DragonBonesData",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_DragonBonesData_getTypeIndex'", nullptr);
            return 0;
        }
        unsigned int ret = dragonBones::DragonBonesData::getTypeIndex();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "db.DragonBonesData:getTypeIndex",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_DragonBonesData_getTypeIndex'.",&tolua_err);
#endif
    return 0;
}
static int lua_dragonBones_DragonBonesData_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (DragonBonesData)");
    return 0;
}

int lua_register_dragonBones_DragonBonesData(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.DragonBonesData");
    tolua_cclass(tolua_S,"DragonBonesData","db.DragonBonesData","db.BaseObject",nullptr);

    tolua_beginmodule(tolua_S,"DragonBonesData");
        tolua_function(tolua_S,"setUserData",lua_dragonBones_DragonBonesData_setUserData);
        tolua_function(tolua_S,"getUserData",lua_dragonBones_DragonBonesData_getUserData);
        tolua_function(tolua_S,"getFrameIndices",lua_dragonBones_DragonBonesData_getFrameIndices);
        tolua_function(tolua_S,"getArmature",lua_dragonBones_DragonBonesData_getArmature);
        tolua_function(tolua_S,"getArmatureNames",lua_dragonBones_DragonBonesData_getArmatureNames);
        tolua_function(tolua_S,"addArmature",lua_dragonBones_DragonBonesData_addArmature);
        tolua_function(tolua_S,"getTypeIndex", lua_dragonBones_DragonBonesData_getTypeIndex);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::DragonBonesData).name();
    g_luaType[typeName] = "db.DragonBonesData";
    g_typeCast["DragonBonesData"] = "db.DragonBonesData";
    return 1;
}

int lua_dragonBones_AnimationData_cacheFrames(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationData_cacheFrames'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "db.AnimationData:cacheFrames");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationData_cacheFrames'", nullptr);
            return 0;
        }
        cobj->cacheFrames(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationData:cacheFrames",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationData_cacheFrames'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationData_getActionTimeline(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationData_getActionTimeline'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.AnimationData:getActionTimeline");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationData_getActionTimeline'", nullptr);
            return 0;
        }
        dragonBones::TimelineData* ret = cobj->getActionTimeline(arg0);
        object_to_luaval<dragonBones::TimelineData>(tolua_S, "db.TimelineData",(dragonBones::TimelineData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationData:getActionTimeline",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationData_getActionTimeline'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationData_setParent(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationData_setParent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::ArmatureData* arg0;

        ok &= luaval_to_object<dragonBones::ArmatureData>(tolua_S, 2, "db.ArmatureData",&arg0, "db.AnimationData:setParent");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationData_setParent'", nullptr);
            return 0;
        }
        cobj->setParent(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationData:setParent",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationData_setParent'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationData_setActionTimeline(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationData_setActionTimeline'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::TimelineData* arg0;

        ok &= luaval_to_object<dragonBones::TimelineData>(tolua_S, 2, "db.TimelineData",&arg0, "db.AnimationData:setActionTimeline");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationData_setActionTimeline'", nullptr);
            return 0;
        }
        cobj->setActionTimeline(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationData:setActionTimeline",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationData_setActionTimeline'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationData_getSlotCachedFrameIndices(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationData_getSlotCachedFrameIndices'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.AnimationData:getSlotCachedFrameIndices");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationData_getSlotCachedFrameIndices'", nullptr);
            return 0;
        }
        std::vector<int>* ret = cobj->getSlotCachedFrameIndices(arg0);
        object_to_luaval<std::vector<int>>(tolua_S, "std::vector<int, std::allocator<int> >*",(std::vector<int>*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationData:getSlotCachedFrameIndices",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationData_getSlotCachedFrameIndices'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationData_addSlotTimeline(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationData_addSlotTimeline'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        dragonBones::SlotData* arg0;
        dragonBones::TimelineData* arg1;

        ok &= luaval_to_object<dragonBones::SlotData>(tolua_S, 2, "db.SlotData",&arg0, "db.AnimationData:addSlotTimeline");

        ok &= luaval_to_object<dragonBones::TimelineData>(tolua_S, 3, "db.TimelineData",&arg1, "db.AnimationData:addSlotTimeline");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationData_addSlotTimeline'", nullptr);
            return 0;
        }
        cobj->addSlotTimeline(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationData:addSlotTimeline",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationData_addSlotTimeline'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationData_addConstraintTimeline(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationData_addConstraintTimeline'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        dragonBones::ConstraintData* arg0;
        dragonBones::TimelineData* arg1;

        ok &= luaval_to_object<dragonBones::ConstraintData>(tolua_S, 2, "db.ConstraintData",&arg0, "db.AnimationData:addConstraintTimeline");

        ok &= luaval_to_object<dragonBones::TimelineData>(tolua_S, 3, "db.TimelineData",&arg1, "db.AnimationData:addConstraintTimeline");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationData_addConstraintTimeline'", nullptr);
            return 0;
        }
        cobj->addConstraintTimeline(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationData:addConstraintTimeline",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationData_addConstraintTimeline'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationData_addBoneTimeline(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationData_addBoneTimeline'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        dragonBones::BoneData* arg0;
        dragonBones::TimelineData* arg1;

        ok &= luaval_to_object<dragonBones::BoneData>(tolua_S, 2, "db.BoneData",&arg0, "db.AnimationData:addBoneTimeline");

        ok &= luaval_to_object<dragonBones::TimelineData>(tolua_S, 3, "db.TimelineData",&arg1, "db.AnimationData:addBoneTimeline");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationData_addBoneTimeline'", nullptr);
            return 0;
        }
        cobj->addBoneTimeline(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationData:addBoneTimeline",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationData_addBoneTimeline'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationData_getBoneCachedFrameIndices(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationData_getBoneCachedFrameIndices'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.AnimationData:getBoneCachedFrameIndices");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationData_getBoneCachedFrameIndices'", nullptr);
            return 0;
        }
        std::vector<int>* ret = cobj->getBoneCachedFrameIndices(arg0);
        object_to_luaval<std::vector<int>>(tolua_S, "std::vector<int, std::allocator<int> >*",(std::vector<int>*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationData:getBoneCachedFrameIndices",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationData_getBoneCachedFrameIndices'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationData_getZOrderTimeline(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationData_getZOrderTimeline'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.AnimationData:getZOrderTimeline");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationData_getZOrderTimeline'", nullptr);
            return 0;
        }
        dragonBones::TimelineData* ret = cobj->getZOrderTimeline(arg0);
        object_to_luaval<dragonBones::TimelineData>(tolua_S, "db.TimelineData",(dragonBones::TimelineData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationData:getZOrderTimeline",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationData_getZOrderTimeline'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationData_setZOrderTimeline(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationData_setZOrderTimeline'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::TimelineData* arg0;

        ok &= luaval_to_object<dragonBones::TimelineData>(tolua_S, 2, "db.TimelineData",&arg0, "db.AnimationData:setZOrderTimeline");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationData_setZOrderTimeline'", nullptr);
            return 0;
        }
        cobj->setZOrderTimeline(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationData:setZOrderTimeline",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationData_setZOrderTimeline'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationData_getParent(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationData_getParent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationData_getParent'", nullptr);
            return 0;
        }
        dragonBones::ArmatureData* ret = cobj->getParent();
        object_to_luaval<dragonBones::ArmatureData>(tolua_S, "db.ArmatureData",(dragonBones::ArmatureData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationData:getParent",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationData_getParent'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationData_getTypeIndex(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"db.AnimationData",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationData_getTypeIndex'", nullptr);
            return 0;
        }
        unsigned int ret = dragonBones::AnimationData::getTypeIndex();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "db.AnimationData:getTypeIndex",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationData_getTypeIndex'.",&tolua_err);
#endif
    return 0;
}
static int lua_dragonBones_AnimationData_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (AnimationData)");
    return 0;
}

int lua_register_dragonBones_AnimationData(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.AnimationData");
    tolua_cclass(tolua_S,"AnimationData","db.AnimationData","db.BaseObject",nullptr);

    tolua_beginmodule(tolua_S,"AnimationData");
        tolua_function(tolua_S,"cacheFrames",lua_dragonBones_AnimationData_cacheFrames);
        tolua_function(tolua_S,"getActionTimeline",lua_dragonBones_AnimationData_getActionTimeline);
        tolua_function(tolua_S,"setParent",lua_dragonBones_AnimationData_setParent);
        tolua_function(tolua_S,"setActionTimeline",lua_dragonBones_AnimationData_setActionTimeline);
        tolua_function(tolua_S,"getSlotCachedFrameIndices",lua_dragonBones_AnimationData_getSlotCachedFrameIndices);
        tolua_function(tolua_S,"addSlotTimeline",lua_dragonBones_AnimationData_addSlotTimeline);
        tolua_function(tolua_S,"addConstraintTimeline",lua_dragonBones_AnimationData_addConstraintTimeline);
        tolua_function(tolua_S,"addBoneTimeline",lua_dragonBones_AnimationData_addBoneTimeline);
        tolua_function(tolua_S,"getBoneCachedFrameIndices",lua_dragonBones_AnimationData_getBoneCachedFrameIndices);
        tolua_function(tolua_S,"getZOrderTimeline",lua_dragonBones_AnimationData_getZOrderTimeline);
        tolua_function(tolua_S,"setZOrderTimeline",lua_dragonBones_AnimationData_setZOrderTimeline);
        tolua_function(tolua_S,"getParent",lua_dragonBones_AnimationData_getParent);
        tolua_function(tolua_S,"getTypeIndex", lua_dragonBones_AnimationData_getTypeIndex);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::AnimationData).name();
    g_luaType[typeName] = "db.AnimationData";
    g_typeCast["AnimationData"] = "db.AnimationData";
    return 1;
}

int lua_dragonBones_AnimationConfig_getFadeOutMode(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationConfig* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationConfig*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationConfig_getFadeOutMode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationConfig_getFadeOutMode'", nullptr);
            return 0;
        }
        int ret = cobj->getFadeOutMode();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationConfig:getFadeOutMode",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationConfig_getFadeOutMode'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationConfig_clear(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationConfig* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationConfig*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationConfig_clear'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationConfig_clear'", nullptr);
            return 0;
        }
        cobj->clear();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationConfig:clear",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationConfig_clear'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationConfig_setFadeOutTweenType(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationConfig* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationConfig*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationConfig_setFadeOutTweenType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "db.AnimationConfig:setFadeOutTweenType");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationConfig_setFadeOutTweenType'", nullptr);
            return 0;
        }
        cobj->setFadeOutTweenType(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationConfig:setFadeOutTweenType",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationConfig_setFadeOutTweenType'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationConfig_addBoneMask(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationConfig* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationConfig*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationConfig_addBoneMask'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        dragonBones::Armature* arg0;
        std::string arg1;
        bool arg2;

        ok &= luaval_to_object<dragonBones::Armature>(tolua_S, 2, "db.Armature",&arg0, "db.AnimationConfig:addBoneMask");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.AnimationConfig:addBoneMask");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "db.AnimationConfig:addBoneMask");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationConfig_addBoneMask'", nullptr);
            return 0;
        }
        cobj->addBoneMask(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationConfig:addBoneMask",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationConfig_addBoneMask'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationConfig_containsBoneMask(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationConfig* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationConfig*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationConfig_containsBoneMask'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.AnimationConfig:containsBoneMask");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationConfig_containsBoneMask'", nullptr);
            return 0;
        }
        bool ret = cobj->containsBoneMask(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationConfig:containsBoneMask",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationConfig_containsBoneMask'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationConfig_getFadeOutTweenType(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationConfig* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationConfig*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationConfig_getFadeOutTweenType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationConfig_getFadeOutTweenType'", nullptr);
            return 0;
        }
        int ret = cobj->getFadeOutTweenType();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationConfig:getFadeOutTweenType",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationConfig_getFadeOutTweenType'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationConfig_removeBoneMask(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationConfig* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationConfig*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationConfig_removeBoneMask'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        dragonBones::Armature* arg0;
        std::string arg1;
        bool arg2;

        ok &= luaval_to_object<dragonBones::Armature>(tolua_S, 2, "db.Armature",&arg0, "db.AnimationConfig:removeBoneMask");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.AnimationConfig:removeBoneMask");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "db.AnimationConfig:removeBoneMask");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationConfig_removeBoneMask'", nullptr);
            return 0;
        }
        cobj->removeBoneMask(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationConfig:removeBoneMask",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationConfig_removeBoneMask'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationConfig_setFadeInTweenType(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationConfig* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationConfig*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationConfig_setFadeInTweenType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "db.AnimationConfig:setFadeInTweenType");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationConfig_setFadeInTweenType'", nullptr);
            return 0;
        }
        cobj->setFadeInTweenType(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationConfig:setFadeInTweenType",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationConfig_setFadeInTweenType'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationConfig_getFadeInTweenType(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationConfig* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationConfig*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationConfig_getFadeInTweenType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationConfig_getFadeInTweenType'", nullptr);
            return 0;
        }
        int ret = cobj->getFadeInTweenType();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationConfig:getFadeInTweenType",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationConfig_getFadeInTweenType'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationConfig_setFadeOutMode(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationConfig* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationConfig*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationConfig_setFadeOutMode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "db.AnimationConfig:setFadeOutMode");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationConfig_setFadeOutMode'", nullptr);
            return 0;
        }
        cobj->setFadeOutMode(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationConfig:setFadeOutMode",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationConfig_setFadeOutMode'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationConfig_getTypeIndex(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"db.AnimationConfig",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationConfig_getTypeIndex'", nullptr);
            return 0;
        }
        unsigned int ret = dragonBones::AnimationConfig::getTypeIndex();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "db.AnimationConfig:getTypeIndex",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationConfig_getTypeIndex'.",&tolua_err);
#endif
    return 0;
}
int lua_dragonBones_AnimationConfig_constructor(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationConfig* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationConfig_constructor'", nullptr);
            return 0;
        }
        cobj = new dragonBones::AnimationConfig();
        tolua_pushusertype(tolua_S,(void*)cobj,"db.AnimationConfig");
        tolua_register_gc(tolua_S,lua_gettop(tolua_S));
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationConfig:AnimationConfig",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationConfig_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_dragonBones_AnimationConfig_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (AnimationConfig)");
    return 0;
}

int lua_register_dragonBones_AnimationConfig(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.AnimationConfig");
    tolua_cclass(tolua_S,"AnimationConfig","db.AnimationConfig","db.BaseObject",nullptr);

    tolua_beginmodule(tolua_S,"AnimationConfig");
        tolua_function(tolua_S,"new",lua_dragonBones_AnimationConfig_constructor);
        tolua_function(tolua_S,"getFadeOutMode",lua_dragonBones_AnimationConfig_getFadeOutMode);
        tolua_function(tolua_S,"clear",lua_dragonBones_AnimationConfig_clear);
        tolua_function(tolua_S,"setFadeOutTweenType",lua_dragonBones_AnimationConfig_setFadeOutTweenType);
        tolua_function(tolua_S,"addBoneMask",lua_dragonBones_AnimationConfig_addBoneMask);
        tolua_function(tolua_S,"containsBoneMask",lua_dragonBones_AnimationConfig_containsBoneMask);
        tolua_function(tolua_S,"getFadeOutTweenType",lua_dragonBones_AnimationConfig_getFadeOutTweenType);
        tolua_function(tolua_S,"removeBoneMask",lua_dragonBones_AnimationConfig_removeBoneMask);
        tolua_function(tolua_S,"setFadeInTweenType",lua_dragonBones_AnimationConfig_setFadeInTweenType);
        tolua_function(tolua_S,"getFadeInTweenType",lua_dragonBones_AnimationConfig_getFadeInTweenType);
        tolua_function(tolua_S,"setFadeOutMode",lua_dragonBones_AnimationConfig_setFadeOutMode);
        tolua_function(tolua_S,"getTypeIndex", lua_dragonBones_AnimationConfig_getTypeIndex);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::AnimationConfig).name();
    g_luaType[typeName] = "db.AnimationConfig";
    g_typeCast["AnimationConfig"] = "db.AnimationConfig";
    return 1;
}

int lua_dragonBones_IEventDispatcher_addDBEventListener(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::IEventDispatcher* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.IEventDispatcher",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::IEventDispatcher*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_IEventDispatcher_addDBEventListener'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        std::function<void (dragonBones::EventObject *)> arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.IEventDispatcher:addDBEventListener");

        do {
			// Lambda binding for lua is not supported.
			assert(false);
		} while(0)
		;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_IEventDispatcher_addDBEventListener'", nullptr);
            return 0;
        }
        cobj->addDBEventListener(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.IEventDispatcher:addDBEventListener",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_IEventDispatcher_addDBEventListener'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_IEventDispatcher_hasDBEventListener(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::IEventDispatcher* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.IEventDispatcher",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::IEventDispatcher*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_IEventDispatcher_hasDBEventListener'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.IEventDispatcher:hasDBEventListener");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_IEventDispatcher_hasDBEventListener'", nullptr);
            return 0;
        }
        bool ret = cobj->hasDBEventListener(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.IEventDispatcher:hasDBEventListener",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_IEventDispatcher_hasDBEventListener'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_IEventDispatcher_removeDBEventListener(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::IEventDispatcher* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.IEventDispatcher",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::IEventDispatcher*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_IEventDispatcher_removeDBEventListener'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        std::function<void (dragonBones::EventObject *)> arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.IEventDispatcher:removeDBEventListener");

        do {
			// Lambda binding for lua is not supported.
			assert(false);
		} while(0)
		;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_IEventDispatcher_removeDBEventListener'", nullptr);
            return 0;
        }
        cobj->removeDBEventListener(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.IEventDispatcher:removeDBEventListener",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_IEventDispatcher_removeDBEventListener'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_IEventDispatcher_dispatchDBEvent(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::IEventDispatcher* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.IEventDispatcher",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::IEventDispatcher*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_IEventDispatcher_dispatchDBEvent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        dragonBones::EventObject* arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.IEventDispatcher:dispatchDBEvent");

        ok &= luaval_to_object<dragonBones::EventObject>(tolua_S, 3, "db.EventObject",&arg1, "db.IEventDispatcher:dispatchDBEvent");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_IEventDispatcher_dispatchDBEvent'", nullptr);
            return 0;
        }
        cobj->dispatchDBEvent(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.IEventDispatcher:dispatchDBEvent",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_IEventDispatcher_dispatchDBEvent'.",&tolua_err);
#endif

    return 0;
}
static int lua_dragonBones_IEventDispatcher_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (IEventDispatcher)");
    return 0;
}

int lua_register_dragonBones_IEventDispatcher(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.IEventDispatcher");
    tolua_cclass(tolua_S,"IEventDispatcher","db.IEventDispatcher","",nullptr);

    tolua_beginmodule(tolua_S,"IEventDispatcher");
        tolua_function(tolua_S,"addDBEventListener",lua_dragonBones_IEventDispatcher_addDBEventListener);
        tolua_function(tolua_S,"hasDBEventListener",lua_dragonBones_IEventDispatcher_hasDBEventListener);
        tolua_function(tolua_S,"removeDBEventListener",lua_dragonBones_IEventDispatcher_removeDBEventListener);
        tolua_function(tolua_S,"dispatchDBEvent",lua_dragonBones_IEventDispatcher_dispatchDBEvent);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::IEventDispatcher).name();
    g_luaType[typeName] = "db.IEventDispatcher";
    g_typeCast["IEventDispatcher"] = "db.IEventDispatcher";
    return 1;
}

int lua_dragonBones_IArmatureProxy_getAnimation(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::IArmatureProxy* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.IArmatureProxy",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::IArmatureProxy*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_IArmatureProxy_getAnimation'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_IArmatureProxy_getAnimation'", nullptr);
            return 0;
        }
        dragonBones::Animation* ret = cobj->getAnimation();
        object_to_luaval<dragonBones::Animation>(tolua_S, "db.Animation",(dragonBones::Animation*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.IArmatureProxy:getAnimation",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_IArmatureProxy_getAnimation'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_IArmatureProxy_dbInit(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::IArmatureProxy* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.IArmatureProxy",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::IArmatureProxy*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_IArmatureProxy_dbInit'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::Armature* arg0;

        ok &= luaval_to_object<dragonBones::Armature>(tolua_S, 2, "db.Armature",&arg0, "db.IArmatureProxy:dbInit");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_IArmatureProxy_dbInit'", nullptr);
            return 0;
        }
        cobj->dbInit(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.IArmatureProxy:dbInit",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_IArmatureProxy_dbInit'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_IArmatureProxy_dbUpdate(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::IArmatureProxy* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.IArmatureProxy",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::IArmatureProxy*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_IArmatureProxy_dbUpdate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_IArmatureProxy_dbUpdate'", nullptr);
            return 0;
        }
        cobj->dbUpdate();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.IArmatureProxy:dbUpdate",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_IArmatureProxy_dbUpdate'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_IArmatureProxy_dispose(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::IArmatureProxy* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.IArmatureProxy",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::IArmatureProxy*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_IArmatureProxy_dispose'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "db.IArmatureProxy:dispose");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_IArmatureProxy_dispose'", nullptr);
            return 0;
        }
        cobj->dispose(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.IArmatureProxy:dispose",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_IArmatureProxy_dispose'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_IArmatureProxy_getArmature(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::IArmatureProxy* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.IArmatureProxy",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::IArmatureProxy*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_IArmatureProxy_getArmature'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_IArmatureProxy_getArmature'", nullptr);
            return 0;
        }
        dragonBones::Armature* ret = cobj->getArmature();
        object_to_luaval<dragonBones::Armature>(tolua_S, "db.Armature",(dragonBones::Armature*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.IArmatureProxy:getArmature",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_IArmatureProxy_getArmature'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_IArmatureProxy_dbClear(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::IArmatureProxy* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.IArmatureProxy",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::IArmatureProxy*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_IArmatureProxy_dbClear'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_IArmatureProxy_dbClear'", nullptr);
            return 0;
        }
        cobj->dbClear();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.IArmatureProxy:dbClear",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_IArmatureProxy_dbClear'.",&tolua_err);
#endif

    return 0;
}
static int lua_dragonBones_IArmatureProxy_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (IArmatureProxy)");
    return 0;
}

int lua_register_dragonBones_IArmatureProxy(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.IArmatureProxy");
    tolua_cclass(tolua_S,"IArmatureProxy","db.IArmatureProxy","db.IEventDispatcher",nullptr);

    tolua_beginmodule(tolua_S,"IArmatureProxy");
        tolua_function(tolua_S,"getAnimation",lua_dragonBones_IArmatureProxy_getAnimation);
        tolua_function(tolua_S,"dbInit",lua_dragonBones_IArmatureProxy_dbInit);
        tolua_function(tolua_S,"dbUpdate",lua_dragonBones_IArmatureProxy_dbUpdate);
        tolua_function(tolua_S,"dispose",lua_dragonBones_IArmatureProxy_dispose);
        tolua_function(tolua_S,"getArmature",lua_dragonBones_IArmatureProxy_getArmature);
        tolua_function(tolua_S,"dbClear",lua_dragonBones_IArmatureProxy_dbClear);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::IArmatureProxy).name();
    g_luaType[typeName] = "db.IArmatureProxy";
    g_typeCast["IArmatureProxy"] = "db.IArmatureProxy";
    return 1;
}

int lua_dragonBones_IAnimatable_advanceTime(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::IAnimatable* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.IAnimatable",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::IAnimatable*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_IAnimatable_advanceTime'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "db.IAnimatable:advanceTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_IAnimatable_advanceTime'", nullptr);
            return 0;
        }
        cobj->advanceTime(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.IAnimatable:advanceTime",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_IAnimatable_advanceTime'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_IAnimatable_setClock(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::IAnimatable* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.IAnimatable",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::IAnimatable*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_IAnimatable_setClock'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::WorldClock* arg0;

        ok &= luaval_to_object<dragonBones::WorldClock>(tolua_S, 2, "db.WorldClock",&arg0, "db.IAnimatable:setClock");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_IAnimatable_setClock'", nullptr);
            return 0;
        }
        cobj->setClock(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.IAnimatable:setClock",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_IAnimatable_setClock'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_IAnimatable_getClock(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::IAnimatable* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.IAnimatable",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::IAnimatable*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_IAnimatable_getClock'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_IAnimatable_getClock'", nullptr);
            return 0;
        }
        dragonBones::WorldClock* ret = cobj->getClock();
        object_to_luaval<dragonBones::WorldClock>(tolua_S, "db.WorldClock",(dragonBones::WorldClock*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.IAnimatable:getClock",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_IAnimatable_getClock'.",&tolua_err);
#endif

    return 0;
}
static int lua_dragonBones_IAnimatable_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (IAnimatable)");
    return 0;
}

int lua_register_dragonBones_IAnimatable(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.IAnimatable");
    tolua_cclass(tolua_S,"IAnimatable","db.IAnimatable","",nullptr);

    tolua_beginmodule(tolua_S,"IAnimatable");
        tolua_function(tolua_S,"advanceTime",lua_dragonBones_IAnimatable_advanceTime);
        tolua_function(tolua_S,"setClock",lua_dragonBones_IAnimatable_setClock);
        tolua_function(tolua_S,"getClock",lua_dragonBones_IAnimatable_getClock);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::IAnimatable).name();
    g_luaType[typeName] = "db.IAnimatable";
    g_typeCast["IAnimatable"] = "db.IAnimatable";
    return 1;
}

int lua_dragonBones_Armature__addSlotToSlotList(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature__addSlotToSlotList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::Slot* arg0;

        ok &= luaval_to_object<dragonBones::Slot>(tolua_S, 2, "db.Slot",&arg0, "db.Armature:_addSlotToSlotList");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature__addSlotToSlotList'", nullptr);
            return 0;
        }
        cobj->_addSlotToSlotList(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:_addSlotToSlotList",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature__addSlotToSlotList'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getSlot(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getSlot'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Armature:getSlot");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getSlot'", nullptr);
            return 0;
        }
        dragonBones::Slot* ret = cobj->getSlot(arg0);
        object_to_luaval<dragonBones::Slot>(tolua_S, "db.Slot",(dragonBones::Slot*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getSlot",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getSlot'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getDisplay(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getDisplay'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getDisplay'", nullptr);
            return 0;
        }
        void* ret = cobj->getDisplay();
        #pragma warning NO CONVERSION FROM NATIVE FOR void*;
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getDisplay",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getDisplay'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature__sortZOrder(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature__sortZOrder'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const short* arg0;
        unsigned int arg1;

        #pragma warning NO CONVERSION TO NATIVE FOR short*
		ok = false;

        ok &= luaval_to_uint32(tolua_S, 3,&arg1, "db.Armature:_sortZOrder");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature__sortZOrder'", nullptr);
            return 0;
        }
        cobj->_sortZOrder(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:_sortZOrder",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature__sortZOrder'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature__bufferAction(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature__bufferAction'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        dragonBones::ActionData* arg0;
        bool arg1;

        ok &= luaval_to_object<dragonBones::ActionData>(tolua_S, 2, "db.ActionData",&arg0, "db.Armature:_bufferAction");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "db.Armature:_bufferAction");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature__bufferAction'", nullptr);
            return 0;
        }
        cobj->_bufferAction(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:_bufferAction",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature__bufferAction'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getCacheFrameRate(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getCacheFrameRate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getCacheFrameRate'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->getCacheFrameRate();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getCacheFrameRate",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getCacheFrameRate'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getAnimatable(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getAnimatable'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getAnimatable'", nullptr);
            return 0;
        }
        dragonBones::IAnimatable* ret = cobj->getAnimatable();
        object_to_luaval<dragonBones::IAnimatable>(tolua_S, "db.IAnimatable",(dragonBones::IAnimatable*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getAnimatable",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getAnimatable'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_removeBone(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_removeBone'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::Bone* arg0;

        ok &= luaval_to_object<dragonBones::Bone>(tolua_S, 2, "db.Bone",&arg0, "db.Armature:removeBone");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_removeBone'", nullptr);
            return 0;
        }
        cobj->removeBone(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:removeBone",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_removeBone'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getName(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getName'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getName'", nullptr);
            return 0;
        }
        const std::string& ret = cobj->getName();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getName",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getName'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_dispose(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_dispose'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_dispose'", nullptr);
            return 0;
        }
        cobj->dispose();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:dispose",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_dispose'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_addSlot(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_addSlot'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        dragonBones::Slot* arg0;
        std::string arg1;

        ok &= luaval_to_object<dragonBones::Slot>(tolua_S, 2, "db.Slot",&arg0, "db.Armature:addSlot");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.Armature:addSlot");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_addSlot'", nullptr);
            return 0;
        }
        cobj->addSlot(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:addSlot",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_addSlot'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_init(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        dragonBones::ArmatureData* arg0;
        dragonBones::IArmatureProxy* arg1;
        void* arg2;
        dragonBones::DragonBones* arg3;

        ok &= luaval_to_object<dragonBones::ArmatureData>(tolua_S, 2, "db.ArmatureData",&arg0, "db.Armature:init");

        ok &= luaval_to_object<dragonBones::IArmatureProxy>(tolua_S, 3, "db.IArmatureProxy",&arg1, "db.Armature:init");

        #pragma warning NO CONVERSION TO NATIVE FOR void*
		ok = false;

        ok &= luaval_to_object<dragonBones::DragonBones>(tolua_S, 5, "db.DragonBones",&arg3, "db.Armature:init");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_init'", nullptr);
            return 0;
        }
        cobj->init(arg0, arg1, arg2, arg3);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:init",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_init'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_invalidUpdate(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_invalidUpdate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_invalidUpdate'", nullptr);
            return 0;
        }
        cobj->invalidUpdate();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Armature:invalidUpdate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_invalidUpdate'", nullptr);
            return 0;
        }
        cobj->invalidUpdate(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        bool arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Armature:invalidUpdate");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "db.Armature:invalidUpdate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_invalidUpdate'", nullptr);
            return 0;
        }
        cobj->invalidUpdate(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:invalidUpdate",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_invalidUpdate'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getFlipY(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getFlipY'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getFlipY'", nullptr);
            return 0;
        }
        bool ret = cobj->getFlipY();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getFlipY",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getFlipY'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getFlipX(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getFlipX'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getFlipX'", nullptr);
            return 0;
        }
        bool ret = cobj->getFlipX();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getFlipX",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getFlipX'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_intersectsSegment(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_intersectsSegment'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        double arg0;
        double arg1;
        double arg2;
        double arg3;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "db.Armature:intersectsSegment");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Armature:intersectsSegment");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "db.Armature:intersectsSegment");

        ok &= luaval_to_number(tolua_S, 5,&arg3, "db.Armature:intersectsSegment");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_intersectsSegment'", nullptr);
            return 0;
        }
        dragonBones::Slot* ret = cobj->intersectsSegment(arg0, arg1, arg2, arg3);
        object_to_luaval<dragonBones::Slot>(tolua_S, "db.Slot",(dragonBones::Slot*)ret);
        return 1;
    }
    if (argc == 5) 
    {
        double arg0;
        double arg1;
        double arg2;
        double arg3;
        dragonBones::Point* arg4;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "db.Armature:intersectsSegment");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Armature:intersectsSegment");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "db.Armature:intersectsSegment");

        ok &= luaval_to_number(tolua_S, 5,&arg3, "db.Armature:intersectsSegment");

        ok &= luaval_to_object<dragonBones::Point>(tolua_S, 6, "db.Point",&arg4, "db.Armature:intersectsSegment");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_intersectsSegment'", nullptr);
            return 0;
        }
        dragonBones::Slot* ret = cobj->intersectsSegment(arg0, arg1, arg2, arg3, arg4);
        object_to_luaval<dragonBones::Slot>(tolua_S, "db.Slot",(dragonBones::Slot*)ret);
        return 1;
    }
    if (argc == 6) 
    {
        double arg0;
        double arg1;
        double arg2;
        double arg3;
        dragonBones::Point* arg4;
        dragonBones::Point* arg5;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "db.Armature:intersectsSegment");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Armature:intersectsSegment");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "db.Armature:intersectsSegment");

        ok &= luaval_to_number(tolua_S, 5,&arg3, "db.Armature:intersectsSegment");

        ok &= luaval_to_object<dragonBones::Point>(tolua_S, 6, "db.Point",&arg4, "db.Armature:intersectsSegment");

        ok &= luaval_to_object<dragonBones::Point>(tolua_S, 7, "db.Point",&arg5, "db.Armature:intersectsSegment");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_intersectsSegment'", nullptr);
            return 0;
        }
        dragonBones::Slot* ret = cobj->intersectsSegment(arg0, arg1, arg2, arg3, arg4, arg5);
        object_to_luaval<dragonBones::Slot>(tolua_S, "db.Slot",(dragonBones::Slot*)ret);
        return 1;
    }
    if (argc == 7) 
    {
        double arg0;
        double arg1;
        double arg2;
        double arg3;
        dragonBones::Point* arg4;
        dragonBones::Point* arg5;
        dragonBones::Point* arg6;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "db.Armature:intersectsSegment");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Armature:intersectsSegment");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "db.Armature:intersectsSegment");

        ok &= luaval_to_number(tolua_S, 5,&arg3, "db.Armature:intersectsSegment");

        ok &= luaval_to_object<dragonBones::Point>(tolua_S, 6, "db.Point",&arg4, "db.Armature:intersectsSegment");

        ok &= luaval_to_object<dragonBones::Point>(tolua_S, 7, "db.Point",&arg5, "db.Armature:intersectsSegment");

        ok &= luaval_to_object<dragonBones::Point>(tolua_S, 8, "db.Point",&arg6, "db.Armature:intersectsSegment");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_intersectsSegment'", nullptr);
            return 0;
        }
        dragonBones::Slot* ret = cobj->intersectsSegment(arg0, arg1, arg2, arg3, arg4, arg5, arg6);
        object_to_luaval<dragonBones::Slot>(tolua_S, "db.Slot",(dragonBones::Slot*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:intersectsSegment",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_intersectsSegment'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getBoneByDisplay(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getBoneByDisplay'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        void* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR void*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getBoneByDisplay'", nullptr);
            return 0;
        }
        dragonBones::Bone* ret = cobj->getBoneByDisplay(arg0);
        object_to_luaval<dragonBones::Bone>(tolua_S, "db.Bone",(dragonBones::Bone*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getBoneByDisplay",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getBoneByDisplay'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_setCacheFrameRate(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_setCacheFrameRate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "db.Armature:setCacheFrameRate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_setCacheFrameRate'", nullptr);
            return 0;
        }
        cobj->setCacheFrameRate(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:setCacheFrameRate",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_setCacheFrameRate'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_removeSlot(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_removeSlot'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::Slot* arg0;

        ok &= luaval_to_object<dragonBones::Slot>(tolua_S, 2, "db.Slot",&arg0, "db.Armature:removeSlot");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_removeSlot'", nullptr);
            return 0;
        }
        cobj->removeSlot(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:removeSlot",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_removeSlot'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_setFlipY(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_setFlipY'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "db.Armature:setFlipY");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_setFlipY'", nullptr);
            return 0;
        }
        cobj->setFlipY(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:setFlipY",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_setFlipY'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_setFlipX(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_setFlipX'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "db.Armature:setFlipX");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_setFlipX'", nullptr);
            return 0;
        }
        cobj->setFlipX(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:setFlipX",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_setFlipX'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_addBone(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_addBone'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        dragonBones::Bone* arg0;
        std::string arg1;

        ok &= luaval_to_object<dragonBones::Bone>(tolua_S, 2, "db.Bone",&arg0, "db.Armature:addBone");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.Armature:addBone");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_addBone'", nullptr);
            return 0;
        }
        cobj->addBone(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:addBone",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_addBone'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_addConstraint(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_addConstraint'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::Constraint* arg0;

        ok &= luaval_to_object<dragonBones::Constraint>(tolua_S, 2, "db.Constraint",&arg0, "db.Armature:addConstraint");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_addConstraint'", nullptr);
            return 0;
        }
        cobj->addConstraint(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:addConstraint",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_addConstraint'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_setReplacedTexture(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_setReplacedTexture'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        void* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR void*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_setReplacedTexture'", nullptr);
            return 0;
        }
        cobj->setReplacedTexture(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:setReplacedTexture",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_setReplacedTexture'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getArmatureData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getArmatureData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getArmatureData'", nullptr);
            return 0;
        }
        const dragonBones::ArmatureData* ret = cobj->getArmatureData();
        object_to_luaval<dragonBones::ArmatureData>(tolua_S, "db.ArmatureData",(dragonBones::ArmatureData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getArmatureData",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getArmatureData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getClassTypeIndex(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getClassTypeIndex'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getClassTypeIndex'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->getClassTypeIndex();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getClassTypeIndex",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getClassTypeIndex'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getReplacedTexture(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getReplacedTexture'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getReplacedTexture'", nullptr);
            return 0;
        }
        void* ret = cobj->getReplacedTexture();
        #pragma warning NO CONVERSION FROM NATIVE FOR void*;
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getReplacedTexture",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getReplacedTexture'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getBone(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getBone'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Armature:getBone");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getBone'", nullptr);
            return 0;
        }
        dragonBones::Bone* ret = cobj->getBone(arg0);
        object_to_luaval<dragonBones::Bone>(tolua_S, "db.Bone",(dragonBones::Bone*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getBone",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getBone'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature__addBoneToBoneList(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature__addBoneToBoneList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::Bone* arg0;

        ok &= luaval_to_object<dragonBones::Bone>(tolua_S, 2, "db.Bone",&arg0, "db.Armature:_addBoneToBoneList");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature__addBoneToBoneList'", nullptr);
            return 0;
        }
        cobj->_addBoneToBoneList(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:_addBoneToBoneList",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature__addBoneToBoneList'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getAnimation(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getAnimation'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getAnimation'", nullptr);
            return 0;
        }
        dragonBones::Animation* ret = cobj->getAnimation();
        object_to_luaval<dragonBones::Animation>(tolua_S, "db.Animation",(dragonBones::Animation*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getAnimation",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getAnimation'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getParent(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getParent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getParent'", nullptr);
            return 0;
        }
        dragonBones::Slot* ret = cobj->getParent();
        object_to_luaval<dragonBones::Slot>(tolua_S, "db.Slot",(dragonBones::Slot*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getParent",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getParent'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getSlotByDisplay(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getSlotByDisplay'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        void* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR void*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getSlotByDisplay'", nullptr);
            return 0;
        }
        dragonBones::Slot* ret = cobj->getSlotByDisplay(arg0);
        object_to_luaval<dragonBones::Slot>(tolua_S, "db.Slot",(dragonBones::Slot*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getSlotByDisplay",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getSlotByDisplay'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature__removeBoneFromBoneList(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature__removeBoneFromBoneList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::Bone* arg0;

        ok &= luaval_to_object<dragonBones::Bone>(tolua_S, 2, "db.Bone",&arg0, "db.Armature:_removeBoneFromBoneList");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature__removeBoneFromBoneList'", nullptr);
            return 0;
        }
        cobj->_removeBoneFromBoneList(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:_removeBoneFromBoneList",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature__removeBoneFromBoneList'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature__removeSlotFromSlotList(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature__removeSlotFromSlotList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::Slot* arg0;

        ok &= luaval_to_object<dragonBones::Slot>(tolua_S, 2, "db.Slot",&arg0, "db.Armature:_removeSlotFromSlotList");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature__removeSlotFromSlotList'", nullptr);
            return 0;
        }
        cobj->_removeSlotFromSlotList(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:_removeSlotFromSlotList",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature__removeSlotFromSlotList'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getEventDispatcher(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getEventDispatcher'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getEventDispatcher'", nullptr);
            return 0;
        }
        dragonBones::IEventDispatcher* ret = cobj->getEventDispatcher();
        object_to_luaval<dragonBones::IEventDispatcher>(tolua_S, "db.IEventDispatcher",(dragonBones::IEventDispatcher*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getEventDispatcher",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getEventDispatcher'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_containsPoint(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_containsPoint'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        double arg0;
        double arg1;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "db.Armature:containsPoint");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Armature:containsPoint");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_containsPoint'", nullptr);
            return 0;
        }
        dragonBones::Slot* ret = cobj->containsPoint(arg0, arg1);
        object_to_luaval<dragonBones::Slot>(tolua_S, "db.Slot",(dragonBones::Slot*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:containsPoint",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_containsPoint'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getProxy(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Armature*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Armature_getProxy'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getProxy'", nullptr);
            return 0;
        }
        dragonBones::IArmatureProxy* ret = cobj->getProxy();
        object_to_luaval<dragonBones::IArmatureProxy>(tolua_S, "db.IArmatureProxy",(dragonBones::IArmatureProxy*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:getProxy",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getProxy'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Armature_getTypeIndex(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"db.Armature",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_getTypeIndex'", nullptr);
            return 0;
        }
        unsigned int ret = dragonBones::Armature::getTypeIndex();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "db.Armature:getTypeIndex",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_getTypeIndex'.",&tolua_err);
#endif
    return 0;
}
int lua_dragonBones_Armature_constructor(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Armature* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Armature_constructor'", nullptr);
            return 0;
        }
        cobj = new dragonBones::Armature();
        tolua_pushusertype(tolua_S,(void*)cobj,"db.Armature");
        tolua_register_gc(tolua_S,lua_gettop(tolua_S));
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Armature:Armature",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Armature_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_dragonBones_Armature_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (Armature)");
    return 0;
}

int lua_register_dragonBones_Armature(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.Armature");
    tolua_cclass(tolua_S,"Armature","db.Armature","db.IAnimatable",nullptr);

    tolua_beginmodule(tolua_S,"Armature");
        tolua_function(tolua_S,"new",lua_dragonBones_Armature_constructor);
        tolua_function(tolua_S,"_addSlotToSlotList",lua_dragonBones_Armature__addSlotToSlotList);
        tolua_function(tolua_S,"getSlot",lua_dragonBones_Armature_getSlot);
        tolua_function(tolua_S,"getDisplay",lua_dragonBones_Armature_getDisplay);
        tolua_function(tolua_S,"_sortZOrder",lua_dragonBones_Armature__sortZOrder);
        tolua_function(tolua_S,"_bufferAction",lua_dragonBones_Armature__bufferAction);
        tolua_function(tolua_S,"getCacheFrameRate",lua_dragonBones_Armature_getCacheFrameRate);
        tolua_function(tolua_S,"getAnimatable",lua_dragonBones_Armature_getAnimatable);
        tolua_function(tolua_S,"removeBone",lua_dragonBones_Armature_removeBone);
        tolua_function(tolua_S,"getName",lua_dragonBones_Armature_getName);
        tolua_function(tolua_S,"dispose",lua_dragonBones_Armature_dispose);
        tolua_function(tolua_S,"addSlot",lua_dragonBones_Armature_addSlot);
        tolua_function(tolua_S,"init",lua_dragonBones_Armature_init);
        tolua_function(tolua_S,"invalidUpdate",lua_dragonBones_Armature_invalidUpdate);
        tolua_function(tolua_S,"getFlipY",lua_dragonBones_Armature_getFlipY);
        tolua_function(tolua_S,"getFlipX",lua_dragonBones_Armature_getFlipX);
        tolua_function(tolua_S,"intersectsSegment",lua_dragonBones_Armature_intersectsSegment);
        tolua_function(tolua_S,"getBoneByDisplay",lua_dragonBones_Armature_getBoneByDisplay);
        tolua_function(tolua_S,"setCacheFrameRate",lua_dragonBones_Armature_setCacheFrameRate);
        tolua_function(tolua_S,"removeSlot",lua_dragonBones_Armature_removeSlot);
        tolua_function(tolua_S,"setFlipY",lua_dragonBones_Armature_setFlipY);
        tolua_function(tolua_S,"setFlipX",lua_dragonBones_Armature_setFlipX);
        tolua_function(tolua_S,"addBone",lua_dragonBones_Armature_addBone);
        tolua_function(tolua_S,"addConstraint",lua_dragonBones_Armature_addConstraint);
        tolua_function(tolua_S,"setReplacedTexture",lua_dragonBones_Armature_setReplacedTexture);
        tolua_function(tolua_S,"getArmatureData",lua_dragonBones_Armature_getArmatureData);
        tolua_function(tolua_S,"getClassTypeIndex",lua_dragonBones_Armature_getClassTypeIndex);
        tolua_function(tolua_S,"getReplacedTexture",lua_dragonBones_Armature_getReplacedTexture);
        tolua_function(tolua_S,"getBone",lua_dragonBones_Armature_getBone);
        tolua_function(tolua_S,"_addBoneToBoneList",lua_dragonBones_Armature__addBoneToBoneList);
        tolua_function(tolua_S,"getAnimation",lua_dragonBones_Armature_getAnimation);
        tolua_function(tolua_S,"getParent",lua_dragonBones_Armature_getParent);
        tolua_function(tolua_S,"getSlotByDisplay",lua_dragonBones_Armature_getSlotByDisplay);
        tolua_function(tolua_S,"_removeBoneFromBoneList",lua_dragonBones_Armature__removeBoneFromBoneList);
        tolua_function(tolua_S,"_removeSlotFromSlotList",lua_dragonBones_Armature__removeSlotFromSlotList);
        tolua_function(tolua_S,"getEventDispatcher",lua_dragonBones_Armature_getEventDispatcher);
        tolua_function(tolua_S,"containsPoint",lua_dragonBones_Armature_containsPoint);
        tolua_function(tolua_S,"getProxy",lua_dragonBones_Armature_getProxy);
        tolua_function(tolua_S,"getTypeIndex", lua_dragonBones_Armature_getTypeIndex);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::Armature).name();
    g_luaType[typeName] = "db.Armature";
    g_typeCast["Armature"] = "db.Armature";
    return 1;
}

int lua_dragonBones_AnimationState_isCompleted(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_isCompleted'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_isCompleted'", nullptr);
            return 0;
        }
        bool ret = cobj->isCompleted();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:isCompleted",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_isCompleted'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_play(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_play'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_play'", nullptr);
            return 0;
        }
        cobj->play();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:play",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_play'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_fadeOut(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_fadeOut'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "db.AnimationState:fadeOut");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_fadeOut'", nullptr);
            return 0;
        }
        cobj->fadeOut(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        double arg0;
        bool arg1;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "db.AnimationState:fadeOut");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "db.AnimationState:fadeOut");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_fadeOut'", nullptr);
            return 0;
        }
        cobj->fadeOut(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:fadeOut",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_fadeOut'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_getName(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_getName'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_getName'", nullptr);
            return 0;
        }
        const std::string& ret = cobj->getName();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:getName",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_getName'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_stop(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_stop'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_stop'", nullptr);
            return 0;
        }
        cobj->stop();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:stop",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_stop'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_setCurrentTime(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_setCurrentTime'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "db.AnimationState:setCurrentTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_setCurrentTime'", nullptr);
            return 0;
        }
        cobj->setCurrentTime(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:setCurrentTime",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_setCurrentTime'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_getCurrentTime(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_getCurrentTime'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_getCurrentTime'", nullptr);
            return 0;
        }
        double ret = cobj->getCurrentTime();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:getCurrentTime",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_getCurrentTime'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_getTotalTime(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_getTotalTime'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_getTotalTime'", nullptr);
            return 0;
        }
        double ret = cobj->getTotalTime();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:getTotalTime",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_getTotalTime'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_init(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        dragonBones::Armature* arg0;
        dragonBones::AnimationData* arg1;
        dragonBones::AnimationConfig* arg2;

        ok &= luaval_to_object<dragonBones::Armature>(tolua_S, 2, "db.Armature",&arg0, "db.AnimationState:init");

        ok &= luaval_to_object<dragonBones::AnimationData>(tolua_S, 3, "db.AnimationData",&arg1, "db.AnimationState:init");

        ok &= luaval_to_object<dragonBones::AnimationConfig>(tolua_S, 4, "db.AnimationConfig",&arg2, "db.AnimationState:init");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_init'", nullptr);
            return 0;
        }
        cobj->init(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:init",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_init'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_isFadeIn(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_isFadeIn'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_isFadeIn'", nullptr);
            return 0;
        }
        bool ret = cobj->isFadeIn();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:isFadeIn",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_isFadeIn'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_addBoneMask(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_addBoneMask'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.AnimationState:addBoneMask");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_addBoneMask'", nullptr);
            return 0;
        }
        cobj->addBoneMask(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        bool arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.AnimationState:addBoneMask");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "db.AnimationState:addBoneMask");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_addBoneMask'", nullptr);
            return 0;
        }
        cobj->addBoneMask(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:addBoneMask",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_addBoneMask'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_containsBoneMask(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_containsBoneMask'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.AnimationState:containsBoneMask");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_containsBoneMask'", nullptr);
            return 0;
        }
        bool ret = cobj->containsBoneMask(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:containsBoneMask",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_containsBoneMask'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_removeAllBoneMask(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_removeAllBoneMask'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_removeAllBoneMask'", nullptr);
            return 0;
        }
        cobj->removeAllBoneMask();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:removeAllBoneMask",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_removeAllBoneMask'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_getAnimationData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_getAnimationData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_getAnimationData'", nullptr);
            return 0;
        }
        const dragonBones::AnimationData* ret = cobj->getAnimationData();
        object_to_luaval<dragonBones::AnimationData>(tolua_S, "db.AnimationData",(dragonBones::AnimationData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:getAnimationData",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_getAnimationData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_isFadeComplete(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_isFadeComplete'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_isFadeComplete'", nullptr);
            return 0;
        }
        bool ret = cobj->isFadeComplete();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:isFadeComplete",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_isFadeComplete'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_advanceTime(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_advanceTime'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        double arg0;
        double arg1;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "db.AnimationState:advanceTime");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.AnimationState:advanceTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_advanceTime'", nullptr);
            return 0;
        }
        cobj->advanceTime(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:advanceTime",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_advanceTime'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_isPlaying(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_isPlaying'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_isPlaying'", nullptr);
            return 0;
        }
        bool ret = cobj->isPlaying();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:isPlaying",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_isPlaying'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_removeBoneMask(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_removeBoneMask'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.AnimationState:removeBoneMask");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_removeBoneMask'", nullptr);
            return 0;
        }
        cobj->removeBoneMask(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        bool arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.AnimationState:removeBoneMask");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "db.AnimationState:removeBoneMask");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_removeBoneMask'", nullptr);
            return 0;
        }
        cobj->removeBoneMask(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:removeBoneMask",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_removeBoneMask'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_getCurrentPlayTimes(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_getCurrentPlayTimes'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_getCurrentPlayTimes'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->getCurrentPlayTimes();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:getCurrentPlayTimes",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_getCurrentPlayTimes'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_isFadeOut(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::AnimationState*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_AnimationState_isFadeOut'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_isFadeOut'", nullptr);
            return 0;
        }
        bool ret = cobj->isFadeOut();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:isFadeOut",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_isFadeOut'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_AnimationState_getTypeIndex(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"db.AnimationState",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_getTypeIndex'", nullptr);
            return 0;
        }
        unsigned int ret = dragonBones::AnimationState::getTypeIndex();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "db.AnimationState:getTypeIndex",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_getTypeIndex'.",&tolua_err);
#endif
    return 0;
}
int lua_dragonBones_AnimationState_constructor(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::AnimationState* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_AnimationState_constructor'", nullptr);
            return 0;
        }
        cobj = new dragonBones::AnimationState();
        tolua_pushusertype(tolua_S,(void*)cobj,"db.AnimationState");
        tolua_register_gc(tolua_S,lua_gettop(tolua_S));
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.AnimationState:AnimationState",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_AnimationState_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_dragonBones_AnimationState_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (AnimationState)");
    return 0;
}

int lua_register_dragonBones_AnimationState(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.AnimationState");
    tolua_cclass(tolua_S,"AnimationState","db.AnimationState","db.BaseObject",nullptr);

    tolua_beginmodule(tolua_S,"AnimationState");
        tolua_function(tolua_S,"new",lua_dragonBones_AnimationState_constructor);
        tolua_function(tolua_S,"isCompleted",lua_dragonBones_AnimationState_isCompleted);
        tolua_function(tolua_S,"play",lua_dragonBones_AnimationState_play);
        tolua_function(tolua_S,"fadeOut",lua_dragonBones_AnimationState_fadeOut);
        tolua_function(tolua_S,"getName",lua_dragonBones_AnimationState_getName);
        tolua_function(tolua_S,"stop",lua_dragonBones_AnimationState_stop);
        tolua_function(tolua_S,"setCurrentTime",lua_dragonBones_AnimationState_setCurrentTime);
        tolua_function(tolua_S,"getCurrentTime",lua_dragonBones_AnimationState_getCurrentTime);
        tolua_function(tolua_S,"getTotalTime",lua_dragonBones_AnimationState_getTotalTime);
        tolua_function(tolua_S,"init",lua_dragonBones_AnimationState_init);
        tolua_function(tolua_S,"isFadeIn",lua_dragonBones_AnimationState_isFadeIn);
        tolua_function(tolua_S,"addBoneMask",lua_dragonBones_AnimationState_addBoneMask);
        tolua_function(tolua_S,"containsBoneMask",lua_dragonBones_AnimationState_containsBoneMask);
        tolua_function(tolua_S,"removeAllBoneMask",lua_dragonBones_AnimationState_removeAllBoneMask);
        tolua_function(tolua_S,"getAnimationData",lua_dragonBones_AnimationState_getAnimationData);
        tolua_function(tolua_S,"isFadeComplete",lua_dragonBones_AnimationState_isFadeComplete);
        tolua_function(tolua_S,"advanceTime",lua_dragonBones_AnimationState_advanceTime);
        tolua_function(tolua_S,"isPlaying",lua_dragonBones_AnimationState_isPlaying);
        tolua_function(tolua_S,"removeBoneMask",lua_dragonBones_AnimationState_removeBoneMask);
        tolua_function(tolua_S,"getCurrentPlayTimes",lua_dragonBones_AnimationState_getCurrentPlayTimes);
        tolua_function(tolua_S,"isFadeOut",lua_dragonBones_AnimationState_isFadeOut);
        tolua_function(tolua_S,"getTypeIndex", lua_dragonBones_AnimationState_getTypeIndex);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::AnimationState).name();
    g_luaType[typeName] = "db.AnimationState";
    g_typeCast["AnimationState"] = "db.AnimationState";
    return 1;
}

int lua_dragonBones_Animation_init(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::Armature* arg0;

        ok &= luaval_to_object<dragonBones::Armature>(tolua_S, 2, "db.Armature",&arg0, "db.Animation:init");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_init'", nullptr);
            return 0;
        }
        cobj->init(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:init",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_init'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_gotoAndPlayByTime(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_gotoAndPlayByTime'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndPlayByTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndPlayByTime'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndPlayByTime(arg0);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        double arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndPlayByTime");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Animation:gotoAndPlayByTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndPlayByTime'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndPlayByTime(arg0, arg1);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 3) 
    {
        std::string arg0;
        double arg1;
        int arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndPlayByTime");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Animation:gotoAndPlayByTime");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "db.Animation:gotoAndPlayByTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndPlayByTime'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndPlayByTime(arg0, arg1, arg2);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:gotoAndPlayByTime",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_gotoAndPlayByTime'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_fadeIn(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_fadeIn'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:fadeIn");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_fadeIn'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->fadeIn(arg0);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        double arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:fadeIn");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Animation:fadeIn");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_fadeIn'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->fadeIn(arg0, arg1);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 3) 
    {
        std::string arg0;
        double arg1;
        int arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:fadeIn");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Animation:fadeIn");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "db.Animation:fadeIn");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_fadeIn'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->fadeIn(arg0, arg1, arg2);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 4) 
    {
        std::string arg0;
        double arg1;
        int arg2;
        int arg3;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:fadeIn");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Animation:fadeIn");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "db.Animation:fadeIn");

        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "db.Animation:fadeIn");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_fadeIn'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->fadeIn(arg0, arg1, arg2, arg3);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 5) 
    {
        std::string arg0;
        double arg1;
        int arg2;
        int arg3;
        std::string arg4;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:fadeIn");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Animation:fadeIn");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "db.Animation:fadeIn");

        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "db.Animation:fadeIn");

        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "db.Animation:fadeIn");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_fadeIn'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->fadeIn(arg0, arg1, arg2, arg3, arg4);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 6) 
    {
        std::string arg0;
        double arg1;
        int arg2;
        int arg3;
        std::string arg4;
        dragonBones::AnimationFadeOutMode arg5;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:fadeIn");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Animation:fadeIn");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "db.Animation:fadeIn");

        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "db.Animation:fadeIn");

        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "db.Animation:fadeIn");

        ok &= luaval_to_int32(tolua_S, 7,(int *)&arg5, "db.Animation:fadeIn");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_fadeIn'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->fadeIn(arg0, arg1, arg2, arg3, arg4, arg5);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:fadeIn",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_fadeIn'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_playConfig(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_playConfig'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::AnimationConfig* arg0;

        ok &= luaval_to_object<dragonBones::AnimationConfig>(tolua_S, 2, "db.AnimationConfig",&arg0, "db.Animation:playConfig");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_playConfig'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->playConfig(arg0);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:playConfig",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_playConfig'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_isCompleted(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_isCompleted'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_isCompleted'", nullptr);
            return 0;
        }
        bool ret = cobj->isCompleted();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:isCompleted",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_isCompleted'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_play(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_play'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_play'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->play();
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:play");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_play'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->play(arg0);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        int arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:play");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "db.Animation:play");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_play'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->play(arg0, arg1);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:play",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_play'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_getState(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_getState'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:getState");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_getState'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->getState(arg0);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:getState",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_getState'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_stop(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_stop'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:stop");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_stop'", nullptr);
            return 0;
        }
        cobj->stop(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:stop",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_stop'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_getLastAnimationName(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_getLastAnimationName'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_getLastAnimationName'", nullptr);
            return 0;
        }
        const std::string& ret = cobj->getLastAnimationName();
        lua_pushlstring(tolua_S,ret.c_str(),ret.length());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:getLastAnimationName",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_getLastAnimationName'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_getLastAnimationState(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_getLastAnimationState'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_getLastAnimationState'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->getLastAnimationState();
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:getLastAnimationState",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_getLastAnimationState'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_getAnimationNames(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_getAnimationNames'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_getAnimationNames'", nullptr);
            return 0;
        }
        const std::vector<std::string>& ret = cobj->getAnimationNames();
        ccvector_std_string_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:getAnimationNames",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_getAnimationNames'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_advanceTime(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_advanceTime'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "db.Animation:advanceTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_advanceTime'", nullptr);
            return 0;
        }
        cobj->advanceTime(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:advanceTime",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_advanceTime'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_isPlaying(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_isPlaying'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_isPlaying'", nullptr);
            return 0;
        }
        bool ret = cobj->isPlaying();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:isPlaying",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_isPlaying'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_gotoAndPlayByProgress(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_gotoAndPlayByProgress'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndPlayByProgress");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndPlayByProgress'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndPlayByProgress(arg0);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        double arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndPlayByProgress");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Animation:gotoAndPlayByProgress");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndPlayByProgress'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndPlayByProgress(arg0, arg1);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 3) 
    {
        std::string arg0;
        double arg1;
        int arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndPlayByProgress");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Animation:gotoAndPlayByProgress");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "db.Animation:gotoAndPlayByProgress");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndPlayByProgress'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndPlayByProgress(arg0, arg1, arg2);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:gotoAndPlayByProgress",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_gotoAndPlayByProgress'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_getAnimationConfig(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_getAnimationConfig'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_getAnimationConfig'", nullptr);
            return 0;
        }
        dragonBones::AnimationConfig* ret = cobj->getAnimationConfig();
        object_to_luaval<dragonBones::AnimationConfig>(tolua_S, "db.AnimationConfig",(dragonBones::AnimationConfig*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:getAnimationConfig",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_getAnimationConfig'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_reset(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_reset'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_reset'", nullptr);
            return 0;
        }
        cobj->reset();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:reset",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_reset'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_hasAnimation(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_hasAnimation'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:hasAnimation");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_hasAnimation'", nullptr);
            return 0;
        }
        bool ret = cobj->hasAnimation(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:hasAnimation",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_hasAnimation'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_gotoAndStopByTime(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_gotoAndStopByTime'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndStopByTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndStopByTime'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndStopByTime(arg0);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        double arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndStopByTime");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Animation:gotoAndStopByTime");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndStopByTime'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndStopByTime(arg0, arg1);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:gotoAndStopByTime",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_gotoAndStopByTime'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_gotoAndStopByProgress(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_gotoAndStopByProgress'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndStopByProgress");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndStopByProgress'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndStopByProgress(arg0);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        double arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndStopByProgress");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "db.Animation:gotoAndStopByProgress");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndStopByProgress'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndStopByProgress(arg0, arg1);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:gotoAndStopByProgress",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_gotoAndStopByProgress'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_gotoAndPlayByFrame(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_gotoAndPlayByFrame'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndPlayByFrame");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndPlayByFrame'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndPlayByFrame(arg0);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        unsigned int arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndPlayByFrame");

        ok &= luaval_to_uint32(tolua_S, 3,&arg1, "db.Animation:gotoAndPlayByFrame");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndPlayByFrame'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndPlayByFrame(arg0, arg1);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 3) 
    {
        std::string arg0;
        unsigned int arg1;
        int arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndPlayByFrame");

        ok &= luaval_to_uint32(tolua_S, 3,&arg1, "db.Animation:gotoAndPlayByFrame");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "db.Animation:gotoAndPlayByFrame");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndPlayByFrame'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndPlayByFrame(arg0, arg1, arg2);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:gotoAndPlayByFrame",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_gotoAndPlayByFrame'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_gotoAndStopByFrame(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::Animation*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_Animation_gotoAndStopByFrame'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndStopByFrame");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndStopByFrame'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndStopByFrame(arg0);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        unsigned int arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.Animation:gotoAndStopByFrame");

        ok &= luaval_to_uint32(tolua_S, 3,&arg1, "db.Animation:gotoAndStopByFrame");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_gotoAndStopByFrame'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->gotoAndStopByFrame(arg0, arg1);
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:gotoAndStopByFrame",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_gotoAndStopByFrame'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_Animation_getTypeIndex(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"db.Animation",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_getTypeIndex'", nullptr);
            return 0;
        }
        unsigned int ret = dragonBones::Animation::getTypeIndex();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "db.Animation:getTypeIndex",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_getTypeIndex'.",&tolua_err);
#endif
    return 0;
}
int lua_dragonBones_Animation_constructor(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::Animation* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_Animation_constructor'", nullptr);
            return 0;
        }
        cobj = new dragonBones::Animation();
        tolua_pushusertype(tolua_S,(void*)cobj,"db.Animation");
        tolua_register_gc(tolua_S,lua_gettop(tolua_S));
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.Animation:Animation",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_Animation_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_dragonBones_Animation_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (Animation)");
    return 0;
}

int lua_register_dragonBones_Animation(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.Animation");
    tolua_cclass(tolua_S,"Animation","db.Animation","db.BaseObject",nullptr);

    tolua_beginmodule(tolua_S,"Animation");
        tolua_function(tolua_S,"new",lua_dragonBones_Animation_constructor);
        tolua_function(tolua_S,"init",lua_dragonBones_Animation_init);
        tolua_function(tolua_S,"gotoAndPlayByTime",lua_dragonBones_Animation_gotoAndPlayByTime);
        tolua_function(tolua_S,"fadeIn",lua_dragonBones_Animation_fadeIn);
        tolua_function(tolua_S,"playConfig",lua_dragonBones_Animation_playConfig);
        tolua_function(tolua_S,"isCompleted",lua_dragonBones_Animation_isCompleted);
        tolua_function(tolua_S,"play",lua_dragonBones_Animation_play);
        tolua_function(tolua_S,"getState",lua_dragonBones_Animation_getState);
        tolua_function(tolua_S,"stop",lua_dragonBones_Animation_stop);
        tolua_function(tolua_S,"getLastAnimationName",lua_dragonBones_Animation_getLastAnimationName);
        tolua_function(tolua_S,"getLastAnimationState",lua_dragonBones_Animation_getLastAnimationState);
        tolua_function(tolua_S,"getAnimationNames",lua_dragonBones_Animation_getAnimationNames);
        tolua_function(tolua_S,"advanceTime",lua_dragonBones_Animation_advanceTime);
        tolua_function(tolua_S,"isPlaying",lua_dragonBones_Animation_isPlaying);
        tolua_function(tolua_S,"gotoAndPlayByProgress",lua_dragonBones_Animation_gotoAndPlayByProgress);
        tolua_function(tolua_S,"getAnimationConfig",lua_dragonBones_Animation_getAnimationConfig);
        tolua_function(tolua_S,"reset",lua_dragonBones_Animation_reset);
        tolua_function(tolua_S,"hasAnimation",lua_dragonBones_Animation_hasAnimation);
        tolua_function(tolua_S,"gotoAndStopByTime",lua_dragonBones_Animation_gotoAndStopByTime);
        tolua_function(tolua_S,"gotoAndStopByProgress",lua_dragonBones_Animation_gotoAndStopByProgress);
        tolua_function(tolua_S,"gotoAndPlayByFrame",lua_dragonBones_Animation_gotoAndPlayByFrame);
        tolua_function(tolua_S,"gotoAndStopByFrame",lua_dragonBones_Animation_gotoAndStopByFrame);
        tolua_function(tolua_S,"getTypeIndex", lua_dragonBones_Animation_getTypeIndex);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::Animation).name();
    g_luaType[typeName] = "db.Animation";
    g_typeCast["Animation"] = "db.Animation";
    return 1;
}

int lua_dragonBones_EventObject_getBone(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::EventObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.EventObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::EventObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_EventObject_getBone'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_EventObject_getBone'", nullptr);
            return 0;
        }
        dragonBones::Bone* ret = cobj->getBone();
        object_to_luaval<dragonBones::Bone>(tolua_S, "db.Bone",(dragonBones::Bone*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.EventObject:getBone",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_EventObject_getBone'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_EventObject_getSlot(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::EventObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.EventObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::EventObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_EventObject_getSlot'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_EventObject_getSlot'", nullptr);
            return 0;
        }
        dragonBones::Slot* ret = cobj->getSlot();
        object_to_luaval<dragonBones::Slot>(tolua_S, "db.Slot",(dragonBones::Slot*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.EventObject:getSlot",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_EventObject_getSlot'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_EventObject_getArmature(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::EventObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.EventObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::EventObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_EventObject_getArmature'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_EventObject_getArmature'", nullptr);
            return 0;
        }
        dragonBones::Armature* ret = cobj->getArmature();
        object_to_luaval<dragonBones::Armature>(tolua_S, "db.Armature",(dragonBones::Armature*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.EventObject:getArmature",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_EventObject_getArmature'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_EventObject_getAnimationState(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::EventObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.EventObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::EventObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_EventObject_getAnimationState'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_EventObject_getAnimationState'", nullptr);
            return 0;
        }
        dragonBones::AnimationState* ret = cobj->getAnimationState();
        object_to_luaval<dragonBones::AnimationState>(tolua_S, "db.AnimationState",(dragonBones::AnimationState*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.EventObject:getAnimationState",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_EventObject_getAnimationState'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_EventObject_getData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::EventObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.EventObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::EventObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_EventObject_getData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_EventObject_getData'", nullptr);
            return 0;
        }
        dragonBones::UserData* ret = cobj->getData();
        object_to_luaval<dragonBones::UserData>(tolua_S, "db.UserData",(dragonBones::UserData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.EventObject:getData",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_EventObject_getData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_EventObject_getTypeIndex(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"db.EventObject",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_EventObject_getTypeIndex'", nullptr);
            return 0;
        }
        unsigned int ret = dragonBones::EventObject::getTypeIndex();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "db.EventObject:getTypeIndex",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_EventObject_getTypeIndex'.",&tolua_err);
#endif
    return 0;
}
int lua_dragonBones_EventObject_constructor(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::EventObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_EventObject_constructor'", nullptr);
            return 0;
        }
        cobj = new dragonBones::EventObject();
        tolua_pushusertype(tolua_S,(void*)cobj,"db.EventObject");
        tolua_register_gc(tolua_S,lua_gettop(tolua_S));
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.EventObject:EventObject",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_EventObject_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_dragonBones_EventObject_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (EventObject)");
    return 0;
}

int lua_register_dragonBones_EventObject(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.EventObject");
    tolua_cclass(tolua_S,"EventObject","db.EventObject","db.BaseObject",nullptr);

    tolua_beginmodule(tolua_S,"EventObject");
        tolua_function(tolua_S,"new",lua_dragonBones_EventObject_constructor);
        tolua_function(tolua_S,"getBone",lua_dragonBones_EventObject_getBone);
        tolua_function(tolua_S,"getSlot",lua_dragonBones_EventObject_getSlot);
        tolua_function(tolua_S,"getArmature",lua_dragonBones_EventObject_getArmature);
        tolua_function(tolua_S,"getAnimationState",lua_dragonBones_EventObject_getAnimationState);
        tolua_function(tolua_S,"getData",lua_dragonBones_EventObject_getData);
        tolua_function(tolua_S,"getTypeIndex", lua_dragonBones_EventObject_getTypeIndex);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::EventObject).name();
    g_luaType[typeName] = "db.EventObject";
    g_typeCast["EventObject"] = "db.EventObject";
    return 1;
}

int lua_dragonBones_BaseFactory_replaceSkin(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_replaceSkin'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        dragonBones::Armature* arg0;
        dragonBones::SkinData* arg1;

        ok &= luaval_to_object<dragonBones::Armature>(tolua_S, 2, "db.Armature",&arg0, "db.BaseFactory:replaceSkin");

        ok &= luaval_to_object<dragonBones::SkinData>(tolua_S, 3, "db.SkinData",&arg1, "db.BaseFactory:replaceSkin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_replaceSkin'", nullptr);
            return 0;
        }
        bool ret = cobj->replaceSkin(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 3) 
    {
        dragonBones::Armature* arg0;
        dragonBones::SkinData* arg1;
        bool arg2;

        ok &= luaval_to_object<dragonBones::Armature>(tolua_S, 2, "db.Armature",&arg0, "db.BaseFactory:replaceSkin");

        ok &= luaval_to_object<dragonBones::SkinData>(tolua_S, 3, "db.SkinData",&arg1, "db.BaseFactory:replaceSkin");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "db.BaseFactory:replaceSkin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_replaceSkin'", nullptr);
            return 0;
        }
        bool ret = cobj->replaceSkin(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 4) 
    {
        dragonBones::Armature* arg0;
        dragonBones::SkinData* arg1;
        bool arg2;
        const std::vector<std::basic_string<char>, std::allocator<std::basic_string<char> > >* arg3;

        ok &= luaval_to_object<dragonBones::Armature>(tolua_S, 2, "db.Armature",&arg0, "db.BaseFactory:replaceSkin");

        ok &= luaval_to_object<dragonBones::SkinData>(tolua_S, 3, "db.SkinData",&arg1, "db.BaseFactory:replaceSkin");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "db.BaseFactory:replaceSkin");

        ok &= luaval_to_object<const std::vector<std::basic_string<char>, std::allocator<std::basic_string<char> > >>(tolua_S, 5, "std::vector<std::basic_string<char>, std::allocator<std::basic_string<char> > >*",&arg3, "db.BaseFactory:replaceSkin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_replaceSkin'", nullptr);
            return 0;
        }
        bool ret = cobj->replaceSkin(arg0, arg1, arg2, arg3);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:replaceSkin",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_replaceSkin'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_replaceAnimation(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_replaceAnimation'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        dragonBones::Armature* arg0;
        dragonBones::ArmatureData* arg1;

        ok &= luaval_to_object<dragonBones::Armature>(tolua_S, 2, "db.Armature",&arg0, "db.BaseFactory:replaceAnimation");

        ok &= luaval_to_object<dragonBones::ArmatureData>(tolua_S, 3, "db.ArmatureData",&arg1, "db.BaseFactory:replaceAnimation");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_replaceAnimation'", nullptr);
            return 0;
        }
        bool ret = cobj->replaceAnimation(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 3) 
    {
        dragonBones::Armature* arg0;
        dragonBones::ArmatureData* arg1;
        bool arg2;

        ok &= luaval_to_object<dragonBones::Armature>(tolua_S, 2, "db.Armature",&arg0, "db.BaseFactory:replaceAnimation");

        ok &= luaval_to_object<dragonBones::ArmatureData>(tolua_S, 3, "db.ArmatureData",&arg1, "db.BaseFactory:replaceAnimation");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "db.BaseFactory:replaceAnimation");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_replaceAnimation'", nullptr);
            return 0;
        }
        bool ret = cobj->replaceAnimation(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:replaceAnimation",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_replaceAnimation'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_replaceSlotDisplayList(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_replaceSlotDisplayList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        dragonBones::Slot* arg3;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:replaceSlotDisplayList");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.BaseFactory:replaceSlotDisplayList");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "db.BaseFactory:replaceSlotDisplayList");

        ok &= luaval_to_object<dragonBones::Slot>(tolua_S, 5, "db.Slot",&arg3, "db.BaseFactory:replaceSlotDisplayList");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_replaceSlotDisplayList'", nullptr);
            return 0;
        }
        bool ret = cobj->replaceSlotDisplayList(arg0, arg1, arg2, arg3);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:replaceSlotDisplayList",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_replaceSlotDisplayList'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_getClock(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_getClock'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_getClock'", nullptr);
            return 0;
        }
        dragonBones::WorldClock* ret = cobj->getClock();
        object_to_luaval<dragonBones::WorldClock>(tolua_S, "db.WorldClock",(dragonBones::WorldClock*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:getClock",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_getClock'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_removeDragonBonesData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_removeDragonBonesData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:removeDragonBonesData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_removeDragonBonesData'", nullptr);
            return 0;
        }
        cobj->removeDragonBonesData(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        bool arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:removeDragonBonesData");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "db.BaseFactory:removeDragonBonesData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_removeDragonBonesData'", nullptr);
            return 0;
        }
        cobj->removeDragonBonesData(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:removeDragonBonesData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_removeDragonBonesData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_removeTextureAtlasData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_removeTextureAtlasData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:removeTextureAtlasData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_removeTextureAtlasData'", nullptr);
            return 0;
        }
        cobj->removeTextureAtlasData(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        bool arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:removeTextureAtlasData");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "db.BaseFactory:removeTextureAtlasData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_removeTextureAtlasData'", nullptr);
            return 0;
        }
        cobj->removeTextureAtlasData(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:removeTextureAtlasData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_removeTextureAtlasData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_parseDragonBonesData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_parseDragonBonesData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "db.BaseFactory:parseDragonBonesData"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_parseDragonBonesData'", nullptr);
            return 0;
        }
        dragonBones::DragonBonesData* ret = cobj->parseDragonBonesData(arg0);
        object_to_luaval<dragonBones::DragonBonesData>(tolua_S, "db.DragonBonesData",(dragonBones::DragonBonesData*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        const char* arg0;
        std::string arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "db.BaseFactory:parseDragonBonesData"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.BaseFactory:parseDragonBonesData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_parseDragonBonesData'", nullptr);
            return 0;
        }
        dragonBones::DragonBonesData* ret = cobj->parseDragonBonesData(arg0, arg1);
        object_to_luaval<dragonBones::DragonBonesData>(tolua_S, "db.DragonBonesData",(dragonBones::DragonBonesData*)ret);
        return 1;
    }
    if (argc == 3) 
    {
        const char* arg0;
        std::string arg1;
        double arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "db.BaseFactory:parseDragonBonesData"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.BaseFactory:parseDragonBonesData");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "db.BaseFactory:parseDragonBonesData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_parseDragonBonesData'", nullptr);
            return 0;
        }
        dragonBones::DragonBonesData* ret = cobj->parseDragonBonesData(arg0, arg1, arg2);
        object_to_luaval<dragonBones::DragonBonesData>(tolua_S, "db.DragonBonesData",(dragonBones::DragonBonesData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:parseDragonBonesData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_parseDragonBonesData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_clear(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_clear'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_clear'", nullptr);
            return 0;
        }
        cobj->clear();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "db.BaseFactory:clear");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_clear'", nullptr);
            return 0;
        }
        cobj->clear(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:clear",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_clear'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_addDragonBonesData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_addDragonBonesData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::DragonBonesData* arg0;

        ok &= luaval_to_object<dragonBones::DragonBonesData>(tolua_S, 2, "db.DragonBonesData",&arg0, "db.BaseFactory:addDragonBonesData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_addDragonBonesData'", nullptr);
            return 0;
        }
        cobj->addDragonBonesData(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        dragonBones::DragonBonesData* arg0;
        std::string arg1;

        ok &= luaval_to_object<dragonBones::DragonBonesData>(tolua_S, 2, "db.DragonBonesData",&arg0, "db.BaseFactory:addDragonBonesData");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.BaseFactory:addDragonBonesData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_addDragonBonesData'", nullptr);
            return 0;
        }
        cobj->addDragonBonesData(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:addDragonBonesData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_addDragonBonesData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_buildArmature(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_buildArmature'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:buildArmature");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_buildArmature'", nullptr);
            return 0;
        }
        dragonBones::Armature* ret = cobj->buildArmature(arg0);
        object_to_luaval<dragonBones::Armature>(tolua_S, "db.Armature",(dragonBones::Armature*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        std::string arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:buildArmature");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.BaseFactory:buildArmature");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_buildArmature'", nullptr);
            return 0;
        }
        dragonBones::Armature* ret = cobj->buildArmature(arg0, arg1);
        object_to_luaval<dragonBones::Armature>(tolua_S, "db.Armature",(dragonBones::Armature*)ret);
        return 1;
    }
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:buildArmature");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.BaseFactory:buildArmature");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "db.BaseFactory:buildArmature");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_buildArmature'", nullptr);
            return 0;
        }
        dragonBones::Armature* ret = cobj->buildArmature(arg0, arg1, arg2);
        object_to_luaval<dragonBones::Armature>(tolua_S, "db.Armature",(dragonBones::Armature*)ret);
        return 1;
    }
    if (argc == 4) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:buildArmature");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.BaseFactory:buildArmature");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "db.BaseFactory:buildArmature");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "db.BaseFactory:buildArmature");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_buildArmature'", nullptr);
            return 0;
        }
        dragonBones::Armature* ret = cobj->buildArmature(arg0, arg1, arg2, arg3);
        object_to_luaval<dragonBones::Armature>(tolua_S, "db.Armature",(dragonBones::Armature*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:buildArmature",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_buildArmature'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_addTextureAtlasData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_addTextureAtlasData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::TextureAtlasData* arg0;

        ok &= luaval_to_object<dragonBones::TextureAtlasData>(tolua_S, 2, "db.TextureAtlasData",&arg0, "db.BaseFactory:addTextureAtlasData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_addTextureAtlasData'", nullptr);
            return 0;
        }
        cobj->addTextureAtlasData(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        dragonBones::TextureAtlasData* arg0;
        std::string arg1;

        ok &= luaval_to_object<dragonBones::TextureAtlasData>(tolua_S, 2, "db.TextureAtlasData",&arg0, "db.BaseFactory:addTextureAtlasData");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.BaseFactory:addTextureAtlasData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_addTextureAtlasData'", nullptr);
            return 0;
        }
        cobj->addTextureAtlasData(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:addTextureAtlasData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_addTextureAtlasData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_getArmatureData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_getArmatureData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:getArmatureData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_getArmatureData'", nullptr);
            return 0;
        }
        dragonBones::ArmatureData* ret = cobj->getArmatureData(arg0);
        object_to_luaval<dragonBones::ArmatureData>(tolua_S, "db.ArmatureData",(dragonBones::ArmatureData*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        std::string arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:getArmatureData");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.BaseFactory:getArmatureData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_getArmatureData'", nullptr);
            return 0;
        }
        dragonBones::ArmatureData* ret = cobj->getArmatureData(arg0, arg1);
        object_to_luaval<dragonBones::ArmatureData>(tolua_S, "db.ArmatureData",(dragonBones::ArmatureData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:getArmatureData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_getArmatureData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_replaceSlotDisplay(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_replaceSlotDisplay'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 5) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        dragonBones::Slot* arg4;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:replaceSlotDisplay");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.BaseFactory:replaceSlotDisplay");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "db.BaseFactory:replaceSlotDisplay");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "db.BaseFactory:replaceSlotDisplay");

        ok &= luaval_to_object<dragonBones::Slot>(tolua_S, 6, "db.Slot",&arg4, "db.BaseFactory:replaceSlotDisplay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_replaceSlotDisplay'", nullptr);
            return 0;
        }
        bool ret = cobj->replaceSlotDisplay(arg0, arg1, arg2, arg3, arg4);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 6) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        dragonBones::Slot* arg4;
        int arg5;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:replaceSlotDisplay");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.BaseFactory:replaceSlotDisplay");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "db.BaseFactory:replaceSlotDisplay");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "db.BaseFactory:replaceSlotDisplay");

        ok &= luaval_to_object<dragonBones::Slot>(tolua_S, 6, "db.Slot",&arg4, "db.BaseFactory:replaceSlotDisplay");

        ok &= luaval_to_int32(tolua_S, 7,(int *)&arg5, "db.BaseFactory:replaceSlotDisplay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_replaceSlotDisplay'", nullptr);
            return 0;
        }
        bool ret = cobj->replaceSlotDisplay(arg0, arg1, arg2, arg3, arg4, arg5);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:replaceSlotDisplay",argc, 5);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_replaceSlotDisplay'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_changeSkin(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_changeSkin'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        dragonBones::Armature* arg0;
        dragonBones::SkinData* arg1;

        ok &= luaval_to_object<dragonBones::Armature>(tolua_S, 2, "db.Armature",&arg0, "db.BaseFactory:changeSkin");

        ok &= luaval_to_object<dragonBones::SkinData>(tolua_S, 3, "db.SkinData",&arg1, "db.BaseFactory:changeSkin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_changeSkin'", nullptr);
            return 0;
        }
        bool ret = cobj->changeSkin(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 3) 
    {
        dragonBones::Armature* arg0;
        dragonBones::SkinData* arg1;
        const std::vector<std::basic_string<char>, std::allocator<std::basic_string<char> > >* arg2;

        ok &= luaval_to_object<dragonBones::Armature>(tolua_S, 2, "db.Armature",&arg0, "db.BaseFactory:changeSkin");

        ok &= luaval_to_object<dragonBones::SkinData>(tolua_S, 3, "db.SkinData",&arg1, "db.BaseFactory:changeSkin");

        ok &= luaval_to_object<const std::vector<std::basic_string<char>, std::allocator<std::basic_string<char> > >>(tolua_S, 4, "std::vector<std::basic_string<char>, std::allocator<std::basic_string<char> > >*",&arg2, "db.BaseFactory:changeSkin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_changeSkin'", nullptr);
            return 0;
        }
        bool ret = cobj->changeSkin(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:changeSkin",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_changeSkin'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_replaceDisplay(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_replaceDisplay'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        dragonBones::Slot* arg0;
        dragonBones::DisplayData* arg1;
        int arg2;

        ok &= luaval_to_object<dragonBones::Slot>(tolua_S, 2, "db.Slot",&arg0, "db.BaseFactory:replaceDisplay");

        ok &= luaval_to_object<dragonBones::DisplayData>(tolua_S, 3, "db.DisplayData",&arg1, "db.BaseFactory:replaceDisplay");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "db.BaseFactory:replaceDisplay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_replaceDisplay'", nullptr);
            return 0;
        }
        cobj->replaceDisplay(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:replaceDisplay",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_replaceDisplay'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_parseTextureAtlasData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_parseTextureAtlasData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        void* arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "db.BaseFactory:parseTextureAtlasData"); arg0 = arg0_tmp.c_str();

        #pragma warning NO CONVERSION TO NATIVE FOR void*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_parseTextureAtlasData'", nullptr);
            return 0;
        }
        dragonBones::TextureAtlasData* ret = cobj->parseTextureAtlasData(arg0, arg1);
        object_to_luaval<dragonBones::TextureAtlasData>(tolua_S, "db.TextureAtlasData",(dragonBones::TextureAtlasData*)ret);
        return 1;
    }
    if (argc == 3) 
    {
        const char* arg0;
        void* arg1;
        std::string arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "db.BaseFactory:parseTextureAtlasData"); arg0 = arg0_tmp.c_str();

        #pragma warning NO CONVERSION TO NATIVE FOR void*
		ok = false;

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "db.BaseFactory:parseTextureAtlasData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_parseTextureAtlasData'", nullptr);
            return 0;
        }
        dragonBones::TextureAtlasData* ret = cobj->parseTextureAtlasData(arg0, arg1, arg2);
        object_to_luaval<dragonBones::TextureAtlasData>(tolua_S, "db.TextureAtlasData",(dragonBones::TextureAtlasData*)ret);
        return 1;
    }
    if (argc == 4) 
    {
        const char* arg0;
        void* arg1;
        std::string arg2;
        double arg3;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "db.BaseFactory:parseTextureAtlasData"); arg0 = arg0_tmp.c_str();

        #pragma warning NO CONVERSION TO NATIVE FOR void*
		ok = false;

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "db.BaseFactory:parseTextureAtlasData");

        ok &= luaval_to_number(tolua_S, 5,&arg3, "db.BaseFactory:parseTextureAtlasData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_parseTextureAtlasData'", nullptr);
            return 0;
        }
        dragonBones::TextureAtlasData* ret = cobj->parseTextureAtlasData(arg0, arg1, arg2, arg3);
        object_to_luaval<dragonBones::TextureAtlasData>(tolua_S, "db.TextureAtlasData",(dragonBones::TextureAtlasData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:parseTextureAtlasData",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_parseTextureAtlasData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_BaseFactory_getDragonBonesData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::BaseFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.BaseFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::BaseFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_BaseFactory_getDragonBonesData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.BaseFactory:getDragonBonesData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_BaseFactory_getDragonBonesData'", nullptr);
            return 0;
        }
        dragonBones::DragonBonesData* ret = cobj->getDragonBonesData(arg0);
        object_to_luaval<dragonBones::DragonBonesData>(tolua_S, "db.DragonBonesData",(dragonBones::DragonBonesData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.BaseFactory:getDragonBonesData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_BaseFactory_getDragonBonesData'.",&tolua_err);
#endif

    return 0;
}
static int lua_dragonBones_BaseFactory_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (BaseFactory)");
    return 0;
}

int lua_register_dragonBones_BaseFactory(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.BaseFactory");
    tolua_cclass(tolua_S,"BaseFactory","db.BaseFactory","",nullptr);

    tolua_beginmodule(tolua_S,"BaseFactory");
        tolua_function(tolua_S,"replaceSkin",lua_dragonBones_BaseFactory_replaceSkin);
        tolua_function(tolua_S,"replaceAnimation",lua_dragonBones_BaseFactory_replaceAnimation);
        tolua_function(tolua_S,"replaceSlotDisplayList",lua_dragonBones_BaseFactory_replaceSlotDisplayList);
        tolua_function(tolua_S,"getClock",lua_dragonBones_BaseFactory_getClock);
        tolua_function(tolua_S,"removeDragonBonesData",lua_dragonBones_BaseFactory_removeDragonBonesData);
        tolua_function(tolua_S,"removeTextureAtlasData",lua_dragonBones_BaseFactory_removeTextureAtlasData);
        tolua_function(tolua_S,"parseDragonBonesData",lua_dragonBones_BaseFactory_parseDragonBonesData);
        tolua_function(tolua_S,"clear",lua_dragonBones_BaseFactory_clear);
        tolua_function(tolua_S,"addDragonBonesData",lua_dragonBones_BaseFactory_addDragonBonesData);
        tolua_function(tolua_S,"buildArmature",lua_dragonBones_BaseFactory_buildArmature);
        tolua_function(tolua_S,"addTextureAtlasData",lua_dragonBones_BaseFactory_addTextureAtlasData);
        tolua_function(tolua_S,"getArmatureData",lua_dragonBones_BaseFactory_getArmatureData);
        tolua_function(tolua_S,"replaceSlotDisplay",lua_dragonBones_BaseFactory_replaceSlotDisplay);
        tolua_function(tolua_S,"changeSkin",lua_dragonBones_BaseFactory_changeSkin);
        tolua_function(tolua_S,"replaceDisplay",lua_dragonBones_BaseFactory_replaceDisplay);
        tolua_function(tolua_S,"parseTextureAtlasData",lua_dragonBones_BaseFactory_parseTextureAtlasData);
        tolua_function(tolua_S,"getDragonBonesData",lua_dragonBones_BaseFactory_getDragonBonesData);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::BaseFactory).name();
    g_luaType[typeName] = "db.BaseFactory";
    g_typeCast["BaseFactory"] = "db.BaseFactory";
    return 1;
}

int lua_dragonBones_CCTextureAtlasData_setRenderTexture(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCTextureAtlasData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCTextureAtlasData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCTextureAtlasData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCTextureAtlasData_setRenderTexture'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Texture2D* arg0;

        ok &= luaval_to_object<cocos2d::Texture2D>(tolua_S, 2, "cc.Texture2D",&arg0, "db.CCTextureAtlasData:setRenderTexture");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCTextureAtlasData_setRenderTexture'", nullptr);
            return 0;
        }
        cobj->setRenderTexture(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCTextureAtlasData:setRenderTexture",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCTextureAtlasData_setRenderTexture'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCTextureAtlasData_getRenderTexture(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCTextureAtlasData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCTextureAtlasData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCTextureAtlasData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCTextureAtlasData_getRenderTexture'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCTextureAtlasData_getRenderTexture'", nullptr);
            return 0;
        }
        cocos2d::Texture2D* ret = cobj->getRenderTexture();
        object_to_luaval<cocos2d::Texture2D>(tolua_S, "cc.Texture2D",(cocos2d::Texture2D*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCTextureAtlasData:getRenderTexture",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCTextureAtlasData_getRenderTexture'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCTextureAtlasData_getTypeIndex(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"db.CCTextureAtlasData",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCTextureAtlasData_getTypeIndex'", nullptr);
            return 0;
        }
        unsigned int ret = dragonBones::CCTextureAtlasData::getTypeIndex();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "db.CCTextureAtlasData:getTypeIndex",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCTextureAtlasData_getTypeIndex'.",&tolua_err);
#endif
    return 0;
}
static int lua_dragonBones_CCTextureAtlasData_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CCTextureAtlasData)");
    return 0;
}

int lua_register_dragonBones_CCTextureAtlasData(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.CCTextureAtlasData");
    tolua_cclass(tolua_S,"CCTextureAtlasData","db.CCTextureAtlasData","db.TextureAtlasData",nullptr);

    tolua_beginmodule(tolua_S,"CCTextureAtlasData");
        tolua_function(tolua_S,"setRenderTexture",lua_dragonBones_CCTextureAtlasData_setRenderTexture);
        tolua_function(tolua_S,"getRenderTexture",lua_dragonBones_CCTextureAtlasData_getRenderTexture);
        tolua_function(tolua_S,"getTypeIndex", lua_dragonBones_CCTextureAtlasData_getTypeIndex);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::CCTextureAtlasData).name();
    g_luaType[typeName] = "db.CCTextureAtlasData";
    g_typeCast["CCTextureAtlasData"] = "db.CCTextureAtlasData";
    return 1;
}

int lua_dragonBones_CCArmatureDisplay_getAnimation(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCArmatureDisplay* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCArmatureDisplay",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCArmatureDisplay*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCArmatureDisplay_getAnimation'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCArmatureDisplay_getAnimation'", nullptr);
            return 0;
        }
        dragonBones::Animation* ret = cobj->getAnimation();
        object_to_luaval<dragonBones::Animation>(tolua_S, "db.Animation",(dragonBones::Animation*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCArmatureDisplay:getAnimation",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCArmatureDisplay_getAnimation'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCArmatureDisplay_hasDBEventListener(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCArmatureDisplay* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCArmatureDisplay",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCArmatureDisplay*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCArmatureDisplay_hasDBEventListener'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCArmatureDisplay:hasDBEventListener");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCArmatureDisplay_hasDBEventListener'", nullptr);
            return 0;
        }
        bool ret = cobj->hasDBEventListener(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCArmatureDisplay:hasDBEventListener",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCArmatureDisplay_hasDBEventListener'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCArmatureDisplay_dbInit(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCArmatureDisplay* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCArmatureDisplay",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCArmatureDisplay*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCArmatureDisplay_dbInit'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        dragonBones::Armature* arg0;

        ok &= luaval_to_object<dragonBones::Armature>(tolua_S, 2, "db.Armature",&arg0, "db.CCArmatureDisplay:dbInit");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCArmatureDisplay_dbInit'", nullptr);
            return 0;
        }
        cobj->dbInit(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCArmatureDisplay:dbInit",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCArmatureDisplay_dbInit'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCArmatureDisplay_addDBEventListener(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCArmatureDisplay* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCArmatureDisplay",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCArmatureDisplay*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCArmatureDisplay_addDBEventListener'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        std::function<void (dragonBones::EventObject *)> arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCArmatureDisplay:addDBEventListener");

        do {
			// Lambda binding for lua is not supported.
			assert(false);
		} while(0)
		;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCArmatureDisplay_addDBEventListener'", nullptr);
            return 0;
        }
        cobj->addDBEventListener(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCArmatureDisplay:addDBEventListener",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCArmatureDisplay_addDBEventListener'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCArmatureDisplay_dbUpdate(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCArmatureDisplay* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCArmatureDisplay",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCArmatureDisplay*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCArmatureDisplay_dbUpdate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCArmatureDisplay_dbUpdate'", nullptr);
            return 0;
        }
        cobj->dbUpdate();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCArmatureDisplay:dbUpdate",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCArmatureDisplay_dbUpdate'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCArmatureDisplay_dispatchDBEvent(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCArmatureDisplay* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCArmatureDisplay",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCArmatureDisplay*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCArmatureDisplay_dispatchDBEvent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        dragonBones::EventObject* arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCArmatureDisplay:dispatchDBEvent");

        ok &= luaval_to_object<dragonBones::EventObject>(tolua_S, 3, "db.EventObject",&arg1, "db.CCArmatureDisplay:dispatchDBEvent");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCArmatureDisplay_dispatchDBEvent'", nullptr);
            return 0;
        }
        cobj->dispatchDBEvent(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCArmatureDisplay:dispatchDBEvent",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCArmatureDisplay_dispatchDBEvent'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCArmatureDisplay_dispose(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCArmatureDisplay* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCArmatureDisplay",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCArmatureDisplay*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCArmatureDisplay_dispose'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCArmatureDisplay_dispose'", nullptr);
            return 0;
        }
        cobj->dispose();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "db.CCArmatureDisplay:dispose");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCArmatureDisplay_dispose'", nullptr);
            return 0;
        }
        cobj->dispose(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCArmatureDisplay:dispose",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCArmatureDisplay_dispose'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCArmatureDisplay_getArmature(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCArmatureDisplay* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCArmatureDisplay",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCArmatureDisplay*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCArmatureDisplay_getArmature'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCArmatureDisplay_getArmature'", nullptr);
            return 0;
        }
        dragonBones::Armature* ret = cobj->getArmature();
        object_to_luaval<dragonBones::Armature>(tolua_S, "db.Armature",(dragonBones::Armature*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCArmatureDisplay:getArmature",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCArmatureDisplay_getArmature'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCArmatureDisplay_removeDBEventListener(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCArmatureDisplay* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCArmatureDisplay",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCArmatureDisplay*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCArmatureDisplay_removeDBEventListener'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        std::function<void (dragonBones::EventObject *)> arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCArmatureDisplay:removeDBEventListener");

        do {
			// Lambda binding for lua is not supported.
			assert(false);
		} while(0)
		;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCArmatureDisplay_removeDBEventListener'", nullptr);
            return 0;
        }
        cobj->removeDBEventListener(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCArmatureDisplay:removeDBEventListener",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCArmatureDisplay_removeDBEventListener'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCArmatureDisplay_dbClear(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCArmatureDisplay* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCArmatureDisplay",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCArmatureDisplay*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCArmatureDisplay_dbClear'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCArmatureDisplay_dbClear'", nullptr);
            return 0;
        }
        cobj->dbClear();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCArmatureDisplay:dbClear",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCArmatureDisplay_dbClear'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCArmatureDisplay_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"db.CCArmatureDisplay",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCArmatureDisplay_create'", nullptr);
            return 0;
        }
        dragonBones::CCArmatureDisplay* ret = dragonBones::CCArmatureDisplay::create();
        object_to_luaval<dragonBones::CCArmatureDisplay>(tolua_S, "db.CCArmatureDisplay",(dragonBones::CCArmatureDisplay*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "db.CCArmatureDisplay:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCArmatureDisplay_create'.",&tolua_err);
#endif
    return 0;
}
int lua_dragonBones_CCArmatureDisplay_constructor(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCArmatureDisplay* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCArmatureDisplay_constructor'", nullptr);
            return 0;
        }
        cobj = new dragonBones::CCArmatureDisplay();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"db.CCArmatureDisplay");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCArmatureDisplay:CCArmatureDisplay",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCArmatureDisplay_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_dragonBones_CCArmatureDisplay_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CCArmatureDisplay)");
    return 0;
}

int lua_register_dragonBones_CCArmatureDisplay(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.CCArmatureDisplay");
    tolua_cclass(tolua_S,"CCArmatureDisplay","db.CCArmatureDisplay","cc.Node",nullptr);

    tolua_beginmodule(tolua_S,"CCArmatureDisplay");
        tolua_function(tolua_S,"new",lua_dragonBones_CCArmatureDisplay_constructor);
        tolua_function(tolua_S,"getAnimation",lua_dragonBones_CCArmatureDisplay_getAnimation);
        tolua_function(tolua_S,"hasDBEventListener",lua_dragonBones_CCArmatureDisplay_hasDBEventListener);
        tolua_function(tolua_S,"dbInit",lua_dragonBones_CCArmatureDisplay_dbInit);
        tolua_function(tolua_S,"addDBEventListener",lua_dragonBones_CCArmatureDisplay_addDBEventListener);
        tolua_function(tolua_S,"dbUpdate",lua_dragonBones_CCArmatureDisplay_dbUpdate);
        tolua_function(tolua_S,"dispatchDBEvent",lua_dragonBones_CCArmatureDisplay_dispatchDBEvent);
        tolua_function(tolua_S,"dispose",lua_dragonBones_CCArmatureDisplay_dispose);
        tolua_function(tolua_S,"getArmature",lua_dragonBones_CCArmatureDisplay_getArmature);
        tolua_function(tolua_S,"removeDBEventListener",lua_dragonBones_CCArmatureDisplay_removeDBEventListener);
        tolua_function(tolua_S,"dbClear",lua_dragonBones_CCArmatureDisplay_dbClear);
        tolua_function(tolua_S,"create", lua_dragonBones_CCArmatureDisplay_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::CCArmatureDisplay).name();
    g_luaType[typeName] = "db.CCArmatureDisplay";
    g_typeCast["CCArmatureDisplay"] = "db.CCArmatureDisplay";
    return 1;
}

int lua_dragonBones_CCFactory_getSoundEventManager(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCFactory_getSoundEventManager'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_getSoundEventManager'", nullptr);
            return 0;
        }
        dragonBones::CCArmatureDisplay* ret = cobj->getSoundEventManager();
        object_to_luaval<dragonBones::CCArmatureDisplay>(tolua_S, "db.CCArmatureDisplay",(dragonBones::CCArmatureDisplay*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCFactory:getSoundEventManager",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCFactory_getSoundEventManager'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCFactory_getTextureDisplay(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCFactory_getTextureDisplay'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCFactory:getTextureDisplay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_getTextureDisplay'", nullptr);
            return 0;
        }
        cocos2d::Sprite* ret = cobj->getTextureDisplay(arg0);
        object_to_luaval<cocos2d::Sprite>(tolua_S, "cc.Sprite",(cocos2d::Sprite*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        std::string arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCFactory:getTextureDisplay");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.CCFactory:getTextureDisplay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_getTextureDisplay'", nullptr);
            return 0;
        }
        cocos2d::Sprite* ret = cobj->getTextureDisplay(arg0, arg1);
        object_to_luaval<cocos2d::Sprite>(tolua_S, "cc.Sprite",(cocos2d::Sprite*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCFactory:getTextureDisplay",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCFactory_getTextureDisplay'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCFactory_loadDragonBonesData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCFactory_loadDragonBonesData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCFactory:loadDragonBonesData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_loadDragonBonesData'", nullptr);
            return 0;
        }
        dragonBones::DragonBonesData* ret = cobj->loadDragonBonesData(arg0);
        object_to_luaval<dragonBones::DragonBonesData>(tolua_S, "db.DragonBonesData",(dragonBones::DragonBonesData*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        std::string arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCFactory:loadDragonBonesData");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.CCFactory:loadDragonBonesData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_loadDragonBonesData'", nullptr);
            return 0;
        }
        dragonBones::DragonBonesData* ret = cobj->loadDragonBonesData(arg0, arg1);
        object_to_luaval<dragonBones::DragonBonesData>(tolua_S, "db.DragonBonesData",(dragonBones::DragonBonesData*)ret);
        return 1;
    }
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        double arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCFactory:loadDragonBonesData");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.CCFactory:loadDragonBonesData");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "db.CCFactory:loadDragonBonesData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_loadDragonBonesData'", nullptr);
            return 0;
        }
        dragonBones::DragonBonesData* ret = cobj->loadDragonBonesData(arg0, arg1, arg2);
        object_to_luaval<dragonBones::DragonBonesData>(tolua_S, "db.DragonBonesData",(dragonBones::DragonBonesData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCFactory:loadDragonBonesData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCFactory_loadDragonBonesData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCFactory_loadTextureAtlasData(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCFactory_loadTextureAtlasData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCFactory:loadTextureAtlasData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_loadTextureAtlasData'", nullptr);
            return 0;
        }
        dragonBones::TextureAtlasData* ret = cobj->loadTextureAtlasData(arg0);
        object_to_luaval<dragonBones::TextureAtlasData>(tolua_S, "db.TextureAtlasData",(dragonBones::TextureAtlasData*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        std::string arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCFactory:loadTextureAtlasData");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.CCFactory:loadTextureAtlasData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_loadTextureAtlasData'", nullptr);
            return 0;
        }
        dragonBones::TextureAtlasData* ret = cobj->loadTextureAtlasData(arg0, arg1);
        object_to_luaval<dragonBones::TextureAtlasData>(tolua_S, "db.TextureAtlasData",(dragonBones::TextureAtlasData*)ret);
        return 1;
    }
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        double arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCFactory:loadTextureAtlasData");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.CCFactory:loadTextureAtlasData");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "db.CCFactory:loadTextureAtlasData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_loadTextureAtlasData'", nullptr);
            return 0;
        }
        dragonBones::TextureAtlasData* ret = cobj->loadTextureAtlasData(arg0, arg1, arg2);
        object_to_luaval<dragonBones::TextureAtlasData>(tolua_S, "db.TextureAtlasData",(dragonBones::TextureAtlasData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCFactory:loadTextureAtlasData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCFactory_loadTextureAtlasData'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCFactory_buildArmatureDisplay(lua_State* tolua_S)
{
    int argc = 0;
    dragonBones::CCFactory* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"db.CCFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (dragonBones::CCFactory*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_dragonBones_CCFactory_buildArmatureDisplay'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCFactory:buildArmatureDisplay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_buildArmatureDisplay'", nullptr);
            return 0;
        }
        dragonBones::CCArmatureDisplay* ret = cobj->buildArmatureDisplay(arg0);
        object_to_luaval<dragonBones::CCArmatureDisplay>(tolua_S, "db.CCArmatureDisplay",(dragonBones::CCArmatureDisplay*)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        std::string arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCFactory:buildArmatureDisplay");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.CCFactory:buildArmatureDisplay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_buildArmatureDisplay'", nullptr);
            return 0;
        }
        dragonBones::CCArmatureDisplay* ret = cobj->buildArmatureDisplay(arg0, arg1);
        object_to_luaval<dragonBones::CCArmatureDisplay>(tolua_S, "db.CCArmatureDisplay",(dragonBones::CCArmatureDisplay*)ret);
        return 1;
    }
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCFactory:buildArmatureDisplay");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.CCFactory:buildArmatureDisplay");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "db.CCFactory:buildArmatureDisplay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_buildArmatureDisplay'", nullptr);
            return 0;
        }
        dragonBones::CCArmatureDisplay* ret = cobj->buildArmatureDisplay(arg0, arg1, arg2);
        object_to_luaval<dragonBones::CCArmatureDisplay>(tolua_S, "db.CCArmatureDisplay",(dragonBones::CCArmatureDisplay*)ret);
        return 1;
    }
    if (argc == 4) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "db.CCFactory:buildArmatureDisplay");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "db.CCFactory:buildArmatureDisplay");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "db.CCFactory:buildArmatureDisplay");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "db.CCFactory:buildArmatureDisplay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_buildArmatureDisplay'", nullptr);
            return 0;
        }
        dragonBones::CCArmatureDisplay* ret = cobj->buildArmatureDisplay(arg0, arg1, arg2, arg3);
        object_to_luaval<dragonBones::CCArmatureDisplay>(tolua_S, "db.CCArmatureDisplay",(dragonBones::CCArmatureDisplay*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "db.CCFactory:buildArmatureDisplay",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCFactory_buildArmatureDisplay'.",&tolua_err);
#endif

    return 0;
}
int lua_dragonBones_CCFactory_getFactory(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"db.CCFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_getFactory'", nullptr);
            return 0;
        }
        dragonBones::CCFactory* ret = dragonBones::CCFactory::getFactory();
        object_to_luaval<dragonBones::CCFactory>(tolua_S, "db.CCFactory",(dragonBones::CCFactory*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "db.CCFactory:getFactory",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCFactory_getFactory'.",&tolua_err);
#endif
    return 0;
}
int lua_dragonBones_CCFactory_getClock(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"db.CCFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_dragonBones_CCFactory_getClock'", nullptr);
            return 0;
        }
        dragonBones::WorldClock* ret = dragonBones::CCFactory::getClock();
        object_to_luaval<dragonBones::WorldClock>(tolua_S, "db.WorldClock",(dragonBones::WorldClock*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "db.CCFactory:getClock",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_dragonBones_CCFactory_getClock'.",&tolua_err);
#endif
    return 0;
}
static int lua_dragonBones_CCFactory_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CCFactory)");
    return 0;
}

int lua_register_dragonBones_CCFactory(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"db.CCFactory");
    tolua_cclass(tolua_S,"CCFactory","db.CCFactory","db.BaseFactory",nullptr);

    tolua_beginmodule(tolua_S,"CCFactory");
        tolua_function(tolua_S,"getSoundEventManager",lua_dragonBones_CCFactory_getSoundEventManager);
        tolua_function(tolua_S,"getTextureDisplay",lua_dragonBones_CCFactory_getTextureDisplay);
        tolua_function(tolua_S,"loadDragonBonesData",lua_dragonBones_CCFactory_loadDragonBonesData);
        tolua_function(tolua_S,"loadTextureAtlasData",lua_dragonBones_CCFactory_loadTextureAtlasData);
        tolua_function(tolua_S,"buildArmatureDisplay",lua_dragonBones_CCFactory_buildArmatureDisplay);
        tolua_function(tolua_S,"getFactory", lua_dragonBones_CCFactory_getFactory);
        tolua_function(tolua_S,"getClock", lua_dragonBones_CCFactory_getClock);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(dragonBones::CCFactory).name();
    g_luaType[typeName] = "db.CCFactory";
    g_typeCast["CCFactory"] = "db.CCFactory";
    return 1;
}
TOLUA_API int register_all_dragonBones(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"db",0);
	tolua_beginmodule(tolua_S,"db");

	lua_register_dragonBones_IEventDispatcher(tolua_S);
	lua_register_dragonBones_IArmatureProxy(tolua_S);
	lua_register_dragonBones_CCArmatureDisplay(tolua_S);
	lua_register_dragonBones_BaseObject(tolua_S);
	lua_register_dragonBones_TextureAtlasData(tolua_S);
	lua_register_dragonBones_AnimationConfig(tolua_S);
	lua_register_dragonBones_IAnimatable(tolua_S);
	lua_register_dragonBones_EventObject(tolua_S);
	lua_register_dragonBones_AnimationState(tolua_S);
	lua_register_dragonBones_BaseFactory(tolua_S);
	lua_register_dragonBones_Animation(tolua_S);
	lua_register_dragonBones_CCFactory(tolua_S);
	lua_register_dragonBones_DragonBonesData(tolua_S);
	lua_register_dragonBones_AnimationData(tolua_S);
	lua_register_dragonBones_Armature(tolua_S);
	lua_register_dragonBones_CCTextureAtlasData(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

