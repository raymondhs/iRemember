//
//  IRSettingStudyPlanViewController.h
//  iRemember
//
//  Created by Raymond Hendy on 4/9/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRStudyPlan.h"
#import "IRHeader.h"
#import "IRReviewIntervalSettingViewController.h"

@interface IRSettingStudyPlanViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	IRStudyPlan *studyPlan;
	IBOutlet UITableView *_tableView;
}

@property (retain) IRStudyPlan *studyPlan;
@property (retain) IBOutlet UITableView *_tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil studyPlan:(IRStudyPlan *)sp;

@end
