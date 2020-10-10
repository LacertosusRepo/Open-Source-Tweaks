export ARCHS = arm64 arm64e

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::7.0

INSTALL_TARGET_PROCESSES = Spotify

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SpotifyAddToFavorites
SpotifyAddToFavorites_FILES = Tweak.x
SpotifyAddToFavorites_EXTRA_FRAMEWORKS += Cephei
SpotifyAddToFavorites_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
