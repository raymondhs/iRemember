//
//  FlashcardViewController.m
//
//  Created by Raymond Hendy on 3/22/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRFlashcardViewController.h"
#import "IRHeader.h"

@implementation IRFlashcardViewController

@synthesize pageNumber, word, wordView, wordLabel;

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (id)initWithPageNumber:(int)page word:(IRWord *)w
{

	self = [super initWithNibName:@"FlashcardView" bundle:nil];
	if(self){
		pageNumber = page;
		self.word = w;
	}
	
	return self;
}

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {

	 [super viewDidLoad];
	 self.view.backgroundColor = [UIColor clearColor];
	 self.view.multipleTouchEnabled = YES;
	 self.view.userInteractionEnabled = YES;
	 
	 [wordView.layer setBorderWidth:7.5];
	 [wordView.layer setBorderColor:[[UIColor colorWithRed:.55 green:.33 blue:.17 alpha:1] CGColor]];
	 wordLabel.text = word.englishWord;
	 
	 explanationView.backgroundColor = [UIColor clearColor];
	 explanationView.font = [UIFont fontWithName:@"Heiti TC" size:36.0];
	 explanationView.textAlignment = UITextAlignmentCenter;
	 explanationView.text = word.translatedWord;
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
	//[wordView release];
	//[word release];
	//[wordLabel release];
	//[explanationView release];
    [super dealloc];
}

@end
