#import "../Redstone.h"

@implementation RSTileEditor {
	RSTile* editedTile;
	
	UIView* panel;
	NSArray* paletteColors;
	NSMutableArray* swatchButtons;
	
	UISlider* opacitySlider;
	UILabel* opacityValueLabel;
	UISwitch* backgroundSwitch;
	UISwitch* iconSwitch;
	UILabel* hintLabel;
}

- (id)initWithTile:(RSTile*)tile {
	self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
	
	if (self) {
		editedTile = tile;
		swatchButtons = [NSMutableArray new];
		
		// Windows 10 accent colors
		paletteColors = @[@"#FFB900", @"#FF8C00", @"#F7630C", @"#CA5010", @"#DA3B01", @"#EF6950",
						  @"#D13438", @"#E81123", @"#EA005E", @"#C30052", @"#E3008C", @"#BF0077",
						  @"#C239B3", @"#9A0089", @"#0078D7", @"#0063B1", @"#8E8CD8", @"#6B69D6",
						  @"#8764B8", @"#744DA9", @"#B146C2", @"#881798", @"#0099BC", @"#2D7D9A",
						  @"#00B7C3", @"#038387", @"#00B294", @"#018574", @"#00CC6A", @"#10893E",
						  @"#7A7574", @"#5D5A58", @"#68768A", @"#515C6B", @"#498205", @"#000000"];
		
		[self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
		
		CGFloat margin = 20;
		CGFloat contentWidth = screenWidth - margin * 2;
		CGFloat panelHeight = 452;
		
		panel = [[UIView alloc] initWithFrame:CGRectMake(0, MAX((screenHeight - panelHeight) / 2, 0), screenWidth, panelHeight)];
		[panel setBackgroundColor:[UIColor colorWithWhite:0.23 alpha:1.0]];
		[panel.layer setBorderWidth:2.0];
		[panel.layer setBorderColor:[RSAesthetics accentColor].CGColor];
		[self addSubview:panel];
		
		[panel addSubview:[self labelWithText:[RSAesthetics localizedStringForKey:@"TILE_EDITOR_TITLE"] frame:CGRectMake(margin, 14, contentWidth, 36) size:26 color:[UIColor whiteColor]]];
		
		// Color
		[panel addSubview:[self labelWithText:[RSAesthetics localizedStringForKey:@"TILE_EDITOR_COLOR"] frame:CGRectMake(margin, 60, contentWidth, 22) size:16 color:[UIColor colorWithWhite:0.75 alpha:1.0]]];
		
		UIScrollView* swatchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(margin, 84, contentWidth, 46)];
		[swatchScrollView setShowsHorizontalScrollIndicator:NO];
		[swatchScrollView setContentSize:CGSizeMake((paletteColors.count + 1) * 46, 46)];
		[panel addSubview:swatchScrollView];
		
		for (NSUInteger i = 0; i <= paletteColors.count; i++) {
			UIButton* swatch = [UIButton buttonWithType:UIButtonTypeCustom];
			[swatch setFrame:CGRectMake(i * 46, 3, 40, 40)];
			[swatch setTag:i];
			[swatch.layer setBorderWidth:2.0];
			
			if (i == 0) {
				// "Default color"
				[swatch setBackgroundColor:[UIColor colorWithWhite:0.38 alpha:1.0]];
				[swatch setTitle:@"✕" forState:UIControlStateNormal];
				[swatch.titleLabel setFont:[UIFont systemFontOfSize:18]];
			} else {
				[swatch setBackgroundColor:[RSAesthetics colorFromHexString:paletteColors[i - 1]]];
			}
			
			[swatch addTarget:self action:@selector(swatchTapped:) forControlEvents:UIControlEventTouchUpInside];
			[swatchScrollView addSubview:swatch];
			[swatchButtons addObject:swatch];
		}
		
		// Opacity
		[panel addSubview:[self labelWithText:[RSAesthetics localizedStringForKey:@"TILE_EDITOR_OPACITY"] frame:CGRectMake(margin, 140, contentWidth, 22) size:16 color:[UIColor colorWithWhite:0.75 alpha:1.0]]];
		
		opacitySlider = [[UISlider alloc] initWithFrame:CGRectMake(margin, 166, contentWidth - 56, 30)];
		[opacitySlider setMinimumValue:0.1];
		[opacitySlider setMaximumValue:1.0];
		[opacitySlider setMinimumTrackTintColor:[RSAesthetics accentColor]];
		[opacitySlider addTarget:self action:@selector(opacityChanged:) forControlEvents:UIControlEventValueChanged];
		[panel addSubview:opacitySlider];
		
		opacityValueLabel = [self labelWithText:@"" frame:CGRectMake(screenWidth - margin - 50, 166, 50, 30) size:16 color:[UIColor whiteColor]];
		[opacityValueLabel setTextAlignment:NSTextAlignmentRight];
		[panel addSubview:opacityValueLabel];
		
		// Switches
		[panel addSubview:[self labelWithText:[RSAesthetics localizedStringForKey:@"TILE_EDITOR_BACKGROUND"] frame:CGRectMake(margin, 214, contentWidth - 60, 31) size:17 color:[UIColor whiteColor]]];
		backgroundSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(screenWidth - margin - 51, 214, 51, 31)];
		[backgroundSwitch setOnTintColor:[RSAesthetics accentColor]];
		[backgroundSwitch addTarget:self action:@selector(backgroundSwitchChanged:) forControlEvents:UIControlEventValueChanged];
		[panel addSubview:backgroundSwitch];
		
		[panel addSubview:[self labelWithText:[RSAesthetics localizedStringForKey:@"TILE_EDITOR_ICON"] frame:CGRectMake(margin, 258, contentWidth - 60, 31) size:17 color:[UIColor whiteColor]]];
		iconSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(screenWidth - margin - 51, 258, 51, 31)];
		[iconSwitch setOnTintColor:[RSAesthetics accentColor]];
		[iconSwitch addTarget:self action:@selector(iconSwitchChanged:) forControlEvents:UIControlEventValueChanged];
		[panel addSubview:iconSwitch];
		
		// Hint about the folder for custom images
		hintLabel = [self labelWithText:@"" frame:CGRectMake(margin, 300, contentWidth, 80) size:12 color:[UIColor colorWithWhite:0.7 alpha:1.0]];
		[hintLabel setNumberOfLines:0];
		[hintLabel setLineBreakMode:NSLineBreakByCharWrapping];
		[panel addSubview:hintLabel];
		
		// Buttons
		CGFloat buttonWidth = (contentWidth - 6) / 2;
		[panel addSubview:[self buttonWithTitle:[RSAesthetics localizedStringForKey:@"TILE_EDITOR_RESET"] frame:CGRectMake(margin, panelHeight - 38 - 24, buttonWidth, 38) action:@selector(resetTapped)]];
		[panel addSubview:[self buttonWithTitle:[RSAesthetics localizedStringForKey:@"TILE_EDITOR_DONE"] frame:CGRectMake(margin + buttonWidth + 6, panelHeight - 38 - 24, buttonWidth, 38) action:@selector(doneTapped)]];
		
		[self refreshControls];
	}
	
	return self;
}

- (UILabel*)labelWithText:(NSString*)text frame:(CGRect)frame size:(CGFloat)size color:(UIColor*)color {
	UILabel* label = [[UILabel alloc] initWithFrame:frame];
	[label setText:text];
	[label setFont:RSFont(@"SegoeUI", size)];
	[label setTextColor:color];
	[label setBackgroundColor:[UIColor clearColor]];
	return label;
}

- (RSTiltView*)buttonWithTitle:(NSString*)title frame:(CGRect)frame action:(SEL)action {
	RSTiltView* button = [[RSTiltView alloc] initWithFrame:frame];
	[button setBackgroundColor:[UIColor colorWithWhite:0.38 alpha:1.0]];
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
	[label setText:title];
	[label setFont:RSFont(@"SegoeUI", 17)];
	[label setTextColor:[UIColor whiteColor]];
	[label setTextAlignment:NSTextAlignmentCenter];
	[button addSubview:label];
	
	UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
	[tap setCancelsTouchesInView:NO];
	[button addGestureRecognizer:tap];
	
	return button;
}

#pragma mark Updating the controls

- (void)refreshControls {
	// selected swatch
	NSInteger selectedIndex = 0;
	if (editedTile.customColor.length > 0) {
		NSUInteger index = [paletteColors indexOfObject:editedTile.customColor];
		selectedIndex = (index == NSNotFound) ? -1 : (NSInteger)(index + 1);
	}
	
	for (UIButton* swatch in swatchButtons) {
		BOOL selected = (swatch.tag == selectedIndex);
		[swatch.layer setBorderColor:(selected ? [UIColor whiteColor].CGColor : [UIColor clearColor].CGColor)];
	}
	
	CGFloat opacity = editedTile.customOpacity ? [editedTile.customOpacity floatValue] : [RSAesthetics tileOpacity];
	[opacitySlider setValue:opacity];
	[opacityValueLabel setText:[NSString stringWithFormat:@"%i%%", (int)roundf(opacity * 100)]];
	
	[backgroundSwitch setOn:editedTile.useCustomBackground];
	[iconSwitch setOn:editedTile.useCustomIcon];
	
	NSString* folder = [RSTile customFilesPathForIdentifier:[[editedTile.icon application] bundleIdentifier]];
	NSString* hint = [NSString stringWithFormat:[RSAesthetics localizedStringForKey:@"TILE_EDITOR_HINT"], folder];
	
	BOOL missingBackground = editedTile.useCustomBackground && ![RSTile customImageExistsNamed:@"background" forIdentifier:[[editedTile.icon application] bundleIdentifier]];
	BOOL missingIcon = editedTile.useCustomIcon && ![RSTile customImageExistsNamed:@"icon" forIdentifier:[[editedTile.icon application] bundleIdentifier]];
	
	if (missingBackground || missingIcon) {
		hint = [hint stringByAppendingFormat:@"\n%@", [RSAesthetics localizedStringForKey:@"TILE_EDITOR_FILE_MISSING"]];
		[hintLabel setTextColor:[UIColor colorWithRed:1.0 green:0.45 blue:0.45 alpha:1.0]];
	} else {
		[hintLabel setTextColor:[UIColor colorWithWhite:0.7 alpha:1.0]];
	}
	
	[hintLabel setText:hint];
}

#pragma mark Actions

- (void)swatchTapped:(UIButton*)sender {
	NSInteger index = sender.tag;
	[editedTile setCustomColor:(index == 0) ? nil : paletteColors[index - 1]];
	[editedTile applyCustomizationColors];
	[self refreshControls];
}

- (void)opacityChanged:(UISlider*)slider {
	[editedTile setCustomOpacity:[NSNumber numberWithFloat:slider.value]];
	[editedTile applyCustomizationColors];
	[opacityValueLabel setText:[NSString stringWithFormat:@"%i%%", (int)roundf(slider.value * 100)]];
}

- (void)backgroundSwitchChanged:(UISwitch*)sender {
	[editedTile setUseCustomBackground:sender.on];
	[editedTile applyCustomization];
	[self refreshControls];
}

- (void)iconSwitchChanged:(UISwitch*)sender {
	[editedTile setUseCustomIcon:sender.on];
	[editedTile applyCustomization];
	[self refreshControls];
}

- (void)resetTapped {
	[editedTile resetCustomization];
	[self refreshControls];
}

- (void)doneTapped {
	[[RSStartScreenController sharedInstance] saveTiles];
	[self hide];
}

#pragma mark Showing and hiding

- (void)show {
	[[[RSCore sharedInstance] window] addSubview:self];
	
	[self setAlpha:0.0];
	[UIView animateWithDuration:0.2 animations:^{
		[self setAlpha:1.0];
	}];
}

- (void)hide {
	[UIView animateWithDuration:0.15 animations:^{
		[self setAlpha:0.0];
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
}

@end
