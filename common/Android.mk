# Copyright 2006 The Android Open Source Project
LOCAL_PATH:= $(call my-dir)
BUILD_VPU_MEM_TEST := false
BUILD_VPU_TEST := false
BUILD_PPOP_TEST := false
BUILD_RK_LIST_TEST := false
BUILD_VPU_MEM_R_TEST := false
BUILD_VPU_MEM_DUMP := false
BUILD_VPU_POOL_TEST := false

# use new vpu framework mpp
USE_MPP := false
ifneq ($(filter rk3399, $(strip $(TARGET_BOARD_PLATFORM))), )
USE_MPP := true
endif 

ifeq ($(USE_MPP), false)

include $(CLEAR_VARS)
LOCAL_MODULE := libvpu
ifeq ($(PLATFORM_VERSION),4.0.4)
	LOCAL_CFLAGS := -DAVS40 \
	-Wno-multichar 
else
	LOCAL_CFLAGS += -Wno-multichar 
endif
# end use vpu framework mpp

LOCAL_ARM_MODE := arm

LOCAL_PRELINK_MODULE := false


LOCAL_SHARED_LIBRARIES := libcutils libion
LOCAL_STATIC_LIBRARIES := #ibion_vpu #libvpu_mem_pool

LOCAL_C_INCLUDES := $(LOCAL_PATH) \
		    $(LOCAL_PATH)/.. \
		    $(LOCAL_PATH)/include \
		    $(LOCAL_PATH)/libvpu_mem_pool \
		    $(TOP)/hardware/libhardware/include \

LOCAL_C_INCLUDES += \
        system/core/libion/include \
        system/core/libion/kernel-headers
LOCAL_SRC_FILES := vpu_mem_dmabuf.c \
				   rk_list.cpp \
				   vpu_mem_pool/vpu_mem_pool.c \
				   vpu_mem_pool/vpu_dma_buf.c \
				   vpu.c \
				   vpu_mem_pool/tsemaphore.c	\
				   ppOp.cpp

LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)
endif

ifeq ($(BUILD_VPU_MEM_TEST),true)
include $(CLEAR_VARS)
LOCAL_MODULE := vpu_mem_test
LOCAL_CFLAGS += -Wno-multichar -DBUILD_VPU_MEM_TEST=1
LOCAL_ARM_MODE := arm
LOCAL_PRELINK_MODULE := false

LOCAL_SHARED_LIBRARIES := libion libvpu libcutils
LOCAL_C_INCLUDES := $(LOCAL_PATH) \
		    $(LOCAL_PATH)/.. \
		    $(LOCAL_PATH)/include \
		    $(TOP)/hardware/libhardware/include
LOCAL_SRC_FILES := vpu_mem.c
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)
endif

ifeq ($(BUILD_VPU_TEST),true)
include $(CLEAR_VARS)
LOCAL_MODULE := vpu_test
LOCAL_CFLAGS += -Wno-multichar -DBUILD_VPU_TEST=1
LOCAL_ARM_MODE := arm
LOCAL_PRELINK_MODULE := false
LOCAL_SHARED_LIBRARIES := libion libvpu libcutils
LOCAL_C_INCLUDES := $(LOCAL_PATH) \
		    $(LOCAL_PATH)/.. \
		    $(LOCAL_PATH)/include \
		    $(TOP)/hardware/libhardware/include
LOCAL_SRC_FILES := vpu.c
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)
endif


ifeq ($(BUILD_PPOP_TEST),true)
include $(CLEAR_VARS)
LOCAL_MODULE := pp_test
LOCAL_CPPFLAGS += -Wno-multichar -DBUILD_PPOP_TEST=1
LOCAL_ARM_MODE := arm
LOCAL_PRELINK_MODULE := false
LOCAL_SHARED_LIBRARIES := libion libvpu libcutils
LOCAL_C_INCLUDES := $(LOCAL_PATH) \
		    $(LOCAL_PATH)/.. \
		    $(LOCAL_PATH)/include \
		    $(TOP)/hardware/libhardware/include
LOCAL_SRC_FILES := ppOp.cpp
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)
endif
ifeq ($(BUILD_RK_LIST_TEST),true)
include $(CLEAR_VARS)
LOCAL_MODULE := rk_list_test
LOCAL_CFLAGS += -Wno-multichar -DBUILD_RK_LIST_TEST=1
LOCAL_ARM_MODE := arm
LOCAL_PRELINK_MODULE := false
LOCAL_SHARED_LIBRARIES := libion libvpu libcutils
LOCAL_C_INCLUDES := $(LOCAL_PATH) \
		    $(LOCAL_PATH)/.. \
		    $(LOCAL_PATH)/include \
		    $(TOP)/hardware/libhardware/include
LOCAL_SRC_FILES := rk_list.cpp
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)
endif

#
# vpu_mem_test
#
ifeq ($(BUILD_VPU_MEM_R_TEST),true)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	vpu_mem_test.c

LOCAL_SHARED_LIBRARIES := \
	libcutils \
	libvpu \
	libion 

#LOCAL_STATIC_LIBRARIES := libion_vpu libvpu_mem_pool

LOCAL_MODULE := vpu_mem_test
LOCAL_MODULE_TAGS := optional tests
LOCAL_PRELINK_MODULE := false

include $(BUILD_EXECUTABLE)

endif

#
# vpu_mem_dump
#
ifeq ($(BUILD_VPU_MEM_DUMP),true)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	vpu_mem_dmabuf.c \
	vpu_mem_pool/vpu_dma_buf.c

LOCAL_SHARED_LIBRARIES := \
	libcutils \
	libvpu \
	libion 

#LOCAL_STATIC_LIBRARIES := libion_vpu libvpu_mem_pool

LOCAL_MODULE := vpu_mem_dump
LOCAL_MODULE_TAGS := optional tests
LOCAL_PRELINK_MODULE := false

LOCAL_CFLAGS += -DCONFIG_DUMP_VPU_MEM_APP

LOCAL_C_INCLUDES := $(LOCAL_PATH) \
		    $(LOCAL_PATH)/.. \
		    $(LOCAL_PATH)/include \
		    $(LOCAL_PATH)/vpu_mem_pool \
		    $(TOP)/system/core/include \
		    $(TOP)/hardware/libhardware/include

include $(BUILD_EXECUTABLE)

endif

#
# vpu_mem_pool_test
#
ifeq ($(BUILD_VPU_POOL_TEST),true)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	vpu_mem_pool/vpu_dma_buf.c \
	vpu_mem_pool/vpu_mem_pool.c \
	vpu_mem_pool/tsemaphore.c \
	vpu.c

LOCAL_SHARED_LIBRARIES := \
	libcutils \
	libion 

#LOCAL_STATIC_LIBRARIES := libion_vpu libvpu_mem_pool

LOCAL_MODULE := vpu_mem_pool_test
LOCAL_MODULE_TAGS := optional tests
LOCAL_PRELINK_MODULE := false

LOCAL_CFLAGS += -DVPU_MEMORY_BLOCK_TEST -DVPU_MBLK_DEBUG

LOCAL_C_INCLUDES := $(LOCAL_PATH) \
		    $(LOCAL_PATH)/.. \
		    $(LOCAL_PATH)/include \
		    $(LOCAL_PATH)/vpu_mem_pool \
		    $(TOP)/system/core/include

include $(BUILD_EXECUTABLE)

endif

include $(call all-makefiles-under,$(LOCAL_PATH))
