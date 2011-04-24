//
//  iRememberAppDelegate.m
//  iRemember
//
//  Created by Raymond Hendy on 3/22/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "iRememberAppDelegate.h"
#import "iRememberViewController.h"

@implementation iRememberAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize scrollviewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch.
	[self.window addSubview:scrollviewController.view];
    [self.window addSubview:navigationController.view];
	[self.navigationController.navigationBar setTintColor:[UIColor brownColor]];
	[self.navigationController setToolbarHidden:NO];
	[self.navigationController.toolbar setTintColor:[UIColor brownColor]];
    [self.window makeKeyAndVisible];
	
	[[IRAppState currentState] loadState];
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[[IRAppState currentState] save];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[[IRAppState currentState] save];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
    [navigationController release];
    [window release];
    [super dealloc];
}


@end
