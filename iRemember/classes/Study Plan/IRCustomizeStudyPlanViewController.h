//
//  IRAddStudyPlanViewController.h
//  iRemember
//
//  Created by Raymond Hendy on 4/1/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <EventKit/EventKit.h>
#import "IRStudyPlan.h"
#import "IRCustomizeWordViewController.h"
#import "IRCustomizeWordListViewController.h"
#import "IRSettingStudyPlanViewController.h"
#import "IRSettingStudyPlanReadOnlyViewController.h"

@protocol IRCustomizeStudyPlanViewControllerDelegate<NSObject>

-(void)refreshStudyPlans;

@end


@interface IRCustomizeStudyPlanViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITextField *textField;
	IBOutlet UITableView *_tableView;
	IBOutlet UISegmentedControl *segmentedControl;
	IRStudyPlan *studyPlan;
	id<IRCustomizeStudyPlanViewControllerDelegate> delegate;
	UIPopoverController *settingPopover;
}

@property (retain) IBOutlet UITextField *textField;
@property (retain) IBOutlet UITableView *tableView;
@property (retain) IBOutlet UISegmentedControl *segmentedControl;
@property (retain) IRStudyPlan *studyPlan;
@property (assign) id delegate;
@property BOOL editing;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
		   studyPlan:(IRStudyPlan *)sp delegate:(id)del editing:(BOOL)mode;

@end
