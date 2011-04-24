//
//  IRReviewViewController.h
//  iRemember
//
//  Created by Raymond Hendy on 4/1/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IRMCQViewController.h"
#import "IRHangmanViewController.h"
#import "IRListeningGameViewController.h"
#import "IRHeader.h"
#import "IRAppState.h"

@interface IRReviewViewController : UIViewController {
	IBOutlet UIButton *mcqButton;
	IBOutlet UIButton *gunShootButton;
	IBOutlet UIButton *hangmanButton;
	NSString *buttonTitle;
}

@property (nonatomic,retain) NSString *buttonTitle;

-(IBAction)buttonPressed:(UIButton *)button;

@end
