    //
//  IRLibraryModifyWordListAddWordViewController.m
//  iRemember
//
//  Created by Yingbo Zhan on 4/10/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRLibraryModifyWordListAddWordViewController.h"

#define CELL_HEIGHT 80
#define MAX_WORD_COUNT 500

@implementation IRLibraryModifyWordListAddWordViewController

@synthesize searchedWordList,updatedWordList,wordlist,language,library,editingMode,del;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil wordlist:(IRWordList*)wrl language:(NSString*)lang editingMode:(BOOL)mode delegate:(id)dele{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.wordlist = wrl;
		self.library = [[IRAppState currentState] libraryWithLanguage:lang];
		self.searchedWordList = [library wordsWithPrefix:@"" maxSize:MAX_WORD_COUNT];
		self.editingMode = mode;
		self.language = lang;
		self.del = dele;
		updatedWordList = [[NSMutableArray alloc] initWithArray:[wordlist words]];	
    }
    return self;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	self.searchedWordList = [library wordsWithPrefix:searchText maxSize:MAX_WORD_COUNT];
	[table reloadData];
	if([searchedWordList count] > 0) {
		[table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
}

- (void)saved
{
	
	[[wordlist words]removeAllObjects];
	[wordlist addWords:updatedWordList];
	[del refresh];
	[self.navigationController popViewControllerAnimated:YES];

}


- (void)configureToolbar
{
	self.navigationController.toolbarHidden = NO;
	self.navigationController.toolbar.tintColor = [UIColor brownColor];
}

- (void)configureNavbar
{
	self.title = @"Edit WordList";
	self.navigationController.toolbar.tintColor = [UIColor brownColor];
	UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save"
																style:UIBarButtonSystemItemSave
															   target:self action:@selector(saved)];
	self.navigationItem.rightBarButtonItem = saveBtn;
	[saveBtn release];
	
}




- (void)viewDidLoad {
    [super viewDidLoad];
	[self configureNavbar];
	[self configureToolbar];
}


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
	cell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:24];
	cell.detailTextLabel.font = [UIFont fontWithName:@"Heiti TC" size:22];
	cell.indentationLevel = 1;
	
	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
	
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
	return interfaceOrientation == UIInterfaceOrientationLandscapeRight;}


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
	[table release];
	[wordlist release];
	[library release];
	[language release];
	[searchedWordList release];
	[updatedWordList release];
    [super dealloc];
}


@end
