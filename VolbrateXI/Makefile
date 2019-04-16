export ARCHS = arm64 arm64e
export SDKVERSION = 11.2
THEOS_DEVICE_IP = 10.0.0.6

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VolbrateXI
VolbrateXI_FILES = Tweak.xm
VolbrateXI_FRAMEWORKS = CoreTelephony AudioToolbox UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += volbratexiprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
