//
//  IRStatisticsCategoryTableViewController.h
//  iRemember
//
//  Created by Zhang Ying on 4/9/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IRHeader.h"
#import "IRAppState.h"
#import "IRStudyPlan.h"
#import "IRWordList.h"

@class IRStatisticsDetailViewController;

@interface IRStatisticsCategoryTableViewController : UITableViewController {
	IRStatisticsDetailViewController *detailViewController;
	NSMutableArray *studyPlans;
}

@property (nonatomic,retain) IRStatisticsDetailViewController *detailViewController;
@property (nonatomic,retain) NSMutableArray *studyPlans;

@end
