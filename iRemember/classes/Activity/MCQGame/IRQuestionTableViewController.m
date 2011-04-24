//
//  IRQuestionsViewController.m
//  IRMCQ
//
//  Created by Zhang Ying on 3/31/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import "IRQuestionTableViewController.h"


@implementation IRQuestionTableViewController

@synthesize questionToDisplay;
@synthesize choicesToDisplay;
@synthesize answer;
@synthesize delegate;

#pragma mark -
#pragma mark Initialization

- (id)initWithQuestion:(NSString*)question Choices:(NSMutableArray*)choices Answer:(NSString*)ans{
	if (self = [super initWithStyle:UITableViewStyleGrouped]){
		self.questionToDisplay = question;
		self.choicesToDisplay = choices;
		self.answer = ans;
	}
	return self;
}

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
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	if (indexPath.row == 0){
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GAME_MCQ_LABEL_WIDTH, GAME_MCQ_LABEL_HEIGHT)];
		label.textAlignment =  UITextAlignmentCenter;
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor orangeColor];
		label.text = questionToDisplay;
		label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(GAME_LABEL_FONT)];
		[cell.contentView addSubview:label];
		[label release];
	}else{
		NSString *givenChoice = [choicesToDisplay objectAtIndex:indexPath.row-1];
		cell.textLabel.text = givenChoice;
	}
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (delegate != nil && indexPath.row != 0){
		NSString *userChoice = [choicesToDisplay objectAtIndex:indexPath.row-1];
		NSString *judgement;
		UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
		
		// to judge whether the user has chosen the correct answer or not
		if ([userChoice isEqual:answer]){
			judgement = @"right";
			cell.detailTextLabel.text = @"correct";
			cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Check-icon.png"]] autorelease];
			cell.accessoryView.bounds = CGRectMake(0, 0, GAME_TABLEVIEW_CELLICON_LENGTH, GAME_TABLEVIEW_CELLICON_LENGTH);
		}else {
			judgement = @"wrong";
			cell.detailTextLabel.text = @"wrong";
			cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_icon.png"]] autorelease];
			cell.accessoryView.bounds = CGRectMake(0, 0, GAME_TABLEVIEW_CELLICON_LENGTH, GAME_TABLEVIEW_CELLICON_LENGTH);
		}
		tableView.allowsSelection = NO;
		[delegate isChoiceRight:judgement];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0){
		return GAME_CELL_HEIGHT1;
	}else {
		return GAME_CELL_HEIGHT2;
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
	[choicesToDisplay release];
	[answer release];
	[questionToDisplay release];
    [super dealloc];
}


@end

