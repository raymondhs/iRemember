//
//  Library.h
//  iRemember
//
//  Created by Aldrian Obaja Muis on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRWord.h"

CFComparisonResult compareWords(const void *val1, const void *val2, void *context);

@interface IRLibrary : NSObject {

}

@property(nonatomic,retain) NSMutableArray* words;
@property(nonatomic,retain) NSString* language;
// Array of Word

-(id)initWithLanguage:(NSString*)lang;

-(BOOL)checkIDConsistency;
// EFFECTS: return YES if the wordIDs in the word list is consistent (no duplicates), NO otherwise

-(NSInteger)availableID;
// EFFECTS: return an available number that can be used for wordID;

-(NSArray*)availableIDWithCount:(int)count;
// EFFECTS: return a list of numbers that are available to be used for wordID;

-(IRWord*)wordWithID:(NSInteger)wordID;
// EFFECTS: return the Word object with specified wordID, nil if not found
// COMPLEXITY : O(N) where N is the size of the list

-(IRWord*)wordWithString:(NSString*)theWord;
// EFFECTS: return the Word object with the specified english word, nil if not found
// COMPLEXITY: O(M log N) where M is the length of theWord and N is the size of the list

-(NSArray*)wordsWithPrefix:(NSString*)pre maxSize:(NSInteger)num;
// EFFECTS: returns the list of words that matches the specified prefix
//			maxSize will determine the maximum number that will be returned
//			If num>0 it is the upper limit of the number of words returned
//			If num<=0 it will return as many words as this method found
// COMPLEXITY: O(M log N + S) where:
//			M is the length of prefix,
//			N is the number of words in the list,
//			S is the size of the returned result.

-(IRWord*)addWord:(NSString*)eng translation:(NSString*)trans lang:(NSString*)lang;
// MODIFIES: words in self
// EFFECTS: add a word with the specified parameters
//          return the created Word object

-(NSArray*)addWords:(NSArray*)wordList;
// MODIFIES: words in self, words in wordList as well
// EFFECTS: add the words in the given list into this list
//			if there exist a word with the same ID, the new word is not added
//			returns the list of words that are added

-(BOOL)removeWordWithID:(NSInteger)wordID;
// MODIFIES: words in self
// EFFECTS: remove the word with the specified id
//			return YES if it's successfully removed

-(BOOL)removeWordWithString:(NSString*)theWord;
// MODIFIES: words in self
// EFFECTS: remove any word that matches the specified English Word
//			returns YES if it's successfully removed

-(NSInteger)count;
// EFFECTS: returns the number of words in this library

-(void)encodeWithCoder:(NSCoder *)coder;

-(id)initWithCoder:(NSCoder *)decoder;

@end
