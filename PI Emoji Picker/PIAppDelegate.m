//
//  PIAppDelegate.m
//  PI Emoji Picker
//
//  Created by Alex Kac on 5/29/14.
//  Copyright (c) 2014 Web Information Solutions, Inc. All rights reserved.
//

#import "PIAppDelegate.h"
#import "PIEmojiViewController.h"

@interface PIAppDelegate ()

@end

@implementation PIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
}

- (IBAction)openEmojiPicker:(NSButton *)sender {
	PIEmojiViewController* emojiVC = [[PIEmojiViewController alloc] initWithNibName:nil bundle:nil];
	
	NSPopover* popover = [[NSPopover alloc] init];
	popover.contentViewController = emojiVC;
	[popover showRelativeToRect:sender.bounds
						 ofView:sender
				  preferredEdge:NSMinXEdge | NSMinYEdge];
}

@end
