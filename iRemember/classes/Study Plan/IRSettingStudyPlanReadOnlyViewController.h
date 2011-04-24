//
//  IRSettingStudyPlanReadOnlyViewController.h
//  iRemember
//
//  Created by Raymond Hendy on 4/12/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRStudyPlan.h"
#import "IRHeader.h"

@interface IRSettingStudyPlanReadOnlyViewController : UITableViewController {
	IRStudyPlan *studyPlan;
}

@property (retain) IRStudyPlan *studyPlan;

- (id)initWithStyle:(UITableViewStyle)style studyPlan:(IRStudyPlan *)sp;

@end
