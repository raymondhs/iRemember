//
//  IRLibraryModifyWordListAddWordViewController.h
//  iRemember
//
//  Created by Yingbo Zhan on 4/10/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRWordList.h"
#import "IRAppState.h"
#import "IRHeader.h"

@protocol IRLibraryModifyWordListAddWordDelegate<NSObject>

-(void)refresh;

@end


@interface IRLibraryModifyWordListAddWordViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
	IBOutlet UITableView *table;

	NSArray *searchedWordList;
	NSMutableArray *updatedWordList;
	IRWordList *wordlist;
	IRLibrary *library;
	NSString *language;
	BOOL editingMode;
	id<IRLibraryModifyWordListAddWordDelegate> del;
}
@property (retain) NSArray *searchedWordList;
@property (retain) NSMutableArray *updatedWordList;
@property (retain) IRWordList *wordlist;
@property (retain) NSString *language;
@property (retain) IRLibrary *library;
@property (readwrite) BOOL editingMode;
@property (assign) id del;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil wordlist:(IRWordList*)wrl language:(NSString*)lang editingMode:(BOOL)mode delegate:(id)dele;
@end
