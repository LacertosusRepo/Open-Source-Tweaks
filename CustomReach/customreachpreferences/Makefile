ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = customreachpreferences
customreachpreferences_FILES = customreachpreferences.mm
customreachpreferences_INSTALL_PATH = /Library/PreferenceBundles
customreachpreferences_FRAMEWORKS = UIKit
customreachpreferences_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/customreachpreferences.plist$(ECHO_END)
