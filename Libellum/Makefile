export ARCHS = arm64 arm64e
export SDKVERSION = 11.2
THEOS_DEVICE_IP = 10.0.0.131

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::12

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Libellum
Libellum_FILES = Tweak.x LibellumView.m
Libellum_LIBRARIES = colorpicker
Libellum_PRIVATE_FRAMEWORKS = AppSupport
# Add ws.hbang.common (>= 1.13) to depencencies
Libellum_EXTRA_FRAMEWORKS += Cephei
Libellum_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += libellumprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
