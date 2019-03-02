//Here, using Logos's 'hook' construct to access the SpringBoard class. 'Hooking' basically means we want to access this class and modify the methods inside it.
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
}

static bool getConditionBool() {
  bool batteryState = [[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging;
  return enabled && (conditions == 0 || (conditions == 1 && batteryState == YES) || (conditions == 2 && batteryState == NO));
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
  [prefs release];
}

%hook SBLockScreenManager
- (void) _finishUIUnlockFromSource:(int)source withOptions:(id)options {
    %orig;
    show(self);
}
%end
