export ARCHS = arm64 arm64e
export SDKVERSION = 11.2
THEOS_DEVICE_IP = 10.0.0.7

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::7.0

INSTALL_TARGET_PROCESSES = Spotify

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Improvify
Improvify_FILES = Tweak.x
Improvify_LIBRARIES = colorpicker
# Add ws.hbang.common (>= 1.13) to depencencies
Improvify_EXTRA_FRAMEWORKS += Cephei
Improvify_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += improvifyprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
