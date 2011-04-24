//
//  IRStatisticsViewController.h
//  iRemember
//
//  Created by Zhang Ying on 4/9/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRStatisticsDetailViewController;
@class IRStatisticsCategoryTableViewController;

@interface IRStatisticsViewController : UIViewController {
	UISplitViewController *splitViewController;
	IRStatisticsDetailViewController *detailController;
	IRStatisticsCategoryTableViewController *masterController;
}

@property (nonatomic,retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic,retain) IBOutlet IRStatisticsDetailViewController *detailController;
@property (nonatomic,retain) IBOutlet IRStatisticsCategoryTableViewController *masterController;

@end
