    //
//  IRLibraryWordViewController.m
//  iRemember
//
//  Created by Yingbo Zhan on 4/9/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRLibraryWordViewController.h"

#define CELL_HEIGHT 80
#define MAX_WORD_COUNT 500

@implementation IRLibraryWordViewController

@synthesize searchedWordList,language,library;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil  language:(NSString*)lang bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.language = lang;
        self.library = [[IRAppState currentState] libraryWithLanguage:language];
		searchedWordList = [[library wordsWithPrefix:@"" maxSize:MAX_WORD_COUNT] mutableCopy];
		
    }
    return self;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if(searchedWordList) [searchedWordList release];
	searchedWordList = [[library wordsWithPrefix:searchText maxSize:MAX_WORD_COUNT] mutableCopy];
	[table reloadData];
	if([searchedWordList count] > 0) {
		[table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)configureToolbar
{
	UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																		 target:self
																		 action:@selector(createNewWord)];
	self.toolbarItems = [NSArray arrayWithObjects:add,nil];
	[add release];
}

- (void)configureNavbar
{
	self.title = @"Word";
	self.navigationController.toolbar.tintColor = [UIColor brownColor];
}

-(void)configureTableView {
	UIView *tableBgView = [[UIView alloc] init];
	tableBgView.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
	table.layer.borderColor = [[UIColor colorWithRed:0.65 green:0.35 blue:0 alpha:1] CGColor];
	table.layer.borderWidth = 5;
	table.backgroundView = tableBgView;
	table.separatorColor = [UIColor colorWithRed:1 green:0.51 blue:0.14 alpha:0.6];
	[tableBgView release];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE]] autorelease];
	[self configureToolbar];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	[self configureNavbar];
	[self configureTableView];
}


- (void)cancel
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


- (void)createNewWord
{
	IRLibraryModifyWord *wordModifyController =
	[[IRLibraryModifyWord alloc] initWithNibName:@"IRModifyWord"
										  bundle:nil 
										delegate:self
											word:nil
											lang:self.language
										 editing:NO];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:wordModifyController];
	navController.navigationBar.tintColor = [UIColor brownColor];
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	[[self navigationController] presentModalViewController:navController animated:YES];
	
	[navController release];
	[wordModifyController release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [searchedWordList count];
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
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	IRWord *wordSelected = [searchedWordList objectAtIndex:indexPath.row];
	
	IRLibraryModifyWord *viewController = [[IRLibraryModifyWord alloc]initWithNibName:@"IRModifyWord" bundle:nil 
																			 delegate:self
																				 word:wordSelected lang:language editing:YES];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
	navController.navigationBar.tintColor = [UIColor brownColor];
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[[self navigationController] presentModalViewController:navController animated:YES];
	[navController release];
	[viewController release];
	
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: animated];
    [table setEditing:editing animated:animated];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Determine if it's in editing mode
    if (table.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source.
		IRWord *removeWord = [searchedWordList objectAtIndex:indexPath.row];
		[library removeWordWithString:removeWord.englishWord];
		[searchedWordList removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}


- (void)refresh
{
	[table reloadData];
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
    [super dealloc];
	[library release];
	[searchedWordList release];
	[language release];
}


@end


