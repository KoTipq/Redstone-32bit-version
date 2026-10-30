#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

%hook RSSoundController

- (void)headphoneConnectionChanged:(NSNotification *)notification {
    if (!notification || !notification.userInfo) {
        return;
    }
    
    %orig(notification);
}

%end
