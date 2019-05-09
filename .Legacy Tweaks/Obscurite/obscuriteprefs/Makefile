include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = obscuriteprefs
obscuriteprefs_FILES = obcRootListController.m ObscuriteButtonController.m
obscuriteprefs_INSTALL_PATH = /Library/PreferenceBundles
obscuriteprefs_FRAMEWORKS = UIKit CoreGraphics
obscuriteprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/obscuriteprefs.plist$(ECHO_END)
