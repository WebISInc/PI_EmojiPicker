//
//  PIEmojiPageView.m
//  PI Emoji Picker
//
//  Created by Alex Kac on 5/30/14.
//  Copyright (c) 2014 Web Information Solutions, Inc. All rights reserved.
//

#import "PIEmojiPageView.h"

#define BACKSPACE_BUTTON_TAG 10
#define BUTTON_FONT_SIZE 32

@interface PIEmojiPageView ()

@property (nonatomic, assign) NSSize buttonSize;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, assign) NSUInteger columns;
@property (nonatomic, assign) NSUInteger rows;

@end


@implementation PIEmojiPageView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
//	[[NSColor redColor] setFill];
//    NSRectFill(dirtyRect);
}

@synthesize buttonSize = buttonSize_;
@synthesize buttons = buttons_;
@synthesize columns = columns_;
@synthesize rows = rows_;
@synthesize delegate = delegate_;

-(BOOL)isFlipped
{
	return YES;
}

- (void)setButtonTexts:(NSMutableArray *)buttonTexts {
	NSAssert(buttonTexts != nil, @"Array containing texts to be set on buttons is nil");

	if (([self.buttons count] - 1) == [buttonTexts count]) {
		// just reset text on each button
		
		[buttonTexts enumerateObjectsUsingBlock:^(NSString* title, NSUInteger idx, BOOL *stop) {
			((NSButton*)(self.buttons[idx])).title = title;
		}];
	} else {
		[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
		self.buttons = nil;
		self.buttons = [NSMutableArray arrayWithCapacity:self.rows * self.columns];
		
		for (NSUInteger i = 0; i < [buttonTexts count]; ++i) {
			NSButton *button = [self createButtonAtIndex:i];
			[button setTitle:buttonTexts[i]];
			[self addToViewButton:button];
		}
		
		NSButton *button = [self createButtonAtIndex:self.rows * self.columns - 1];
		[button setImage:[NSImage imageNamed:@"backspace_n"]];
		button.tag = BACKSPACE_BUTTON_TAG;
		[self addToViewButton:button];
	}
}

- (void)addToViewButton:(NSButton *)button {
	
	NSAssert(button != nil, @"Button to be added is nil");
	
	[self.buttons addObject:button];
	[self addSubview:button];
}

// Padding is the expected space between two buttons.
// Thus, space of top button = padding / 2
// extra padding according to particular button's pos = pos * padding
// Margin includes, size of buttons in between = pos * buttonSize
// Thus, margin = padding / 2
//                + pos * padding
//                + pos * buttonSize

- (CGFloat)XMarginForButtonInColumn:(NSInteger)column {
	CGFloat padding = ((CGRectGetWidth(self.bounds) - self.columns * self.buttonSize.width) / self.columns);
	return (padding / 2 + column * (padding + self.buttonSize.width));
}

- (CGFloat)YMarginForButtonInRow:(NSInteger)rowNumber {
	CGFloat padding = ((CGRectGetHeight(self.bounds) - self.rows * self.buttonSize.height) / self.rows);
	return (padding / 2 + rowNumber * (padding + self.buttonSize.height));
}

- (NSButton *)createButtonAtIndex:(NSUInteger)index {
	NSButton *button = [[NSButton alloc] initWithFrame: NSZeroRect];
	[button setButtonType: NSMomentaryLightButton];
	[button setBezelStyle: NSRoundedDisclosureBezelStyle];
	[button setBordered: NO];
	[button setTarget: self];
	[button setAction: @selector(emojiButtonPressed:)];
	[button.cell setImageScaling:NSImageScaleProportionallyDown];
	
	button.font = [NSFont fontWithName:@"Apple color emoji" size:BUTTON_FONT_SIZE];
	NSInteger row = (NSInteger)(index / self.columns);
	NSInteger column = (NSInteger)(index % self.columns);
	button.frame = CGRectIntegral(CGRectMake([self XMarginForButtonInColumn:column],
											 [self YMarginForButtonInRow:row],
											 self.buttonSize.width,
											 self.buttonSize.height));
	return button;
}

- (id)initWithFrame:(NSRect)frame buttonSize:(NSSize)buttonSize rows:(NSUInteger)rows columns:(NSUInteger)columns {
	self = [super initWithFrame:frame];
	if (self) {
		self.buttonSize = buttonSize;
		self.columns = columns;
		self.rows = rows;
		self.buttons = [[NSMutableArray alloc] initWithCapacity:self.rows * columns];
	}
	return self;
}

- (void)emojiButtonPressed:(NSButton *)button {
	if (button.tag == BACKSPACE_BUTTON_TAG) {
		[self.delegate emojiPageViewDidPressBackSpace:self];
		return;
	}
	[self.delegate emojiPageView:self didUseEmoji: button.title];
}

- (void)dealloc {
	self.buttons = nil;
}


@end
