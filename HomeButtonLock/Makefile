THEOS_DEVICE_IP = 192.168.1.4
ARCHS = armv7 arm64
SDK = iPhoneOS8.1

include theos/makefiles/common.mk

TWEAK_NAME = HomeButtonLock
HomeButtonLock_FILES = Tweak.xm
HomeButtonLock_LIBRARIES = activator

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += hblprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
