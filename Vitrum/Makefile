export ARCHS = arm64
THEOS_DEVICE_IP = 10.0.0.6

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Vitrum
Vitrum_LIBRARIES = colorpicker
Vitrum_FILES = Tweak.xm
Vitrum_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += vitrumprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
