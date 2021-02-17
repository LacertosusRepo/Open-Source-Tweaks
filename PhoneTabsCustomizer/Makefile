ifdef SIM
	export ARCHS = x86_64
	TARGET = simulator:clang::7.0
else
	export ARCHS = arm64 arm64e
endif

INSTALL_TARGET_PROCESSES = MobilePhone

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PhoneTabsCustomizer
PhoneTabsCustomizer_FILES = Tweak.x
PhoneTabsCustomizer_EXTRA_FRAMEWORKS += Cephei
PhoneTabsCustomizer_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += phonetabscustomizerprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
