ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = soundprefs
soundprefs_FILES = soundprefs.mm
soundprefs_INSTALL_PATH = /Library/PreferenceBundles
soundprefs_FRAMEWORKS = UIKit
soundprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/soundprefs.plist$(ECHO_END)
