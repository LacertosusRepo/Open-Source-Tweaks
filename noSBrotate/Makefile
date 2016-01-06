THEOS_DEVICE_IP = 10.0.0.180
ARCHS = armv7 arm64
SDK = iPhoneOS8.1

include theos/makefiles/common.mk

TWEAK_NAME = noSBrotate
noSBrotate_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
