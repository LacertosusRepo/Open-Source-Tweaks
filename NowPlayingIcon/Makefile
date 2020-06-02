export ARCHS = arm64 arm64e
export SDKVERSION = 11.2
THEOS_DEVICE_IP = 10.0.0.130

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::7.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NowPlayingIcon
NowPlayingIcon_FILES = Tweak.x
# Add ws.hbang.common (>= 1.13) to depencencies
# NowPlayingIcon_EXTRA_FRAMEWORKS += Cephei
NowPlayingIcon_PRIVATE_FRAMEWORKS = MediaRemote
NowPlayingIcon_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
