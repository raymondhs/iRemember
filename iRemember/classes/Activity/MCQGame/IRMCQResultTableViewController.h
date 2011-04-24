//
//  IRMCQResultTableViewController.h
//  IRMCQ
//
//  Created by Zhang Ying on 4/1/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRWordWithStatisticsInGame.h"

@interface IRMCQResultTableViewController : UITableViewController<UITableViewDelegate> {
	NSMutableArray *wordWithStatisticsInGame;
	NSMutableArray *wordsInGame;
}

@property (nonatomic,retain) NSMutableArray *wordWithStatisticsInGame;
@property (nonatomic,retain) NSMutableArray *wordsInGame;

- (id)initWithWordWithStatisticsInGame:(NSMutableArray*)wordWithStsInGame WithWords:(NSMutableArray*)wordsInGame;

@end
