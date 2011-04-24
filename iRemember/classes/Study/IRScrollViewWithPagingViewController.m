//
//  ScrollViewWithPagingViewController.m
//  ScrollViewWithPaging
//
//

#import "IRScrollViewWithPagingViewController.h"
#import "IRFlashcardViewController.h"


double prev;


@interface IRScrollViewWithPagingViewController (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (IRWord*)getDisplayForWordDisplayId:(int)displayid;

@end

@implementation IRScrollViewWithPagingViewController

@synthesize scrollView,viewallwords, viewControllers;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self) {
		self.viewallwords = NO;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if(!viewallwords)
	{
		wordsUsedForFlashcardDisplay = [[[[IRAppState currentState] currentStudyPlan]wordsForStudy] retain] ;
		
		if([wordsUsedForFlashcardDisplay count]==0)
		{
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have finished the Study Plan!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			[self change];
			return;
		}
		kNumberOfPages = [wordsUsedForFlashcardDisplay count];
		
		self.title = @"Study New Words";
		[self configureToolbarItems];
	}
	else
	{
		wordsUsedForFlashcardDisplay = [[[[[IRAppState currentState] currentStudyPlan]wordList]studiedWords] retain];
		if([wordsUsedForFlashcardDisplay count]==0){
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have not studied anything!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release]; 
			[self change];
			return;
		}
		kNumberOfPages = [wordsUsedForFlashcardDisplay count];

		self.title = @"Review Words Learned Before";
		[self configureToolbarItems];
	}
	
	self.view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE]] autorelease];
		
	if([wordsUsedForFlashcardDisplay count]>0)
	{
		// a page is the width of the scroll view
		scrollView.pagingEnabled = YES;
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollsToTop = NO;
		scrollView.delegate = self;
		[scrollView setContentOffset:CGPointMake(0, 0)];
		
		
		pageControl.numberOfPages = kNumberOfPages;
		pageControl.currentPage =0;
		pageGlobal = 0;
		
		
		[self loadScrollViewWithPage:0];
		if(kNumberOfPages>1){
			[self loadScrollViewWithPage:1];
		}
	}
	
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
	
    for (unsigned i = 0; i < kNumberOfPages; i++)	
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
	
	[self loadScrollViewWithPage:0];
	if(kNumberOfPages > 1){
		[self loadScrollViewWithPage:1];
	}
	
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0 || page >= kNumberOfPages) return;
	
    // replace the placeholder if necessary
    IRFlashcardViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[IRFlashcardViewController alloc]initWithPageNumber:page word:[self getDisplayForWordDisplayId:page]];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];	
    }
	
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
	
}

-(void)configureToolbarItems 
{	
	slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 750, 20)];
	slider.minimumValue = 0;
	slider.maximumValue = kNumberOfPages-1;
	if(pageControl.currentPage==0){
		slider.value = 0;
	} else {
		slider.value =  pageControl.currentPage;
	}
	
	[slider addTarget:self action:@selector(updateViewBySlider) forControlEvents:UIControlEventValueChanged];
	[slider addTarget:self action:@selector(roundUp) forControlEvents:UIControlEventTouchUpInside];
	[slider addTarget:self action:@selector(roundUp) forControlEvents:UIControlEventTouchUpOutside];
	
	UIBarButtonItem *sliderbar = [[UIBarButtonItem alloc] initWithCustomView:slider];
	UIBarButtonItem *listen = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
																			target:self
																			action:@selector(listen)];
	
	UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																		 target:self 
																		 action:nil];
	
	UIBarButtonItem* viewall = nil;
	if(viewallwords)
	{
		viewall = [[UIBarButtonItem alloc] initWithTitle:@"Words going to Study"
																	style:UIBarButtonItemStyleBordered 
																   target:self 
																   action:@selector(change)];
		self.toolbarItems = [NSArray arrayWithObjects:listen,sliderbar,flex,viewall,nil];
	}
	else 
	{
		viewall = [[UIBarButtonItem alloc] initWithTitle:@"All words Studied"
																	style:UIBarButtonItemStyleBordered 
																   target:self 
																   action:@selector(change)];
		
		UIBarButtonItem *review = [[UIBarButtonItem alloc] initWithTitle:@"Review Now" 
																   style:UIBarButtonItemStyleBordered 
																  target:self 
																  action:@selector(review)];
		self.toolbarItems = [NSArray arrayWithObjects:listen,sliderbar,flex,viewall,review,nil];	
		[review release];
		
	}
	
	[listen release];
	[sliderbar release];
	[flex release];
	[viewall release];
}

- (void)change{
	if(viewallwords) viewallwords = NO;
	else {
		viewallwords = YES;
	}
	[self viewDidLoad];
}

- (void)review
{
	NSString *gamename = [[[IRAppState currentState]currentStudyPlan]defaultGameName];
	[[IRAppState currentState] setWordsForGameWithMode:IRGameStartNext];

	if([gamename isEqual:GAME_MCQ])
	{
		IRMCQViewController *mcqController = [[IRMCQViewController alloc] init];
		[self.navigationController pushViewController:mcqController animated:YES];
		[mcqController release];
	}
	else if([gamename isEqual:GAME_HANGMAN])
	{
		IRHangmanViewController *hangmanController = [[IRHangmanViewController alloc] initWithNibName:@"HangmanView" bundle:nil];
		[self.navigationController pushViewController:hangmanController animated:YES];
		[hangmanController release];
	}
	else if([gamename isEqual:GAME_LISTENING])
	{
		IRListeningGameViewController *listeningController = [[IRListeningGameViewController alloc] init];
		[self.navigationController pushViewController:listeningController animated:YES];
		[listeningController release];
	}
}


- (IRWord*)getDisplayForWordDisplayId:(int)displayid{
	IRWord *word = [wordsUsedForFlashcardDisplay objectAtIndex:displayid];
	return word;
}

- (void)listen
{
	[audioPlayer stop];
	NSString *readFileName = [[wordsUsedForFlashcardDisplay objectAtIndex:pageGlobal]soundFileName]; 
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentDirectory = [paths objectAtIndex:0];
	NSString* fullPath = [NSString stringWithFormat:@"%@/%@",documentDirectory,readFileName];
	if(![[NSFileManager defaultManager] fileExistsAtPath:[fullPath stringByExpandingTildeInPath]]){
		NSString* currentDirectory = [[NSBundle mainBundle] bundlePath];
		fullPath = [NSString stringWithFormat:@"%@/default.caf",currentDirectory];
	}
	
	NSURL *url = [NSURL fileURLWithPath:fullPath];	

	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = 0;	
	if (audioPlayer) [audioPlayer play];
	
}

- (void)updateViewBySlider
{
	pageGlobal = round(slider.value);
	if(pageGlobal<0){
		pageGlobal = 0;
	}
	[self loadScrollViewWithPage:pageGlobal - 1];
	[self loadScrollViewWithPage:pageGlobal];
	[self loadScrollViewWithPage:pageGlobal + 1];
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
	CGFloat contentoffset = pageGlobal*pageWidth;
	
	[scrollView setContentOffset:CGPointMake(contentoffset, 0)];
}

-(void)roundUp{
	[slider setValue:pageGlobal animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
	[scrollView setContentOffset:CGPointMake(sender.contentOffset.x, 0)];
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
	pageGlobal = page;
	
	[self loadScrollViewWithPage:page-1];
	[self loadScrollViewWithPage:page];
	[self loadScrollViewWithPage:page+1];
	
	[slider setValue:pageGlobal animated:YES];
}


// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;

}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[viewControllers release];
    [scrollView release];
    [pageControl release];
	[wordsUsedForFlashcardDisplay release];
	[audioPlayer release];
    [super dealloc];
}

@end
