//
//  iRememberViewController.h
//  iRemember
//
//  Created by Raymond Hendy on 3/22/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRLibrarySelectViewController.h"
#import "IRFlashcardViewController.h"
#import "IRStudyPlanViewController.h"
#import "IRReviewViewController.h"
#import "IRStatisticsViewController.h"
#import "IRInfo.h"

@interface iRememberViewController : UIViewController {
	UIPopoverController *infoPopover;
}

-(IBAction)buttonPressed:(UIButton *)button;

@end

