//
//  ScrollViewWithPagingViewController.h
//  ScrollViewWithPaging
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "IRAppState.h"
#import "IRFlashcardViewController.h"
#import "IRListeningGameViewController.h"
#import "IRHangmanViewController.h"
#import "IRMCQViewController.h"
#import "IRWord.h"

@interface IRScrollViewWithPagingViewController : UIViewController <UIScrollViewDelegate >
{
	IBOutlet UIScrollView *scrollView;
	UIPageControl *pageControl;
    BOOL pageControlUsed;
	NSArray *wordsUsedForFlashcardDisplay;
	NSInteger kNumberOfPages;
	BOOL viewallwords;
	
	AVAudioPlayer *audioPlayer;

	UISlider *slider;

	NSTimer *timer;

	float count;
	int pageGlobal;

	NSMutableArray *viewControllers;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (readwrite) BOOL viewallwords;

@property (retain) NSMutableArray *viewControllers;

- (IBAction)changePage:(id)sender;
-(void)configureToolbarItems;
-(void)change;


@end

