//
//  IRConnection.h
//  iRemember
//
//  Created by Aldrian Obaja Muis on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum IRConnectionError{
	IRConnectionErrorInvalidCommand = 1,
	IRConnectionErrorNoSuchWordList = 2
} IRConnectionError;

@protocol IRConnection<NSObject>

-(void)didGetWordList:(IRWordList*)list;
// the wordlist got from the server

-(void)didGetWordListNames:(NSArray *)names;
// the names of available wordLists got from the server

-(void)didReceiveError:(IRConnectionError)errorNumber;
// if error is received, the error number is defined in this file

@end
