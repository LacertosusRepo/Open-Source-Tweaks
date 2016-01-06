THEOS_DEVICE_IP = 10.0.0.180
ARCHS = armv7 arm64
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
