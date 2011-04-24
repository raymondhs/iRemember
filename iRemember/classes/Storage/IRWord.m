//
//  Word.m
//  iRemember
//
//  Created by Aldrian Obaja Muis on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IRWord.h"


@implementation IRWord

@synthesize wordID, englishWord, translatedWord, language, pronunciation, difficulty, example, explanation, soundFileName;

-(id)init{
	return [self initWithID:1 englishWord:@"" translated:@"" lang:@""];
}

-(id)initWithID:(NSInteger)wordId englishWord:(NSString *)eng translated:(NSString *)trans lang:(NSString *)lang{
	return [self initWithID:wordId englishWord:eng translated:trans explanation:@"" pronunciation:@"" lang:lang];
}

-(id)initWithID:(NSInteger)wordId englishWord:(NSString *)eng translated:(NSString *)trans explanation:(NSString *)expln pronunciation:(NSString*)pron lang:(NSString *)lang
{
	[super init];
	if(self!=nil){
		[self setWordID:wordId];
		[self setEnglishWord:[[eng lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t\n."]]];
		[self setTranslatedWord:trans];
		[self setExplanation:expln];
		[self setPronunciation:pron];
		[self setLanguage:lang];
		[self setDifficulty:0];
		[self setExample:@""];
	}
	return self;
}

-(NSString*)soundFileName{
	return [NSString stringWithFormat:@"%d%@.caf",wordID,englishWord];
}

-(BOOL)isEqual:(IRWord*)word{
	if(self==nil || word==nil) return NO;
	else
	{
		BOOL result = YES;
		result = result && self.wordID == word.wordID;
		result = result &&[self.englishWord isEqual: word.englishWord];
		result = result &&[self.translatedWord isEqual: word.translatedWord];
		result = result &&[self.language isEqual:word.language];
		result = result &&[self.pronunciation isEqual: word.pronunciation];
		result = result && self.difficulty==word.difficulty;
		result = result &&[self.example isEqual: word.example];
		result = result &&[self.explanation isEqual: word.explanation];
		result = result &&[self.soundFileName isEqual: word.soundFileName];
		return result;
	}
}


-(void)encodeWithCoder:(NSCoder*)coder{
	[coder encodeInteger:wordID forKey:@"wordID"];
	[coder encodeObject:englishWord forKey:@"englishWord"];
	[coder encodeObject:translatedWord forKey:@"translatedWord"];
	[coder encodeObject:language forKey:@"language"];
	[coder encodeObject:pronunciation forKey:@"pronunciation"];
	[coder encodeInteger:difficulty forKey:@"difficulty"];
	[coder encodeObject:example forKey:@"example"];
	[coder encodeObject:explanation forKey:@"explanation"];
}

-(id)initWithCoder:(NSCoder*)decoder{
	if([super init]!=nil){
		
		[self setWordID:[decoder decodeIntegerForKey:@"wordID"]];
		[self setEnglishWord:[decoder decodeObjectForKey:@"englishWord"]];
		[self setTranslatedWord:[decoder decodeObjectForKey:@"translatedWord"]];
		[self setLanguage:[decoder decodeObjectForKey:@"language"]];
		[self setPronunciation:[decoder decodeObjectForKey:@"pronunciation"]];
		[self setDifficulty:[decoder decodeIntegerForKey:@"difficulty"]];
		[self setExample:[decoder decodeObjectForKey:@"example"]];
		[self setExplanation:[decoder decodeObjectForKey:@"explanation"]];
		 
	}
	return self;
}

-(void)dealloc{
	[englishWord release];
	[translatedWord release];
	[language release];
	[pronunciation release];
	[example release];
	[explanation release];
	[super dealloc];
}

@end
