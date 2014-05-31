//
//  PIEmojiViewController.h
//  PI Emoji Picker
//
//  Created by Alex Kac on 5/29/14.
//  Copyright (c) 2014 Web Information Solutions, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PIEmojiKeyboardView.h"

@interface PIEmojiViewController : NSViewController
@property (nonatomic, weak) id<PIEmojiViewDelegate> delegate;

@end

