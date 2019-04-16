export ARCHS = arm64 arm64e
SDKVERSION = 11.2
THEOS_DEVIVE_IP = 10.0.0.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FLEX4Me
FLEX4Me_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
