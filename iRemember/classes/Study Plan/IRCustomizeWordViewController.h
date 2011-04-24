//
//  IRCustomizeWordViewController.h
//  iRemember
//
//  Created by Raymond Hendy on 4/5/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRAppState.h"
#import "IRLibrary.h"
#import "IRStudyPlan.h"

@interface IRCustomizeWordViewController : UIViewController<UISearchBarDelegate> {
	IRLibrary *library;
	IRStudyPlan *studyPlan;
	NSMutableArray *updatedWordList;
	NSArray *searchedWordList;
	
	IBOutlet UITableView *_tableView;
}

@property (retain) IRLibrary *library;
@property (retain) IRStudyPlan *studyPlan;
@property (retain) NSMutableArray *updatedWordList;
@property (retain) NSArray *searchedWordList;
@property (retain) IBOutlet UITableView *_tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil studyPlan:(IRStudyPlan *)sp;

@end
