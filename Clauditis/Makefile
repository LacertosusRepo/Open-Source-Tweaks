export ARCHS = arm64
THEOS_DEVIVE_IP = 10.0.0.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Clauditis
Clauditis_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
