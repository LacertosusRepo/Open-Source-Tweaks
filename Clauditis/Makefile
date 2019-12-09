export ARCHS = arm64 arm64e
export SDKVERSION = 11.2
THEOS_DEVICE_IP = 10.0.0.7

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::7.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Clauditis
Clauditis_FILES = Tweak.x
# Add ws.hbang.common (>= 1.13) to depencencies
# Clauditis_EXTRA_FRAMEWORKS += Cephei
Clauditis_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
