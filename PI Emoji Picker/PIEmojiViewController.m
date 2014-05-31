//
//  PIEmojiViewController.m
//  PI Emoji Picker
//
//  Created by Alex Kac on 5/29/14.
//  Copyright (c) 2014 Web Information Solutions, Inc. All rights reserved.
//

#import "PIEmojiViewController.h"

@interface PIEmojiViewController ()
@end

@implementation PIEmojiViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:@"EmojiView" bundle:nil];
	if (self) {
	}
	return self;
}

-(void)setDelegate:(id<PIEmojiViewDelegate>)delegate
{
	PIEmojiKeyboardView* emojiKeyboardView = (PIEmojiKeyboardView*)self.view;
	emojiKeyboardView.delegate = delegate;
}

@end
