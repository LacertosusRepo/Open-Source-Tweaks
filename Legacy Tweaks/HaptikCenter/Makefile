export ARCHS = armv7 arm64
THEOS_DEVICE_IP = 192.168.0.10

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HaptikCenter
HaptikCenter_FILES = Tweak.xm
HaptikCenter_FRAMEWORKS = CoreTelephony AudioToolbox UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += hcprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
