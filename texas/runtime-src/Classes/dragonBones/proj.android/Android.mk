LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := dragonbones_static

LOCAL_MODULE_FILENAME := libdragonbones

EngineRoot1 := E:/work2/client_code/cocos2d-x-3.15

LOCAL_SRC_FILES :=      ../animation/Animation.cpp \
                        ../animation/AnimationState.cpp \
                        ../animation/BaseTimelineState.cpp \
                        ../animation/TimelineState.cpp \
                        ../animation/WorldClock.cpp \
                        ../armature/Armature.cpp \
                        ../armature/Bone.cpp \
                        ../armature/Constraint.cpp \
                        ../armature/Slot.cpp \
                        ../armature/TransformObject.cpp \
                        ../core/BaseObject.cpp \
                        ../core/DragonBones.cpp \
                        ../event/EventObject.cpp \
                        ../factory/BaseFactory.cpp \
                        ../geom/Point.cpp \
                        ../geom/Transform.cpp \
                        ../model/AnimationConfig.cpp \
                        ../model/AnimationData.cpp \
                        ../model/ArmatureData.cpp \
                        ../model/BoundingBoxData.cpp \
                        ../model/CanvasData.cpp \
                        ../model/ConstraintData.cpp \
                        ../model/DisplayData.cpp \
                        ../model/DragonBonesData.cpp \
                        ../model/SkinData.cpp \
                        ../model/TextureAtlasData.cpp \
                        ../model/UserData.cpp \
                        ../parser/BinaryDataParser.cpp \
                        ../parser/DataParser.cpp \
                        ../parser/JSONDataParser.cpp \
                        ../cocos2dx/CCArmatureDisplay.cpp \
                        ../cocos2dx/CCFactory.cpp \
                        ../cocos2dx/CCSlot.cpp \
                        ../cocos2dx/CCTextureAtlasData.cpp \
                        ../auto/dragonBones_auto.cpp


LOCAL_C_INCLUDES :=     $(EngineRoot1)/cocos \
                        $(EngineRoot1)/external \
                        $(EngineRoot1)/external/lua \
                        $(EngineRoot1)/external/lua/tolua \
                        $(EngineRoot1)/external/lua/luajit/include \
                        $(LOCAL_PATH)/../ \
                        $(LOCAL_PATH)/../animation \
                        $(LOCAL_PATH)/../armature \
                        $(LOCAL_PATH)/../core \
                        $(LOCAL_PATH)/../events \
                        $(LOCAL_PATH)/../factories \
                        $(LOCAL_PATH)/../geom \
                        $(LOCAL_PATH)/../model \
                        $(LOCAL_PATH)/../parsers \
                        $(LOCAL_PATH)/../cocos2dx \
                        $(LOCAL_PATH)/../.. \

LOCAL_EXPORT_C_INCLUDES :=     $(LOCAL_PATH)/../ \
                        $(LOCAL_PATH)/../animation \
                        $(LOCAL_PATH)/../armature \
                        $(LOCAL_PATH)/../core \
                        $(LOCAL_PATH)/../events \
                        $(LOCAL_PATH)/../factories \
                        $(LOCAL_PATH)/../geom \
                        $(LOCAL_PATH)/../model \
                        $(LOCAL_PATH)/../parsers \
                        $(LOCAL_PATH)/../cocos2dx \

LOCAL_WHOLE_STATIC_LIBRARIES += cocos2dx_static

LOCAL_CFLAGS += -Wno-psabi
LOCAL_EXPORT_CFLAGS += -Wno-psabi

include $(BUILD_STATIC_LIBRARY)

$(call import-module,.)
