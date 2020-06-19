export ARCHS = arm64 arm64e
export SDKVERSION = 11.2

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::7.0

INSTALL_TARGET_PROCESSES = MobilePhone

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RecentsHue
RecentsHue_FILES = Tweak.x
RecentsHue_LIBRARIES = colorpicker
# Add ws.hbang.common (>= 1.13) to depencencies
RecentsHue_EXTRA_FRAMEWORKS += Cephei Alderis
RecentsHue_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += recentshueprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
