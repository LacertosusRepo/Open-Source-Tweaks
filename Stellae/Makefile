export ARCHS = arm64
export SDKVERSION = 11.2
THEOS_DEVIVE_IP = 10.0.0.6

# Simject
# export ARCHS = x86_64
# TARGET = simulator:clang::7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Stellae
Stellae_FILES = Tweak.xm Listener.xm
Stellae_LIBRARIES = activator
Stellae_PRIVATE_FRAMEWORKS = PhotoLibrary PersistentConnection AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += stellaeprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
