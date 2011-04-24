//
//  IRReviewIntervalSettingViewController.h
//  iRemember
//
//  Created by Raymond Hendy on 4/9/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRStudyPlan.h"

@interface IRReviewIntervalSettingViewController : UITableViewController {

}

@property (retain) IRStudyPlan *studyPlan;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil studyPlan:(IRStudyPlan *)sp;

@end
