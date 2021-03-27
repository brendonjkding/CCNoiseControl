ifdef SIMULATOR
TARGET := simulator:clang:11.2:11.0
else
TARGET := iphone:clang:13.0:11.0
endif
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CCNoiseControl
CCNoiseControl_BUNDLE_EXTENSION = bundle
CCNoiseControl_FILES = CCNoiseControl.m
CCNoiseControl_CFLAGS = -fobjc-arc -Wno-error=unused-variable -Wno-error=unused-function
CCNoiseControl_PRIVATE_FRAMEWORKS = ControlCenterUIKit
CCNoiseControl_INSTALL_PATH = /Library/ControlCenter/Bundles/

include $(THEOS_MAKE_PATH)/bundle.mk
