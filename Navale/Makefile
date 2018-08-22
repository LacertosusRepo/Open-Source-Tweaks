export ARCHS = arm64
THEOS_DEVICE_IP = 10.0.0.6

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Navale
Navale_FILES = Tweak.xm
Navale_FRAMWORKS = CoreTelephony
Navale_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += navaleprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
