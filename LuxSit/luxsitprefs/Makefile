include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = luxsitprefs
luxsitprefs_FILES = LUXRootListController.m LUXHeaderCell.m
luxsitprefs_INSTALL_PATH = /Library/PreferenceBundles
luxsitprefs_FRAMEWORKS = UIKit
luxsitprefs_PRIVATE_FRAMEWORKS = Preferences
luxsitprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
luxsitprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/luxsitprefs.plist$(ECHO_END)
