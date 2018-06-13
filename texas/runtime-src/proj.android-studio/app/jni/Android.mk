LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

$(call import-add-path, I:/Code/client)

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../Classes\
$(boost_include)\
$(cocos2d_common)\
$(LOCAL_PATH)/../../../Classes/crypto\
$(LOCAL_PATH)/../../../Classes/crypto/md5

LOCAL_SRC_FILES := \
../../../Classes/AppDelegate.cpp \
../../../Classes/crypto/lua_crypto.cpp \
../../../Classes/lua_extensions_more.c \
../../../Classes/crypto/md5/md51.cpp \
../../../Classes/crypto/md5/md5_impl.cpp \
../../../Classes/lpack/lpack.c \
../../../Classes/filesystem/lfs.c \
hellolua/main.cpp

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += version_compare_static
LOCAL_STATIC_LIBRARIES += unzip_static

# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module,version_compare)
$(call import-module,unzip)
# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END
