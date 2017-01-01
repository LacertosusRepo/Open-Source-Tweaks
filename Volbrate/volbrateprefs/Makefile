include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = volbrateprefs
volbrateprefs_FILES = volRootListController.m VolbrateButtonController.m
volbrateprefs_INSTALL_PATH = /Library/PreferenceBundles
volbrateprefs_FRAMEWORKS = UIKit CoreGraphics
volbrateprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/volbrateprefs.plist$(ECHO_END)
