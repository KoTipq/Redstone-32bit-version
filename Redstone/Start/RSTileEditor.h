#import <UIKit/UIKit.h>

@class RSTile;

@interface RSTileEditor : UIView

- (id)initWithTile:(RSTile*)tile;
- (void)show;
- (void)hide;

@end
