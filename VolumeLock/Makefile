export ARCHS = arm64 arm64e
export SDKVERSION = 11.2
THEOS_DEVICE_IP = 10.0.0.133

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::7.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VolumeLock
VolumeLock_FILES = Tweak.x
VolumeLock_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
