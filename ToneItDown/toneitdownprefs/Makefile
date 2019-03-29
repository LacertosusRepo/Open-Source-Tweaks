include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = toneitdownprefs
toneitdownprefs_FILES = TIDRootListController.m TIDButtonController.m
toneitdownprefs_INSTALL_PATH = /Library/PreferenceBundles
toneitdownprefs_FRAMEWORKS = UIKit
toneitdownprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/toneitdownprefs.plist$(ECHO_END)
