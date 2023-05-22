ifdef SIMULATOR
TARGET := simulator:clang:latest:11.0
else
TARGET := iphone:clang:latest:11.0
endif
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CCNoiseControlProvider
CCNoiseControlProvider_BUNDLE_EXTENSION = bundle
CCNoiseControlProvider_FILES = CCNoiseControl.m CCNoiseControlProvider.m CCNoiseControlNormal.m
CCNoiseControlProvider_CFLAGS = -fobjc-arc
CCNoiseControlProvider_PRIVATE_FRAMEWORKS = ControlCenterUIKit
CCNoiseControlProvider_INSTALL_PATH = /Library/ControlCenter/CCSupport_Providers

ADDITIONAL_CFLAGS += -Wno-error=unused-variable -Wno-error=unused-function

include $(THEOS_MAKE_PATH)/bundle.mk
