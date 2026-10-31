#import <UIKit/UIKit.h>

@class SBLeafIcon, RSTiltView, RSTileInfo, RSTileNotificationView, BBBulletin;
@protocol RSLiveTileDelegate;

@interface RSTile : RSTiltView <UIGestureRecognizerDelegate> {
	CGPoint centerOffset;
	
	UIView* tileWrapper;
	UIView* tileContainer;
	
	UILabel* tileLabel;
	UIImageView* tileImageView;
	
	int badgeValue;
	UILabel* badgeLabel;
	
	UIView* unpinButton;
	UIView* scaleButton;
	UIView* customizeButton;
	UIImageView* customBackgroundView;
	BOOL customIconApplied;
	
	UITapGestureRecognizer* tapGestureRecognizer;
	UILongPressGestureRecognizer* longPressGestureRecognizer;
	UIPanGestureRecognizer* panGestureRecognizer;
	
	UITapGestureRecognizer* unpinGestureRecognizer;
	UITapGestureRecognizer* scaleGestureRecognizer;
	UITapGestureRecognizer* customizeGestureRecognizer;
	
	BOOL shouldAllowPan;
	
	UIView<RSLiveTileDelegate>* liveTile;
	NSTimer* liveTileUpdateTimer;
	NSTimer* liveTileAnimationTimer;
	NSInteger liveTilePageIndex;
	
	RSTileNotificationView* notificationTile;
	
	UIView* wallpaperClipView;
	UIImageView* wallpaperCropView;
	UIView* wallpaperTintView;
}

@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) int size;
@property (nonatomic, strong) RSTileInfo* tileInfo;
@property (nonatomic, strong) SBLeafIcon* icon;
@property (nonatomic, strong) NSString* iconIdentifier;
@property (nonatomic, assign) BOOL isSelectedTile;
@property (nonatomic, assign) int tileX;
@property (nonatomic, assign) int tileY;
@property (nonatomic, assign, readonly) CGRect basePosition;

// Per-tile customization
@property (nonatomic, strong) NSString* customColor;
@property (nonatomic, strong) NSNumber* customOpacity;
@property (nonatomic, assign) BOOL useCustomBackground;
@property (nonatomic, assign) BOOL useCustomIcon;

- (id)initWithFrame:(CGRect)frame leafIdentifier:(NSString*)leafId size:(int)tileSize;
- (CGRect)basePosition;
- (CGPoint)originalCenter;
- (void)setBadge:(int)badgeCount;

- (void)applyCustomization;
- (void)applyCustomizationColors;
- (void)resetCustomization;
- (void)loadCustomizationFromDictionary:(NSDictionary*)dictionary;
- (void)writeCustomizationToDictionary:(NSMutableDictionary*)dictionary;
+ (NSString*)customFilesPathForIdentifier:(NSString*)identifier;
+ (BOOL)customImageExistsNamed:(NSString*)name forIdentifier:(NSString*)identifier;

+ (BOOL)wallpaperInTilesEnabled;
+ (UIImage*)sharedTileWallpaper;
+ (void)invalidateSharedTileWallpaper;
- (void)updateWallpaperCrop;
- (void)reloadWallpaperImage;

- (void)startLiveTile;
- (void)stopLiveTile;
- (void)setLiveTileHidden:(BOOL)hidden;
- (void)setLiveTileHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)addBulletin:(BBBulletin*)bulletin;
- (void)removeBulletin:(BBBulletin*)bulletin;

@end
