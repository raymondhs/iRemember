//
//  StudyPlanViewController.h
//  iRemember
//
//  Created by Raymond Hendy on 3/22/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "IRCustomizeStudyPlanViewController.h"
#import "IRStudyPlan.h"
#import "IRHeader.h"
#import "IRAppState.h"

@interface IRStudyPlanViewController : UIViewController<IRCustomizeStudyPlanViewControllerDelegate,
										UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView *_tableView;
	NSMutableArray *studyPlans;
}

@property (retain) NSMutableArray *studyPlans;
@property (retain) IBOutlet UITableView *tableView;


@end
