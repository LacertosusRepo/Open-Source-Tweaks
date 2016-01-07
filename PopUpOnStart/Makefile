THEOS_DEVICE_IP = 192.168.1.4			//Just using this to install to my iPhone from my PC
export ARCHS = armv7 arm64				//Compiles tweak for arm 64 too
export TARGET = iphone:clang:8.1
SDK = iPhoneOS8.1						//Compiles with iOS 8.1 

include theos/makefiles/common.mk

TWEAK_NAME = PopUpOnStart
PopUpOnStart_FILES = Tweak.xm
PopUpOnStart_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
