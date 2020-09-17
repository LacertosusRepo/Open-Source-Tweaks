ifdef SIM
	export ARCHS = x86_64
	TARGET = simulator:clang::7.0
else
	export ARCHS = arm64 arm64e
endif

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeywordReplace
KeywordReplace_FILES = Tweak.x
KeywordReplace_EXTRA_FRAMEWORKS += Cephei
KeywordReplace_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += keywordreplaceprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
