THEOS_DEVICE_IP = 192.168.1.4
ARCHS = armv7 arm64
SDK = iPhoneOS8.1

include theos/makefiles/common.mk

TWEAK_NAME = ScreenLock
ScreenLock_FILES = Tweak.xm
ScreenLock_FRAMEWORKS = UIKit
ScreenLock_LIBRARIES = activator

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

