#line 1 "Tweak.xm"

#define settingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.samplasion.custombetaalertprefs.plist"]

CGFloat iOSVersionFloat = [[[UIDevice currentDevice] systemVersion] floatValue];
NSInteger iOSVersionInt = (NSInteger)(floor(iOSVersionFloat));
NSString *iOSVersion = [@(iOSVersionInt) stringValue];
NSString *fallbackTitle = [NSString stringWithFormat:@"A new iOS update is available. Please update from the iOS %@ beta.", iOSVersion];
NSString *fallbackMsg = @"";
NSString *fallbackButton = @"Close";

NSMutableDictionary *prefs;
bool enabled;
NSString *title;
NSString *msg;
NSString *button;
NSInteger conditions;
NSInteger batteryTreshold;

static NSString *placeholders(NSString *og) {
  NSString *ret = og;
  NSString *battery = [ @( [ @( [[UIDevice currentDevice] batteryLevel] * 100 ) intValue ] ) stringValue ];

  ret = [ret stringByReplacingOccurrencesOfString:@"%iOS" withString:iOSVersion];
  ret = [ret stringByReplacingOccurrencesOfString:@"%batt" withString:battery];
  ret = [ret stringByReplacingOccurrencesOfString:@"%model" withString:[UIDevice currentDevice].localizedModel];

  return ret;
}

static void loadPrefs() {
  prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
  enabled = [[prefs objectForKey:@"enabled"] boolValue];
  title = [prefs objectForKey:@"title"] ?: fallbackTitle;
  title = placeholders(title);
  msg = [prefs objectForKey:@"msg"] ?: fallbackMsg;
  msg = placeholders(msg);
  button = [prefs objectForKey:@"button"] ?: fallbackButton;
  button = placeholders(button);

  conditions = [[prefs objectForKey:@"conditions"] intValue];
  conditions = [[prefs objectForKey:@"batterytreshold"] intValue];
}

static bool getConditionBool() {
  bool batteryState = [[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging;
  NSInteger batteryLevel = [@([[UIDevice currentDevice] batteryLevel] * 100) intValue];

  return enabled && (conditions == 0
    || (conditions == 1 && batteryState == YES)
    || (conditions == 2 && batteryState == NO)
    || (conditions == 3 && batteryLevel >= batteryTreshold)
    || (conditions == 4 && batteryLevel <= batteryTreshold));
}

static void show(id ourSelf) {
  loadPrefs();
  if (getConditionBool()) {
    
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:title
        message:msg
        delegate:ourSelf
        cancelButtonTitle:button
        otherButtonTitles:nil];
    
    [alert1 show];
    
    [alert1 release];
  }
  [prefs release];
}


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
static void (*_logos_orig$_ungrouped$SBLockScreenManager$_finishUIUnlockFromSource$withOptions$)(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST, SEL, int, id); static void _logos_method$_ungrouped$SBLockScreenManager$_finishUIUnlockFromSource$withOptions$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST, SEL, int, id); 

#line 72 "Tweak.xm"

static void _logos_method$_ungrouped$SBLockScreenManager$_finishUIUnlockFromSource$withOptions$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int source, id options) {
    _logos_orig$_ungrouped$SBLockScreenManager$_finishUIUnlockFromSource$withOptions$(self, _cmd, source, options);
    show(self);
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBLockScreenManager = objc_getClass("SBLockScreenManager"); MSHookMessageEx(_logos_class$_ungrouped$SBLockScreenManager, @selector(_finishUIUnlockFromSource:withOptions:), (IMP)&_logos_method$_ungrouped$SBLockScreenManager$_finishUIUnlockFromSource$withOptions$, (IMP*)&_logos_orig$_ungrouped$SBLockScreenManager$_finishUIUnlockFromSource$withOptions$);} }
#line 78 "Tweak.xm"
