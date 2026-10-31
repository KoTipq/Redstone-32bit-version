#import "../Redstone.h"

@implementation RSLockScreenPasscodeEntryButton

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[buttonLabel setFont:RSFont(@"SegoeUI", 34)];
		[buttonLabel setTextColor:[UIColor whiteColor]];
		[buttonLabel setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:buttonLabel];
		
		UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
		[longPressGestureRecognizer setMinimumPressDuration:0];
		[longPressGestureRecognizer setCancelsTouchesInView:NO];
		[longPressGestureRecognizer setDelaysTouchesBegan:NO];
		[longPressGestureRecognizer setDelaysTouchesEnded:NO];
		[self addGestureRecognizer:longPressGestureRecognizer];
	}
	
	return self;
}

- (void)pressed:(UILongPressGestureRecognizer*)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		[self setBackgroundColor:[RSAesthetics accentColor]];
		
		if (self.isBackSpaceButton) {
			[[[[RSLockScreenController sharedInstance] passcodeEntryController] currentKeypad] passcodeLockNumberPadBackspaceButtonHit:nil];
		} else {
			[[[[RSLockScreenController sharedInstance] passcodeEntryController] currentKeypad] passcodeLockNumberPad:nil keyDown:self.numberPadButton];
		}
	} else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
		[self setBackgroundColor:[UIColor clearColor]];
		
		if (!self.isBackSpaceButton && [[[RSLockScreenController sharedInstance] passcodeEntryController] currentKeypad]) {
			[[[[RSLockScreenController sharedInstance] passcodeEntryController] currentKeypad] passcodeLockNumberPad:nil keyUp:self.numberPadButton];
		}
	}
}

- (void)setButtonLabelText:(NSString*)buttonLabelText {
	if (!self.isBackSpaceButton) {
		[buttonLabel setText:buttonLabelText];
	}
}

- (void)setIsBackSpaceButton:(BOOL)isBackSpaceButton {
	_isBackSpaceButton = isBackSpaceButton;
	
	if (isBackSpaceButton) {
		[buttonLabel setFont:RSFont(@"SegoeMDL2Assets", 34)];
		[buttonLabel setText:RSGlyph(@"\uE94F", @"⌫")];
	}
}

@end
