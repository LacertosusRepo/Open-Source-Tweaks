export ARCHS = arm64 arm64e

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::12

INSTALL_TARGET_PROCESSES = Preferences #SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Libellum
Libellum_FILES = Tweak.x LibellumView.m LGestureRecognizer.m
Libellum_LIBRARIES = colorpicker
Libellum_PRIVATE_FRAMEWORKS = AppSupport
# Add ws.hbang.common (>= 1.13) to depencencies
Libellum_EXTRA_FRAMEWORKS += Cephei Alderis
Libellum_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += libellumprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
