ifdef SIM
	export ARCHS = x86_64
	TARGET = simulator:clang::7.0
else
	export ARCHS = arm64 arm64e
endif

INSTALL_TARGET_PROCESSES = Preferences#SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DockIndicators
DockIndicators_FILES = Tweak.x
DockIndicators_LIBRARIES = colorpicker
DockIndicators_EXTRA_FRAMEWORKS += Cephei Alderis
DockIndicators_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += dockindicatorsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
