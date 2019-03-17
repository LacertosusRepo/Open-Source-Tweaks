include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = stellaeprefs
stellaeprefs_FILES = STLRootListController.m STLButtonController.m
stellaeprefs_INSTALL_PATH = /Library/PreferenceBundles
stellaeprefs_FRAMEWORKS = UIKit
stellaeprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/stellaeprefs.plist$(ECHO_END)
