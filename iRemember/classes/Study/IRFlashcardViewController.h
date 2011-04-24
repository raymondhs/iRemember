//
//  FlashcardViewController.h
//
//  Created by Raymond Hendy on 3/22/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "IRWord.h"
#import "IRWordList.h"

@interface IRFlashcardViewController : UIViewController {
	IBOutlet UIView *wordView;
	IBOutlet UILabel *wordLabel;
	IBOutlet UITextView *explanationView;
	int pageNumber;
	IRWord *word;
}

@property int pageNumber;
@property (retain) IRWord *word;
@property (retain) IBOutlet UIView *wordView;
@property (retain) IBOutlet UILabel *wordLabel;

- (id)initWithPageNumber:(int)page word:(IRWord *)word;


@end
