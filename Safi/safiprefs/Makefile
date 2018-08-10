export ARCHS = arm64
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = safiprefs
safiprefs_FILES = LACRootListController.m SafiButtonController.m
safiprefs_LIBRARIES = colorpicker
safiprefs_INSTALL_PATH = /Library/PreferenceBundles
safiprefs_FRAMEWORKS = UIKit CoreGraphics
safiprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/safiprefs.plist$(ECHO_END)
