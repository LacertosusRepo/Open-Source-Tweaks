ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = popprefs
popprefs_FILES = popprefs.mm
popprefs_INSTALL_PATH = /Library/PreferenceBundles
popprefs_FRAMEWORKS = UIKit
popprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/popprefs.plist$(ECHO_END)
