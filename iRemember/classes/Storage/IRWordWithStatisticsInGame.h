//
//  WordWithStatisticsInGame.h
//  iRemember
//
//  Created by Aldrian Obaja Muis on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRWord.h"

@interface IRWordWithStatisticsInGame : NSObject {

}

@property(nonatomic) NSInteger wordID;
@property(nonatomic) NSInteger correctCount;
@property(nonatomic) NSInteger incorrectCount;
@property(nonatomic) NSInteger totalReactionTime;

-(id)initWithID:(NSInteger)wordId;

-(NSInteger)usedCount;
// RETURNS: The total number this word has been used in a game session

-(void)addTotalReactionTime:(NSInteger)time;
// MODIFIES: self
// EFFECTS: add the specified time to the totalReactionTime=

-(CGFloat)getAverageReactionTime;
// EFFECTS: returns the average reaction time

-(void)updateStatWithStat:(IRWordWithStatisticsInGame*)word;
// EFFECTS: update the statistics in this object with the one specified by word

@end
