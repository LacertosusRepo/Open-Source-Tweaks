export ARCHS = arm64 arm64e
TARGET = iphone:clang:14.5:14.5
FINALPACKAGE = 1

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
