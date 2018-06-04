LOCAL_PATH := $(call my-dir)
#=================================================================================
# build version compare
#=================================================================================
include $(CLEAR_VARS)

ZIP_TOOL_ROOT := E:/Source/eggplant/unzip

LOCAL_MODULE := version_compare_static

LOCAL_C_INCLUDES := $(BOOST_INCLUDE) \
                    $(cocos2d_common) \
                    $(server_client_common) \
                    $(ZIP_TOOL_ROOT)

LOCAL_SRC_FILES :=	http_download_file.cpp \
                    version_compare.cpp


include $(BUILD_STATIC_LIBRARY)


