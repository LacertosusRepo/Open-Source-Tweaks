export ARCHS = arm64
THEOS_DEVICE_IP = 10.0.0.6

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Imperium
Imperium_FILES = Tweak.xm ImperiumClasses.m
Imperium_FRAMWORKS = UIKit
Imperium_PRIVATE_FRAMEWORKS = MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += imperiumprefs AppleMusic Spotify
include $(THEOS_MAKE_PATH)/aggregate.mk
