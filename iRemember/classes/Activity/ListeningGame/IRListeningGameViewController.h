//
//  IRListeningGameViewController.h
//  iRemember
//
//  Created by Zhang Ying on 4/6/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRWord.h"
#import "IRWordWithStatisticsInGame.h"
#import "IRMCQResultTableViewController.h"
#import "IRListenQuestionTableViewController.h"
#import "IRAppState.h"

@interface IRListeningGameViewController : UIViewController <IRListenQuestionTableDelegate> {
	NSMutableArray* wordsUsedForGameTwoDisplay;
	NSMutableArray* wordsWithStatisticsList;
	NSInteger wordDisplayId;
	NSMutableArray *currentChoices;
	NSString *currentAnswer;
	UIProgressView *progress;
	IRListenQuestionTableViewController *questionTableView;
	IRWord *currentWord;
}

@property(nonatomic,retain) NSMutableArray* wordsUsedForGameTwoDisplay;
@property(nonatomic,retain) IRListenQuestionTableViewController *questionTableView;
@property(nonatomic,retain) NSMutableArray *currentChoices;
@property(nonatomic,retain) NSString *currentAnswer;
@property(nonatomic,retain) NSMutableArray *wordsWithStatisticsList;
@property(nonatomic,retain) IRWord *currentWord;
@property(nonatomic,retain) UIProgressView *progress;

- (void)updateNewQuestionTableView;

- (IRWordWithStatisticsInGame*)getIRWordInStatisticsListBasedOnId:(NSInteger)wordIdNum;

@end
