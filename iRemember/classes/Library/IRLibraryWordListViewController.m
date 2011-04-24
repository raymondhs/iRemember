    //
//  IRLibraryWordListViewController.m
//  iRemember
//
//  Created by Yingbo Zhan on 4/9/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRLibraryWordListViewController.h"

#define CELL_HEIGHT 80
@implementation IRLibraryWordListViewController

@synthesize language,listOfWordlists,checkLang, client;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (void) selectCount
{
	for (IRWordList *w in listOfWordlists) 
	{
		if([[w language]isEqual:language])
		{
			[checkLang addObject:w];
		}
		
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lang:(NSString*)lang {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		self.language = lang;
		self.listOfWordlists = [[IRAppState currentState] wordLists];
		checkLang = [[NSMutableArray alloc] init];
		[self selectCount];
		client = [[IRClient alloc] init];
    }
    return self;
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
																		 action:@selector(createNewWordList)];
	self.toolbarItems = [NSArray arrayWithObjects:add,nil];
	[add release];
}

- (void)configureNavbar
{
	self.title = @"WordLists";
	self.navigationController.toolbar.tintColor = [UIColor brownColor];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)createNewWordList
{
	
	
	IRLibraryModifyWordListViewController *viewController = [[IRLibraryModifyWordListViewController alloc]initWithNibName:@"IRLibraryModifyWordListView" bundle:nil
																												 language:self.language
																												 delegate:self
																												 wordlist:nil
																												  editing:NO];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
	navController.navigationBar.tintColor = [UIColor brownColor];
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[[self navigationController] presentModalViewController:navController animated:YES];
	[navController release];
	[viewController release];
	
}

-(void)didGetWordList:(IRWordList*)list {
	// the wordlist got from the server
	// do nothing
}

-(void)didGetWordListNames:(NSArray *)names {
	// the names of available wordLists got from the server
	// do nothing
}

-(void)didReceiveError:(IRConnectionError)errorNumber {
	// if error is received, the error number is defined in this file
	NSString *emsg = errorNumber ? @"No such word list." : @"Invalid command.";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download Failed"
													message:[NSString stringWithFormat:@"Error: %@",emsg]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE]] autorelease];
	[self configureToolbar];
	[self configureNavbar];
	[self configureTableView];
	[client startWithName:@"iRemember"];
}

-(void)viewWillDisappear:(BOOL)animated {
	[client exit];
}

-(void)upload:(UIButton *)btn {
	UITableViewCell *cell = (UITableViewCell *)(btn.superview);
	NSString *wlName = cell.textLabel.text;
	IRWordList *wl = [(IRAppState*)[IRAppState currentState] wordListWithName:wlName];
	[client addWordList:wl];
}

- (void)refresh
{		
	[checkLang removeAllObjects];
	[self selectCount];
	[table reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [checkLang count];
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
	IRWordList *wordlist = [checkLang objectAtIndex:indexPath.row];
	cell.textLabel.text = wordlist.listName;
	
	cell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:24];
	cell.indentationLevel = 1;
	
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	btn.frame = CGRectMake(0, 0, 115, 41);
	[btn setTitle:@"Upload" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(upload:) forControlEvents:UIControlEventTouchUpInside];
	cell.accessoryView = btn;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	IRWordList *wordlistSelected = [checkLang objectAtIndex:indexPath.row];
	
	IRLibraryModifyWordListViewController *viewController = [[IRLibraryModifyWordListViewController alloc]initWithNibName:@"IRLibraryModifyWordListView" bundle:nil
																												 language:self.language
																												 delegate:self
																												 wordlist:wordlistSelected
																												  editing:YES];	
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
    [table setEditing: editing animated:animated];
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
		[listOfWordlists removeObject:[checkLang objectAtIndex:indexPath.row]];
		[checkLang removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
	[language release];
	[table release];
	[client release];
	[listOfWordlists release];
	[checkLang release];
	[super dealloc];
}


@end
