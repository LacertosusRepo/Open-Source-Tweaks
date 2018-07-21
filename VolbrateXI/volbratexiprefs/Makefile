include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = volbratexiprefs
volbratexiprefs_FILES = volRootListController.m VolbrateButtonController.m
volbratexiprefs_INSTALL_PATH = /Library/PreferenceBundles
volbratexiprefs_FRAMEWORKS = UIKit CoreGraphics
volbratexiprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/volbratexiprefs.plist$(ECHO_END)
