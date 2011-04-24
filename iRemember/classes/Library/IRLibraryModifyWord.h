//
//  IRLibraryModifyWord.h
//  iRemember
//
//  Created by Yingbo Zhan on 4/9/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IRWord.h"
#import "IRAppState.h"
#import "IRLibrary.h"
#import <AVFoundation/AVFoundation.h>

@protocol IRLibraryModifyWordDelegate<NSObject>

-(void)refresh;

@end


@interface IRLibraryModifyWord : UIViewController <AVAudioRecorderDelegate>{
	IRWord *word;
	NSString *lang;
	AVAudioPlayer *audioPlayer;
	AVAudioRecorder *recorder;
	IBOutlet UITextField *language;
	IBOutlet UITextView *example;
	IBOutlet UITextView *explanation;
	IBOutlet UITextField *englishword;
	IBOutlet UITextField *pronunciation;
	IBOutlet UITextField *translatedword;
	
	UIProgressView *recordingview;
	UIBarButtonItem *progressbar;
	BOOL editing;
	NSTimer *timer;
	int count;
	
	id<IRLibraryModifyWordDelegate> delegate;
}

@property (retain) IRWord *word;
@property BOOL editing;
@property (retain) NSString *lang;
@property (assign) id delegate;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id)del word:(IRWord *)wd lang:(NSString*)lange editing:(BOOL)mode;


@end
