include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ExampleCepheiProjectPrefs

ExampleCepheiProjectPrefs_FILES = ECPRootListController.m
ExampleCepheiProjectPrefs_INSTALL_PATH = /Library/PreferenceBundles
ExampleCepheiProjectPrefs_FRAMEWORKS = UIKit
ExampleCepheiProjectPrefs_PRIVATE_FRAMEWORKS = Preferences
	# add Cephei and CepheiPrefs to extra frameworks
ExampleCepheiProjectPrefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
ExampleCepheiProjectPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ExampleCepheiProjectPrefs.plist$(ECHO_END)
