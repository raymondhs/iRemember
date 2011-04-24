//
//  IRClient.h
//  iRemember
//
//  Created by Aldrian Obaja Muis on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "IRAppState.h"
#import "IRLibrary.h"
#import "IRWordList.h"
#import "IRConnection.h"

@interface IRClient : NSObject {
	id<IRConnection> delegate;
}

@property(nonatomic,assign) id<IRConnection> delegate;

-(void)startWithName:(NSString*)name;
// Start a connection with the name as identifier (the name is not used now)

-(void)addWordList:(IRWordList*)wordList;
// Send a word list to the server

-(void)wordListWithName:(NSString*)name;
// Get a word list with a specified name
// This method will call the delegate method didGetWordList:(IRWordList*)list

-(void)wordListNames;
// Get the list of word lists in the server
// This method will call the delegate method didGetWordListNames:(NSArray*)names

-(void)exit;
// Notify the server and disconnect the connection

-(void)write:(NSString*)msg;
// Testing method only

@end
