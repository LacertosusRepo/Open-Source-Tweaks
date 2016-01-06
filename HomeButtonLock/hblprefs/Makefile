ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = hblprefs
hblprefs_FILES = hblprefs.mm
hblprefs_INSTALL_PATH = /Library/PreferenceBundles
hblprefs_FRAMEWORKS = UIKit
hblprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/hblprefs.plist$(ECHO_END)
