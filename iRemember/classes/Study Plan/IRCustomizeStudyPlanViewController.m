    //
//  IRAddStudyPlanViewController.m
//  iRemember
//
//  Created by Raymond Hendy on 4/1/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRCustomizeStudyPlanViewController.h"

#define CELL_HEIGHT 80

@implementation IRCustomizeStudyPlanViewController

@synthesize textField, tableView = _tableView, segmentedControl, studyPlan, delegate, editing;

#pragma mark -
#pragma mark Initialization

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
		   studyPlan:(IRStudyPlan *)sp delegate:(id)del editing:(BOOL)mode{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self) {
		self.studyPlan = sp;
		self.delegate = del;
		self.editing = mode;
	}
	return self;
}

#pragma mark -
#pragma mark View lifecycle

-(void)changeLanguage {
	NSInteger selected = segmentedControl.selectedSegmentIndex;
	NSString *lang;

	if(selected == 0) {
		lang = LANG_CHINESE;
	} else {
		lang = LANG_INDONESIAN;
	}
	studyPlan.wordList = [[[IRWordList alloc] initWithLanguage:lang] autorelease];
	[_tableView reloadData];
}

-(void)cancel {
	[delegate refreshStudyPlans];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(void)save {
	if([textField.text length] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save"
														message:@"Enter name for study plan."
													   delegate:self
											  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
		return;
	}
	IRStudyPlan *sp = [[IRAppState currentState] studyPlanWithName:textField.text];
	if(sp != nil && sp != self.studyPlan) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save"
														message:@"Enter different name."
													   delegate:self
											  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
	} else if([studyPlan.wordList.words count] < studyPlan.numberOfWordsForReview) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save"
														message:[NSString stringWithFormat:
																 @"There should be at least %d words in the study plan.",
																 studyPlan.numberOfWordsForReview]
													   delegate:self
											  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
	} else {
		studyPlan.name = textField.text;
		[[IRAppState currentState] addStudyPlan:self.studyPlan];
		[studyPlan setReviewInterval:[studyPlan reviewInterval]];
		[self cancel];
	}
}

-(void)settingButtonPressed:(UIButton *)button {
	
	if(editing) {
		IRSettingStudyPlanReadOnlyViewController *settingController =
					[[IRSettingStudyPlanReadOnlyViewController alloc] initWithStyle:UITableViewStyleGrouped
																		  studyPlan:self.studyPlan];
		settingPopover = [[UIPopoverController alloc] initWithContentViewController:settingController];
		settingPopover.popoverContentSize = CGSizeMake(320, 390);
		[settingPopover presentPopoverFromRect:button.bounds
										inView:button
					  permittedArrowDirections:UIPopoverArrowDirectionDown
									  animated:YES];
		[settingController release];
	} else {
		IRSettingStudyPlanViewController *settingController =
					[[IRSettingStudyPlanViewController alloc] initWithNibName:@"SettingStudyPlanView"
															   bundle:nil studyPlan:self.studyPlan];		
		[self.navigationController pushViewController:settingController animated:YES];
		[settingController release];
	}

}

-(void)addButtonPressed {
	IRCustomizeWordViewController *wordController = [[IRCustomizeWordViewController alloc] initWithNibName:@"CustomizeWordView" bundle:nil studyPlan:self.studyPlan];
	[self.navigationController pushViewController:wordController animated:YES];
	[wordController release];
}

-(void)addListButtonPressed {
	IRCustomizeWordListViewController *wordListController = [[IRCustomizeWordListViewController alloc] initWithNibName:@"CustomizeWordListView" bundle:nil studyPlan:self.studyPlan];
	[self.navigationController pushViewController:wordListController animated:YES];
	[wordListController release];
}

-(void)configureNavBar {
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
																  style:UIBarButtonSystemItemCancel
																 target:self action:@selector(cancel)];
	UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done"
																  style:UIBarButtonSystemItemSave
																 target:self action:@selector(save)];

	if(!editing) {
		self.navigationItem.leftBarButtonItem = cancelBtn;
		self.navigationItem.rightBarButtonItem = saveBtn;
	} else {
		self.navigationItem.leftBarButtonItem = saveBtn;

	}
	[saveBtn release];
	[cancelBtn release];
}

-(void)configureToolbar {	
	self.navigationController.toolbarHidden = NO;
	self.navigationController.toolbar.tintColor = [UIColor brownColor];
	UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"Word" style:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
	UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc]
										  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
										  target:nil action:nil];
	UIBarButtonItem *addListItem = [[UIBarButtonItem alloc] initWithTitle:@"Wordlist" style:UIBarButtonSystemItemAdd target:self action:@selector(addListButtonPressed)];
	
	UIImage *img = [UIImage imageNamed:@"setting.png"];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setImage:img forState:UIControlStateNormal];
	btn.frame = CGRectMake(0, 0, 31, 31);
	
	UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithCustomView:btn];

	[btn addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:setting,flexibleSpaceItem,addItem,addListItem,nil];
	self.toolbarItems = items;
	
	[setting release];
	[flexibleSpaceItem release];
	[addItem release];
	[addListItem release];
	[items release];
}

- (void)viewWillAppear:(BOOL)animated {
	[_tableView reloadData];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	if(studyPlan) {
		self.title = @"Edit Study Plan";
		textField.text = studyPlan.name;
		segmentedControl.hidden = YES;
	} else {
		self.title = @"New Study Plan";
		studyPlan = [[IRStudyPlan alloc] init];
	}
	self.segmentedControl.tintColor = [UIColor brownColor];
	[self.segmentedControl addTarget:self
							  action:@selector(changeLanguage)
					forControlEvents:UIControlEventValueChanged];
	[self configureToolbar];
	[self configureNavBar];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
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
    return [[studyPlan wordList] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELL_HEIGHT;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	// Configure the cell...
	if(studyPlan) {
		IRWord *word = [studyPlan.wordList.words objectAtIndex:indexPath.row];
		cell.textLabel.text = word.englishWord;
		cell.detailTextLabel.text = word.translatedWord;
		cell.selectionStyle = UITableViewCellSeparatorStyleNone;
		cell.textLabel.font = [UIFont systemFontOfSize:24];
		cell.detailTextLabel.font = [UIFont systemFontOfSize:22];
		cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
		cell.indentationLevel = 1;
		
		cell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:24];
		cell.detailTextLabel.font = [UIFont fontWithName:@"Heiti TC" size:24];
	}
    
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
	[settingPopover release];
	[_tableView release];
	[segmentedControl release];
	[textField release];
	[studyPlan release];
    [super dealloc];
}

@end
