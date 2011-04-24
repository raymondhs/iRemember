//
//  IRMCQViewController.h
//  iRemember
//
//  Created by Zhang Ying on 3/30/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRWord.h"
#import "IRWordWithStatisticsInGame.h"
#import "IRWordWithStatistics.h"
#import "IRQuestionTableViewController.h"
#import "IRMCQResultTableViewController.h"
#import "IRHeader.h"
#import "IRAppState.h"

@interface IRMCQViewController : UIViewController <UIScrollViewDelegate,IRQuestionTableDelegate> {
	NSMutableArray* wordsUsedForGameOneDisplay;
	NSMutableArray* wordsWithStatisticsList;
	NSInteger wordDisplayId;
	IRQuestionTableViewController *questionTableView;
	IRWord *currentWord;
	NSString *currentQuestion;
	NSMutableArray *currentChoices;
	NSString *currentAnswer;
	UIProgressView *progress;
}
@property(nonatomic,retain) NSMutableArray* wordsUsedForGameOneDisplay;
@property(nonatomic,retain) IRQuestionTableViewController *questionTableView;
@property(nonatomic,retain) NSString *currentQuestion;
@property(nonatomic,retain) NSMutableArray *currentChoices;
@property(nonatomic,retain) NSString *currentAnswer;
@property(nonatomic,retain) NSMutableArray *wordsWithStatisticsList;
@property(nonatomic,retain) IRWord *currentWord;
@property(nonatomic,retain) UIProgressView *progress;

- (void)updateNewQuestionTableView;

- (IRWordWithStatisticsInGame*)getIRWordInStatisticsListBasedOnId:(NSInteger)wordIdNum;

@end
