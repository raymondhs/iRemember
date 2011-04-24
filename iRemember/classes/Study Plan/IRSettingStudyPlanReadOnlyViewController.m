//
//  IRSettingStudyPlanReadOnlyViewController.m
//  iRemember
//
//  Created by Raymond Hendy on 4/12/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRSettingStudyPlanReadOnlyViewController.h"


@implementation IRSettingStudyPlanReadOnlyViewController

@synthesize studyPlan;

#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style studyPlan:(IRStudyPlan *)sp {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
		self.studyPlan = sp;
    }
    return self;
}

-(void)viewDidLoad {
	self.tableView.scrollEnabled = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}


#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch(section) {
		case 0: return SPSETTING_REVIEWGAME;
		case 1: return SPSETTING_NUMWORDS;
		case 2: return SPSETTING_ORDERING;
		case 3: return SPSETTING_REVIEWINTERVAL;
	}
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	
	NSString *label;
	
	switch(indexPath.section) {
		case 0: label = studyPlan.defaultGameName; break;
		case 1: label = [NSString stringWithFormat:@"%d words",studyPlan.numberOfWordsForReview]; break;
		case 2:
			switch(studyPlan.studyOrdering) {
				case IRStudyOrderingAlphabetical: label = SPORDERING_ALPHABETICAL; break;
				case IRStudyOrderingReversed: label = SPORDERING_REVERSED; break;
				case IRStudyOrderingRandom: label = SPORDERING_RANDOM; break;
			} break;
		case 3:
			if(studyPlan.ebenhauseMode) {
				label = @"Ebenhause Mode";
			} else {
				label = @"Daily";
				NSInteger interval = studyPlan.reviewInterval;
				if(interval == 1) cell.detailTextLabel.text = @"Every day";
				else {
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%d days",studyPlan.reviewInterval];
				}
			}
			break;
	}
	
	cell.textLabel.text = label;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// do nothing
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
	[studyPlan release];
    [super dealloc];
}


@end

