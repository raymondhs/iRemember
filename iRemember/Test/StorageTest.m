//
//  StorageTest.m
//  iRemember
//
//  Created by Yingbo Zhan on 4/2/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "StorageTest.h"
#import "IRWord.h"

@implementation StorageTest


 
- (void) setUp
{
	/******************IRWord********************/
	//It will be the caller's responsibility to ensure the input argument to be correct
	word1 = [[IRWord alloc]initWithID:1 englishWord:@"a" translated:@"first character in alphabet" lang:LANG_ENGLISH];
	word2 = [[IRWord alloc]initWithID:2 englishWord:@"b" translated:@"第二个字母" lang:LANG_CHINESE];
	word3 = [[IRWord alloc]initWithID:3 englishWord:@"c" translated:@"huruf ketiga" lang:LANG_INDONESIAN];
	
	//empty string as argument
	word4 = [[IRWord alloc]initWithID:4 englishWord:@"" translated:@"empty" lang:LANG_ENGLISH];
	word5 = [[IRWord alloc]initWithID:5 englishWord:@"e" translated:@"" lang:LANG_ENGLISH];
	
	//Common init for test
	word6 = [[IRWord alloc]initWithID:6 englishWord:@"b" translated:@"2nd character in alphabet" lang:LANG_ENGLISH];
	word7 = [[IRWord alloc]initWithID:7 englishWord:@"e" translated:@"5th character in alphabet" lang:LANG_ENGLISH];
	word8 = [[IRWord alloc]initWithID:8 englishWord:@"f" translated:@"6th character in alphabet" lang:LANG_ENGLISH];
	word9 = [[IRWord alloc]initWithID:9 englishWord:@"c" translated:@"3rd character in alphabet" lang:LANG_ENGLISH];
	word0 = [[IRWord alloc]initWithID:0 englishWord:@"d" translated:@"4th character in alphabet" lang:LANG_ENGLISH];
	
	/***************IRLibrary*******************/
	englishLibrary = [[IRLibrary alloc]initWithLanguage:LANG_ENGLISH];
	chineseLibrary = [[IRLibrary alloc]initWithLanguage:LANG_CHINESE];
	indonesLibrary = [[IRLibrary alloc]initWithLanguage:LANG_INDONESIAN];
}
/******************************************** IRWord Test ********************************************/
//test the getter method
- (void)testInitializationOfIRWord
{
	STAssertTrue(word1.wordID==1&&
				 [word1.englishWord isEqual:@"a"]&&
				 [word1.translatedWord isEqual:@"first character in alphabet"]&&
				 [word1.language isEqual: LANG_ENGLISH],@"word 1");
	
	STAssertTrue(word2.wordID==2&&
				 [word2.englishWord isEqual:@"b"]&&
				 [word2.translatedWord isEqual:@"第二个字母"]&&
				 [word2.language isEqual:LANG_CHINESE],@"word 2");
	
	STAssertTrue(word3.wordID==3&&
				 [word3.englishWord isEqual:@"c"]&&
				 [word3.translatedWord isEqual:@"huruf ketiga"]&&
				 [word3.language isEqual:LANG_INDONESIAN],@"word 3");
	
	STAssertTrue(word4.wordID==4&&
				 [word4.englishWord isEqual:@""]&&
				 [word4.translatedWord isEqual:@"empty"]&&
				 [word4.language isEqual: LANG_ENGLISH],@"word 4");
	
	STAssertTrue(word5.wordID==5&&
				 [word5.englishWord isEqual:@"e"]&&
				 [word5.translatedWord isEqual:@""]&&
				 [word5.language isEqual: LANG_ENGLISH],@"word 5");
	
	STAssertTrue(word6.wordID==6&&
				 [word6.englishWord isEqual:@"b"]&&
				 [word6.translatedWord isEqual:@"2nd character in alphabet"]&&
				 [word6.language isEqual: LANG_ENGLISH],@"word 6");
	
	STAssertTrue(word7.wordID==7&&
				 [word7.englishWord isEqual: @"e"]&&
				 [word7.translatedWord isEqual: @"5th character in alphabet"]&&
				 [word7.language isEqual: LANG_ENGLISH],@"word 7");
	
	STAssertTrue(word8.wordID==8&&
				 [word8.englishWord isEqual: @"f"]&&
				 [word8.translatedWord isEqual: @"6th character in alphabet"]&&
				 [word8.language isEqual: LANG_ENGLISH],@"word 8");
	
	STAssertTrue(word9.wordID==9&&
				 [word9.englishWord isEqual: @"c"]&&
				 [word9.translatedWord isEqual: @"3rd character in alphabet"]&&
				 [word9.language isEqual: LANG_ENGLISH],@"word 9");
	
	STAssertTrue(word0.wordID==0&&
				 [word0.englishWord isEqual:@"d"]&&
				 [word0.translatedWord isEqual: @"4th character in alphabet"]&&
				 [word0.language isEqual: LANG_ENGLISH],@"word 0");
}

//test equal
- (void)testIRWordFuncionIsEqual
{
	STAssertTrue([word0 isEqual:word0],@"Same Word");
	STAssertFalse([word1 isEqual:word0],@"DifferentWord");
	IRWord *test1 = nil;
	STAssertFalse([word0 isEqual:test1],@"Same non existence");
}
/******************************************** IRLibrary Test ****************************************/
- (void)testInitializationOfIRLibrary
{
	STAssertTrue(englishLibrary.language == LANG_ENGLISH,@"English library");
	STAssertTrue(chineseLibrary.language == LANG_CHINESE,@"Chinese library");
	STAssertTrue(indonesLibrary.language == LANG_INDONESIAN,@"Indoensian library");
}
//execute add library function.
- (void)testLibraryFunctionAddWordAndAddWords
{
	//set up
	NSMutableArray *wordlist = [[NSMutableArray alloc]init];
	//normal test
	[englishLibrary addWord:@"a" translation:@"first character in alphabet" lang:LANG_ENGLISH];
	STAssertTrue([[englishLibrary.words objectAtIndex:0] isEqual:word1],@"Function Add Word");
	STAssertTrue([englishLibrary.words count]==1,@"Function Add Word");
	
	//normal test
	[englishLibrary addWord:@"b" translation:@"2nd character in alphabet" lang:LANG_ENGLISH];
	STAssertFalse([[englishLibrary.words objectAtIndex:1] isEqual:word6],@"Function Add Word");
	STAssertTrue([englishLibrary.words count]==2,@"Function Add Word");
	word6.wordID = 2;
	STAssertTrue([[englishLibrary.words objectAtIndex:1] isEqual:word6],@"Function Add Word");
	word6.wordID = 6;
	
	//check for unequal word (normal test)
	[englishLibrary addWord:@"e" translation:@"5th character in alphabet" lang:LANG_ENGLISH];
	word7.wordID = 3;
	STAssertTrue([[englishLibrary.words objectAtIndex:2] isEqual:word7],@"Function Add Word");
	STAssertTrue([englishLibrary.words count]==3,@"Function Add Word");
	
	//check for the repeated words
	[englishLibrary addWord:@"b" translation:@"2nd character in alphabet" lang:LANG_ENGLISH];
	STAssertFalse([[englishLibrary.words objectAtIndex:2] isEqual:word6],@"Function Add Word");
	STAssertTrue([englishLibrary.words count]==4,@"Function Add Word");
	word6.wordID = 4;
	STAssertTrue([[englishLibrary.words objectAtIndex:2] isEqual:word6],@"Function Add Word");
	word6.wordID = 6;
	STAssertTrue([[englishLibrary.words objectAtIndex:3] isEqual:word7],@"Function Add Word");
	word7.wordID = 7;
	
				  
	//[englishLibrary addWord:@"b" translation:@"第二个字母" lang:LANG_CHINESE];

	[wordlist addObject:word5]; //e
	word4.wordID = 8;
	[wordlist addObject:word4]; //
	[wordlist addObject:word9]; //c
	[englishLibrary addWords:wordlist];

	STAssertTrue([[englishLibrary.words objectAtIndex:0] isEqual:word4],@"Function Add Words");
	word4.wordID = 4;
	STAssertTrue([englishLibrary.words count]==7,@"Function Add Words");
	STAssertTrue([[englishLibrary.words objectAtIndex:4] isEqual:word9],@"Function Add Words");
	STAssertTrue([[englishLibrary.words objectAtIndex:6] isEqual:word5],@"Function Add Words");
	[englishLibrary addWord:@"f" translation:@"6th character in alphabet" lang:LANG_ENGLISH];
	word8.wordID = 6;
	STAssertTrue([[englishLibrary.words objectAtIndex:7] isEqual:word8],@"Function Add Word");
	word8.wordID = 8;
	
	//clean up
	[wordlist release];
	[englishLibrary release];

}

- (void)testAvailableID
{
	NSMutableArray *wordlist = [[NSMutableArray alloc]init];

	[wordlist addObject:word4];//c
	[wordlist addObject:word0];//d
	englishLibrary = [[IRLibrary alloc]initWithLanguage:LANG_ENGLISH];
	STAssertTrue([englishLibrary availableID]==1,@"available ID");
	
	[englishLibrary addWords:wordlist];
	
	//Test available ID to be 1 (the first)

	STAssertTrue([englishLibrary availableID]==1,@"available ID");
	word2.language = LANG_ENGLISH;	
	[wordlist addObject:word2];//f
	[wordlist addObject:word1];//e

	
	//Test available ID to be some number < max and > min
	[englishLibrary addWords:wordlist];
	STAssertTrue([englishLibrary availableID]==3,@"available ID %d",[englishLibrary availableID]);
	
	//Test available ID larger than max
	word3.language = LANG_ENGLISH;
	[wordlist addObject:word3];
	[englishLibrary addWords:wordlist];
	STAssertTrue([englishLibrary availableID]==5,@"available ID %d",[englishLibrary availableID]);
	
	//clean up
	[wordlist release];
	word2.language = LANG_CHINESE;
	word3.language = LANG_INDONESIAN;
	[englishLibrary release];
}

- (void)testWordWithID
{
	//Set up
	NSMutableArray *wordlist = [[NSMutableArray alloc]init];
	englishLibrary = [[IRLibrary alloc]initWithLanguage:LANG_ENGLISH];
	
	[wordlist addObject:word8];
	[wordlist addObject:word0];//d
	[englishLibrary addWords:wordlist];
	
	//Test to get the word with wordID 1 (the first)
	[englishLibrary addWord:@"a" translation:@"first character in alphabet" lang:LANG_ENGLISH];
	STAssertTrue([[englishLibrary wordWithID:0]isEqual:word0],@"wordWithID");
	STAssertTrue([[englishLibrary wordWithID:1]isEqual:word1],@"wordWithID");
	

	[wordlist addObject:word6];
	[wordlist addObject:word5];
	
	//Test to get the word with wordID < max and > min
	[englishLibrary addWords:wordlist];
	STAssertTrue([[englishLibrary wordWithID:5]isEqual:word5],@"wordWithID");
	
	//Test to get the word with largest wordID
	[wordlist addObject:word9];//c
	[englishLibrary addWords:wordlist];
	STAssertTrue([[englishLibrary wordWithID:9]isEqual:word9],@"wordWithID");
	
	//test for non existence
	STAssertTrue([englishLibrary wordWithID:7]==nil,@"wordWithID");
	//clean up
	[wordlist release];
	[englishLibrary release];
}

- (void)testWordWithString
{
	//Set up
	NSMutableArray *wordlist = [[NSMutableArray alloc]init];
	englishLibrary = [[IRLibrary alloc]initWithLanguage:LANG_ENGLISH];
	
	[wordlist addObject:word8];
	[wordlist addObject:word0];//d
	[englishLibrary addWords:wordlist];
	
	//Test to get the word with wordID 1 (the first)
	[englishLibrary addWord:@"a" translation:@"first character in alphabet" lang:LANG_ENGLISH];
	STAssertTrue([[englishLibrary wordWithString:@"d"]isEqual:word0],@"wordWithString");
	STAssertTrue([[englishLibrary wordWithString:@"a"]isEqual:word1],@"wordWithID");
	
	
	[wordlist addObject:word6];
	[wordlist addObject:word5];
	
	//Test to get the word with wordID < max and > min
	[englishLibrary addWords:wordlist];
	STAssertTrue([[englishLibrary wordWithString:@"e"]isEqual:word5],@"wordWithString");
	
	//Test to get the word with largest wordID
	[wordlist addObject:word9];//c
	[englishLibrary addWords:wordlist];
	STAssertTrue([[englishLibrary wordWithString:@"c"]isEqual:word9],@"wordWithString");
	
	//test for non existence
	STAssertTrue([englishLibrary wordWithString:@"z"]==nil,@"wordWithID");
	//clean up
	[wordlist release];
	[englishLibrary release];
	
}

- (void)removeWordWithID
{
	//Set up
	NSMutableArray *wordlist = [[NSMutableArray alloc]init];
	englishLibrary = [[IRLibrary alloc]initWithLanguage:LANG_ENGLISH];

	[wordlist addObject:word1];
	[wordlist addObject:word4];
	[wordlist addObject:word7];
	[wordlist addObject:word9];
	[englishLibrary addWords:wordlist];
	
	//Test to remove first word
	[englishLibrary	removeWordWithID:1];
	STAssertTrue([englishLibrary wordWithID:1]==nil,@"Remove Word WithID");
	//Test to remove word with non extreme id
	[englishLibrary removeWordWithID:7];
	STAssertTrue([englishLibrary wordWithID:7]==nil,@"Remove Word WithID");
	//Test to remove last word
	[englishLibrary removeWordWithID:9];
	STAssertTrue([englishLibrary wordWithID:9]==nil,@"Remove Word WithID");
	//Test to remove non existence word
	[englishLibrary removeWordWithID:4];
	STAssertFalse([englishLibrary removeWordWithID:4],@"Remove Word WithID");
	
	//clean
	[wordlist release];
	[englishLibrary release];
}

- (void)removeWordWithString
{
	//Set up
	NSMutableArray *wordlist = [[NSMutableArray alloc]init];
	englishLibrary = [[IRLibrary alloc]initWithLanguage:LANG_ENGLISH];
	
	[wordlist addObject:word1];
	[wordlist addObject:word4];
	[wordlist addObject:word7];
	[wordlist addObject:word9];
	[wordlist addObject:word5];
	[englishLibrary addWords:wordlist];
	
	//Test to remove first word
	[englishLibrary	removeWordWithString:@"a"];
	STAssertTrue([englishLibrary wordWithString:@"a"]==nil,@"Remove Word WithString");
	//Test to remove word with non extreme id repeated words
	[englishLibrary removeWordWithString:@"e"];
	STAssertTrue([englishLibrary wordWithString:@"e"]==nil,@"Remove Word WithString");
	//Test to remove word with non extreme id
	[englishLibrary removeWordWithString:@""];
	STAssertTrue([englishLibrary wordWithString:@""]==nil,@"Remove Word WithString");
	//Test to remove last word
	[englishLibrary removeWordWithString:@"c"];
	STAssertTrue([englishLibrary wordWithString:@"c"]==nil,@"Remove Word WithString");
	//Test to remove non existence word
	[englishLibrary removeWordWithID:3];
	STAssertFalse([englishLibrary removeWordWithID:3],@"Remove Word WithString");
}

- (void)testCount
{
	//Set up
	NSMutableArray *wordlist = [[NSMutableArray alloc]init];
	englishLibrary = [[IRLibrary alloc]initWithLanguage:LANG_ENGLISH];
	
	//Test for 0 length of wordlist
	STAssertTrue([englishLibrary count]==0,@"Count function");
	
	[englishLibrary addWord:@"a" translation:@"first character in alphabet" lang:LANG_ENGLISH];
	
	//test after addword
	STAssertTrue([englishLibrary count]==1,@"Count function");
	
	[wordlist addObject:word8];
	[wordlist addObject:word0];//d
	[englishLibrary addWords:wordlist];
	
	//Test after addwords
	STAssertTrue([englishLibrary count]==3,@"Count function");
	

	[englishLibrary removeWordWithID:1];
	STAssertTrue([englishLibrary count]==2,@"Count function");
	

	//clean up
	[wordlist release];
	[englishLibrary release];
}

/****************************************** IRWordList *********************************************/

	
/****************************************** IRStudyPlan ********************************************/


@end
