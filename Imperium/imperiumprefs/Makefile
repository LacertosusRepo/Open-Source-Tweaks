include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = imperiumprefs
imperiumprefs_FILES = IMPRootListController.m IMPHeaderCell.m
imperiumprefs_INSTALL_PATH = /Library/PreferenceBundles
imperiumprefs_FRAMEWORKS = UIKit
imperiumprefs_PRIVATE_FRAMEWORKS = Preferences
imperiumprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
imperiumprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/imperiumprefs.plist$(ECHO_END)
