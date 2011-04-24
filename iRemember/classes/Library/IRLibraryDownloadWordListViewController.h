//
//  IRLibraryDownloadWordListViewController.h
//  iRemember
//
//  Created by Raymond Hendy on 4/15/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"IRClient.h"
#import "IRConnection.h"
#import "IRWordList.h"
#import "IRAppState.h"

@interface IRLibraryDownloadWordListViewController : UIViewController<IRConnection,UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView *_tableView;
	NSArray *wordListNames;
	IRClient *client;
}

@property (retain) UITableView *_tableView;
@property (retain) NSArray *wordListNames;
@property (retain) IRClient *client;

@end
