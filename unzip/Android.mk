LOCAL_PATH := $(call my-dir)
#=================================================================================
# build unzip
#=================================================================================
include $(CLEAR_VARS)
LOCAL_MODULE := unzip_static


LOCAL_C_INCLUDES := $(BOOST_INCLUDE) \
                    $(cocos2d_common) \
                    $(server_client_common) \


LOCAL_SRC_FILES :=	ioapi.cpp \
                    ioapi_mem.cpp \
                    unzip.cpp \
                    ZipUtils.cpp


include $(BUILD_STATIC_LIBRARY)