include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LibellumPrefs
LibellumPrefs_FILES = LBMRootListController.m LBMHeaderCell.m
LibellumPrefs_INSTALL_PATH = /Library/PreferenceBundles
LibellumPrefs_LIBRARIES = colorpicker
LibellumPrefs_FRAMEWORKS = UIKit
LibellumPrefs_PRIVATE_FRAMEWORKS = Preferences
LibellumPrefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
LibellumPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/LibellumPrefs.plist$(ECHO_END)
