    //
//  IRCustomizeWordViewController.m
//  iRemember
//
//  Created by Raymond Hendy on 4/5/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRCustomizeWordViewController.h"

#define CELL_HEIGHT 80
#define MAX_WORD_COUNT 500

@implementation IRCustomizeWordViewController

@synthesize library, studyPlan, updatedWordList, searchedWordList, _tableView;


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	self.searchedWordList = [library wordsWithPrefix:searchText maxSize:MAX_WORD_COUNT];
	[_tableView reloadData];
	if([searchedWordList count] > 0) {
		[_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil studyPlan:(IRStudyPlan *)sp{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.library = [[IRAppState currentState] libraryWithLanguage:[sp language]];
		self.studyPlan = sp;
		updatedWordList = [[NSMutableArray alloc] initWithArray:sp.wordList.words];
		self.searchedWordList = [library wordsWithPrefix:@"" maxSize:MAX_WORD_COUNT];
    }
    return self;
}

-(void)clear {
	[updatedWordList removeAllObjects];
	[_tableView reloadData];
}

-(void)selectAll {
	for(IRWord *w in searchedWordList) {
		if(![updatedWordList containsObject:w])
			[updatedWordList addObject:w];
	}
	[_tableView reloadData];	
}

-(void)done {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)save {
	int i;
	for(i = [studyPlan.wordList.words count]-1; i >= 0; i--) {
		IRWord *w = [studyPlan.wordList.words objectAtIndex:i];
		if(![updatedWordList containsObject:w]) {
			[studyPlan.wordList removeWordWithID:w.wordID];
		}
	}
	
	[studyPlan.wordList addWords:updatedWordList];
	[self done];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Add words";
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back"
																style:UIBarButtonSystemItemSave
															   target:self action:@selector(done)];
	self.navigationItem.leftBarButtonItem = doneBtn;
	UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save"
																style:UIBarButtonSystemItemSave
															   target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveBtn;
	
	UIBarButtonItem *clearBtn = [[UIBarButtonItem alloc] initWithTitle:@"Clear Selection"
																style:UIBarButtonSystemItemSave
															   target:self action:@selector(clear)];
	UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc]
										  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
										  target:nil action:nil];
	UIBarButtonItem *selectAllBtn = [[UIBarButtonItem alloc] initWithTitle:@"Select All"
																style:UIBarButtonSystemItemSave
															   target:self action:@selector(selectAll)];
	self.toolbarItems = [NSArray arrayWithObjects:selectAllBtn,flexibleSpaceItem,clearBtn,nil];
	
	[doneBtn release];
	[saveBtn release];
	[clearBtn release];
	[flexibleSpaceItem release];
	[selectAllBtn release];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return fmin([searchedWordList count],MAX_WORD_COUNT);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELL_HEIGHT;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *CellIdentifier = [@"Cell" stringByAppendingFormat:@"%d",indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	// Configure the cell...
	IRWord *word = [searchedWordList objectAtIndex:indexPath.row];
	cell.textLabel.text = word.englishWord;
	cell.detailTextLabel.text = word.translatedWord;
	cell.textLabel.font = [UIFont systemFontOfSize:24];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:22];
	cell.indentationLevel = 1;
	
	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
	
	cell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:24];
	cell.detailTextLabel.font = [UIFont fontWithName:@"Heiti TC" size:24];
	
	BOOL found = NO;
	for(IRWord *w in updatedWordList) {
		if([w.englishWord isEqual:word.englishWord]) found = YES;
	}
	if(found) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	IRWord *wordSelected = [searchedWordList objectAtIndex:indexPath.row];
	if(cell.accessoryType == UITableViewCellAccessoryCheckmark) {
		cell.accessoryType = UITableViewCellAccessoryNone;
		[updatedWordList removeObject:wordSelected];
	} else {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[updatedWordList addObject:wordSelected];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return  interfaceOrientation == UIInterfaceOrientationLandscapeRight;
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
	[updatedWordList release];
	[studyPlan release];
	[library release];
    [super dealloc];
}


@end
