    //
//  IRHangmanViewController.m
//  iRemember
//
//  Created by Zhang Ying on 4/3/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import "IRHangmanViewController.h"

#define GAME_HANGMAN_ALPHA 0.3
#define GAME_HANGMAN_TEXTBOX_LENGTH 40
#define GAME_HANGMAN_TEXTBOX_OX 350
#define GAME_HANGMAN_TEXTBOX_OY 290
#define GAME_HANGMAN_TEXTBOX_INTERVAL 50

@implementation IRHangmanViewController

@synthesize inputLetters;
@synthesize wordsUsedForGameThreeDisplay;
@synthesize wordsWithStatisticsList;
@synthesize currentWord;
@synthesize progress;
@synthesize disableButton;

- (IBAction) buttonPressed:(UIButton*)button{
	if(disableButton) return;

	NSString* buttonName = button.titleLabel.text;
	button.userInteractionEnabled = NO;
	button.enabled = NO;
	button.alpha = GAME_HANGMAN_ALPHA;
	[self updateAlphabetWithWord:buttonName];
}

- (void)updateAlphabetWithWord:(NSString*)alphabet {
	
	// if the alphabet is contained in the current word, show the alphabet in the word and disable the alphabet's button
	// else, update the hangman picture and counters
	BOOL indicator = NO;
	for (int i = 0; i <[[currentWord englishWord] length]; i++){
		NSString *sub = [currentWord.englishWord substringWithRange:NSMakeRange(i, 1)];
		if ([sub isEqual:alphabet] || [sub isEqual:[alphabet lowercaseString]]){
			UITextField* textbox = (UITextField*) [inputLetters objectAtIndex:i];
			textbox.text = sub;
			numberOfCorrectLetters--;
			indicator = YES;
		}
	}
	if (indicator == NO && disableButton == NO){
		numberOfGuesses++;
		[self updateHangmanImage:numberOfGuesses];
		if (numberOfGuesses >=6){
			disableButton = YES;
			IRWordWithStatisticsInGame *wordWSt = [self getIRWordInStatisticsListBasedOnId:currentWord.wordID];
			wordWSt.incorrectCount +=1;
			[wordsUsedForGameThreeDisplay addObject:currentWord];
			[NSTimer scheduledTimerWithTimeInterval:GAME_ANIMATION_DURATION
											 target:self
										   selector:@selector(goToNextWord)
										   userInfo:nil
											repeats:NO];
		}
	}
	if (numberOfCorrectLetters <=0 && disableButton == NO){
		disableButton = YES;
		for (IRWordWithStatistics *word in [[[[IRAppState currentState] currentStudyPlan] wordList] wordsWithStatistics]){
			if (word.wordID == currentWord.wordID){
				word.isStudied = YES;
			}
		}
		IRWordWithStatisticsInGame *wordWSt = [self getIRWordInStatisticsListBasedOnId:currentWord.wordID];
		wordWSt.correctCount +=1;
		[NSTimer scheduledTimerWithTimeInterval:GAME_ANIMATION_DURATION
										 target:self
									   selector:@selector(goToNextWord)
									   userInfo:nil
										repeats:NO];
	}
}

- (void)goToNextWord {
	// reset: textbox, numberOfCorrect, init, alpha, button enabled, wordDisplayID++
	// and also whether show result or not
	disableButton = NO;
	if (wordDisplayId >= [wordsUsedForGameThreeDisplay count]-1){
		// if all words are shown, update statistics and pop out result list
		wordDisplayId++;
		progress.progress = 1.0*wordDisplayId/[wordsUsedForGameThreeDisplay count];
		[[IRAppState currentState] updateStatisticsWithList:wordsWithStatisticsList inGame:GAME_HANGMAN];
		IRMCQResultTableViewController *resultListController = [[IRMCQResultTableViewController alloc] initWithWordWithStatisticsInGame:wordsWithStatisticsList 
																															  WithWords:wordsUsedForGameThreeDisplay];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:resultListController];
		navigationController.navigationBar.tintColor = [UIColor brownColor];
		
		navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
		[self.navigationController presentModalViewController:navigationController animated:YES];
		
		[navigationController release];
		[resultListController release];

		return;
	}else {
		// show the next word by: reseting textbox, numberOfCorrect, init, alpha, button enabled, wordDisplayID++
		for (UITextField *textbox in inputLetters){
			[textbox removeFromSuperview];
		}
		[inputLetters release];
		wordDisplayId++;
		progress.progress = 1.0*wordDisplayId/[wordsUsedForGameThreeDisplay count];
		self.currentWord = [wordsUsedForGameThreeDisplay objectAtIndex:wordDisplayId];
		numberOfCorrectLetters = [[currentWord englishWord] length];
		numberOfGuesses = 0;
		for (UIView *viewTemp in self.view.subviews){
			if ([viewTemp isKindOfClass:[UIButton class]]){
				UIButton *buttonTemp = (UIButton*) viewTemp;
				buttonTemp.enabled = YES;
				buttonTemp.userInteractionEnabled = YES;
				buttonTemp.alpha = 1;
			}
		}
		// set up new question
		_wordMeangingLabel.text = [currentWord translatedWord];
		inputLetters = [[NSMutableArray alloc] init];
		for (int i = 0; i < [[currentWord englishWord] length]; i++){
			UITextField *textbox = [[UITextField alloc] initWithFrame:CGRectMake(GAME_HANGMAN_TEXTBOX_OX+GAME_HANGMAN_TEXTBOX_INTERVAL*i-numberOfCorrectLetters*8, 
																				 GAME_HANGMAN_TEXTBOX_OY, 
																				 GAME_HANGMAN_TEXTBOX_LENGTH, GAME_HANGMAN_TEXTBOX_LENGTH)];
			textbox.textAlignment = UITextAlignmentCenter;
			textbox.borderStyle = UITextBorderStyleLine;
			textbox.backgroundColor = [UIColor whiteColor];
			textbox.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(GAME_LABEL_FONT)];
			textbox.userInteractionEnabled = NO;
			[inputLetters addObject:textbox];
			[self.view addSubview: textbox];
			[textbox release];
		}
		
		// set up the hangman picture
		[self updateHangmanImage:numberOfGuesses];
	}
}

- (void)setUpWords {
	// get the words for this game
	self.wordsUsedForGameThreeDisplay = [NSMutableArray arrayWithArray:[[IRAppState currentState] wordsForGame]];
	self.wordsWithStatisticsList = [[NSMutableArray alloc] init];
	wordDisplayId = 0;
	
	// initialize the game statistics for this game
	for (IRWord *word in wordsUsedForGameThreeDisplay){
		IRWordWithStatisticsInGame *wordWithSt = [[[IRWordWithStatisticsInGame alloc] init] autorelease];
		wordWithSt.wordID = word.wordID;
		wordWithSt.correctCount = 0;
		wordWithSt.incorrectCount = 0;
		wordWithSt.totalReactionTime = 0;
		[wordsWithStatisticsList addObject:wordWithSt];
	}
	
	self.currentWord = [wordsUsedForGameThreeDisplay objectAtIndex:wordDisplayId];
}

- (void)updateHangmanImage:(NSInteger)numOfGuesses {
	// change the hangman picture based on how many times the user guessed wrongly
	if (numOfGuesses == 0){
		_hangmanImageView.image = [UIImage imageNamed:@"Hangman-0.png"];
	}else if (numOfGuesses == 1){
		_hangmanImageView.image = [UIImage imageNamed:@"Hangman-1.png"];
	}else if (numOfGuesses == 2){
		_hangmanImageView.image = [UIImage imageNamed:@"Hangman-2.png"];
	}else if (numOfGuesses == 3){
		_hangmanImageView.image = [UIImage imageNamed:@"Hangman-3.png"];
	}else if (numOfGuesses == 4){
		_hangmanImageView.image = [UIImage imageNamed:@"Hangman-4.png"];
	}else if (numOfGuesses == 5){
		_hangmanImageView.image = [UIImage imageNamed:@"Hangman-5.png"];
	}else if (numOfGuesses == 6){
		_hangmanImageView.image = [UIImage imageNamed:@"Hangman-6.png"];
	}else {
		return;
	}

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 1) ? NO : YES;
}

- (void)quitHalfWay {
	// if quit half the way, update the statistics and pop out the result view
	[[IRAppState currentState] updateStatisticsWithList:wordsWithStatisticsList inGame:GAME_HANGMAN];
	
	IRMCQResultTableViewController *resultListController = [[IRMCQResultTableViewController alloc] initWithWordWithStatisticsInGame:wordsWithStatisticsList 
																														  WithWords:wordsUsedForGameThreeDisplay];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:resultListController];
	navigationController.navigationBar.tintColor = [UIColor brownColor];
	
	navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self.navigationController presentModalViewController:navigationController animated:YES];
	
	[navigationController release];
	[resultListController release];

}

- (void)configureToolbar {
	// toolbar consists of progress bar and quit now button
	progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	progress.progress = 1.0*wordDisplayId/ [wordsUsedForGameThreeDisplay count];
	UIBarButtonItem *progressBar = [[UIBarButtonItem alloc] initWithCustomView:progress];
	UIBarButtonItem *finishHalfWay = [[UIBarButtonItem alloc] initWithTitle:@"Quit Now" style:UIBarButtonSystemItemCancel target:self action:@selector(quitHalfWay)];
	UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc]
										  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
										  target:nil action:nil];
	UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GAME_TOOLBAR_WIDTH, GAME_TOOLBAR_HEIGHT)];
	labelName.text = @"Progress";
	labelName.backgroundColor = [UIColor clearColor];
	UIBarButtonItem *labelButton = [[UIBarButtonItem alloc] initWithCustomView:labelName];
	[labelName release];
	self.toolbarItems = [NSArray arrayWithObjects:labelButton,progressBar,flexibleSpaceItem,finishHalfWay,nil];
	[progress release];
	[flexibleSpaceItem release];
	[finishHalfWay release];
	[progressBar release];
	[labelButton release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = GAME_HANGMAN;
	self.view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE]] autorelease];
	wordDisplayId = 0;
	// set up words
	[self setUpWords];
	disableButton = NO;
	// set up the first word meaning label textview
	_wordMeangingLabel.lineBreakMode = UILineBreakModeWordWrap;
	_wordMeangingLabel.numberOfLines = 0;
	_wordMeangingLabel.textAlignment =  UITextAlignmentCenter;
	_wordMeangingLabel.textColor = [UIColor whiteColor];
	_wordMeangingLabel.backgroundColor = [UIColor orangeColor];
	_wordMeangingLabel.text = [currentWord translatedWord] ;
	
	numberOfCorrectLetters = [[currentWord englishWord] length];
	numberOfGuesses = 0;
	inputLetters = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [[currentWord englishWord] length]; i++){
		UITextField *textbox = [[UITextField alloc] initWithFrame:CGRectMake(GAME_HANGMAN_TEXTBOX_OX+GAME_HANGMAN_TEXTBOX_INTERVAL*i-numberOfCorrectLetters*8, 
																			 GAME_HANGMAN_TEXTBOX_OY, 
																			 GAME_HANGMAN_TEXTBOX_LENGTH, GAME_HANGMAN_TEXTBOX_LENGTH)];
		textbox.textAlignment = UITextAlignmentCenter;
		textbox.borderStyle = UITextBorderStyleLine;
		textbox.backgroundColor = [UIColor whiteColor];
		textbox.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(GAME_LABEL_FONT)];
		textbox.userInteractionEnabled = NO;
		[inputLetters addObject:textbox];
		[self.view addSubview: textbox];
        [textbox release];
	}
	
	// set up the hangman picture
	[self updateHangmanImage:numberOfGuesses];
	
	self.navigationController.toolbarHidden = NO;
	self.navigationController.toolbar.tintColor = [UIColor brownColor];
	[self configureToolbar];

}

- (IRWordWithStatisticsInGame*)getIRWordInStatisticsListBasedOnId:(NSInteger)wordIdNum {
	
	for (IRWordWithStatisticsInGame *word in wordsWithStatisticsList){
		if (word.wordID == wordIdNum){
			return word;
		}
	}
	return nil;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
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
	[inputLetters release];
	[wordsUsedForGameThreeDisplay release];
	[wordsWithStatisticsList release];
	[currentWord release];
    [super dealloc];
}


@end
