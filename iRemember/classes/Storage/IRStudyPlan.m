//
//  StudyPlan.m
//  iRemember
//
//  Created by Aldrian Obaja Muis on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IRStudyPlan.h"
#import "IRHeader.h"

@implementation IRStudyPlan

@synthesize name, wordList, plannedReviewDates, actualReviewDates, elapsedDay, totalDay, reviewAlertTime;
@synthesize numberOfWordsForReview, defaultGameName, studyOrdering, reviewInterval, ebenhauseMode, wordsForStudy;

NSTimeInterval dayToSecond(int days){
	return days*24*60*60;
}

-(id)init{
	return [self initWithName:DEFAULT_STUDYPLAN wordList:[[[IRWordList alloc] init] autorelease]];
}

-(id)initWithName:(NSString*)nam wordList:(IRWordList*)list{
	if([super init]!=nil){
		[self setName:nam];
		[self setWordList:list];
		plannedReviewDates = [[NSMutableArray alloc] init];
		[self setElapsedDay:0];
		[self setTotalDay:DEFAULT_TOTAL_DAYS];
		NSDateComponents* time = [[NSDateComponents alloc] init];
		[time setHour:DEFAULT_HOUR];
		[time setMinute:DEFAULT_MINUTE];
		[self setReviewAlertTime:time];
		[time release];
		
		numberOfWordsForReview = 5;
		[self setDefaultGameName:GAME_MCQ];
		studyOrdering = IRStudyOrderingAlphabetical;
		reviewInterval = 1;
		ebenhauseMode = NO;
		wordsForStudy = [[NSMutableArray alloc] init];
	}
	return self;
}

-(NSString*)language{
	return [wordList language];
}

-(void)setLanguage:(NSString*)lang{
	[[self wordList] setLanguage:lang];
}

-(NSMutableArray*)actualReviewDates{
	NSMutableArray* arr = [[NSMutableArray alloc] init];
	for(IRWordWithStatistics* stat in [wordList wordsWithStatistics]){
		int i=0;
		for(i=0; i<[stat numberOfConductedReview]; i++){
			NSDate* take = [[stat reviewDates] objectAtIndex:i];
			if(![arr containsObject:take]){
				[arr addObject:take];
			}
		}
	}
	return arr;
}

-(IRWord*)addWord:(NSString *)eng translation:(NSString *)trans lang:(NSString *)lang{
	return [wordList addWord:eng translation:trans lang:lang];
}

-(NSArray*)addWordsInList:(NSArray*)list{
	return [wordList addWords:list];
}

-(NSArray*)difficultWords{
	NSMutableArray* result = [[NSMutableArray alloc] init];
	int i=0;
	NSArray* words = [wordList statisticsOverview];
	for(i=0; i<[words count]; i++){
		IRWordWithStatisticsInGame* wordWithStat = [words objectAtIndex:i];
		if([wordWithStat incorrectCount]>[wordWithStat correctCount]+1){
			[result addObject:[wordList wordWithID:[wordWithStat wordID]]];
		}
	}
	return [result autorelease];
}

-(NSArray*)wordsForStudy{
	if([wordsForStudy count]>0){
		BOOL allStudied = YES;
		for(IRWordWithStatistics* stat in [self statisticsOfWords:wordsForStudy]){
			if(![stat isStudied]){
				allStudied = NO;
				break;
			}
		}
		if(!allStudied) return wordsForStudy;
	}
	[wordsForStudy release];
	int wordsPerDay = numberOfWordsForReview;
	NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:wordsPerDay];
	int i=0,j=0;
	NSArray* unstudied = [wordList unstudiedWords];
	int used[[unstudied count]];
	int size = [unstudied count];
	for(i=0; i<[unstudied count]; i++){
		used[i] = i;
	}
	switch(studyOrdering){
		case IRStudyOrderingReversed:
			for(i=[unstudied count]-1; i>=[unstudied count]-wordsPerDay && i>=0; i--){
				[result addObject:[wordList wordWithID:[[unstudied objectAtIndex:i] wordID]]];
			}
			break;
		case IRStudyOrderingRandom:
			for(i=0; i<wordsPerDay && i<[unstudied count]; i++){
				int idx = rand()%size;
				[result addObject:[wordList wordWithID:[[unstudied objectAtIndex:used[idx]] wordID]]];
				for(j=idx; j<size-1; j++){
					used[j]=used[j+1];
				}
				size--;
			}
			break;
		default:
			for(i=0; i<wordsPerDay && i<[unstudied count]; i++){
				[result addObject:[wordList wordWithID:[[unstudied objectAtIndex:i] wordID]]];
			}
			break;
	}
	wordsForStudy = [result retain];
	[self setupReviewDatesWithList:wordsForStudy];
	[result release];
	return wordsForStudy;
}

-(NSArray*)wordsWithReviewDate:(NSDate*)date{
	NSMutableArray* result = [[NSMutableArray alloc] init];
	for(IRWordWithStatistics* stat in [wordList wordsWithStatistics]){
		if([[stat reviewDates] count]>0 && [stat numberOfConductedReview]<[[stat reviewDates] count]){
			if([(NSDate*)[[stat reviewDates] objectAtIndex:[stat numberOfConductedReview]] compare:date]==0){
				[result addObject:stat];
			}
		}
	}
	return [result autorelease];
}

-(NSArray*)wordsWithReviewDateEarlierThan:(NSDate *)date{
	NSMutableArray* result = [[NSMutableArray alloc] init];
	for(IRWordWithStatistics* stat in [wordList wordsWithStatistics]){
		if([[stat reviewDates] count]>0 && [stat numberOfConductedReview]<[[stat reviewDates] count]){
			if([(NSDate*)[[stat reviewDates] objectAtIndex:[stat numberOfConductedReview]] compare:date]<=0){
				[result addObject:stat];
			}
		}
	}
	return [result autorelease];
}


-(NSMutableArray*)statisticsOfWords:(NSArray*)list{
	NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:[list count]];
	for(IRWord* word in list){
		for(IRWordWithStatistics* stat in [wordList wordsWithStatistics]){
			if([stat wordID]==[word wordID]){
				[result addObject:stat];
				break;
			}
		}
	}
	return [result autorelease];
}

-(void)setReviewInterval:(NSInteger)interval{
	reviewInterval = interval;
	NSMutableArray* arr = [[NSMutableArray alloc] init];
	for(IRWordWithStatistics* word in [self statisticsOfWords:[wordList words]]){
		if([[word reviewDates] count]>0){
			[arr addObject:word];
		}
	}
	for(IRWordWithStatistics* stat in [self statisticsOfWords:[self wordsForStudy]]){
		[arr addObject:stat];
	}
	[self setupReviewDatesWithList:[arr autorelease]];
}

-(void)setupReviewDatesWithList:(NSArray*)list{
	int i=0;
	NSArray* theWords = [self statisticsOfWords:list];
	NSDateComponents* base = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
	[base setHour:0];
	[base setMinute:0];
	NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:base];
	NSDateComponents* diff = [[NSDateComponents alloc] init];
	[diff setHour:[reviewAlertTime hour]];
	[diff setMinute:[reviewAlertTime minute]];
	if(!ebenhauseMode){
		//NSLog(@"enter !enben %d list = %d",[theWords count],[list count]);
		for(IRWordWithStatistics* word in theWords){
			int con = [word numberOfConductedReview];
			if([[word reviewDates] count]>0 && [(NSDate*)[[word reviewDates] objectAtIndex:con] compare:date]>=0){
				for(i=0; i<NUMBER_REVIEW-con; i++){
					NSDate* newDate = [[word reviewDates] objectAtIndex:i+con];
					if(![plannedReviewDates containsObject:newDate]) [plannedReviewDates addObject:newDate];
				}
				continue;
			}
			//NSLog(@"haha before iteration %d", NUMBER_REVIEW-con);
			for(i=0; i<NUMBER_REVIEW-con; i++){
				[diff setDay:reviewInterval*i+1];
				NSDate* newDate = [[NSCalendar currentCalendar] dateByAddingComponents:diff toDate:date options:0];
				if(i+con<[[word reviewDates] count]){
					[[word reviewDates] replaceObjectAtIndex:i+con withObject:newDate];
				}else{
					//NSLog(@"alll enter add newDate");
					[[word reviewDates] addObject:newDate];
				}
				if(![plannedReviewDates containsObject:newDate]) [plannedReviewDates addObject:newDate];
			}
		}
	} else {
		for(IRWordWithStatistics* word in theWords){
			int con = [word numberOfConductedReview];
			if([[word reviewDates] count]>0 && [(NSDate*)[[word reviewDates] objectAtIndex:con] compare:date]>=0){
				for(i=0; i<NUMBER_REVIEW-con; i++){
					NSDate* newDate = [[word reviewDates] objectAtIndex:i+con];
					if(![plannedReviewDates containsObject:newDate]) [plannedReviewDates addObject:newDate];
				}
				continue;
			}
			for(i=0; i<NUMBER_REVIEW-con; i++){
				[diff setDay:i*((3*i)/(i+2))-con*((3*con)/(con+2))+1];
				NSDate* newDate = [[NSCalendar currentCalendar] dateByAddingComponents:diff toDate:date options:0];
				if(i+con<[[word reviewDates] count]){
					[[word reviewDates] replaceObjectAtIndex:i+con withObject:newDate];
				}else{
					[[word reviewDates] addObject:newDate];
				}
				if(![plannedReviewDates containsObject:newDate]) [plannedReviewDates addObject:newDate];
			}
		}
	}
	[diff release];
}

-(void)updateStatisticsWithList:(NSArray*)list inGame:(NSString *)gameName{
	[wordList updateStatisticsWithList:list inGame:gameName];
}

-(BOOL)isEqual:(IRStudyPlan*)sp{
	if(self==nil || sp==nil) return NO;
	else
	{
		return [self.name isEqual:sp.name];
	}
}

-(void)encodeWithCoder:(NSCoder*)coder{
	[coder encodeObject:name forKey:@"name"];
	[coder encodeObject:wordList forKey:@"wordList"];
	[plannedReviewDates removeAllObjects];
	[coder encodeObject:plannedReviewDates forKey:@"plannedReviewDates"];
	[coder encodeInteger:elapsedDay forKey:@"elapsedDay"];
	[coder encodeInteger:totalDay forKey:@"totalDay"];
	[reviewAlertTime setHour:DEFAULT_HOUR];
	[reviewAlertTime setMinute:DEFAULT_MINUTE];
	[coder encodeObject:reviewAlertTime forKey:@"reviewAlertTime"];
	[coder encodeInteger:numberOfWordsForReview forKey:@"numberOfWordsForReview"];
	[coder encodeObject:defaultGameName forKey:@"defaultGameName"];
	[coder encodeInteger:studyOrdering forKey:@"studyOrdering"];
	[coder encodeInteger:reviewInterval forKey:@"reviewInterval"];
	[coder encodeBool:ebenhauseMode forKey:@"ebenhauseMode"];
}

-(id)initWithCoder:(NSCoder*)decoder{
	if([super init]!=nil){
		[self setName:[decoder decodeObjectForKey:@"name"]];
		[self setWordList:[decoder decodeObjectForKey:@"wordList"]];
		[self setPlannedReviewDates:[decoder decodeObjectForKey:@"plannedReviewDates"]];
		[self setElapsedDay:[decoder decodeIntegerForKey:@"elapsedDay"]];
		[self setTotalDay:[decoder decodeIntegerForKey:@"totalDay"]];
		[self setReviewAlertTime:[decoder decodeObjectForKey:@"reviewAlertTime"]];
		[self setNumberOfWordsForReview:[decoder decodeIntegerForKey:@"numberOfWordsForReview"]];
		[self setDefaultGameName:[decoder decodeObjectForKey:@"defaultGameName"]];
		[self setStudyOrdering:[decoder decodeIntegerForKey:@"studyOrdering"]];
		[self setReviewInterval:[decoder decodeIntegerForKey:@"reviewInterval"]];
		[self setEbenhauseMode:[decoder decodeBoolForKey:@"ebenhauseMode"]];
	}
	return self;
}

-(void)dealloc{
	[name release];
	[wordList release];
	[plannedReviewDates release];
	[reviewAlertTime release];
	[defaultGameName release];
	[wordsForStudy release];
	[super dealloc];
}

@end
