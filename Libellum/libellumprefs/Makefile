include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LibellumPrefs
LibellumPrefs_FILES = LBMRootListController.m LBMGeneralListController.m LBMColorsListController.m LBMGesturesListController.m LBMLabeledSliderCell.m LBMHeaderView.m LBMBackupViewController.m LBMStylePickerCell.m LBMStyleOptionView.m LBMStyleCheckView.m
LibellumPrefs_INSTALL_PATH = /Library/PreferenceBundles
LibellumPrefs_LIBRARIES = colorpicker
LibellumPrefs_FRAMEWORKS = UIKit AVFoundation
LibellumPrefs_PRIVATE_FRAMEWORKS = Preferences AppSupport
LibellumPrefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs Alderis
LibellumPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/LibellumPrefs.plist$(ECHO_END)
