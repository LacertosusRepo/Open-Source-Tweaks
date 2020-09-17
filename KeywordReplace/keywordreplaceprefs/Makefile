include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = keywordreplaceprefs
keywordreplaceprefs_FILES = KWDRootListController.m KWDHeaderView.m KWDKeywordListController.m KWDKeywordTextCell.m
keywordreplaceprefs_INSTALL_PATH = /Library/PreferenceBundles
keywordreplaceprefs_FRAMEWORKS = UIKit
keywordreplaceprefs_PRIVATE_FRAMEWORKS = Preferences
keywordreplaceprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
keywordreplaceprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/keywordreplaceprefs.plist$(ECHO_END)
