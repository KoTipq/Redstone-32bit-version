#include "RDSRootListController.h"
#include <dlfcn.h>

// system() is marked unavailable in newer iOS SDKs, so look it up at runtime.
#define RDSLocalized(text) [[NSBundle bundleForClass:[RDSRootListController class]] localizedStringForKey:text value:text table:@"Root"]

static void RDSRunCommand(const char* command) {
	int (*systemFunction)(const char*) = (int (*)(const char*))dlsym(RTLD_DEFAULT, "system");
	if (systemFunction) {
		systemFunction(command);
	}
}

@implementation RDSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	settingsView = [[UIApplication sharedApplication] keyWindow];
	
	settingsView.tintColor = [UIColor redColor];
	self.navigationController.navigationBar.tintColor = [UIColor redColor];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	settingsView.tintColor = nil;
	self.navigationController.navigationBar.tintColor = nil;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void)killSpringBoard {
	RDSRunCommand("killall SpringBoard");
}
#pragma GCC diagnostic pop

- (id)readPreferenceValue:(PSSpecifier*)specifier {
	id properties = [specifier properties];
	
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", properties[@"defaults"]];
	NSDictionary* settings = [NSDictionary dictionaryWithContentsOfFile:path];
	
	if ([[specifier propertyForKey:@"key"] isEqualToString:@"showMoreTiles"] && [UIScreen mainScreen].bounds.size.width == 414) {
		[specifier setProperty:[NSNumber numberWithBool:NO] forKey:@"enabled"];
	}
	
	return (settings[properties[@"key"]]) ?: properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	id properties = [specifier properties];
	
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", properties[@"defaults"]];
	NSMutableDictionary* settings = [NSMutableDictionary dictionaryWithContentsOfFile:path] ?: [NSMutableDictionary dictionary];
	
	[settings setObject:value forKey:properties[@"key"]];
	[settings writeToFile:path atomically:YES];
	CFStringRef notificationName = (CFStringRef)properties[@"PostNotification"];
	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void)resetHomeScreenLayout {
	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:@""
										  message:RDSLocalized(@"This will reset your Start Screen layout to factory defaults.")
										  preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction *cancelAction = [UIAlertAction
								   actionWithTitle:RDSLocalized(@"Cancel")
								   style:UIAlertActionStyleCancel
								   handler:nil];
	
	UIAlertAction *okAction = [UIAlertAction
							   actionWithTitle:RDSLocalized(@"Reset Start Screen")
							   style:UIAlertActionStyleDestructive
							   handler:^(UIAlertAction *action) {
								   NSMutableDictionary* preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/ml.festival.redstone.plist"] ?: [NSMutableDictionary dictionary];
								   NSArray* twoColumnLayout = [NSArray arrayWithContentsOfFile:@"/var/mobile/Library/FESTIVAL/Redstone/2ColumnDefaultLayout.plist"];
								   NSArray* threeColumnLayout = [NSArray arrayWithContentsOfFile:@"/var/mobile/Library/FESTIVAL/Redstone/3ColumnDefaultLayout.plist"];
								   if (twoColumnLayout) {
									   [preferences setObject:twoColumnLayout forKey:@"2ColumnLayout"];
								   }
								   if (threeColumnLayout) {
									   [preferences setObject:threeColumnLayout forKey:@"3ColumnLayout"];
								   }
								   [preferences writeToFile:@"/var/mobile/Library/Preferences/ml.festival.redstone.plist" atomically:YES];
								   
								   RDSRunCommand("killall backboardd");
							   }];
	[alertController addAction:cancelAction];
	[alertController addAction:okAction];
	[self presentViewController:alertController animated:YES completion:nil];
}
#pragma GCC diagnostic pop

@end
