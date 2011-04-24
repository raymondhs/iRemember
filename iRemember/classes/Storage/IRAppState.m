//
//  AppState.m
//  iRemember
//
//  Created by Aldrian Obaja Muis on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IRAppState.h"
#import "IRHeader.h"

static IRAppState* currentState;

@implementation IRAppState

@synthesize libraries, currentStudyPlan, wordLists, studyPlanList;

+(id)currentState{
	if(currentState==nil) currentState = [[IRAppState alloc] init];
	return currentState;
}

-(id)init{
	if([super init]!=nil){
		libraries = [[NSMutableArray alloc] init];
		currentStudyPlan = [[IRStudyPlan alloc] init];
		wordLists = [[NSMutableArray alloc] init];
		studyPlanList = [[NSMutableArray alloc] init];
//		IRStudyPlan* defaultStudyPlan = [[IRStudyPlan alloc] init];
		[studyPlanList addObject:currentStudyPlan];		
//		[defaultStudyPlan release];
	}
	return self;
}

-(void)save{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentDirectory = [paths objectAtIndex:0];
	NSString* fullPath = [NSString stringWithFormat:@"%@/%@",documentDirectory,@"appstate.plist"];
	NSLog(@"%@",fullPath);
	NSMutableData* data = [[NSMutableData alloc] init];
	NSKeyedArchiver* arc = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[arc encodeObject:libraries forKey:@"libraries"];
	[arc encodeObject:currentStudyPlan forKey:@"currentStudyPlan"];
	[arc encodeObject:wordLists forKey:@"wordLists"];
	[arc encodeObject:studyPlanList forKey:@"studyPlanList"];
	
	[arc finishEncoding];
	BOOL success = [data writeToFile:fullPath atomically:YES];
	[arc release];
	[data release];
	if(!success) NSLog(@"Unsuccessful!");
}

-(void)loadState{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentDirectory = [paths objectAtIndex:0];
	NSString* fullPath = [NSString stringWithFormat:@"%@/%@",documentDirectory,@"appstate.plist"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:[fullPath stringByExpandingTildeInPath]]){
		NSString* currentDirectory = [[NSBundle mainBundle] bundlePath];
		fullPath = [NSString stringWithFormat:@"%@/appstate.plist",currentDirectory];
		//NSLog(@"default");
	}
	
	NSMutableData* data = [NSData dataWithContentsOfFile:fullPath];
	NSKeyedUnarchiver* unarc = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	NSMutableArray* loadedLibraries = [unarc decodeObjectForKey:@"libraries"];
	IRStudyPlan* loadedStudyPlan = [unarc decodeObjectForKey:@"currentStudyPlan"];
	NSMutableArray* loadedWordLists = [unarc decodeObjectForKey:@"wordLists"];
	NSMutableArray* loadedStudyPlanList = [unarc decodeObjectForKey:@"studyPlanList"];
	[unarc finishDecoding];
	
	[self setLibraries:loadedLibraries];	
	[self setStudyPlanList:loadedStudyPlanList];
	[self setCurrentStudyPlan:loadedStudyPlan];
	[self setWordLists:loadedWordLists];
	[unarc release];
}

-(IRLibrary*)libraryWithLanguage:(NSString *)lang{
	int i=0;
	for(i=0; i<[libraries count]; i++){
		if([[[libraries objectAtIndex:i] language] isEqual:lang]){
			return [libraries objectAtIndex:i];
		}
	}
	return nil;
}

-(void)addLibrary:(IRLibrary *)library{
	if([self libraryWithLanguage:[library language]]!=nil) return;
	[libraries addObject:library];
}

-(void)mergeLibrary:(IRLibrary *)library{
	int i=0;
	IRLibrary* curLib;
	for(i=0; i<[libraries count]; i++){
		curLib = [libraries	objectAtIndex:i];
		if([[curLib language] isEqual:[library language]]) break;
	}
	[curLib addWords:[library words]];
}

-(void)removeLibrary:(NSString *)lang{
	IRLibrary* libraryWithLanguage = [self libraryWithLanguage:lang];
	if(libraryWithLanguage==nil) return;
	[libraries removeObject:libraryWithLanguage];
}

-(IRWordList*)wordListWithName:(NSString *)name{
	NSInteger wlIdx = [wordLists indexOfObject:[[[IRWordList alloc] initWithLanguage:@"" name:name] autorelease]];
	return [wordLists objectAtIndex:wlIdx];
}

-(BOOL)addWordList:(IRWordList *)wordList{
	if([wordLists containsObject:wordList]) return NO;
	[wordLists addObject:wordList];
	return YES;
}

-(void)removeWordList:(NSString *)name{
	[wordLists removeObject:[[[IRWordList alloc] initWithLanguage:@"" name:name] autorelease]];
	
}

-(BOOL)addStudyPlan:(IRStudyPlan *)studyPlan{
	if([studyPlanList containsObject:studyPlan]) { return NO; }
	[studyPlanList addObject:studyPlan];
	return YES;
}

-(IRStudyPlan*)studyPlanWithName:(NSString *)planName{
	NSInteger spIdx = [studyPlanList indexOfObject:[[[IRStudyPlan alloc] initWithName:planName wordList:nil] autorelease]];
	if(spIdx == NSNotFound) return nil;
	return [studyPlanList objectAtIndex:spIdx];
}

-(BOOL)removeStudyPlanWithName:(NSString *)planName{
	IRStudyPlan *target = [[IRStudyPlan alloc] initWithName:planName wordList:nil];
	if(![studyPlanList containsObject:target]) return NO;
	[studyPlanList removeObject:target];
	[target release];
	return YES;
}

-(void)removeStudyPlanAtIndex:(NSInteger)index {
	[studyPlanList removeObjectAtIndex:index];
}

-(void)setWordsForGameWithMode:(IRGameStartMode)mode{
	switch(mode){
		case IRGameStartAll:
			wordsForGame = [[[currentStudyPlan wordList] words] retain];
			break;
		case IRGameStartStudied:
			wordsForGame = [[[currentStudyPlan wordList] studiedWords] retain];
			break;
		case IRGameStartDifficult:
			wordsForGame = [[currentStudyPlan difficultWords] retain];
			break;
		case IRGameStartNext:
			wordsForGame = [[currentStudyPlan wordsForStudy] retain];
			break;
	}			
	return;
}

-(NSArray*)wordsForGame{
	return [wordsForGame autorelease];
}

-(void)updateStatisticsWithList:(NSArray*)list inGame:(NSString *)gameName{
	[currentStudyPlan updateStatisticsWithList:list inGame:gameName];
}

-(void)encodeWithCoder:(NSCoder*)coder{
	[coder encodeObject:libraries forKey:@"libraries"];
	[coder encodeObject:currentStudyPlan forKey:@"currentStudyPlan"];
}

-(id)initWithCoder:(NSCoder*)decoder{
	if([super init]!=nil){
		[self setLibraries:[decoder decodeObjectForKey:@"libraries"]];
		[self setCurrentStudyPlan:[decoder decodeObjectForKey:@"currentStudyPlan"]];
	}
	return self;
}
	
-(void)dealloc{
	if(wordsForGame!=nil) [wordsForGame release];
	[libraries release];
	[wordLists release];
	[currentStudyPlan release];
	[studyPlanList release];
	[super dealloc];
}

@end
