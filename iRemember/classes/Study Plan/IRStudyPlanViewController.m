//
//  StudyPlanViewController.m
//  iRemember
//
//  Created by Raymond Hendy on 3/22/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRStudyPlanViewController.h"


#define CELL_HEIGHT 70

@implementation IRStudyPlanViewController

@synthesize studyPlans, tableView = _tableView;

-(void)updateCalendarEventsWithStudyPlan:(IRStudyPlan *)sp {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// clear other iRemember events
	EKEventStore *store = [[EKEventStore alloc] init];
	NSDate *beginDate = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
	
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *comp = [[NSDateComponents alloc] init];
	[comp setDay:3*DEFAULT_TOTAL_DAYS];
	NSDate *endDate = [gregorian dateByAddingComponents:comp toDate:beginDate options:0];
	
	NSPredicate *predicate = [store predicateForEventsWithStartDate:beginDate
															endDate:endDate
														  calendars:nil];
	NSArray *eventList = [store eventsMatchingPredicate:predicate];
	
	for(EKEvent *evt in eventList) {
		[store removeEvent:evt span:EKSpanThisEvent error:nil];
	}
	[comp release];
	[store release];
	
	// insert the new event
	int i;
	for (i = 0; i < [sp.plannedReviewDates count]; i++) {
		EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
		EKEvent *event = [EKEvent eventWithEventStore:eventStore];
		event.title     = @"iRemember Study Time";
		event.startDate = [sp.plannedReviewDates objectAtIndex:i];
		event.endDate = [[[NSDate alloc] initWithTimeInterval:3600 sinceDate:event.startDate] autorelease];
		
		EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:event.startDate];
		event.alarms = [[[NSMutableArray alloc] initWithObjects:alarm,nil] autorelease];

		event.calendar = [eventStore defaultCalendarForNewEvents];
		[eventStore saveEvent:event span:EKSpanThisEvent error:nil];
	}
	
	[pool release];
}

-(void)changeToDefaultStudyPlan{
	IRStudyPlan *sp = [[IRAppState currentState] studyPlanWithName:DEFAULT_STUDYPLAN];
	[[IRAppState currentState] setCurrentStudyPlan:sp];
	[self updateCalendarEventsWithStudyPlan:sp];
	[self refreshStudyPlans];
}

-(void)setAsDefault:(UIButton *)btn {
	UITableViewCell *cell = (UITableViewCell *)(btn.superview);
	NSString *spName = cell.textLabel.text;
	IRStudyPlan *sp = [[IRAppState currentState] studyPlanWithName:spName];
	[[IRAppState currentState] setCurrentStudyPlan:sp];
	
	[NSThread detachNewThreadSelector:@selector(updateCalendarEventsWithStudyPlan:) toTarget:self withObject:sp];
	
	[self refreshStudyPlans];
}

-(void)refreshStudyPlans {
	[_tableView reloadData];
}

-(void)configureTableView {
	UIView *tableBgView = [[UIView alloc] init];
	tableBgView.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
	_tableView.layer.borderColor = [[UIColor colorWithRed:0.65 green:0.35 blue:0 alpha:1] CGColor];
	_tableView.layer.borderWidth = 5;
	_tableView.backgroundView = tableBgView;
	_tableView.separatorColor = [UIColor colorWithRed:1 green:0.51 blue:0.14 alpha:0.6];
	[tableBgView release];
}

-(void)customizeStudyPlan:(IRStudyPlan *)sp editing:(BOOL)mode {
	IRCustomizeStudyPlanViewController *custStudyPlanController =
	[[IRCustomizeStudyPlanViewController alloc] initWithNibName:@"CustomizeStudyPlanView"
														 bundle:nil
													  studyPlan:sp
													   delegate:self
														editing:mode];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:custStudyPlanController];
	navController.navigationBar.tintColor = [UIColor brownColor];
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	[[self navigationController] presentModalViewController:navController animated:YES];
	
	[navController release];
	[custStudyPlanController release];
}

-(void)addButtonPressed {
	[self customizeStudyPlan:nil editing:NO];
}

-(void)configureToolbarItems {	
	UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			 target:self
																			 action:@selector(addButtonPressed)];
	self.toolbarItems = [NSArray arrayWithObjects:addItem,nil];
	
	[addItem release];
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELL_HEIGHT;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [studyPlans count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell...
	cell.textLabel.backgroundColor = [UIColor clearColor];
	
	IRStudyPlan *sp =[studyPlans objectAtIndex:indexPath.row];
    cell.textLabel.text = [sp name];
	cell.detailTextLabel.text = [[sp wordList] language];
	cell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:24];
	cell.detailTextLabel.font = [UIFont fontWithName:@"Heiti TC" size:24];
	
	UIView *cellBgView = [[UIView alloc] init];
	cellBgView.backgroundColor = [UIColor colorWithRed:0.6 green:0.4 blue:0.2 alpha:0.5];
	cell.selectedBackgroundView = cellBgView;
	[cellBgView release];
	
	cell.indentationLevel = 1;
	cell.indentationWidth = 5;
	
	if([[[IRAppState currentState] currentStudyPlan] isEqual:sp]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.accessoryView = nil;
	} else {
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		btn.frame = CGRectMake(0, 0, 115, 41);
		[btn setTitle:@"Set as Default" forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(setAsDefault:) forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryView = btn;
	}
	
    return cell;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: animated];
    [_tableView setEditing:editing animated:animated];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Determine if it's in editing mode
    if (_tableView.editing && ![[[studyPlans objectAtIndex:indexPath.row] name] isEqual:DEFAULT_STUDYPLAN]) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source.
		[studyPlans removeObjectAtIndex:indexPath.row];
		BOOL shouldDefault = NO;
		if([[tableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryCheckmark) {
			shouldDefault = YES;
		}
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		if(shouldDefault){
			[self changeToDefaultStudyPlan];
		}
	}    
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self customizeStudyPlan:[studyPlans objectAtIndex:indexPath.row] editing:YES];
}

#pragma mark -
#pragma mark Memory management

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Study Plan";
	self.view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE]] autorelease];
	[self configureToolbarItems];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self configureTableView];
	self.studyPlans = [[IRAppState currentState] studyPlanList];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_tableView release];
	[studyPlans release];
    [super dealloc];
}

@end
