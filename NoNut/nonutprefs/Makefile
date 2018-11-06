include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = nonutprefs
nonutprefs_FILES = NNNRootListController.m LacertosusButtonController.m
nonutprefs_INSTALL_PATH = /Library/PreferenceBundles
nonutprefs_FRAMEWORKS = UIKit
nonutprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/nonutprefs.plist$(ECHO_END)
