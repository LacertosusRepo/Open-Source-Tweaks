export ARCHS = arm64 arm64e
TARGET = iphone:clang:14.5:14.5
FINALPACKAGE = 1

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Libellum
Libellum_FILES = $(wildcard *.x *.m)
Libellum_LIBRARIES = colorpicker
Libellum_PRIVATE_FRAMEWORKS= CoverSheet
Libellum_EXTRA_FRAMEWORKS += Alderis
Libellum_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += libellumprefs
include $(THEOS_MAKE_PATH)/aggregate.mk