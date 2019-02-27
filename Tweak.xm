//Here, using Logos's 'hook' construct to access the SpringBoard class. 'Hooking' basically means we want to access this class and modify the methods inside it.
#define settingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.samplasion.custombetaalertprefs.plist"]

%hook SBLockScreenManager

-(void)setUIUnlocking:(BOOL)isUnlocking {
    // We'll use this method to define when the user is unlocking the device
    %orig(isUnlocking);
    if (isUnlocking) {
      NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
      bool enabled = [[prefs objectForKey:@"enabled"] boolValue];
      NSString* title = [prefs objectForKey:@"title"];
      NSString* msg = [prefs objectForKey:@"msg"];
      NSString* button = [prefs objectForKey:@"button"];
      if (enabled) {
        // Initialize our alert
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:title
            message:msg
            delegate:self
            cancelButtonTitle:button
            otherButtonTitles:nil];
        //Now show that alert
        [alert1 show];
        //And release it. We don't want any memory leaks ;)
        [alert1 release];
      }
      [prefs release];
    }
}

%end
