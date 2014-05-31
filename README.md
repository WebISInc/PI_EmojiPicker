PI_EmojiPicker
==============

Emoji Picker View Controller for Mac OS X Mavericks and up based off the code from AGEmojiKeyboard(https://github.com/ayushgoel/iOS-emoji-keyboard)

## Usage



## Installation

Copy the files in Emoji Picker into your project and look at the PI Emoji Picker folder to see how the classes are used for more detail.

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


## Author

PI_EmojiPicker is authored by Alex Kac
AGEmojiKeyboard is authored by Ayush Goel, ayushgoel111@gmail.com

## License

PI_EmojiPicker is available under the MIT license. See the LICENSE file for more info.

