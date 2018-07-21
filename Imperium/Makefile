export ARCHS = arm64
THEOS_DEVICE_IP = 10.0.0.6
FINAL_PACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Imperium
Imperium_FILES = Tweak.xm
Imperium_PRIVATE_FRAMEWORKS = MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
