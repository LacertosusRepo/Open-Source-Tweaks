export ARCHS = arm64 arm64e
export SDKVERSION = 11.2
THEOS_DEVICE_IP = 10.0.0.7

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::7.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Navale
Navale_FILES = Tweak.x iOSPalette/Palette.m iOSPalette/PaletteColorUtils.m iOSPalette/PaletteSwatch.m iOSPalette/PaletteTarget.m iOSPalette/PriorityBoxArray.m iOSPalette/UIImage+Palette.m iOSPalette/PaletteColorModel.m
Navale_LIBRARIES = colorpicker
Navale_PRIVATE_FRAMEWORKS = AppSupport
# Add ws.hbang.common (>= 1.13) to depencencies
Navale_EXTRA_FRAMEWORKS += Cephei
Navale_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += navaleprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
