    //
//  IRStatisticsViewController.m
//  iRemember
//
//  Created by Zhang Ying on 4/9/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import "IRStatisticsViewController.h"
#import "IRStatisticsDetailViewController.h"
#import "IRStatisticsCategoryTableViewController.h"

@implementation IRStatisticsViewController

@synthesize splitViewController;
@synthesize detailController;
@synthesize masterController;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	masterController = [[IRStatisticsCategoryTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:masterController];
	navigationController.navigationBarHidden = YES;
	navigationController.wantsFullScreenLayout = YES;
    detailController = [[IRStatisticsDetailViewController alloc] initWithNibName:@"StatisticsDetailView" bundle:nil];
    masterController.detailViewController = detailController;
    
    splitViewController = [[UISplitViewController alloc] init];
    splitViewController.viewControllers = [NSArray arrayWithObjects:navigationController, detailController, nil];
	splitViewController.delegate = detailController;
	[self.view addSubview:splitViewController.view];
	
	[navigationController release];
	
	self.title = @"Statistics";
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[detailController release];
	[masterController release];
	[splitViewController release];
    [super dealloc];
}


@end
