# Simject
export ARCHS = x86_64
TARGET = simulator:clang::12
DEBUG = 1

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Libellum
Libellum_FILES = Tweak.x LibellumView.m iOSPalette/Palette.m iOSPalette/PaletteColorUtils.m iOSPalette/PaletteSwatch.m iOSPalette/PaletteTarget.m iOSPalette/PriorityBoxArray.m iOSPalette/UIImage+Palette.m iOSPalette/PaletteColorModel.m
Libellum_LIBRARIES = colorpicker
Libellum_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
