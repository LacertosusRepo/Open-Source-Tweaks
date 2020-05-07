include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = coloredscrollindicatorprefs
coloredscrollindicatorprefs_FILES = CIPRootListController.m CIPLabeledSliderCell.m CIPColorIndicatorCell.m CIPHeaderCell.m CIPGradientPreviewCell.m
coloredscrollindicatorprefs_INSTALL_PATH = /Library/PreferenceBundles
coloredscrollindicatorprefs_FRAMEWORKS = UIKit
coloredscrollindicatorprefs_LIBRARIES = colorpicker
coloredscrollindicatorprefs_PRIVATE_FRAMEWORKS = Preferences
coloredscrollindicatorprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
coloredscrollindicatorprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/coloredscrollindicatorprefs.plist$(ECHO_END)
