//
//  iRememberViewController.m
//  iRemember
//
//  Created by Raymond Hendy on 3/22/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "iRememberViewController.h"
#import "IRScrollViewWithPagingViewController.h"

@implementation iRememberViewController


-(IBAction)buttonPressed:(UIButton*)button {
	NSString *buttonTitle = button.titleLabel.text;
	UIViewController *viewController;
	
	if([buttonTitle isEqual:@"Study"]) {
		viewController = [[IRScrollViewWithPagingViewController alloc] initWithNibName:@"ScrollViewWithPageControl" bundle:nil];
	} else if([buttonTitle isEqual:@"StudyPlan"]) {
		viewController = [[IRStudyPlanViewController alloc] initWithNibName:@"StudyPlanView" bundle:nil];
	} else if([buttonTitle isEqual:@"Review"]) {
		viewController = [[IRReviewViewController alloc] initWithNibName:@"ReviewView" bundle:nil];
	} else if([buttonTitle isEqual:@"Library"]) {
		viewController = [[IRLibrarySelectViewController alloc] initWithNibName:@"IRLibrarySelect" bundle:nil];
	} else if([buttonTitle isEqual:@"Statistics"]) {
		viewController = [[IRStatisticsViewController alloc] init];
	}
	[[self navigationController] pushViewController:viewController animated:YES];
	[viewController release];
	
}

-(void)infoButtonPressed:(UIButton *)button {
	[infoPopover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)configureToolbarItems {
	UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
	[infoBtn addTarget:self action:@selector(infoButtonPressed:)
	  forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
	UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc]
										  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
										  target:nil action:nil];
	self.toolbarItems = [NSArray arrayWithObjects:flexibleSpaceItem,infoItem,nil];

	[flexibleSpaceItem release];
	[infoItem release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE]] autorelease];
	[self configureToolbarItems];
	IRInfo *infoController = [[[IRInfo alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
	infoPopover = [[UIPopoverController alloc] initWithContentViewController:infoController];
	infoPopover.popoverContentSize = CGSizeMake(320, 220);
	
	[[IRAppState currentState] loadState];
	//[[IRAppState currentState] save];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[infoPopover release];
    [super dealloc];
}

@end
