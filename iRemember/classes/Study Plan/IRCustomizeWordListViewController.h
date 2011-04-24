//
//  IRCustomizeWordListViewController.h
//  iRemember
//
//  Created by Raymond Hendy on 4/9/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRAppState.h"

@interface IRCustomizeWordListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	NSMutableArray *updatedWordLists;
	NSMutableArray *filteredWordLists;
	IRStudyPlan *studyPlan;
}

@property (retain) NSMutableArray *updatedWordLists;
@property (retain) NSMutableArray *filteredWordLists;
@property (retain) IRStudyPlan *studyPlan;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil studyPlan:(IRStudyPlan *)sp;

@end
