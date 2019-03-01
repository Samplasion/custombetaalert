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

static void loadPrefs() {
  prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
  enabled = [[prefs objectForKey:@"enabled"] boolValue];
  title = [prefs objectForKey:@"title"] ?: fallbackTitle;
  title = [title stringByReplacingOccurrencesOfString:@"@@iOS" withString:iOSVersion];
  msg = [prefs objectForKey:@"msg"] ?: fallbackMsg;
  msg = [msg stringByReplacingOccurrencesOfString:@"@@iOS" withString:iOSVersion];
  button = [prefs objectForKey:@"button"] ?: fallbackButton;
  button = [button stringByReplacingOccurrencesOfString:@"@@iOS" withString:iOSVersion];
}

static void show(id ourSelf) {
  loadPrefs();
  if (enabled) {
    // Initialize our alert
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:title
        message:msg
        delegate:ourSelf
        cancelButtonTitle:button
        otherButtonTitles:nil];
    //Now show that alert
    [alert1 show];
    //And release it. We don't want any memory leaks ;)
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
