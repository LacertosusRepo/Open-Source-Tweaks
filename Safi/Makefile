export ARCHS = arm64
THEOS_DEVICE_IP = 10.0.0.6

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Safi
Safi_FILES = Tweak.xm
Safi_LIBRARIES = colorpicker
Safi_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += safiprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
