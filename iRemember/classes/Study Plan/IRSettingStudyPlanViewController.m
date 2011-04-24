    //
//  IRSettingStudyPlanViewController.m
//  iRemember
//
//  Created by Raymond Hendy on 4/9/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRSettingStudyPlanViewController.h"

#define WORD_COUNT(X) (self.studyPlan.numberOfWordsForReview == (X) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone)
#define ORDER(X) (self.studyPlan.studyOrdering == (X) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone)
#define GAME(X) ([((NSString *)X) isEqual:self.studyPlan.defaultGameName] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone)

@implementation IRSettingStudyPlanViewController

@synthesize studyPlan, _tableView;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

-(void)switchValueChanged:(id)sender {
	UISwitch *sw = (UISwitch *)sender;
	NSIndexPath *dayMode = [NSIndexPath indexPathForRow:1 inSection:3];
	NSArray *arr = [[NSArray alloc] initWithObjects:dayMode,nil];
	studyPlan.ebenhauseMode = sw.on;
	if(sw.on) {
		[_tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
	} else {
		[_tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
		[_tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil studyPlan:(IRStudyPlan *)sp {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.studyPlan = sp;
    }
    return self;
}

-(void)done {
	[self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated {
	NSIndexPath *dayMode = [NSIndexPath indexPathForRow:1 inSection:3];
	NSArray *arr = [[[NSArray alloc] initWithObjects:dayMode,nil] autorelease];
	[_tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Settings";
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done"
																style:UIBarButtonSystemItemSave
															   target:self action:@selector(done)];
	self.navigationItem.leftBarButtonItem = doneBtn;
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
	switch(section) {
		case 0: return 3;
		case 1: return 4;
		case 2: return 3;
		case 3: return studyPlan.ebenhauseMode ? 1 : 2;
	}
	return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.section];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		UITableViewCellStyle style = indexPath.section == 3 ? UITableViewCellStyleValue1 : UITableViewCellStyleDefault;
        cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:CellIdentifier] autorelease];
    }
	
	// Configure the cell...
	NSString *cellText;
	NSInteger row = indexPath.row;
	
	UITableViewCellAccessoryType type;
	
	switch(indexPath.section) {
		case 0:
			switch(row) {
				case 0: cellText = GAME_MCQ; type = GAME(GAME_MCQ); break;
				case 1: cellText = GAME_LISTENING; type = GAME(GAME_LISTENING); break;
				case 2: cellText = GAME_HANGMAN; type = GAME(GAME_HANGMAN); break;
			} break;
		case 1:
			switch(row) {
				case 0: cellText = @"5 words"; type = WORD_COUNT(5); break;
				case 1: cellText = @"10 words"; type = WORD_COUNT(10); break;
				case 2: cellText = @"25 words"; type = WORD_COUNT(25); break;
			    case 3: cellText = @"50 words"; type = WORD_COUNT(50); break;
			} break;
		case 2:
			switch(row) {
				case 0: cellText = SPORDERING_ALPHABETICAL; type = ORDER(0); break;
				case 1: cellText = SPORDERING_REVERSED; type = ORDER(1); break;
				case 2: cellText = SPORDERING_RANDOM; type = ORDER(2); break;
			} break;
		case 3:
			if(row == 0) {
				cellText = SPMODE_EBENHAUSE;
				UISwitch *switchView = [[UISwitch alloc] init];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				type = UITableViewCellAccessoryNone;
				if(studyPlan.ebenhauseMode) switchView.on = YES;
				[switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
				cell.accessoryView = switchView;
				[switchView release];
			} else {
				cellText = SPMODE_DAILY;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				type = UITableViewCellAccessoryDisclosureIndicator;
				NSString *detailText;
				NSInteger reviewInterval = studyPlan.reviewInterval;
				if(reviewInterval == 1) {
					detailText = @"Every day";
				} else if(reviewInterval != 0) {
					detailText = [NSString stringWithFormat:@"%d days",reviewInterval];	
				}
				cell.detailTextLabel.text = detailText;
				type = UITableViewCellAccessoryDisclosureIndicator;
			}
			break;
	}
	cell.textLabel.text = cellText;
	cell.accessoryType = type;
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger numRow = [self tableView:tableView numberOfRowsInSection:indexPath.section];
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	if(section == 3) {
		if(indexPath.row == 1) {
			IRReviewIntervalSettingViewController *intervalController =
			[[IRReviewIntervalSettingViewController alloc] initWithNibName:@"ReviewIntervalSettingView" bundle:nil studyPlan:self.studyPlan];
			[self.navigationController pushViewController:intervalController animated:YES];
			[intervalController release];
		}
	} else {
		int i;
		for(i = 0; i < numRow; i++) {
			UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
			if(i == indexPath.row) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		}
		[_tableView deselectRowAtIndexPath:indexPath animated:YES];
		switch(section) {
			case 0:
				switch (row) {
					case 0: studyPlan.defaultGameName = GAME_MCQ; break;
					case 1: studyPlan.defaultGameName = GAME_LISTENING; break;
					case 2: studyPlan.defaultGameName = GAME_HANGMAN; break;
				} break;
			case 1:
				switch (row) {
					case 0: studyPlan.numberOfWordsForReview = 5; break;
					case 1: studyPlan.numberOfWordsForReview = 10; break;
					case 2: studyPlan.numberOfWordsForReview = 25; break;
					case 3: studyPlan.numberOfWordsForReview = 50; break;
				} break;
			case 2:
				switch (row) {
					case 0: studyPlan.studyOrdering = IRStudyOrderingAlphabetical; break;
					case 1: studyPlan.studyOrdering = IRStudyOrderingReversed; break;
					case 2: studyPlan.studyOrdering = IRStudyOrderingRandom; break;
				} break;
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_tableView release];
	[studyPlan release];
    [super dealloc];
}


@end
