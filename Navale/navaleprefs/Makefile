include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = navaleprefs
navaleprefs_FILES = NAVRootListController.m LacertosusButtonController.m
navaleprefs_INSTALL_PATH = /Library/PreferenceBundles
navaleprefs_LIBRARIES = colorpicker
navaleprefs_FRAMEWORKS = UIKit
navaleprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/navaleprefs.plist$(ECHO_END)
