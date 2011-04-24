//
//  IRStatisticsCategoryTableViewController.m
//  iRemember
//
//  Created by Zhang Ying on 4/9/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import "IRStatisticsCategoryTableViewController.h"
#import "IRStatisticsDetailViewController.h"

@implementation IRStatisticsCategoryTableViewController

@synthesize detailViewController;
@synthesize studyPlans;

#pragma mark -
#pragma mark Initialization


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.clearsSelectionOnViewWillAppear;
	
	UIView *tableBgView = [[UIView alloc] init];
	tableBgView.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
	
	self.tableView.backgroundView = tableBgView;
	self.tableView.separatorColor = [UIColor colorWithRed:1 green:0.51 blue:0.14 alpha:0.6];
	[tableBgView release];

	// read the studyplanlist from the appstate
	self.studyPlans = [[IRAppState currentState] studyPlanList];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    //return 3;
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	switch (section) {
		case 0:
			return [studyPlans count];
		case 1:
			return 4;
		default:
			return 3;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = [[studyPlans objectAtIndex:indexPath.row] name];
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = GAME_MCQ;
					break;
				case 1:
					cell.textLabel.text = GAME_LISTENING;
					break;
				case 2:
					cell.textLabel.text = GAME_HANGMAN;
					break;
				case 3:
					cell.textLabel.text = @"Review Overview";
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
	
    return cell;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0: return @"Study Plan";
		case 1: return @"Review Game";
	}
	return 0;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	IRStudyPlan *currentSP = [[IRAppState currentState] currentStudyPlan];
	IRWordList *currentWL = [currentSP wordList];
    switch (indexPath.section) {
		case 0:
			detailViewController.detailItem = [studyPlans objectAtIndex:indexPath.row];
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
					detailViewController.detailItem = [currentWL statisticsInGame:GAME_MCQ];
					break;
				case 1:
					detailViewController.detailItem = [currentWL statisticsInGame:GAME_LISTENING];
					break;
				case 2:
					detailViewController.detailItem = [currentWL statisticsInGame:GAME_HANGMAN];
					break;
				case 3:
					detailViewController.detailItem = [currentWL statisticsOverview];
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[detailViewController release];
	[studyPlans release];
    [super dealloc];
}


@end

