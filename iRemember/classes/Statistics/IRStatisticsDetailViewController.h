//
//  IRStatisticsDetailViewController.h
//  iRemember
//
//  Created by Zhang Ying on 4/9/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRWordList.h"
#import "IRStudyPlan.h"
#import "IRWordWithStatisticsInGame.h"
#import "IRWordWithStatistics.h"
#import "IRHeader.h"
#import "UIViewWithLine.h"

@interface IRStatisticsDetailViewController : UIViewController<UISplitViewControllerDelegate> {
	IBOutlet UIImageView *statisticsImageView;
	id detailItem;
}

@property (nonatomic,retain) IBOutlet UIImageView *statisticsImageView;
@property (nonatomic,retain) id detailItem;

@end
