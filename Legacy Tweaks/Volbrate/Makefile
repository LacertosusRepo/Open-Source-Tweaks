export ARCHS = armv7 arm64
THEOS_DEVICE_IP = 128.198.104.180

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Volbrate
Volbrate_FILES = Tweak.xm
Volbrate_FRAMEWORKS = CoreTelephony AudioToolbox UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += volbrateprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
