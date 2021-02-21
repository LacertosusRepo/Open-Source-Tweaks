ifdef SIM
	export ARCHS = x86_64
	TARGET = simulator:clang:latest:8.0
else
	export ARCHS = arm64 arm64e
endif

INSTALL_TARGET_PROCESSES = Preferences BluetoothSettings

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SkipBTForgetConfirmation
SkipBTForgetConfirmation_FILES = $(wildcard *.x)
SkipBTForgetConfirmation_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
