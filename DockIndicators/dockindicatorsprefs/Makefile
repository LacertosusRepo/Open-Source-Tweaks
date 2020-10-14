include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = dockindicatorsprefs
dockindicatorsprefs_FILES = DIPRootListController.m DIPHeaderView.m DIPLabeledSliderCell.m DIPIndicatorPreviewCell.m DIPModifyCachedAppColorsController.m DIPAppColorCell.m
dockindicatorsprefs_INSTALL_PATH = /Library/PreferenceBundles
dockindicatorsprefs_LIBRARIES = colorpicker
dockindicatorsprefs_FRAMEWORKS = UIKit
dockindicatorsprefs_PRIVATE_FRAMEWORKS = Preferences
dockindicatorsprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs Alderis
dockindicatorsprefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/bundle.mk
