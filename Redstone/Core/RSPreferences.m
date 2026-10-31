#import "../Redstone.h"

@implementation RSPreferences

static RSPreferences* sharedInstance;

+ (NSMutableDictionary*)preferences {
	return sharedInstance.preferences;
}

+ (void)setValue:(id)value forKey:(NSString*)key {
	[sharedInstance.preferences setObject:value forKey:key];
	[sharedInstance.preferences writeToFile:PREFERENCES_PATH atomically:YES];
}

- (id)init {
	self = [super init];
	
	if (self) {
		sharedInstance = self;
		
		self.preferences = [NSMutableDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
		if (!self.preferences) {
			self.preferences = [[NSMutableDictionary alloc] init];
		}
		
		if (![self.preferences objectForKey:@"enabled"]) {
			self.preferences = [[NSMutableDictionary alloc] init];
			[self.preferences setValue:[NSNumber numberWithBool:YES] forKey:@"enabled"];
		}
		
		if (![self.preferences objectForKey:@"startScreenEnabled"]) {
			[self.preferences setValue:[NSNumber numberWithBool:YES] forKey:@"startScreenEnabled"];
		}
		
		if (![self.preferences objectForKey:@"lockScreenEnabled"]) {
			[self.preferences setValue:[NSNumber numberWithBool:YES] forKey:@"lockScreenEnabled"];
		}
		
		if (![self.preferences objectForKey:@"notificationsEnabled"]) {
			[self.preferences setValue:[NSNumber numberWithBool:YES] forKey:@"notificationsEnabled"];
		}
		
		/*if (![self.preferences objectForKey:@"volumeControlEnabled"]) {
			[self.preferences setValue:[NSNumber numberWithBool:YES] forKey:@"volumeControlEnabled"];
		}*/
		
		if (![self.preferences objectForKey:@"accentColor"]) {
			[self.preferences setValue:@"#0078D7" forKey:@"accentColor"];
		}
		
		if (![self.preferences objectForKey:@"tileOpacity"]) {
			[self.preferences setValue:[NSNumber numberWithFloat:0.8] forKey:@"tileOpacity"];
		}
		
		if (![self.preferences objectForKey:@"showMoreTiles"] || [UIScreen mainScreen].bounds.size.width == 414) {
			[self.preferences setValue:[NSNumber numberWithBool:YES] forKey:@"showMoreTiles"];
		}
		
		/*if (![self.preferences objectForKey:@"showWallpaper"]) {
			[self.preferences setValue:[NSNumber numberWithBool:YES] forKey:@"showWallpaper"];
		}*/
		
		// Customization defaults (only added when missing, existing choices are kept)
		NSDictionary* customizationDefaults = @{
			@"tileSpacing": @5.0,
			@"tileIconScale": @1.0,
			@"showTileIcons": @YES,
			@"showTileLabels": @YES,
			@"largeTilesEnabled": @NO,
			@"tileTiltEnabled": @YES,
			@"liveTilesEnabled": @YES,
			@"lockScreenDim": @0.0,
			@"lockScreenTimeFormat": @"system",
			@"lockScreenShowDate": @YES,
			@"appListSortOrder": @"az",
			@"startBackgroundBlack": @NO,
			@"wallpaperInTiles": @YES,
			@"tallTilesEnabled": @NO,
			@"language": @"system"
		};
		for (NSString* key in customizationDefaults) {
			if (![self.preferences objectForKey:key]) {
				[self.preferences setObject:[customizationDefaults objectForKey:key] forKey:key];
			}
		}
		
		if (![self.preferences objectForKey:@"2ColumnLayout"]) {
			NSArray* defaultLayout = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/2ColumnDefaultLayout.plist", RESOURCE_PATH]];
			[self.preferences setObject:(defaultLayout ?: @[]) forKey:@"2ColumnLayout"];
		}
		
		if (![self.preferences objectForKey:@"3ColumnLayout"]) {
			NSArray* defaultLayout = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/3ColumnDefaultLayout.plist", RESOURCE_PATH]];
			[self.preferences setObject:(defaultLayout ?: @[]) forKey:@"3ColumnLayout"];
		}
		
		[self.preferences writeToFile:PREFERENCES_PATH atomically:YES];
	}
	
	return self;
}

@end
