
#include "lua_extensions_more.h"

#if __cplusplus
extern "C" {
#endif
// lpack
#include "lpack/lpack.h"
// filesystem
#include "filesystem/lfs.h"

static luaL_Reg luax_exts[] = {
    {"pack", luaopen_pack},
	{"lfs", luaopen_lfs},
    {NULL, NULL}
};

void luaopen_lua_extensions_more(lua_State *L)
{
    // load extensions
    luaL_Reg* lib = luax_exts;
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "preload");
    for (; lib->func; lib++)
    {
        lua_pushcfunction(L, lib->func);
        lua_setfield(L, -2, lib->name);
    }
    lua_pop(L, 2);
}

#if __cplusplus
} // extern "C"
#endif
