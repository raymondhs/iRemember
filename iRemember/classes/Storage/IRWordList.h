//
//  IRWordList.h
//  iRemember
//
//  Created by Aldrian Obaja Muis on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRLibrary.h"
#import "IRWordWithStatistics.h"
#import "IRWordWithStatisticsInGame.h"

@interface IRWordList : IRLibrary {

}

@property(nonatomic,retain) NSString* listName;
// The name of this word list

@property(nonatomic,retain) NSMutableArray* wordsWithStatistics;
// The list of words with the statistics

@property(nonatomic,retain) NSMutableDictionary* wordsWithStatisticsInGame;
// The collection of word lists for each game statistics

-(id)init;
// Create a word list with default language as defined in IRHeader.h

-(id)initWithLanguage:(NSString *)lang name:(NSString*)name;
// Create a word list with specified language and name

-(NSArray*)studiedWords;
// EFFECTS: return the words which have been studied

-(NSArray*)unstudiedWords;
// EFFECTS: returns the list of words which have not been studied

-(NSArray*)statisticsInGame:(NSString*)gameName;
// EFFECTS: returns the list of wordWithStatisticsInGame for a specified game
//			returns nil if there is no such game

-(NSArray*)statisticsOverview;
// EFFECTS: returns the list of wordWithStatisticsInGame by combining the statistics
//			from all games(reviews)

-(void)updateStatisticsWithList:(NSArray*)list inGame:(NSString *)gameName;
// MODIFIES: the respective statistics for the game
// EFFECTS: updates the words with statistics in game
//			This method is usually called after a review is finished

@end
