export ARCHS = arm64
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = vitrumprefs
vitrumprefs_FILES = GLARootListController.m LacertosusButtonController.m
vitrumprefs_LIBRARIES = colorpicker
vitrumprefs_INSTALL_PATH = /Library/PreferenceBundles
vitrumprefs_FRAMEWORKS = UIKit
vitrumprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/vitrumprefs.plist$(ECHO_END)
