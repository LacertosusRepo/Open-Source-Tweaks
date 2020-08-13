ifdef SIM
	export ARCHS = x86_64
	TARGET = simulator:clang::7.0
else
	export ARCHS = arm64 arm64e
endif

INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = zzzTweakSearch
zzzTweakSearch_FILES = Tweak.x
zzzTweakSearch_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
