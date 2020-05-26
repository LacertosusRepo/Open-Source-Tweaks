export ARCHS = arm64 arm64e
export SDKVERSION = 11.2
THEOS_DEVICE_IP = 10.0.0.131

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::7.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ColoredScrollIndicator
ColoredScrollIndicator_FILES = Tweak.x
# Add ws.hbang.common (>= 1.13) to depencencies
ColoredScrollIndicator_EXTRA_FRAMEWORKS += Cephei Alderis
ColoredScrollIndicator_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += coloredscrollindicatorprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
