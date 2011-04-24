    //
//  IRLibraryModifyWordListViewController.m
//  iRemember
//
//  Created by Yingbo Zhan on 4/10/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRLibraryModifyWordListViewController.h"

#define CELL_HEIGHT 80

@implementation IRLibraryModifyWordListViewController

@synthesize wordlist,dele,lang,editingMode,words;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil language:(NSString*)language delegate:(id)del wordlist:(IRWordList*)wdl editing:(BOOL)mode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{
		self.editingMode = mode;
		self.lang = language;
		self.dele = del;
		
		if(editingMode)
		{
			self.wordlist = wdl;
			
		}
		else {
			wordlist = [[IRWordList alloc] initWithLanguage:language];
		}
		
		self.words = [wordlist words];

    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)addNewWord
{
	
	IRLibraryModifyWordListAddWordViewController *wordController = [[IRLibraryModifyWordListAddWordViewController alloc] initWithNibName:@"IRLibraryModifyWordListAddWord" bundle:nil wordlist:wordlist language:self.lang editingMode:NO delegate:self];

	[self.navigationController pushViewController:wordController animated:YES];
	[wordController release];
}

- (void)configureToolbar
{
	self.navigationController.toolbarHidden = NO;
	self.navigationController.toolbar.tintColor = [UIColor brownColor];
	UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																		 target:self
																		 action:@selector(addNewWord)];
	self.toolbarItems = [NSArray arrayWithObjects:add,nil];
	[add release];
	
}

- (void)cancel
{
	BOOL done = NO;
	if([wordlistname.text length]==0&&[[wordlist words]count]!=0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save"
														message:@"Enter name for wordList."
													   delegate:self
											  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
		return;
	}		
	
	else if([[wordlist words]count]==0&&[wordlistname.text length]!=0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save"
														message:@"Enter name for wordList or add at least 1 word."
													   delegate:self
											  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
		return;
	}
	else if([[wordlist words]count]==0&&[wordlistname.text length]==0)
	{
		done = YES;
	}
	[wordlist setListName:wordlistname.text];
	
	if(!editingMode&&!done)
	{
		if([[IRAppState currentState]addWordList:wordlist]){
			
		} else {
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can not add This WordList"
															message:@"The word list exists already.Change to another name please."
														   delegate:self
												  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
			[alert show];
			[alert release];
			return;	
		}
	}
	[dele refresh];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)refresh
{
	[table reloadData];
}

- (void)configureNavbar
{
	self.title = @"WordList";
	self.navigationController.toolbar.tintColor = [UIColor brownColor];
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done"
																  style:UIBarButtonSystemItemCancel
																 target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelBtn;
	[cancelBtn release];

}

- (void)configureOthers
{
	if(editingMode)
		wordlistname.text = [wordlist listName];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[self configureToolbar];
	[self configureNavbar];
	[self configureOthers];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	//NSLog(@"table %d",[words count]);
    return [words count];
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
	IRWord *word = [words objectAtIndex:indexPath.row];
	cell.textLabel.text = word.englishWord;
	cell.detailTextLabel.text = word.translatedWord;
	cell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:24];
	cell.detailTextLabel.font = [UIFont fontWithName:@"Heiti TC" size:22];
	cell.indentationLevel = 1;
	
	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
	
	    return cell;
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
	[table release];
	[wordlistname release];
	[lang release];
	[words release];
	[wordlist release];
    [super dealloc];
}


@end
