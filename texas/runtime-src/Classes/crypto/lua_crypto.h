#ifndef _LUA_API_H_
#define _LUA_API_H_

#ifdef __cplusplus
extern "C" {
#endif
#include "lua/tolua/tolua++.h"
#ifdef __cplusplus
}
#endif

int register_lua_api(lua_State* L);

#endif // !_LUA_API_H_