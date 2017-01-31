THEOS_DEVICE_IP = 192.168.0.28

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CenterSpring
CenterSpring_FILES = Tweak.xm
CenterSpring_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
