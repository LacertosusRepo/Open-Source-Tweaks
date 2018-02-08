include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = notiprefs
notiprefs_FILES = NOTRootListController.m
notiprefs_INSTALL_PATH = /Library/PreferenceBundles
notiprefs_FRAMEWORKS = UIKit
notiprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/notiprefs.plist$(ECHO_END)
