THEOS_DEVICE_IP = 192.168.1.5

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Obscurite
Obscurite_FILES = Tweak.xm
Obscurite_FRAMEWORKS = UIKit
Obscurite_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += obscuriteprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
