#line 1 "Tweak.xm"

#define settingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.samplasion.custombetaalertprefs.plist"]

































#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBLockScreenManager; 
static void (*_logos_orig$_ungrouped$SBLockScreenManager$setUIUnlocking$)(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$SBLockScreenManager$setUIUnlocking$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST, SEL, BOOL); 

#line 35 "Tweak.xm"


static void _logos_method$_ungrouped$SBLockScreenManager$setUIUnlocking$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL isUnlocking) {
    
    _logos_orig$_ungrouped$SBLockScreenManager$setUIUnlocking$(self, _cmd, isUnlocking);
    if (isUnlocking) {
      NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
      bool enabled = [[prefs objectForKey:@"enabled"] boolValue];
      NSString* title = [prefs objectForKey:@"title"];
      NSString* msg = [prefs objectForKey:@"msg"];
      NSString* button = [prefs objectForKey:@"button"];
      if (enabled) {
        
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:title
            message:msg
            delegate:self
            cancelButtonTitle:button
            otherButtonTitles:nil];
        
        [alert1 show];
        
        [alert1 release];
      }
      [prefs release];
    }
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBLockScreenManager = objc_getClass("SBLockScreenManager"); MSHookMessageEx(_logos_class$_ungrouped$SBLockScreenManager, @selector(setUIUnlocking:), (IMP)&_logos_method$_ungrouped$SBLockScreenManager$setUIUnlocking$, (IMP*)&_logos_orig$_ungrouped$SBLockScreenManager$setUIUnlocking$);} }
#line 63 "Tweak.xm"
