LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := libluajit
LOCAL_SRC_FILES := libluajit.a
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE := tolua
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../src
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../luajit-2.1/src

LOCAL_CPPFLAGS := -O2
LOCAL_CFLAGS := -O2 -std=gnu99
LOCAL_SRC_FILES := \
 ../../src/int64.c \
 ../../src/tolua.c \
 ../../src/uint64.c

LOCAL_WHOLE_STATIC_LIBRARIES += libluajit
include $(BUILD_SHARED_LIBRARY)
