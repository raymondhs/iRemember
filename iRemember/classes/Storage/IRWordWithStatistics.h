//
//  WordWithStatistics.h
//  iRemember
//
//  Created by Aldrian Obaja Muis on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRWord.h"

@interface IRWordWithStatistics : NSObject {

}

@property(nonatomic) NSInteger wordID;
// The wordID this word with statistics refers to

@property(nonatomic,retain) NSMutableArray* reviewDates;
// This array contains NSDate object, the planned date and time when the review is conducted

@property(nonatomic) BOOL isStudied;
// The flag whether this word has been studied or not
// The definition of studied is not here

@property(nonatomic) NSInteger numberOfConductedReview;
// The number of reviews that have been conducted

-(id)initWithID:(NSInteger)wordId;

@end
