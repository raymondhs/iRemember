//
//  IRClient.m
//  iRemember
//
//  Created by Aldrian Obaja Muis on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IRClient.h"
#define DELIMITER @"\1\0\n"
#define HOST @"aldrian-z.comp.nus.edu.sg"
#define PORT 80
#define MOD 65535

typedef enum IRTag{
	IRTagReadWordListData = 0,
	IRTagExit = 1,
	IRTagReadOther = 2
} IRTag;

static AsyncSocket* socket;

////////// HELPER METHODS ////////////////
NSData* dataWithString(NSString* str){
	return [[str stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
}

NSArray* parseParam(NSString* str){
	NSArray* arr = [[str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\1\0\n \t"]] componentsSeparatedByString:@" "];
	NSMutableArray* result = [[NSMutableArray alloc] init];
	BOOL isQuoted = NO;
	NSMutableString* quot = [NSMutableString stringWithString:@""];
	int i=0;
	for(i=0; i<[arr count]; i++){
		NSString* cur = [arr objectAtIndex:i];
		if(!isQuoted){
			quot = [NSMutableString stringWithString:@""];
			if([cur length]>0 && [cur characterAtIndex:0]=='"'){
				if([cur length]>1 && [cur characterAtIndex:[cur length]-1]=='"'){
					[quot appendString:[cur substringWithRange:NSMakeRange(1, [cur length]-2)]];
				} else {
					[quot appendString:[cur substringFromIndex:1]];
					isQuoted = YES;
				}
			} else {
				[quot appendString:cur];
			}
		} else {
			if([cur length]>0 && [cur characterAtIndex:[cur length]-1]=='"'){
				[quot appendFormat:@" %@",[cur substringToIndex:[cur length]-1]];
				isQuoted = NO;
			} else {
				[quot appendFormat:@" %@",cur];
			}
		}
		if(!isQuoted) [result addObject:quot];
	}
	return result;
}

@implementation IRClient

@synthesize delegate;

-(void)startWithName:(NSString*)name{
	socket = [[AsyncSocket alloc] init];
	[socket setDelegate:self];
	NSError* err = nil;
	if(![socket connectToHost:HOST onPort:PORT error:&err]){
		NSLog(@"%@",[err localizedDescription]);
	}
	NSString* msg = [NSString stringWithFormat:@"start \"%@\"\n",name];
	NSData* data = [msg dataUsingEncoding:NSUTF8StringEncoding];
	[socket writeData:data withTimeout:2 tag:0];
	
	NSData* delim = [DELIMITER dataUsingEncoding:NSUTF8StringEncoding];
	[socket readDataToData:delim withTimeout:-1 tag:IRTagReadOther];
}

-(void)addWordList:(IRWordList*)list{
	NSMutableData* newdata = [[NSMutableData alloc] init];
	NSKeyedArchiver* arc = [[NSKeyedArchiver alloc] initForWritingWithMutableData:newdata];
	[arc encodeObject:list forKey:@"list"];
	[arc finishEncoding];
	[arc release];
	int temp = 0;
	int i=0;
	const char* byteData = (const char*)[newdata bytes];
	for(i=0; i<[newdata length]; i++){
		temp = (((temp+byteData[i])%MOD)+MOD)%MOD;
	}
	
	NSString* addWord = [NSString stringWithFormat:@"addwordlist \"%@\" \"%d\" \"%d\"",[list listName],[newdata length],temp];
	NSMutableData* addWordData = [NSMutableData dataWithData:dataWithString(addWord)];
	[addWordData appendData:newdata];
	[newdata release];
	[socket writeData:addWordData withTimeout:-1 tag:1];
}

-(void)wordListWithName:(NSString*)name{
	NSData* data = dataWithString([NSString stringWithFormat:@"getwordlist \"%@\"",name]);
	[socket writeData:data withTimeout:-1 tag:2];
}

-(void)wordListNames{
	NSData* data = dataWithString(@"wordlistnames");
	[socket writeData:data withTimeout:-1 tag:3];
}

-(void)exit{
	NSData* data = dataWithString(@"exit");
	[socket writeData:data withTimeout:-1 tag:4];
	[socket disconnectAfterWriting];
}

-(void)write:(NSString*)msg{
	if(msg==nil) return;
	NSString* mesg = [msg stringByAppendingString:@"\n"];
	NSData* exitData = [mesg dataUsingEncoding:NSUTF8StringEncoding];
	UIApplication* app = [UIApplication sharedApplication];
	[app setNetworkActivityIndicatorVisible:YES];
	[socket writeData:exitData withTimeout:-1 tag:1];
	if([msg isEqual:@"exit"]){
		[socket disconnectAfterWriting];
	}
}

////////// DELEGATE METHODS ///////////////

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
	NSLog(@"Connected!");
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
	NSString* msg = nil;
	long newTag = IRTagReadOther;
	int len = 0;
	if(tag==IRTagReadWordListData){
		NSKeyedUnarchiver* unarc = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		IRWordList* list = [unarc decodeObjectForKey:@"list"];
		[unarc finishDecoding];
		[unarc release];
		if([delegate respondsToSelector:@selector(didGetWordList:)]){
			[delegate didGetWordList:list];
		}
	} else {
		msg = [NSString stringWithUTF8String:[data bytes]];
	}
	if(msg!=nil){
		//NSLog(@"%@",msg);
		NSArray* words = parseParam(msg);
		if([[[words objectAtIndex:0] lowercaseString] isEqual:@"wordlist"]){
			newTag = IRTagReadWordListData;
			len = [[words objectAtIndex:2] integerValue];
		} else if([[[words objectAtIndex:0] lowercaseString] isEqual:@"wordlistnames"]){
			int num = [[words objectAtIndex:1] integerValue];
			NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:num];
			int i=0;
			for(i=2; i<num+2; i++){
				[result addObject:[[words objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\1\0\n \t"]]];
			}
			if([delegate respondsToSelector:@selector(didGetWordListNames:)]){
				[delegate didGetWordListNames:[result autorelease]];
			}
		} else if([[[words objectAtIndex:0] lowercaseString] isEqual:@"err"]){
			if([delegate respondsToSelector:@selector(didReceiveError:)]){
				[delegate didReceiveError:[[words objectAtIndex:1] integerValue]];
			}
		}

	}
	if(newTag==IRTagReadOther){
		NSData* delim = [DELIMITER dataUsingEncoding:NSUTF8StringEncoding];
		[socket readDataToData:delim withTimeout:-1 tag:newTag];
	} else {
		[socket readDataToLength:len withTimeout:-1 tag:newTag];
	}
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
	UIApplication* app = [UIApplication sharedApplication];
	[app setNetworkActivityIndicatorVisible:NO];
}

- (NSTimeInterval)onSocket:(AsyncSocket *)sock
 shouldTimeoutWriteWithTag:(long)tag
				   elapsed:(NSTimeInterval)elapsed
				 bytesDone:(CFIndex)length{
	NSLog(@"Message with tag %ld timeout!",tag);
	return 0;
}

- (void)onSocket:(AsyncSocket *)sender willDisconnectWithError:(NSError *)error{
	if([error localizedDescription]==nil) return;
	NSLog(@"Error: %@",[error localizedDescription]);
}

-(void)dealloc{
	[socket release];
	[super dealloc];
}

@end
