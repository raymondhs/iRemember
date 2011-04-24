//
//  IRLibraryWordViewController.h
//  iRemember
//
//  Created by Yingbo Zhan on 4/9/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRLibraryModifyWord.h"
#import "IRLibrary.h"
#import "IRAppState.h"

@interface IRLibraryWordViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,IRLibraryModifyWordDelegate>
{
	IBOutlet UITableView *table;
	IRLibrary *library;
	NSMutableArray *searchedWordList;
	NSString *language;
}

@property (retain) NSMutableArray *searchedWordList;
@property (retain) NSString *language;
@property (retain) IRLibrary *library;

- (id)initWithNibName:(NSString *)nibNameOrNil  language:(NSString*)lang bundle:(NSBundle *)nibBundleOrNil;
@end

