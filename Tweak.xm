//Here, using Logos's 'hook' construct to access the SpringBoard class. 'Hooking' basically means we want to access this class and modify the methods inside it.
#define settingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.samplasion.custombetaalertprefs.plist"]

/*
@interface SBWiFiManager
-(id)sharedInstance;
-(void)setWiFiEnabled:(BOOL)enabled;
-(bool)wiFiEnabled;
-(bool)isAssociated;
@end
*/

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
NSInteger batteryConditions;
NSInteger batteryTreshold;
// NSInteger wifiConditions;

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
  batteryConditions = [[prefs objectForKey:@"batteryconditions"] intValue];
  batteryTreshold = [[prefs objectForKey:@"batterytreshold"] intValue];
  // wifiConditions = [[prefs objectForKey:@"wificonditions"] intValue];

  [prefs release];
}

static bool getConditionBool() {
  bool batteryState = [[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging;
  NSInteger batteryLevel = [@([[UIDevice currentDevice] batteryLevel] * 100) intValue];
  // SBWiFiManager *wiFiManager = (SBWiFiManager *)[%c(SBWiFiManager) sharedInstance];
  // BOOL wifiConnected = [wiFiManager isAssociated];

  return enabled && (conditions == 0
    || (conditions == 1 && batteryState == YES)
    || (conditions == 2 && batteryState == NO)) && (batteryConditions == 0
    || (batteryConditions == 1 && batteryLevel >= batteryTreshold)
    || (batteryConditions == 2 && batteryLevel <= batteryTreshold));
    /* && (wifiConditions == 0
    || (wifiConditions == 1 && wifiConnected == YES)
    || (wifiConditions == 2 && wifiConnected == NO))*/
}

static void show(id ourSelf) {
  loadPrefs();
  if (getConditionBool()) {
    // Initialize our alert
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:title
        message:msg
        delegate:ourSelf
        cancelButtonTitle:button
        otherButtonTitles:nil];
    // Now show that alert
    [alert1 show];
    // And release it. We don't want any memory leaks ;)
    [alert1 release];
  }
}

%hook SBLockScreenManager
- (void) _finishUIUnlockFromSource:(int)source withOptions:(id)options {
    %orig;
    show(self);
}
%end
