//
//  Word.h
//  iRemember
//
//  Created by Aldrian Obaja Muis on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IRWord : NSObject {

}

@property(nonatomic) NSInteger wordID;
@property(nonatomic,retain) NSString* englishWord;
//The English word of this Word object, in lowercase

@property(nonatomic,retain) NSString* translatedWord;
@property(nonatomic,retain) NSString* language;
@property(nonatomic,retain) NSString* pronunciation;
@property(nonatomic) NSInteger difficulty;
@property(nonatomic,retain) NSString* example;
@property(nonatomic,retain) NSString* explanation;
@property(nonatomic,readonly) NSString* soundFileName;
// Readonly property to return the file name of the pronunciation of this word
// It is constructed from the wordID and the English Word

-(id)initWithID:(NSInteger)wordId englishWord:(NSString*)eng translated:(NSString*)trans lang:(NSString*)lang;
-(id)initWithID:(NSInteger)wordId englishWord:(NSString*)eng translated:(NSString*)trans explanation:(NSString*)expln pronunciation:(NSString*)pron lang:(NSString*)lang;
// These two init methods will create an IRWord object with specified parameters
// with English Word converted to lowercase String

@end
