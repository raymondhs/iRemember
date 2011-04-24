//
//  IRListenQuestionTableViewController.h
//  iRemember
//
//  Created by Zhang Ying on 4/6/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "IRHeader.h"

@protocol IRListenQuestionTableDelegate

- (void)isChoiceRight:(NSString*) choice;

@end

@interface IRListenQuestionTableViewController : UITableViewController {
	AVAudioPlayer *audioPlayer;
	NSString *avFileName;
	NSMutableArray *choicesToDisplay;
	NSString *answer;
	id<IRListenQuestionTableDelegate> delegate;
}
@property (nonatomic,retain) AVAudioPlayer *audioPlayer;
@property (nonatomic,retain) NSString *avFileName;
@property (nonatomic,retain) NSMutableArray *choicesToDisplay;
@property (nonatomic,retain) NSString *answer;
@property (nonatomic,assign) id<IRListenQuestionTableDelegate> delegate;

- (id)initWithFileName:(NSString*)fn Choices:(NSMutableArray*)choices Answer:(NSString*)ans;

- (void)listen;

- (void)pressButtonToListenAgain:(id)sender;


@end
