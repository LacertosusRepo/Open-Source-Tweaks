include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = flashnotifyprefs
flashnotifyprefs_FILES = FNPRootListController.m FNPTimeIntervalPickerCell.m FNPSegmentTableImageCell.m FNPHeaderView.m
flashnotifyprefs_INSTALL_PATH = /Library/PreferenceBundles
flashnotifyprefs_FRAMEWORKS = UIKit
flashnotifyprefs_PRIVATE_FRAMEWORKS = Preferences
flashnotifyprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
flashnotifyprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/flashnotifyprefs.plist$(ECHO_END)
