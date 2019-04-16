THEOS_DEVICE_IP = 192.168.1.4
ARCHS = armv7 arm64
THEOS_BUILD_DIR = DEBS
SDK = iPhoneOS8.1

include theos/makefiles/common.mk

TWEAK_NAME = SoundSpring
SoundSpring_FILES = Tweak.xm
SoundSpring_FRAMEWORKS = UIKit AudioToolbox AVFoundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += soundprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
