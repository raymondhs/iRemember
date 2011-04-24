//
//  IRReviewViewController.m
//  iRemember
//
//  Created by Raymond Hendy on 3/22/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRReviewViewController.h"


@implementation IRReviewViewController

@synthesize buttonTitle;

-(void)configureButtons {
	UIColor *bgColor = [UIColor colorWithRed:.6 green:.4 blue:.2 alpha:.7];
	UIColor *borderColor = [UIColor colorWithRed:.37 green:.22 blue:.11 alpha:1];
	mcqButton.backgroundColor = bgColor;
	mcqButton.layer.borderColor = borderColor.CGColor;
	mcqButton.layer.cornerRadius = 5;
	mcqButton.layer.borderWidth = 5;
	
	gunShootButton.backgroundColor = bgColor;
	gunShootButton.layer.borderColor = borderColor.CGColor;
	gunShootButton.layer.cornerRadius = 5;
	gunShootButton.layer.borderWidth = 5;
	
	hangmanButton.backgroundColor = bgColor;
	hangmanButton.layer.borderColor = borderColor.CGColor;
	hangmanButton.layer.cornerRadius = 5;
	hangmanButton.layer.borderWidth = 5;
}

-(void)gameMCQController {
	IRMCQViewController *mcqController = [[IRMCQViewController alloc] init];
	[self.navigationController pushViewController:mcqController animated:YES];
	[mcqController release];
}

- (void)hangmanController {
	IRHangmanViewController *hangmanController = [[IRHangmanViewController alloc] initWithNibName:@"HangmanView" bundle:nil];
	[self.navigationController pushViewController:hangmanController animated:YES];
	[hangmanController release];
}

- (void)listeningController {
	IRListeningGameViewController *listeningController = [[IRListeningGameViewController alloc] init];
	[self.navigationController pushViewController:listeningController animated:YES];
	[listeningController release];
}

-(IBAction)buttonPressed:(UIButton *)button {
	self.buttonTitle = button.titleLabel.text;
	
	if ([[[[[IRAppState currentState] currentStudyPlan] wordList] studiedWords] count]==0){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You haven't studied any word yet :-( But you can still study the scheduled words."  
													 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Scheduled",nil];
		[alert show];
		[alert release];
		return;
	}
	
	if ([[[[IRAppState currentState] currentStudyPlan] wordsForStudy] count]==0){
		[[IRAppState currentState] setWordsForGameWithMode:IRGameStartStudied];
		if([buttonTitle isEqual:GAME_MCQ]) {
			[self gameMCQController];
		}else if([buttonTitle isEqual:GAME_HANGMAN]) {
			[self hangmanController];
		}else if ([buttonTitle isEqual:GAME_LISTENING]){
			[self listeningController];
		}
	}else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Review Choices" message:@"You have scheduled reviews left. Please choose the review type."  
													   delegate:self cancelButtonTitle:@"For Fun" otherButtonTitles:@"Scheduled",nil];
		[alert show];
		[alert release];
	}

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if([alertView.title isEqual:@"Review Choices"]){
		if(buttonIndex == 0){
			[[IRAppState currentState] setWordsForGameWithMode:IRGameStartStudied];
		}else {
			[[IRAppState currentState] setWordsForGameWithMode:IRGameStartNext];
		}
	}else if ([alertView.title isEqual:@"Sorry"]){
		if (buttonIndex == 0){
			return;
		}else {
			[[IRAppState currentState] setWordsForGameWithMode:IRGameStartNext];
		}
	}
	if([buttonTitle isEqual:GAME_MCQ]) {
		[self gameMCQController];
	}else if([buttonTitle isEqual:GAME_HANGMAN]) {
		[self hangmanController];
	}else if ([buttonTitle isEqual:GAME_LISTENING]){
		[self listeningController];
	}
}


-(void)configureToolbarItems {	
	//self.toolbarItems = [NSArray arrayWithObjects:,nil];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Review";
	self.view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE]] autorelease];
	[self configureToolbarItems];
	[self configureButtons];
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
	[buttonTitle release];
    [super dealloc];
}

@end