#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_HeadphoneJackIsConnectedDidChangeNotification" object:nil];
}

%end
