export ARCHS = arm64 arm64e
export CLI = 0
export ROOTLESS = 1

ifeq ($(ROOTLESS),1)
export THEOS_PACKAGE_SCHEME = rootless
export TARGET = iphone:clang:14.5:15.0
else
export TARGET = iphone:clang:14.5:13.0
endif


INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DockIndicators
DockIndicators_FILES = Tweak.x
DockIndicators_LIBRARIES = colorpicker
DockIndicators_EXTRA_FRAMEWORKS += Alderis
DockIndicators_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += dockindicatorsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
