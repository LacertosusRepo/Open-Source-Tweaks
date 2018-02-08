include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NotificationExample
NotificationExample_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += notiprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
