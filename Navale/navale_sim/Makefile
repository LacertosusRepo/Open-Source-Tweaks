# Simject
export ARCHS = x86_64
TARGET = simulator:clang::11.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Navale
Navale_FILES = Tweak.x iOSPalette/Palette.m iOSPalette/PaletteColorUtils.m iOSPalette/PaletteSwatch.m iOSPalette/PaletteTarget.m iOSPalette/PriorityBoxArray.m iOSPalette/UIImage+Palette.m iOSPalette/PaletteColorModel.m
# Add ws.hbang.common (>= 1.13) to depencencies
Navale_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
