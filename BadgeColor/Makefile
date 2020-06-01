export ARCHS = arm64 arm64e
export SDKVERSION = 11.2

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::7.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BadgeColor
BadgeColor_FILES = Tweak.x
BadgeColor_LIBRARIES = colorpicker
# Add ws.hbang.common (>= 1.13) to depencencies
BadgeColor_EXTRA_FRAMEWORKS += Cephei Alderis
BadgeColor_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += badgecolorprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
