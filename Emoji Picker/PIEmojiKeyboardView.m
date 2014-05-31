//
//  PIEmojiKeyboardView.m
//  PI Emoji Picker
//
//  Created by Alex Kac on 5/30/14.
//  Copyright (c) 2014 Web Information Solutions, Inc. All rights reserved.
//

#import "PIEmojiKeyboardView.h"
#import "PIEmojiPageView.h"

static const CGFloat ButtonWidth = 45;
static const CGFloat ButtonHeight = 37;

#define RECENT_EMOJIS_MAINTAINED_COUNT 50
#define DEFAULT_SELECTED_SEGMENT 0

static NSString *const segmentRecentName = @"Recent";
NSString *const RecentUsedEmojiCharactersKey = @"RecentUsedEmojiCharactersKey";

@interface PIEmojiKeyboardView () <PIEmojiPageViewDelegate>
@property (nonatomic) NSDictionary *emojis;
@property (weak) IBOutlet NSSegmentedControl *segmentsBar;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (nonatomic) NSString *category;
@end


@implementation PIEmojiKeyboardView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.category = segmentRecentName;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
		self.category = segmentRecentName;
    }
    return self;
}

- (NSDictionary *)emojis {
	if (!_emojis) {
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmojisList"
															  ofType:@"plist"];
		_emojis = [[NSDictionary dictionaryWithContentsOfFile:plistPath] copy];
	}
	return _emojis;
}

// recent emojis are backed in NSUserDefaults to save them across app restarts.
- (NSMutableArray *)recentEmojis {
	NSArray *emojis = [[NSUserDefaults standardUserDefaults] arrayForKey:RecentUsedEmojiCharactersKey];
	NSMutableArray *recentEmojis = [emojis mutableCopy];
	if (recentEmojis == nil) {
		recentEmojis = [NSMutableArray array];
	}
	return recentEmojis;
}

- (void)setRecentEmojis:(NSMutableArray *)recentEmojis {
	// remove emojis if they cross the cache maintained limit
	if ([recentEmojis count] > RECENT_EMOJIS_MAINTAINED_COUNT) {
		NSIndexSet *indexesToBeRemoved = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(RECENT_EMOJIS_MAINTAINED_COUNT, [recentEmojis count] - RECENT_EMOJIS_MAINTAINED_COUNT)];
		[recentEmojis removeObjectsAtIndexes:indexesToBeRemoved];
	}
	[[NSUserDefaults standardUserDefaults] setObject:recentEmojis forKey:RecentUsedEmojiCharactersKey];
}

- (NSArray*)imagesForSelectedSegments
{
	return @[[NSImage imageNamed:@"recent_n"],
			 [NSImage imageNamed:@"face_n"],
			 [NSImage imageNamed:@"bell_n"],
			 [NSImage imageNamed:@"flower_n"],
			 [NSImage imageNamed:@"car_n"],
			 [NSImage imageNamed:@"characters_n"]];
}

- (void)_setupSegmentedControl
{
	NSArray* images = self.imagesForSelectedSegments;
	[self.segmentsBar setSegmentCount:images.count];
	
	[images enumerateObjectsUsingBlock:^(NSImage* image, NSUInteger idx, BOOL *stop) {
		NSSegmentedCell* cell = [self.segmentsBar cell];
		[cell setImage:image forSegment:idx];
		[cell setTag:idx forSegment:idx];
	}];
	
	[self setSelectedCategoryImageInSegmentControl:self.segmentsBar AtIndex:DEFAULT_SELECTED_SEGMENT];
	self.segmentsBar.selectedSegment = DEFAULT_SELECTED_SEGMENT;
	
	[self.segmentsBar setFocusRingType:NSFocusRingTypeNone];
}

-(void)layout
{
	[super layout];
	
	CGFloat width = self.bounds.size.width/self.segmentsBar.segmentCount;
	for (int index = 0; index < self.segmentsBar.segmentCount; ++index)
		[self.segmentsBar setWidth:width forSegment:index];
}

-(void)awakeFromNib
{
	[self _setupSegmentedControl];
	[self setCurrentEmojiPageView];
}

#pragma mark event handlers

- (void)setSelectedCategoryImageInSegmentControl:(NSSegmentedControl *)segmentsBar AtIndex:(NSInteger)index {
	NSArray *imagesNamesForSelectedSegments = @[@"recent_s",
												@"face_s",
												@"bell_s",
												@"flower_s",
												@"car_s",
												@"characters_s"];
	NSArray *imagesForNonSelectedSegments = @[[NSImage imageNamed:@"recent_n"],
											  [NSImage imageNamed:@"face_n"],
											  [NSImage imageNamed:@"bell_n"],
											  [NSImage imageNamed:@"flower_n"],
											  [NSImage imageNamed:@"car_n"],
											  [NSImage imageNamed:@"characters_n"]];
	
	for (int i=0; i < segmentsBar.segmentCount; ++i) {
		[[segmentsBar cell] setImage:imagesForNonSelectedSegments[i] forSegment:i];
	}
	
	NSImage* selectedImage = [NSImage imageNamed: imagesNamesForSelectedSegments[index] ];
	[[segmentsBar cell] setImage:selectedImage forSegment:index];
}

- (IBAction)categoryChangedViaSegmentsBar:(NSSegmentedControl *)sender {
	// recalculate number of pages for new category and recreate emoji pages
	NSArray *categoryList = @[segmentRecentName, @"People", @"Objects", @"Nature", @"Places", @"Symbols"];
	
	self.category = categoryList[sender.selectedSegment];
	
	[self setSelectedCategoryImageInSegmentControl:sender AtIndex:sender.selectedSegment];
	
	[self setCurrentEmojiPageView];
}

// Set emoji page view for given index.
- (void)setCurrentEmojiPageView {
	NSMutableArray *buttonTexts = [self emojiTextsForCategory:self.category];
	NSUInteger columns = [self numberOfColumnsForFrameSize:self.scrollView.bounds.size];
	NSUInteger rows = ceil(buttonTexts.count / columns) + 1;
	
	//set the height of this now
	NSRect thisBounds = self.scrollView.bounds;
	thisBounds.size.height  = rows * ButtonHeight;
	
	PIEmojiPageView *pageView = [[PIEmojiPageView alloc] initWithFrame:thisBounds
															buttonSize:CGSizeMake(ButtonWidth, ButtonHeight)
																  rows:rows
															   columns:columns];
	[pageView setButtonTexts:buttonTexts];
	pageView.delegate = self;

	[self.scrollView setDocumentView:pageView];
}

#pragma mark data methods

- (NSUInteger)numberOfColumnsForFrameSize:(CGSize)frameSize {
	return (NSUInteger)floor(frameSize.width / ButtonWidth);
}

- (NSArray *)emojiListForCategory:(NSString *)category {
	if ([category isEqualToString:segmentRecentName]) {
		return [self recentEmojis];
	}
	return [self.emojis objectForKey:category];
}

// return the emojis for a category, given a staring and an ending index
- (NSMutableArray *)emojiTextsForCategory:(NSString *)category
{
	NSArray *emojis = [self emojiListForCategory:category];
	return [emojis mutableCopy];
}

#pragma mark EmojiPageViewDelegate

- (void)setInRecentsEmoji:(NSString *)emoji {
	NSAssert(emoji != nil, @"Emoji can't be nil");
	
	NSMutableArray *recentEmojis = [self recentEmojis];
	for (int i = 0; i < [recentEmojis count]; ++i) {
		if ([recentEmojis[i] isEqualToString:emoji]) {
			[recentEmojis removeObjectAtIndex:i];
		}
	}
	[recentEmojis insertObject:emoji atIndex:0];
	[self setRecentEmojis:recentEmojis];
}

// add the emoji to recents
- (void)emojiPageView:(PIEmojiPageView *)emojiPageView didUseEmoji:(NSString *)emoji {
	[self setInRecentsEmoji:emoji];
	[self.delegate emojiKeyDidUseEmoji:emoji];
}

- (void)emojiPageViewDidPressBackSpace:(PIEmojiPageView *)emojiPageView {
	NSLog(@"Back button pressed");
	[self.delegate emojiKeyBoardViewDidPressBackSpace];
}



@end
