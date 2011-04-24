//
//  IRQuestionsViewController.h
//  IRMCQ
//
//  Created by Zhang Ying on 3/31/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRHeader.h"

@protocol IRQuestionTableDelegate

- (void)isChoiceRight:(NSString*) choice;

@end

@interface IRQuestionTableViewController : UITableViewController {
	NSString *questionToDisplay;
	NSMutableArray *choicesToDisplay;
	NSString *answer;
	id<IRQuestionTableDelegate> delegate;
}

@property (nonatomic,retain) NSString *questionToDisplay;
@property (nonatomic,retain) NSMutableArray *choicesToDisplay;
@property (nonatomic,retain) NSString *answer;
@property (nonatomic,assign) id<IRQuestionTableDelegate> delegate;

- (id)initWithQuestion:(NSString*)question Choices:(NSMutableArray*)choices Answer:(NSString*)ans;

@end
