    //
//  IRCustomizeWordListViewController.m
//  iRemember
//
//  Created by Raymond Hendy on 4/9/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRCustomizeWordListViewController.h"

#define CELL_HEIGHT 80

@implementation IRCustomizeWordListViewController

@synthesize filteredWordLists, updatedWordLists, studyPlan;

// filter according to language
-(void)filterWordList {
	filteredWordLists = [[NSMutableArray alloc] init];
	NSMutableArray *libWL = [[IRAppState currentState] wordLists];
	int i;
	for(i = 0; i < [libWL count]; i++) {
		IRWordList *wl = [libWL objectAtIndex:i];
		if([[wl language] isEqual:[studyPlan.wordList language]])
			[filteredWordLists addObject:wl];
	}
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil studyPlan:(IRStudyPlan *)sp {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		updatedWordLists = [[NSMutableArray alloc] init];
		self.studyPlan = sp;
		[self filterWordList];
    }
    return self;
}

-(void)save {
	int i;
	for(i = 0; i < [updatedWordLists count]; i++) {
		[self.studyPlan.wordList addWords:[[updatedWordLists objectAtIndex:i] words]];
	}
	[self.navigationController popViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Add wordlist";
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add to Study Plan"
																style:UIBarButtonSystemItemSave
															   target:self action:@selector(save)];
	self.navigationItem.leftBarButtonItem = doneBtn;
	[doneBtn release];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [filteredWordLists count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELL_HEIGHT;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *CellIdentifier = [@"Cell" stringByAppendingFormat:@"%d",indexPath.row];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	// Configure the cell...
	IRWordList *wl = [filteredWordLists objectAtIndex:indexPath.row];
	cell.textLabel.text = wl.listName;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[wl words] count]];
	cell.textLabel.font = [UIFont systemFontOfSize:24];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:22];
	cell.indentationLevel = 1;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	IRWordList *wlSelected = [filteredWordLists objectAtIndex:indexPath.row];
	if(cell.accessoryType == UITableViewCellAccessoryCheckmark) {
		cell.accessoryType = UITableViewCellAccessoryNone;
		[updatedWordLists removeObject:wlSelected];
	} else {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[updatedWordLists addObject:wlSelected];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
	[updatedWordLists release];
	[filteredWordLists release];
	[studyPlan release];
    [super dealloc];
}


@end
