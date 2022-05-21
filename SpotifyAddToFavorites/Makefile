export ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = Spotify

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SpotifyAddToFavorites
SpotifyAddToFavorites_FILES = Tweak.x SATFFavoritePlaylistContextAction.m
SpotifyAddToFavorites_FRAMEWORKS = UIKit CoreGraphics
SpotifyAddToFavorites_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
