THEOS_DEVICE_IP = 192.168.1.3
export ARCHS = armv7 arm64
THEOS_BUILD_DIR = DEBS
SDK = iPhoneOS8.1

include theos/makefiles/common.mk

TWEAK_NAME = PopUpOnStart
PopUpOnStart_FILES = Tweak.xm
PopUpOnStart_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += popprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
