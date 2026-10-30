#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface RDSRootListController : PSListController {
	UIWindow* settingsView;
}


- (void)killSpringBoard;
- (void)resetHomeScreenLayout;

@end
