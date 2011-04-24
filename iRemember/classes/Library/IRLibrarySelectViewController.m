    //
//  IRLibrarySelectViewController.m
//  iRemember
//
//  Created by Yingbo Zhan on 4/9/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRLibrarySelectViewController.h"

#define CHINESE_WORD_TAG 111
#define INDO_WORD_TAG 222
#define CHINESE_WORDLIST_TAG 333
#define INDO_WORDLIST_TAG 444

@implementation IRLibrarySelectViewController

-(void)downloadButtonPressed {
	IRLibraryDownloadWordListViewController *downloader =
	[[IRLibraryDownloadWordListViewController alloc] initWithNibName:@"IRLibraryDownloadWordList"
															  bundle:nil];
	UINavigationController *navController = 
	[[UINavigationController alloc] initWithRootViewController:downloader];
	
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self.navigationController presentModalViewController:navController animated:YES];
	
	[downloader release];
	[navController release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE]] autorelease];
	self.title = @"Library";
	
	UIImage *img = [UIImage imageNamed:@"download.png"];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setImage:img forState:UIControlStateNormal];
	btn.frame = CGRectMake(0, 0, 31, 31);
	
	UIBarButtonItem *download = [[UIBarButtonItem alloc] initWithCustomView:btn];
	
	[btn addTarget:self action:@selector(downloadButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	self.toolbarItems = [NSArray arrayWithObject:download];
	[download release];
}



-(IBAction)buttonPressed:(UIButton*)button {
	UIViewController *viewController;
	
	NSInteger tag = button.tag;
	
	switch(tag) {
		case CHINESE_WORD_TAG:
			viewController = [[IRLibraryWordViewController alloc]
							  initWithNibName:@"IRLibraryWord" language:LANG_CHINESE bundle:nil];
			break;
		case INDO_WORD_TAG:
			viewController = [[IRLibraryWordViewController alloc]
							  initWithNibName:@"IRLibraryWord" language:LANG_INDONESIAN bundle:nil];
			break;
		case CHINESE_WORDLIST_TAG:
			viewController = [[IRLibraryWordListViewController alloc]
							  initWithNibName:@"IRLibraryWordList" bundle:nil lang:LANG_CHINESE];
			break;
		case INDO_WORDLIST_TAG:
			viewController = [[IRLibraryWordListViewController alloc]
							  initWithNibName:@"IRLibraryWordList" bundle:nil lang:LANG_INDONESIAN];
			break;
			
	}
	[[self navigationController] pushViewController:viewController animated:YES];
	[viewController release];
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
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
    [super dealloc];
}


@end
