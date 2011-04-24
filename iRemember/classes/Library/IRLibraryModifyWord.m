    //
//  IRLibraryModifyWord.m
//  iRemember
//
//  Created by Yingbo Zhan on 4/9/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IRLibraryModifyWord.h"
#import "IRHeader.h"

#define CELL_HEIGHT 80
#define MAX_WORD_COUNT 500


@implementation IRLibraryModifyWord
@synthesize word,editing,lang,delegate;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id)del word:(IRWord *)wd lang:(NSString*)lange editing:(BOOL)mode{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self) {
		self.delegate = del;
		self.word = wd;
		self.editing = mode;
		self.lang = lange;
	}
	return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)setAudio
{
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
	
	if(err){
        return;
	}
	[audioSession setActive:YES error:&err];
	err = nil;
	if(err){
        return;
	}
	
	NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
	
	[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
	[recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
	
	[recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
	
	// Create a new dated file
	NSString *readFileName = [word soundFileName]; 
	
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentDirectory = [paths objectAtIndex:0];
	NSString* fullPath = [NSString stringWithFormat:@"%@/%@",documentDirectory,readFileName];
	NSURL *url = [NSURL fileURLWithPath:fullPath];	
	
	err = nil;
	if(recorder) [recorder release];
	recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
	if(!recorder){
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: [err localizedDescription]
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
	}
	
	[recordSetting release];
	
	//prepare to record
	[recorder setDelegate:self];
	[recorder prepareToRecord];
	recorder.meteringEnabled = YES;
	
	BOOL audioHWAvailable = audioSession.inputIsAvailable;
	if (!audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: @"Audio input hardware not available"
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release]; 
        return;
	}
}

- (void)playSound
{
	
	if(audioPlayer)
	{
		[audioPlayer stop];
		[audioPlayer release];
	}
	NSString *readFileName = [word soundFileName]; 
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentDirectory = [paths objectAtIndex:0];
	NSString* fullPath = [NSString stringWithFormat:@"%@/%@",documentDirectory,readFileName];
	if(![[NSFileManager defaultManager] fileExistsAtPath:[fullPath stringByExpandingTildeInPath]]){
		NSString* currentDirectory = [[NSBundle mainBundle] bundlePath];
		fullPath = [NSString stringWithFormat:@"%@/default.caf",currentDirectory];
	}
		
	NSURL *url = [NSURL fileURLWithPath:fullPath];	
	
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = 0;	
	
	if (audioPlayer)
		[audioPlayer play];
}

- (void)recordSound
{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Recording Confirmation" message:@"New recording will delete the previous sound"  delegate:self cancelButtonTitle:@"Start" otherButtonTitles:@"Cancel",nil];
	[alert show];
	[alert release];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if([alertView.title isEqual:@"Recording Confirmation"])
	{
		if(buttonIndex == 0)
		{
			[self setAudio];

			[recorder recordForDuration:(NSTimeInterval) 3];
			self.navigationItem.leftBarButtonItem.enabled = NO;
			self.navigationItem.rightBarButtonItem.enabled = NO;
			if(recordingview) [recordingview release];
			recordingview = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
			if(progressbar) [progressbar release];
			progressbar = [[UIBarButtonItem alloc] initWithCustomView:recordingview];
			
			UIBarButtonItem *playItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemPlay target:self action:@selector(playSound)];
		
			UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc]
												  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
												  target:nil action:nil];
																			
			NSMutableArray *items = [[NSMutableArray alloc] init];
			[items addObjectsFromArray:[NSArray arrayWithObjects:playItem,flexibleSpaceItem,progressbar,nil]];
			self.toolbarItems = items;

	
			timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateView) userInfo:nil repeats:YES];
			count = 0;
			
			[items release];
			[playItem release];
			[flexibleSpaceItem release];
		}
		
	}
}

-(void)updateView
// Update the timing view for recording
{
	count++;
	[recordingview setProgress:count/(CGFloat)RECORDING_TIME];
	if(count==RECORDING_TIME)
		[timer invalidate];
}



- (void)setTextField
{
	explanation.font = [UIFont fontWithName:@"Heiti TC" size:18];
	example.font = [UIFont fontWithName:@"Heiti TC" size:18];
	explanation.textColor = [UIColor grayColor];
	example.textColor = [UIColor grayColor];
	example.layer.borderColor = [[UIColor grayColor] CGColor];
	example.layer.borderWidth = 1.0;
	explanation.layer.borderColor = [[UIColor grayColor] CGColor];
	explanation.layer.borderWidth = 1.0;
	
	if(!editing)
	{
		language.text = lang;
		englishword.borderStyle = UITextBorderStyleLine;
		pronunciation.borderStyle = UITextBorderStyleLine;
		translatedword.borderStyle = UITextBorderStyleLine;
	}
	else 
	{
		englishword.text = word.englishWord;
		language.text = word.language;
		englishword.enabled = NO;
		language.enabled = NO;
		translatedword.text = word.translatedWord;
		pronunciation.text = word.pronunciation;
		pronunciation.enabled = NO;
		
		if([word.example length]!=0)
		explanation.text = word.explanation;		
		else
			explanation.text = @"The explanation goes here...";
		if([word.example length]!=0)
			example.text = word.example;
		else {
			example.text = @"The example goes here...";
		}

		
	}
}

- (void)cancel
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
	
}

- (void)saved
{
	if(editing)
	{
		word.englishWord = englishword.text;
		word.language = language.text;
		word.translatedWord = translatedword.text;
		word.pronunciation = pronunciation.text;
		word.example = example.text;
		word.explanation = explanation.text;
	}
	else 
	{
		IRLibrary *library = [[IRAppState currentState] libraryWithLanguage:lang];
		IRWord *newWord = [library addWord:englishword.text translation:translatedword.text lang:lang];
		newWord.explanation = explanation.text;
		newWord.example = example.text;
		newWord.pronunciation = pronunciation.text;
	}
	[delegate refresh];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(void)toolbarConfigure
{	
	self.navigationController.toolbarHidden = NO;
	self.navigationController.toolbar.tintColor = [UIColor brownColor];
	UIBarButtonItem *playItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemPlay target:self action:@selector(playSound)];
	UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc]
										  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
										  target:nil action:nil];
	UIBarButtonItem *recordItem = [[UIBarButtonItem alloc] initWithTitle:@"Record" style:UIBarButtonSystemItemAdd target:self action:@selector(recordSound)];
	
	NSMutableArray *items = [[NSMutableArray alloc] init];
	[items addObjectsFromArray:[NSArray arrayWithObjects:playItem,flexibleSpaceItem,recordItem,nil]];
	self.toolbarItems = items;
	
	[flexibleSpaceItem release];
	[playItem release];
	[recordItem release];
	[items release];
}

- (void)titlebarConfigure
{
	
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
																  style:UIBarButtonSystemItemCancel
																 target:self action:@selector(cancel)];
	
	UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save"
																style:UIBarButtonSystemItemSave
															   target:self action:@selector(saved)];
	
	
	
	self.navigationItem.leftBarButtonItem = cancelBtn;
	self.navigationItem.rightBarButtonItem = saveBtn;
	self.navigationController.toolbar.tintColor = [UIColor brownColor];

	[saveBtn release];
	[cancelBtn release];
	
	
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recder successfully:(BOOL)flag
{
	[recorder stop];
	[self toolbarConfigure];
	[self playSound];
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];//[[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE_FILE]] autorelease];
	[self toolbarConfigure];
	[self titlebarConfigure];
	[self setTextField];
	if(!editing) self.title = @"Add a new word";
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
	[word release];
	[recorder release];
	[lang release];
	[audioPlayer release];
	[language release];
	[example release];
	[explanation release];
	[englishword release];
	[pronunciation release];
	[translatedword release];
	[recordingview release];
	[progressbar release];
    [super dealloc];
}


@end
