PI_EmojiPicker
==============

Simple NSView or NSViewController based picker for Emoji. 

I took the wonderful work of AGEmojiKeyboard (https://github.com/ayushgoel/iOS-emoji-keyboard) as a base to create an OS X version. 

Its extremely simple and worth a couple hours of work. Its useful if you want to allow a user to enter Emoji without having to use the "special keyboard" in the edit menu. 

An example would be like Messages/iChat which has a smiley face picker next to the text entry. 


## Installation

Copy the files in Emoji Picker into your project and look at the PI Emoji Picker folder to see how the classes are used for more detail.

## Usage

The example file uses a simple NSViewController subclass to show the Emoji picker within an NSPopover:

```objective-c
@interface PIEmojiViewController : NSViewController
@property (nonatomic, weak) id<PIEmojiViewDelegate> delegate;

@end

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

```

Implement two delegate methods:

```objective-c
-(void)emojiKeyDidUseEmoji:(NSString *)emoji
{
}

-(void)emojiKeyBoardViewDidPressBackSpace
{
}
```

## Requirements

Written and tested only on 10.9 Mavericks, with Xcode 5.11, and using ARC

## Author

PI_EmojiPicker is authored by Alex Kac

AGEmojiKeyboard is authored by Ayush Goel, ayushgoel111@gmail.com

## License

PI_EmojiPicker is available under the MIT license. See the LICENSE file for more info.

