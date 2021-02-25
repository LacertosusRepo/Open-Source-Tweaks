include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = libellumPrefs
libellumPrefs_FILES = $(wildcard *.m LBMStylePickerCell/*.m)
libellumPrefs_INSTALL_PATH = /Library/PreferenceBundles
libellumPrefs_LIBRARIES = colorpicker
libellumPrefs_FRAMEWORKS = UIKit AVFoundation
libellumPrefs_PRIVATE_FRAMEWORKS = Preferences AppSupport
libellumPrefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs Alderis
libellumPrefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/bundle.mk
