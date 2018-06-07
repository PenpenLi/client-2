#include "iversion_compare.h"
#include "istatus_callback.h"

#include "lua_crypto.h"

// md5
#include "md5/md5_impl.h"


// base64
//#include "crypto/base64/base64Con.h"

#define DEF_FUNCTION(f)     lua_pushcfunction(L, f); lua_setglobal(L, #f)

int md5string(lua_State* L);            //Calculate md5 for string
int sign_varibles(lua_State* L);        //sign varibles

int encode_base64(lua_State* L);        //base64 encode
int decode_base64(lua_State* L);        //base64 decode

//Calculate md5 for string
int md5string(lua_State* L)
{
	std::string r = "";

	if (lua_type(L, 1) == LUA_TSTRING)
	{
		const char* str = lua_tostring(L, 1);
		r = Md5_String(str);
	}

	lua_pushstring(L, r.c_str());
	return 1;
}

//sign varibles
int sign_varibles(lua_State* L)
{
	std::string r = "";
	if (lua_type(L, 1) == LUA_TSTRING && lua_type(L, 2) == LUA_TSTRING && lua_type(L, 3) == LUA_TSTRING)
	{
		std::string p1 = lua_tostring(L, 1);
		std::string p2 = lua_tostring(L, 2);
		std::string p3 = lua_tostring(L, 3);
		std::string s = p1 + Md5_String(p2) + p3 + "{51B539D8-0D9A-4E35-940E-22C6EBFA86A8}";
		r = Md5_String(s);
	}

	lua_pushstring(L, r.c_str());
	return 1;
}

//base64 encode
int encode_base64(lua_State* L)
{
	//std::string r = "";
	//if (lua_type(L, 1) == LUA_TSTRING)
	//{
	//	std::string src = lua_tostring(L, 1);
	//	try
	//	{
	//		std::string t = Gzip_Encode(src);
	//		r = Base64_Encode(t.c_str(), t.length());
	//	}
	//	catch (...)
	//	{
	//		//do nothing.
	//	}
	//}
	//lua_pushstring(L, r.c_str());
	return 1;
}

//base64 decode
int decode_base64(lua_State* L)
{
	//std::string r = "";
	//if (lua_type(L, 1) == LUA_TSTRING)
	//{
	//	std::string src = lua_tostring(L, 1);
	//	if (!src.empty())
	//	{
	//		try
	//		{
	//			r = Gzip_Decode(CL::Base64_Decode(src.c_str(), src.length()));
	//		}
	//		catch (...)
	//		{
	//			//do nothing.
	//		}
	//	}
	//}
	//lua_pushstring(L, r.c_str());
	return 1;
}

extern vsp::iversion_compare* vcp;
int		vsp_check_version(lua_State* L)
{
	int ret = 0;
	if (lua_type(L, 1) == LUA_TSTRING && lua_type(L, 2) == LUA_TSTRING && lua_type(L, 3) == LUA_TSTRING){
		std::string exe = lua_tostring(L, 1);
		std::string localp = lua_tostring(L, 2);
		std::string remotep = lua_tostring(L, 3);
		ret = vcp->check_update(exe, localp, remotep);
	}
	lua_pushnumber(L, ret);
	return 1;
}

//
int		vsp_query_version_status(lua_State* L)
{
	vsp::vsync_status st;
	vcp->query_status(st);
	lua_pushnumber(L, (int)st.st_);
	lua_pushnumber(L, (int)st.progress_);
	lua_pushnumber(L, (int)st.progress_max_);
	return 3;
}

int		vsp_install_update(lua_State* L)
{
	lua_pushnumber(L, vcp->install_update()); 
	return 1;
}

int		vsp_is_working(lua_State* L)
{
	lua_pushnumber(L, vcp->is_working());
	return 1;
}

int		vsp_clean(lua_State* L)
{
	vcp->clean();
	return 0;
}

int		vsp_copy_dir(lua_State* L)
{
	int ret = 0; std::string err;
	if (lua_type(L, 1) == LUA_TSTRING && lua_type(L, 2) == LUA_TSTRING ) {
		std::string from = lua_tostring(L, 1);
		std::string to = lua_tostring(L, 2);
		ret = vcp->copy_dir(from, to, err);
	}
	lua_pushnumber(L, ret);
	lua_pushstring(L, err.c_str());
	return 2;
}

//////////////////////////////////////////////////////////////////////////
int register_lua_api(lua_State* L)
{
	DEF_FUNCTION(md5string);
	DEF_FUNCTION(sign_varibles);

	DEF_FUNCTION(encode_base64);
	DEF_FUNCTION(decode_base64);
	DEF_FUNCTION(vsp_check_version);
	DEF_FUNCTION(vsp_query_version_status);
	DEF_FUNCTION(vsp_install_update);
	DEF_FUNCTION(vsp_is_working);
	DEF_FUNCTION(vsp_clean);
	DEF_FUNCTION(vsp_copy_dir);
	return 1;
};
