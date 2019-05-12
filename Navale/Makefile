export ARCHS = arm64
export SDKVERSION = 11.2
THEOS_DEVICE_IP = 10.0.0.6

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Navale
Navale_FILES = Tweak.xm ColorsFromImage.m
Navale_LIBRARIES = colorpicker
Navale_PRIVATE_FRAMEWORKS = AppSupport
Navale_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += navaleprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
