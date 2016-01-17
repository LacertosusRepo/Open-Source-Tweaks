THEOS_DEVICE_IP = 192.168.1.4
ARCHS = armv7 arm64
THEOS_BUILD_DIR = DEBS
SDK = iPhoneOS8.1

include theos/makefiles/common.mk

TWEAK_NAME = CustomReach
CustomReach_FILES = Tweak.xm
CustomReach_FRAMEWORKS = UIKit
SUBPROJECTS += customreachpreferences

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
