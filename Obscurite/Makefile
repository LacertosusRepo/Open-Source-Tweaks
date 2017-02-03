include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Obscurite
Obscurite_FILES = Tweak.xm
Obscurite_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += obscuriteprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
