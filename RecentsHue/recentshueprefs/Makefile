include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = recentshueprefs
recentshueprefs_FILES = RHPRootListController.m RHPLabeledSliderCell.m RHPHeaderView.m
recentshueprefs_INSTALL_PATH = /Library/PreferenceBundles
recentshueprefs_LIBRARIES = colorpicker
recentshueprefs_FRAMEWORKS = UIKit AppSupport
recentshueprefs_PRIVATE_FRAMEWORKS = Preferences
recentshueprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs Alderis
recentshueprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/recentshueprefs.plist$(ECHO_END)
