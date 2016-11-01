include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = hcprefs
hcprefs_FILES = hpkRootListController.m HaptikCenterButtonController.m
hcprefs_INSTALL_PATH = /Library/PreferenceBundles
hcprefs_FRAMEWORKS = UIKit CoreGraphics
hcprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/hcprefs.plist$(ECHO_END)
