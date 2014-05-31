//
//  PIEmojiKeyboardView.h
//  PI Emoji Picker
//
//  Created by Alex Kac on 5/30/14.
//  Copyright (c) 2014 Web Information Solutions, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PIEmojiViewDelegate;


@interface PIEmojiKeyboardView : NSView
@property (nonatomic, weak) id<PIEmojiViewDelegate> delegate;
@end

/**
 Protocol to be followed by the delegate of `PIEmojiView`.
 */
@protocol PIEmojiViewDelegate <NSObject>

/**
 Delegate method called when user taps an emoji button
 
 @param emojiKeyBoardView EmojiKeyBoardView object on which user has tapped.
 
 @param emoji Emoji used by user
 */
- (void)emojiKeyDidUseEmoji:(NSString *)emoji;

/**
 Delegate method called when user taps on the backspace button
 
 @param emojiKeyBoardView EmojiKeyBoardView object on which user has tapped.
 */
- (void)emojiKeyBoardViewDidPressBackSpace;

@end
