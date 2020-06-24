include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = badgecolorprefs
badgecolorprefs_FILES = BCPRootListController.m BCPLabeledSliderCell.m
badgecolorprefs_INSTALL_PATH = /Library/PreferenceBundles
badgecolorprefs_LIBRARIES = colorpicker
badgecolorprefs_FRAMEWORKS = UIKit
badgecolorprefs_PRIVATE_FRAMEWORKS = Preferences
badgecolorprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs Alderis
badgecolorprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/badgecolorprefs.plist$(ECHO_END)
