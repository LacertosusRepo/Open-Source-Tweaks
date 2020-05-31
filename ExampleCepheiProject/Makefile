	# set archs for project and subprojects
export ARCHS = arm64 arm64e
	# set SDK for project and subprojects
export SDKVERSION = 11.2

INSTALL_TARGET_PROCESSES = SpringBoard
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ExampleCepheiProject
ExampleCepheiProject_FILES = Tweak.x
	# Add Cephei to extra frameworks and ws.hbang.common (>= 1.13) to control file
ExampleCepheiProject_EXTRA_FRAMEWORKS += Cephei
ExampleCepheiProject_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += examplecepheiprojectprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
