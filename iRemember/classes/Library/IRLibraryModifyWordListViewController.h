//
//  IRLibraryModifyWordListViewController.h
//  iRemember
//
//  Created by Yingbo Zhan on 4/10/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRWordList.h"
#import "IRAppState.h"
#import "IRLibraryModifyWordListAddWordViewController.h"

@interface IRLibraryModifyWordListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
	
	IBOutlet UITableView *table;
	IBOutlet UITextField *wordlistname;
	NSString* lang;
	IRWordList *wordlist;
	id dele;
	BOOL editingMode;
	NSMutableArray *words;
	
}

@property (retain) NSString* lang;
@property (retain) IRWordList *wordlist;
@property BOOL editingMode;
@property (assign) id dele;
@property (retain) NSMutableArray *words;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil language:(NSString*)language delegate:(id)del wordlist:(IRWordList*)wdl editing:(BOOL)mode;

- (void)refresh;

@end
