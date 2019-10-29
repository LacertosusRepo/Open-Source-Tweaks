export ARCHS = arm64 arm64e
export SDKVERSION = 11.2
THEOS_DEVICE_IP = 10.0.0.6

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::7.0

INSTALL_TARGET_PROCESSES = MobilePhone

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DialerGradient
DialerGradient_FILES = Tweak.x
DialerGradient_LIBRARIES = colorpicker
DialerGradient_EXTRA_FRAMEWORKS += Cephei
DialerGradient_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += dialergradientprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
