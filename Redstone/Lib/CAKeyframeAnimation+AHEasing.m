#import "CAKeyframeAnimation+AHEasing.h"

@implementation CAKeyframeAnimation (AHEasing)

+ (id)animationWithKeyPath:(NSString *)path function:(AHEasingFunction)function fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
    
    NSUInteger steps = 60;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:steps];
    
    for (NSUInteger i = 0; i < steps; i++) {
        CGFloat t = (CGFloat)i / (CGFloat)(steps - 1);
        CGFloat evaluatedValue = fromValue + function(t) * (toValue - fromValue);
        
        if (isnan(evaluatedValue) || isinf(evaluatedValue)) {
            evaluatedValue = toValue;
        }
        
        NSNumber *numberValue = [NSNumber numberWithFloat:evaluatedValue];
        if (numberValue != nil) {
            [values addObject:numberValue];
        } else {
            [values addObject:[NSNumber numberWithFloat:toValue]];
        }
    }
    
    [animation setValues:values];
    return animation;
}

@end
