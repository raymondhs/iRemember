//
//  IRHangmanViewController.h
//  iRemember
//
//  Created by Zhang Ying on 4/3/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRWord.h"
#import "IRWordWithStatisticsInGame.h"
#import "IRMCQResultTableViewController.h"
#import "IRAppState.h"

@interface IRHangmanViewController : UIViewController {
	IBOutlet UIImageView *_hangmanImageView;
	IBOutlet UILabel *_wordMeangingLabel;
	IBOutlet UIButton *_alphaButton;
	NSInteger numberOfCorrectLetters;
	NSInteger numberOfGuesses;
	NSMutableArray *inputLetters;
	NSMutableArray* wordsUsedForGameThreeDisplay;
	NSMutableArray* wordsWithStatisticsList;
	NSInteger wordDisplayId;
	UIProgressView *progress;
	IRWord *currentWord;
	BOOL disableButton;
}

@property (nonatomic, retain) NSMutableArray *inputLetters;
@property(nonatomic,retain) NSMutableArray* wordsUsedForGameThreeDisplay;
@property(nonatomic,retain) NSMutableArray *wordsWithStatisticsList;
@property(nonatomic,retain) IRWord *currentWord;
@property(nonatomic,retain) UIProgressView *progress;
@property(nonatomic) BOOL disableButton;

- (IRWordWithStatisticsInGame*)getIRWordInStatisticsListBasedOnId:(NSInteger)wordIdNum;

- (IBAction) buttonPressed:(UIButton*)button;

- (void)updateAlphabetWithWord:(NSString*)alphabet;

- (void)updateHangmanImage:(NSInteger)numOfGuesses;

- (void)goToNextWord;

@end
