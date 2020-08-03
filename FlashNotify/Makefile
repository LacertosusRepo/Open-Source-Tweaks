ifdef SIM
	export ARCHS = x86_64
	TARGET = simulator:clang::7.0
else
	export ARCHS = arm64 arm64e
endif

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FlashNotify
FlashNotify_FILES = Tweak.x FlashNotifyProvider.m
FlashNotify_FRAMEWORKS = CoreMotion
FlashNotify_PRIVATE_FRAMEWORKS = BulletinBoard
FlashNotify_EXTRA_FRAMEWORKS += Cephei
FlashNotify_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += app
SUBPROJECTS += flashnotifyprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
