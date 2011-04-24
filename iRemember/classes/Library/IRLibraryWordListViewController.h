//
//  IRLibraryWordListViewController.h
//  iRemember
//
//  Created by Yingbo Zhan on 4/9/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IRAppState.h"
#import "IRLibrary.h"
#import "IRLibraryModifyWordListViewController.h"
#import "IRConnection.h"
#import "IRClient.h"

@interface IRLibraryWordListViewController : UIViewController<IRConnection,UITableViewDelegate,UITableViewDataSource>{
	IBOutlet UITableView *table;
	NSString *language;
	NSMutableArray *listOfWordlists;
	NSMutableArray *checkLang;
	IRClient *client;
}

@property (retain) NSString *language;
@property (retain) NSMutableArray *listOfWordlists;
@property (retain) NSMutableArray *checkLang;
@property (retain) IRClient *client;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lang:(NSString*)lang;

@end
