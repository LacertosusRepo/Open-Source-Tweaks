include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = speculumprefs
speculumprefs_FILES = SPCRootListController.m SPCHeaderCell.m
speculumprefs_INSTALL_PATH = /Library/PreferenceBundles
speculumprefs_FRAMEWORKS = UIKit
speculumprefs_LIBRARIES = colorpicker
speculumprefs_PRIVATE_FRAMEWORKS = Preferences
speculumprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
speculumprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/speculumprefs.plist$(ECHO_END)
