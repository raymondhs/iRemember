    //
//  IRListeningGameViewController.m
//  iRemember
//
//  Created by Zhang Ying on 4/6/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import "IRListeningGameViewController.h"


@implementation IRListeningGameViewController

@synthesize questionTableView;
@synthesize wordsUsedForGameTwoDisplay;
@synthesize currentChoices;
@synthesize currentAnswer;
@synthesize wordsWithStatisticsList;
@synthesize currentWord;

@synthesize progress;


- (void)setUpWords {
	// get the words for this game
	self.wordsUsedForGameTwoDisplay = [NSMutableArray arrayWithArray:[[IRAppState currentState] wordsForGame]];
	wordsWithStatisticsList = [[NSMutableArray alloc] init];
	wordDisplayId = 0;
	
	// initialize the statistics for each word in the game
	for (IRWord *word in wordsUsedForGameTwoDisplay){
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
	
	// if quit half the way, update the statistics and show the result view
	[[IRAppState currentState] updateStatisticsWithList:wordsWithStatisticsList inGame:GAME_LISTENING];

	IRMCQResultTableViewController *resultListController = [[IRMCQResultTableViewController alloc] initWithWordWithStatisticsInGame:wordsWithStatisticsList 
																														  WithWords:wordsUsedForGameTwoDisplay];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:resultListController];
	navigationController.navigationBar.tintColor = [UIColor brownColor];
	
	navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self.navigationController presentModalViewController:navigationController animated:YES];
	
	[navigationController release];
	[resultListController release];
}

- (void)configureToolbar {
	
	// toolbar contains a progress bar and a quit now button
	progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	progress.progress = 1.0*wordDisplayId/ [wordsUsedForGameTwoDisplay count];
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
	self.title = GAME_LISTENING;
	self.view.frame = CGRectMake(0, 0, GAME_FRAME_WIDTH, GAME_FRAME_HEIGHT);
	self.view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE]] autorelease];
	
	[self setUpWords];
	wordDisplayId = 0;
	
	[self updateNewQuestionTableView];
	[self.view addSubview:questionTableView.tableView];
	
	self.navigationController.toolbarHidden = NO;
	self.navigationController.toolbar.tintColor = [UIColor brownColor];
	[self configureToolbar];
	
	questionTableView.tableView.frame = CGRectMake(GAME_TABLEVIEW_ORIGIN_X,GAME_TABLEVIEW_ORIGIN_Y,GAME_TABLEVIEW_WIDTH,GAME_TABLEVIEW_HEIGHT);
}


- (void)updateNewQuestionTableView{
	self.currentWord = [wordsUsedForGameTwoDisplay objectAtIndex:wordDisplayId];
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

	self.questionTableView = [[IRListenQuestionTableViewController alloc] initWithFileName:[currentWord soundFileName]
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
	if (wordDisplayId >=[wordsUsedForGameTwoDisplay count]-1) {
		
		// if all words have been shown, pop out the result list and update the statistics
		wordDisplayId++;
		progress.progress = 1.0*wordDisplayId/[wordsUsedForGameTwoDisplay count];
		[[questionTableView audioPlayer] stop];
		[[IRAppState currentState] updateStatisticsWithList:wordsWithStatisticsList inGame:GAME_LISTENING];

		IRMCQResultTableViewController *resultListController = [[IRMCQResultTableViewController alloc] initWithWordWithStatisticsInGame:wordsWithStatisticsList 
																															  WithWords:wordsUsedForGameTwoDisplay];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:resultListController];
		navigationController.navigationBar.tintColor = [UIColor brownColor];
		
		navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
		[self.navigationController presentModalViewController:navigationController animated:YES];
		
		[navigationController release];
		[resultListController release];
		return;
	}else {
		
		// jump to the next word; implement animations between the showing question
		wordDisplayId++;
		UIView* sup = questionTableView.view.superview;
		[[questionTableView audioPlayer] stop];
		IRListenQuestionTableViewController *temp = questionTableView;
		
		CGRect correctFrame = CGRectMake(GAME_TABLEVIEW_ORIGIN_X, GAME_TABLEVIEW_ORIGIN_Y, GAME_TABLEVIEW_WIDTH, GAME_TABLEVIEW_HEIGHT);
		CGRect tempFinalFrame = CGRectMake(-(GAME_TABLEVIEW_WIDTH+GAME_TABLEVIEW_ORIGIN_X), GAME_TABLEVIEW_ORIGIN_Y, GAME_TABLEVIEW_WIDTH, GAME_TABLEVIEW_HEIGHT);
		CGRect newQuestionInitFrame = CGRectMake(GAME_FRAME_WIDTH, GAME_TABLEVIEW_ORIGIN_Y, GAME_TABLEVIEW_WIDTH, GAME_TABLEVIEW_HEIGHT);
		
		[self updateNewQuestionTableView];
		[sup addSubview:questionTableView.tableView];
		questionTableView.tableView.frame = newQuestionInitFrame;
		
		[UIView animateWithDuration:GAME_ANIMATION_DURATION
							  delay:GAME_ANIMATION_DELAY
							options:UIViewAnimationTransitionNone
						 animations:^{
							 progress.progress = 1.0*wordDisplayId/[wordsUsedForGameTwoDisplay count];
							 temp.tableView.frame = tempFinalFrame;
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
			printf("The wordWithStatistics is nil in IRListeningGameViewController line 221");
		}
		
	}else {
		// add the wrong one to the end of the array
		[wordsUsedForGameTwoDisplay addObject:currentWord];
		// update the statistics
		IRWordWithStatisticsInGame *wordWithSt =[self getIRWordInStatisticsListBasedOnId:currentWord.wordID];
		if (wordWithSt != nil){
			[wordWithSt setIncorrectCount:([wordWithSt incorrectCount]+1)];
		}else {
			printf("The wordWithStatistics is nil in IRListeningGameViewController line 226");
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
	[wordsUsedForGameTwoDisplay release];
	[wordsWithStatisticsList release];
	[questionTableView release];
	[currentChoices release];
	[currentAnswer release];
	[currentWord release];
    [super dealloc];
}



@end
