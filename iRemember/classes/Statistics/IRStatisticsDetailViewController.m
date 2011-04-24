    //
//  IRStatisticsDetailViewController.m
//  iRemember
//
//  Created by Zhang Ying on 4/9/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import "IRStatisticsDetailViewController.h"
#define IMAGEVIEW_TAG 100

@interface IRStatisticsDetailViewController ()
- (void)configureView;
@end

@implementation IRStatisticsDetailViewController

@synthesize statisticsImageView;
@synthesize detailItem;

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem {
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }
}

// programmatically create all the views for statistics part
- (void)configureView {
	// clear the previous view selection
	if ([self.view viewWithTag:IMAGEVIEW_TAG] != nil){
		[[self.view viewWithTag:IMAGEVIEW_TAG] removeFromSuperview];
	}
	
	// compute the new statistics diagram
	// the diagram's x axis is each word's correction rate = correct count/(correct count+incorrect count)
	// the y axis is to show the number of words
	UIImageView *tempImageView = [[UIImageView alloc] init];
	if ([detailItem isKindOfClass:[IRStudyPlan class]]){
		IRStudyPlan *sP = (IRStudyPlan*) detailItem;
		NSArray *stList = [[sP wordList] statisticsOverview];
		// x- axix : the rate, 0, 20, 40, 60, 80, 100%
		NSInteger zeroToTwenty = 0;
		NSInteger twentyToForty = 0;
		NSInteger fortyToSixty = 0;
		NSInteger sixtyToEighty = 0;
		NSInteger eightyToHundred = 0;
		for (IRWordWithStatisticsInGame *wordWSt in stList){
			CGFloat ratio = wordWSt.correctCount * 1.0 / [wordWSt usedCount];
			if (ratio <= 0.2){
				zeroToTwenty++;
			}else if (ratio <= 0.4){
				twentyToForty++;
			}else if (ratio <= 0.6){
				fortyToSixty++;
			}else if (ratio <= 0.8){
				sixtyToEighty++;
			}else if (ratio <= 1.0){
				eightyToHundred++;
			}else {
			}
		}	
		NSInteger totalNumberOfWords = [stList count];
		if(totalNumberOfWords==0) totalNumberOfWords=1;
		UIViewWithLine *line1 = [[UIViewWithLine alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000) 
															  Point1X:STATISTICS_BAR_OFFSET_X 
															  Point1Y:STATISTICS_BAR_OFFSET_Y-STATISTICS_BAR_HEIGHT*zeroToTwenty/totalNumberOfWords
															  Point2X:STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+STATISTICS_BAR_WIDTH
															  Point2Y:STATISTICS_BAR_OFFSET_Y-STATISTICS_BAR_HEIGHT*twentyToForty/totalNumberOfWords];
		[tempImageView addSubview:line1];
		[line1 release];
		
		UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(STATISTICS_BAR_OFFSET_X, STATISTICS_BAR_OFFSET_Y,
																  150, 30)];
		lab1.text = @"  20"; 
		lab1.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
		[tempImageView addSubview:lab1];
		[lab1 release];
		
		UIViewWithLine *line2 = [[UIViewWithLine alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000) 
															  Point1X:STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+STATISTICS_BAR_WIDTH 
															  Point1Y:STATISTICS_BAR_OFFSET_Y-STATISTICS_BAR_HEIGHT*twentyToForty/totalNumberOfWords
															  Point2X:2*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+2*STATISTICS_BAR_WIDTH
															  Point2Y:STATISTICS_BAR_OFFSET_Y-STATISTICS_BAR_HEIGHT*fortyToSixty/totalNumberOfWords];
		[tempImageView addSubview:line2];
		[line2 release];
		
		UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+STATISTICS_BAR_WIDTH, STATISTICS_BAR_OFFSET_Y,
																  150, 30)];
		lab2.text = @"  40"; 
		lab2.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
		[tempImageView addSubview:lab2];
		[lab2 release];
		
		UIViewWithLine *line3 = [[UIViewWithLine alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000) 
															  Point1X:2*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+2*STATISTICS_BAR_WIDTH 
															  Point1Y:STATISTICS_BAR_OFFSET_Y-STATISTICS_BAR_HEIGHT*fortyToSixty/totalNumberOfWords
															  Point2X:3*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+3*STATISTICS_BAR_WIDTH
															  Point2Y:STATISTICS_BAR_OFFSET_Y-STATISTICS_BAR_HEIGHT*sixtyToEighty/totalNumberOfWords];
		[tempImageView addSubview:line3];
		[line3 release];
		
		UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(2*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+2*STATISTICS_BAR_WIDTH, STATISTICS_BAR_OFFSET_Y,
																  150, 30)];
		lab3.text = @"  60"; 
		lab3.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
		[tempImageView addSubview:lab3];
		[lab3 release];
		
		UIViewWithLine *line4 = [[UIViewWithLine alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000) 
															  Point1X:3*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+3*STATISTICS_BAR_WIDTH 
															  Point1Y:STATISTICS_BAR_OFFSET_Y-STATISTICS_BAR_HEIGHT*sixtyToEighty/totalNumberOfWords
															  Point2X:4*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+4*STATISTICS_BAR_WIDTH
															  Point2Y:STATISTICS_BAR_OFFSET_Y-STATISTICS_BAR_HEIGHT*eightyToHundred/totalNumberOfWords];
		[tempImageView addSubview:line4];
		[line4 release];
		
		UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(3*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+3*STATISTICS_BAR_WIDTH, STATISTICS_BAR_OFFSET_Y,
																  150, 30)];
		lab4.text = @"  80"; 
		lab4.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
		[tempImageView addSubview:lab4];
		[lab4 release];
				
		UILabel *lab5 = [[UILabel alloc] initWithFrame:CGRectMake(4*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+4*STATISTICS_BAR_WIDTH, STATISTICS_BAR_OFFSET_Y,
																  150, 30)];
		lab5.text = @"  100"; 
		lab5.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
		[tempImageView addSubview:lab5];
		[lab5 release];
	}else if ([detailItem isKindOfClass:[NSArray class]]){
		NSArray *stList = (NSArray*) detailItem;
		// x- axix : the rate, 0, 20, 40, 60, 80, 100%
		NSInteger zeroToTwenty = 0;
		NSInteger twentyToForty = 0;
		NSInteger fortyToSixty = 0;
		NSInteger sixtyToEighty = 0;
		NSInteger eightyToHundred = 0;
		for (IRWordWithStatisticsInGame *wordWSt in stList){
			CGFloat ratio = wordWSt.correctCount * 1.0 / [wordWSt usedCount];
			if (ratio <= 0.2){
				zeroToTwenty++;
			}else if (ratio <= 0.4){
				twentyToForty++;
			}else if (ratio <= 0.6){
				fortyToSixty++;
			}else if (ratio <= 0.8){
				sixtyToEighty++;
			}else if (ratio <= 1.0){
				eightyToHundred++;
			}else {
			}
		}
		NSInteger totalNumberOfWords = [stList count];
		if(totalNumberOfWords==0) totalNumberOfWords=1;
		UILabel *bar1 = [[UILabel alloc] initWithFrame:CGRectMake(STATISTICS_BAR_OFFSET_X, 
																STATISTICS_BAR_OFFSET_Y-STATISTICS_BAR_HEIGHT*zeroToTwenty/totalNumberOfWords,  
																STATISTICS_BAR_WIDTH, STATISTICS_BAR_HEIGHT*zeroToTwenty/totalNumberOfWords)];
		bar1.backgroundColor = [UIColor orangeColor];
		bar1.text = [NSString stringWithFormat:@"%d",zeroToTwenty];
		bar1.textAlignment = UITextAlignmentCenter;
		[tempImageView addSubview:bar1];
		[bar1 release];
		
		UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(STATISTICS_BAR_OFFSET_X, STATISTICS_BAR_OFFSET_Y,
																  150, 30)];
		lab1.text = @" 0 - 20"; 
		lab1.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
		[tempImageView addSubview:lab1];
		[lab1 release];
		 
		UILabel *bar2 = [[UILabel alloc] initWithFrame:CGRectMake(STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+STATISTICS_BAR_WIDTH, 
																STATISTICS_BAR_OFFSET_Y-STATISTICS_BAR_HEIGHT*twentyToForty/totalNumberOfWords,  
																STATISTICS_BAR_WIDTH, STATISTICS_BAR_HEIGHT*twentyToForty/totalNumberOfWords)];
		bar2.backgroundColor = [UIColor orangeColor];
		bar2.text = [NSString stringWithFormat:@"%d",twentyToForty];
		bar2.textAlignment = UITextAlignmentCenter;
		[tempImageView addSubview:bar2];
		[bar2 release];
		
		UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+STATISTICS_BAR_WIDTH, STATISTICS_BAR_OFFSET_Y,
																  150, 30)];
		lab2.text = @" 20 - 40"; 
		lab2.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
		[tempImageView addSubview:lab2];
		[lab2 release];
		
		UILabel *bar3 = [[UILabel alloc] initWithFrame:CGRectMake(2*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+2*STATISTICS_BAR_WIDTH, 
																STATISTICS_BAR_OFFSET_Y-STATISTICS_BAR_HEIGHT*fortyToSixty/totalNumberOfWords, 
																STATISTICS_BAR_WIDTH, STATISTICS_BAR_HEIGHT*fortyToSixty/totalNumberOfWords)];
		bar3.backgroundColor = [UIColor orangeColor];
		bar3.text = [NSString stringWithFormat:@"%d",fortyToSixty];
		bar3.textAlignment = UITextAlignmentCenter;
		[tempImageView addSubview:bar3];
		[bar3 release];
		
		UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(2*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+2*STATISTICS_BAR_WIDTH, STATISTICS_BAR_OFFSET_Y,
																  150, 30)];
		lab3.text = @" 40 - 60"; 
		lab3.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
		[tempImageView addSubview:lab3];
		[lab3 release];
		
		UILabel *bar4 = [[UILabel alloc] initWithFrame:CGRectMake(3*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+3*STATISTICS_BAR_WIDTH, 
																STATISTICS_BAR_OFFSET_Y-STATISTICS_BAR_HEIGHT*sixtyToEighty/totalNumberOfWords, 
																STATISTICS_BAR_WIDTH, STATISTICS_BAR_HEIGHT*sixtyToEighty/totalNumberOfWords)];
		bar4.backgroundColor = [UIColor orangeColor];
		bar4.text = [NSString stringWithFormat:@"%d",sixtyToEighty];
		bar4.textAlignment = UITextAlignmentCenter;
		[tempImageView addSubview:bar4];
		[bar4 release];
		
		UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(3*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+3*STATISTICS_BAR_WIDTH, STATISTICS_BAR_OFFSET_Y,
																  150, 30)];
		lab4.text = @" 60 - 80"; 
		lab4.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
		[tempImageView addSubview:lab4];
		[lab4 release];
		
		UILabel *bar5 = [[UILabel alloc] initWithFrame:CGRectMake(4*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+4*STATISTICS_BAR_WIDTH,
																STATISTICS_BAR_OFFSET_Y-STATISTICS_BAR_HEIGHT*eightyToHundred/totalNumberOfWords,
																STATISTICS_BAR_WIDTH, STATISTICS_BAR_HEIGHT*eightyToHundred/totalNumberOfWords)];
		bar5.backgroundColor = [UIColor orangeColor];
		bar5.text = [NSString stringWithFormat:@"%d",eightyToHundred];
		bar5.textAlignment = UITextAlignmentCenter;
		[tempImageView addSubview:bar5];
		[bar5 release];
		
		UILabel *lab5 = [[UILabel alloc] initWithFrame:CGRectMake(4*STATISTICS_BARS_INTERVAL+STATISTICS_BAR_OFFSET_X+4*STATISTICS_BAR_WIDTH, STATISTICS_BAR_OFFSET_Y,
																  150, 30)];
		lab5.text = @" 80 - 100"; 
		lab5.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
		[tempImageView addSubview:lab5];
		[lab5 release];
	}else {
		
	}
	
	UILabel *xAxis = [[UILabel alloc] initWithFrame:CGRectMake(STATISTICS_BAR_OFFSET_X- STATISTICS_BARS_INTERVAL,
															   STATISTICS_BAR_OFFSET_Y, STATISTICS_XAXIS_LENGTH, STATISTICS_AXIS_WIDTH)];
	xAxis.backgroundColor = [UIColor blackColor];
	[tempImageView addSubview:xAxis];
	[xAxis release];
	
	UILabel *yAxis = [[UILabel alloc] initWithFrame:CGRectMake(STATISTICS_BAR_OFFSET_X- STATISTICS_BARS_INTERVAL, 
															   STATISTICS_BAR_OFFSET_Y-STATISTICS_YXIS_HEIGHT,
															   STATISTICS_AXIS_WIDTH, STATISTICS_YXIS_HEIGHT)];
	yAxis.backgroundColor = [UIColor blackColor];
	[tempImageView addSubview:yAxis];
	[yAxis release];
	
	UILabel *xIndic = [[UILabel alloc] initWithFrame:CGRectMake(STATISTICS_BAR_OFFSET_X+STATISTICS_XAXIS_LENGTH-5*STATISTICS_BARS_INTERVAL,
																STATISTICS_BAR_OFFSET_Y+STATISTICS_BARS_INTERVAL, 150, 30)];
	xIndic.lineBreakMode = UILineBreakModeWordWrap;
	xIndic.text = @"x%: Correct/All";
	xIndic.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
	[tempImageView addSubview:xIndic];
	[xIndic release];
	
	UILabel *yIndic = [[UILabel alloc] initWithFrame:CGRectMake(STATISTICS_BAR_OFFSET_X-3*STATISTICS_BARS_INTERVAL, 
																STATISTICS_BAR_OFFSET_Y-STATISTICS_YXIS_HEIGHT-STATISTICS_BARS_INTERVAL,
																150, 30)];
	yIndic.lineBreakMode = UILineBreakModeWordWrap;
	yIndic.text = @"y: # of Words";
	yIndic.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
	[tempImageView addSubview:yIndic];
	[yIndic release];
	
	[tempImageView setTag:IMAGEVIEW_TAG];
	[statisticsImageView addSubview:tempImageView];
	[tempImageView release];
}

#pragma mark -
#pragma mark View Support

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithRed:0.898 green:0.824 blue:0.686 alpha:1];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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
	[statisticsImageView release];
	[detailItem release];
    [super dealloc];
}


@end
