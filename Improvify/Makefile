export ARCHS = arm64 arm64e
export SDKVERSION = 11.2
THEOS_DEVICE_IP = 10.0.0.6

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Improvify
Improvify_FILES = Tweak.xm
Improvify_LIBRARIES = colorpicker
Improvify_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Spotify"
SUBPROJECTS += improvifyprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
