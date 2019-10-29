include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = dialergradientprefs
dialergradientprefs_FILES = DIARootListController.m DIAHeaderCell.m
dialergradientprefs_INSTALL_PATH = /Library/PreferenceBundles
dialergradientprefs_LIBRARIES = colorpicker
dialergradientprefs_FRAMEWORKS = UIKit
dialergradientprefs_PRIVATE_FRAMEWORKS = Preferences
dialergradientprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
dialergradientprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/dialergradientprefs.plist$(ECHO_END)
