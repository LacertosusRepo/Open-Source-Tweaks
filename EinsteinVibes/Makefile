export ARCHS = arm64
THEOS_DEVICE_IP = 10.0.0.6

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EinsteinVibes
EinsteinVibes_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Calculator"
