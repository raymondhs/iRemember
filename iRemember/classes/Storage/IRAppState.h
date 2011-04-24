//
//  AppState.h
//  iRemember
//
//  Created by Aldrian Obaja Muis on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRWordList.h"
#import "IRStudyPlan.h"
#import "IRHeader.h"

@interface IRAppState : NSObject {
	NSArray* wordsForGame;
}

@property(nonatomic,retain) NSMutableArray* libraries;
// The list of libraries of different languages

@property(nonatomic,retain) IRStudyPlan* currentStudyPlan;
// Current study plan that is being used

@property(nonatomic,retain) NSMutableArray* wordLists;
// The list of word lists, using the listName as the key for the IRWordList object

@property(nonatomic,retain) NSMutableArray* studyPlanList;

+(id)currentState;
// EFFECTS: return the current state of the app

-(void)save;
// EFFECTS: save current state to Documents folder

-(void)loadState;
// EFFECTS: load a state from a file in this order, whichever is available first:
//			-The file in the user Document folder (mutable, user-configured)
//			-The file in the resource (immutable)

-(IRLibrary*)libraryWithLanguage:(NSString*)lang;
// EFFECTS: return the library with the specified language, nil if it doesn't exist

-(void)addLibrary:(IRLibrary*)library;
// REQUIRES: there is no library with the same language
// EFFECTS: add the library to current list of libraries

-(void)mergeLibrary:(IRLibrary*)library;
// REQUIRES: there is a library with the same language
// EFFECTS: merge this library with a library in the list of libraries which has
//			the same language

-(void)removeLibrary:(NSString*)lang;
// REQUIRES: the library with the specified language exists
// MODIFIES: self
// EFFECTS : removes the library with the specified language

-(IRWordList*)wordListWithName:(NSString*)name;
// EFFECTS: returns the wordList with the specified name, nil if it doesn't exist

-(BOOL)addWordList:(IRWordList*)wordList;
// REQUIRES: there is no wordList with the same name
// MODIFIES: self
// EFFECTS : add the specified wordlist into current list of wordList

-(void)removeWordList:(NSString*)name;
// REQUIRES: there is a wordList with the specified name
// MODIFIES: self
// EFFECTS : remove the wordlist with the specified name

-(BOOL)addStudyPlan:(IRStudyPlan*)studyPlan;
// EFFECTS: adds the specified studyplan into the list of study plan
//			returns YES if previously there is no study plan with the same name
//			returns NO otherwise

-(IRStudyPlan*)studyPlanWithName:(NSString*)planName;
// EFFECTS: returns the study plan with the specified name
//			returns nil if there is no study plan with such name

-(BOOL)removeStudyPlanWithName:(NSString*)planName;
// EFFECTS: removes the study plan with the specified name
//			return YES if there exists a study plan with that name, and removed
//			return NO otherwise

-(void)removeStudyPlanAtIndex:(NSInteger)index;
// EFFECTS: removes the study plan at the specified index

-(void)setWordsForGameWithMode:(IRGameStartMode)mode;
// EFFECTS: set up the word list to be used by the game
//			The word list is set up according to the mode
//			as defined in the IRHeader.h

-(NSArray*)wordsForGame;
// REQUIRES: setWordsForGameWithMode is called before this function
// EFFECTS: return the autoreleased list of words that can be used in the game
//			so this method can only be called once per setWordsForGameWithMode

-(void)updateStatisticsWithList:(NSArray*)list inGame:(NSString *)gameName;
// REQUIRES: list contain IRWordWithStatisticsInGame objects that contain updated contents
// EFFECTS: the list of word with statistics in game stored in the wordlist inside current
//          study plan will be updated

@end