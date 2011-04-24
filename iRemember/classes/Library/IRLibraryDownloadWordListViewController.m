//
//  IRLibraryDownloadWordListViewController.m
//  iRemember
//
//  Created by Raymond Hendy on 4/15/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRLibraryDownloadWordListViewController.h"

#define CELL_HEIGHT 80

static BOOL success;

@implementation IRLibraryDownloadWordListViewController

@synthesize client, wordListNames, _tableView;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		client = [[IRClient alloc] init];
		wordListNames = [[NSArray alloc] init];
    }
    return self;
}

-(void)done {
	[client exit];
	NSLog(@"download exit");
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)download {
	success = YES;
	NSInteger numRows = [wordListNames count];
	for(unsigned i = 0; i < numRows; i++) {
		UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		if(cell.accessoryType == UITableViewCellAccessoryCheckmark) {
			[client wordListWithName:[wordListNames objectAtIndex:i]];
		}
	}
	if(success) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download Success"
														message:nil
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	//[self done];
}

-(void)configureNavBar {
	self.navigationController.navigationBar.tintColor = [UIColor brownColor];
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemSave
																target:self action:@selector(done)];
	self.navigationItem.leftBarButtonItem = back;
	UIBarButtonItem *download = [[UIBarButtonItem alloc] initWithTitle:@"Download" style:UIBarButtonSystemItemSave
																		  target:self action:@selector(download)];
	self.navigationItem.rightBarButtonItem = download;
	
	[back release];
	[download release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Download WordLists";
	[self configureNavBar];
	client.delegate = self;
	[client startWithName:@"iRemember"];
	[client wordListNames];
}


-(void)didGetWordList:(IRWordList*)list {
// the wordlist got from the server
	[(IRAppState*)[IRAppState currentState] addWordList:list];
}

-(void)didGetWordListNames:(NSArray *)names {
// the names of available wordLists got from the server
	self.wordListNames = names;
	[_tableView reloadData];
}

-(void)didReceiveError:(IRConnectionError)errorNumber {
// if error is received, the error number is defined in this file
	return;
	success = NO;
	NSString *emsg = errorNumber ? @"No such word list." : @"Invalid command.";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download Failed"
													message:[NSString stringWithFormat:@"Error: %@",emsg]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
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
    return [wordListNames count];
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
	NSString *wordListName = [wordListNames objectAtIndex:indexPath.row];
	cell.textLabel.text = wordListName;
	cell.indentationLevel = 1;	
	cell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:24];

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if(cell.accessoryType == UITableViewCellAccessoryCheckmark) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	} else {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
	[client release];
	[wordListNames release];
    [super dealloc];
}


@end
