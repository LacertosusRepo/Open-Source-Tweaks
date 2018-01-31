export ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Safi
Safi_FILES = Tweak.xm
Safi_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += safiprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
