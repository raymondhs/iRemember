//
//  IRMCQViewController.m
//  iRemember
//
//  Created by Zhang Ying on 3/30/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import "IRMCQViewController.h"


@implementation IRMCQViewController

@synthesize questionTableView;
@synthesize currentQuestion;
@synthesize wordsUsedForGameOneDisplay;
@synthesize currentChoices;
@synthesize currentAnswer;
@synthesize wordsWithStatisticsList;
@synthesize currentWord;
@synthesize progress;

- (void)setUpWords {
	// get the words that are used for this game
	self.wordsUsedForGameOneDisplay = [NSMutableArray arrayWithArray:[[IRAppState currentState] wordsForGame]];
	wordsWithStatisticsList = [[NSMutableArray alloc] init];
	wordDisplayId = 0;
	
	// initialize the game statistics for each word
	for (IRWord *word in wordsUsedForGameOneDisplay){
		IRWordWithStatisticsInGame *wordWithSt = [[IRWordWithStatisticsInGame alloc] init];
		wordWithSt.wordID = word.wordID;
		wordWithSt.correctCount = 0;
		wordWithSt.incorrectCount = 0;
		wordWithSt.totalReactionTime = 0;
		[wordsWithStatisticsList addObject:wordWithSt];
		[wordWithSt release];
	}
}

- (void)quitHalfWay {
	// if quit half way, update the statistics and pop out the result view
	[[IRAppState currentState] updateStatisticsWithList:wordsWithStatisticsList inGame:GAME_MCQ];
	IRMCQResultTableViewController *resultListController = [[IRMCQResultTableViewController alloc] initWithWordWithStatisticsInGame:wordsWithStatisticsList 
																														  WithWords:wordsUsedForGameOneDisplay];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:resultListController];
	navigationController.navigationBar.tintColor = [UIColor brownColor];
	
	navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self.navigationController presentModalViewController:navigationController animated:YES];
	
	[navigationController release];
	[resultListController release];

}

- (void)configureToolbar {
	// toolbar contains progress bar and quit now button
	progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	progress.progress = 1.0*wordDisplayId/ [wordsUsedForGameOneDisplay count];
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

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = GAME_MCQ;
	self.view.frame = CGRectMake(0, 0, GAME_FRAME_WIDTH, GAME_FRAME_HEIGHT);
	self.view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE]] autorelease];
	
	[self setUpWords];
	wordDisplayId = 0;
	
	[self updateNewQuestionTableView];
	[self.view addSubview:questionTableView.tableView];
	questionTableView.tableView.frame = CGRectMake(GAME_TABLEVIEW_ORIGIN_X,GAME_TABLEVIEW_ORIGIN_Y,GAME_TABLEVIEW_WIDTH,GAME_TABLEVIEW_HEIGHT);	
	
	self.navigationController.toolbarHidden = NO;
	self.navigationController.toolbar.tintColor = [UIColor brownColor];
	
	[self configureToolbar];
}

- (void)updateNewQuestionTableView{
	self.currentWord = [wordsUsedForGameOneDisplay objectAtIndex:wordDisplayId];
	currentQuestion = [currentWord englishWord];
	currentAnswer = [currentWord translatedWord];
	
	// The following algorithm is to randomly select meanings from current studyplan's wordlist
	// and shuffle them at differet places
	NSInteger correctWordsPos = arc4random() % 4;
	NSInteger chosenPos1=-1;
	NSInteger chosenPos2=-1;
	NSInteger chosenPos3=-1;
	IRWordList* wordlist = [[[IRAppState currentState] currentStudyPlan] wordList];
	NSInteger chosenPos = arc4random() % [[wordlist wordsWithStatistics] count];
	while (chosenPos1 ==-1 || chosenPos2 ==-1 || chosenPos3 == -1){
		NSLog(@"wordlist count: %d",[wordlist count]);
		IRWord *tempWord = [[wordlist words] objectAtIndex:chosenPos];
		if (chosenPos1==-1 && tempWord.wordID!=currentWord.wordID){
			chosenPos1 = chosenPos;
			chosenPos = arc4random() % [[wordlist wordsWithStatistics] count];
		}else if (chosenPos1 !=chosenPos && chosenPos2==-1 && tempWord.wordID!=currentWord.wordID){
			chosenPos2 = chosenPos;
			chosenPos = arc4random() % [[wordlist wordsWithStatistics] count];
		}else if (chosenPos1 !=chosenPos && chosenPos2 !=chosenPos && chosenPos3==-1 && tempWord.wordID!=currentWord.wordID){
			chosenPos3 = chosenPos;
			break;
		}else {
			chosenPos = arc4random() % [[wordlist wordsWithStatistics] count];
		}
	}
	if (wordDisplayId !=0){
		[currentChoices release];
	}
	currentChoices = [[NSMutableArray alloc] init];
	[currentChoices addObject:[[[wordlist words] objectAtIndex:chosenPos1] translatedWord]];
	[currentChoices addObject:[[[wordlist words] objectAtIndex:chosenPos2] translatedWord]];
	[currentChoices addObject:[[[wordlist words] objectAtIndex:chosenPos3] translatedWord]];

	[currentChoices insertObject:currentAnswer atIndex:correctWordsPos];
	self.questionTableView = [[IRQuestionTableViewController alloc] initWithQuestion:currentQuestion
																		Choices:currentChoices 
																		 Answer:currentAnswer];
	questionTableView.delegate = self;
	questionTableView.tableView.scrollEnabled = NO;
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

- (void)changeToNext {
	if (wordDisplayId >=[wordsUsedForGameOneDisplay count]-1) {
		
		// if all words have been shown, then should pop up the result list		
		wordDisplayId++;
		progress.progress = 1.0*wordDisplayId/[wordsUsedForGameOneDisplay count];
		[[IRAppState currentState] updateStatisticsWithList:wordsWithStatisticsList inGame:GAME_MCQ];
		IRMCQResultTableViewController *resultListController = [[IRMCQResultTableViewController alloc] initWithWordWithStatisticsInGame:wordsWithStatisticsList 
																															  WithWords:wordsUsedForGameOneDisplay];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:resultListController];
		navigationController.navigationBar.tintColor = [UIColor brownColor];
		
		navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
		[self.navigationController presentModalViewController:navigationController animated:YES];
				
		[navigationController release];
		[resultListController release];

		return;
	}else {
		
		// show the next word; also add animation during the question view's transition
		wordDisplayId++;
		UIView* sup = questionTableView.view.superview;
		IRQuestionTableViewController *temp = questionTableView;
		
		CGRect correctFrame = CGRectMake(GAME_TABLEVIEW_ORIGIN_X, GAME_TABLEVIEW_ORIGIN_Y, GAME_TABLEVIEW_WIDTH, GAME_TABLEVIEW_HEIGHT);
		CGRect tempFinalFrame = CGRectMake(-(GAME_TABLEVIEW_WIDTH+GAME_TABLEVIEW_ORIGIN_X), GAME_TABLEVIEW_ORIGIN_Y, GAME_TABLEVIEW_WIDTH, GAME_TABLEVIEW_HEIGHT);
		CGRect newQuestionInitFrame = CGRectMake(GAME_FRAME_WIDTH, GAME_TABLEVIEW_ORIGIN_Y, GAME_TABLEVIEW_WIDTH, GAME_TABLEVIEW_HEIGHT);
		
		[self updateNewQuestionTableView];
		[sup addSubview:questionTableView.tableView];
		questionTableView.tableView.frame = newQuestionInitFrame;
		
		[UIView animateWithDuration:GAME_ANIMATION_DURATION
							  delay:GAME_ANIMATION_DELAY
							options:UIViewAnimationCurveEaseOut
						 animations:^{
							 temp.tableView.frame = tempFinalFrame;
							 progress.progress = 1.0*wordDisplayId/[wordsUsedForGameOneDisplay count];
									  questionTableView.tableView.frame = correctFrame;}
						 completion:^(BOOL finished){ [temp.tableView removeFromSuperview]; 
												      [temp release];}];
	}
}

- (void)isChoiceRight:(NSString*)judgement{

	if ([judgement isEqual:@"right"]){
		
		// update the statistics
		for (IRWordWithStatistics *word in [[[[IRAppState currentState] currentStudyPlan] wordList] wordsWithStatistics]){
			if (word.wordID == currentWord.wordID){
				word.isStudied = YES;
			}
		}
		
		IRWordWithStatisticsInGame *wordWithSt =[self getIRWordInStatisticsListBasedOnId:currentWord.wordID];
		if (wordWithSt != nil){
			[wordWithSt setCorrectCount:([wordWithSt correctCount]+1)];
		}else {
			printf("The wordWithStatistics is nil in IRMCQViewController line 217");
		}

	}else {
		// add the wrong one to the end of the array
		[wordsUsedForGameOneDisplay addObject:currentWord];
		
		// update the statistics
		IRWordWithStatisticsInGame *wordWithSt =[self getIRWordInStatisticsListBasedOnId:currentWord.wordID];
		if (wordWithSt != nil){
			[wordWithSt setIncorrectCount:([wordWithSt incorrectCount]+1)];
		}else {
			printf("The wordWithStatistics is nil in IRMCQViewController line 227");
		}
	}
	// move to the next
	[NSTimer scheduledTimerWithTimeInterval:GAME_ANIMATION_DURATION
                                     target:self
                                   selector:@selector(changeToNext)
                                   userInfo:nil
                                    repeats:NO];
}

- (IRWordWithStatisticsInGame*)getIRWordInStatisticsListBasedOnId:(NSInteger)wordIdNum {
	
	for (IRWordWithStatisticsInGame *word in wordsWithStatisticsList){
		if (word.wordID == wordIdNum){
			return word;
		}
	}
	return nil;
}

- (void)dealloc {
	[wordsUsedForGameOneDisplay release];
	[wordsWithStatisticsList release];
	[questionTableView release];
	[currentQuestion release];
	[currentChoices release];
	[currentAnswer release];
	[currentWord release];
    [super dealloc];
}


@end
