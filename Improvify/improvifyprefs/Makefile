include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = improvifyprefs
improvifyprefs_FILES = IFYRootListController.m IFYHeaderCell.m
improvifyprefs_INSTALL_PATH = /Library/PreferenceBundles
improvifyprefs_LIBRARIES = colorpicker
improvifyprefs_FRAMEWORKS = UIKit
improvifyprefs_PRIVATE_FRAMEWORKS = Preferences
improvifyprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
improvifyprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/improvifyprefs.plist$(ECHO_END)
