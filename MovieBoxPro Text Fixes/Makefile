export ARCHS = arm64
SDKVERSION = 11.2
THEOS_DEVIVE_IP = 10.0.0.6

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MovieBoxProTextFixes
MovieBoxProTextFixes_FILES = Tweak.xm
MovieBoxProTextFixes_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MovieBox"
