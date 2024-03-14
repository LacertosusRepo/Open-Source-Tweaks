BUNDLE_NAME = libellumPrefs
libellumPrefs_FILES = $(wildcard *.m LBMStylePickerCell/*.m)
libellumPrefs_INSTALL_PATH = /Library/PreferenceBundles
libellumPrefs_LIBRARIES = colorpicker gcuniversal
libellumPrefs_FRAMEWORKS = UIKit AVFoundation
libellumPrefs_PRIVATE_FRAMEWORKS = Preferences AppSupport
libellumPrefs_EXTRA_FRAMEWORKS = Alderis
libellumPrefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -DPACKAGE_VERSION='@"$(THEOS_PACKAGE_BASE_VERSION)"' -DPACKAGE_SCHEME='@"$(THEOS_PACKAGE_SCHEME)"'

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk
