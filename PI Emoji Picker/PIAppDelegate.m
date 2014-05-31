//
//  PIAppDelegate.m
//  PI Emoji Picker
//
//  Created by Alex Kac on 5/29/14.
//  Copyright (c) 2014 Web Information Solutions, Inc. All rights reserved.
//

#import "PIAppDelegate.h"
#import "PIEmojiViewController.h"

@interface PIAppDelegate () <PIEmojiViewDelegate>
@property (weak) IBOutlet NSTextField *textField;

@end

@implementation PIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
}

- (IBAction)openEmojiPicker:(NSButton *)sender {
	PIEmojiViewController* emojiVC = [[PIEmojiViewController alloc] initWithNibName:nil bundle:nil];
	emojiVC.delegate = self;
	
	NSPopover* popover = [[NSPopover alloc] init];
	popover.contentViewController = emojiVC;
	[popover showRelativeToRect:sender.bounds
						 ofView:sender
				  preferredEdge:NSMinXEdge | NSMinYEdge];
}

-(void)emojiKeyDidUseEmoji:(NSString *)emoji
{
	NSString* oldString = self.textField.stringValue;
	self.textField.stringValue = [oldString stringByAppendingString:emoji];
}

-(void)emojiKeyBoardViewDidPressBackSpace
{
	NSString* oldString = self.textField.stringValue;
	if (oldString.length)
		self.textField.stringValue = [oldString substringToIndex:oldString.length-1];
}

@end
