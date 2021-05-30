ifdef SIM
	export ARCHS = x86_64
	TARGET = simulator:clang:latest:8.0
else
	export ARCHS = arm64 arm64e
endif

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FlashlightIndicator
FlashlightIndicator_FILES = $(wildcard *.x)
FlashlightIndicator_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

sim::
	@$(MAKE) SIM=1
	@echo "Copying dylib and plist to /opt/simject..."
	@cp -R .theos/obj/iphone_simulator/debug/x86_64/$(TWEAK_NAME).dylib /opt/simject/
	@cp -R $(TWEAK_NAME).plist /opt/simject/
	@echo "Restarting simulator..."
	@$(RESPRING)
