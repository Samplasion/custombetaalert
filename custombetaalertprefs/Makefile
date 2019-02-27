include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = custombetaalertprefs
custombetaalertprefs_FILES = CBARootListController.m
custombetaalertprefs_INSTALL_PATH = /Library/PreferenceBundles
custombetaalertprefs_FRAMEWORKS = UIKit
custombetaalertprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/custombetaalertprefs.plist$(ECHO_END)
