//
//  StillOpenAppDelegate.m
//  StillOpen
//
//  Created by Alexander Medearis on 6/26/10.
//  Copyright 2010 Alex Medearis. All rights reserved.
//

#import "StillOpenAppDelegate.h"
#import "PlacesListViewController.h"
#import "Appirater.h"
#import "RotationNavigationController.h"
#import <Optimizely/Optimizely.h>

@implementation StillOpenAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    [Appirater setAppId:@"604952162"];
    
	// Create the nav controller
	RotationNavigationController * mainNavController = [[RotationNavigationController alloc] init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
												 
	// Create the place list and start it loading
	PlacesListViewController * placesList = [[PlacesListViewController alloc] initWithNibName:@"PlacesList" bundle:[NSBundle mainBundle]];
	[mainNavController pushViewController:placesList animated:NO];
    self.placesList = placesList;
    
    [self.window setRootViewController:mainNavController];
	self.mainNavController = mainNavController;
    
	// Display
    [window makeKeyAndVisible];
    
    [Appirater setDaysUntilPrompt:3];
    [Appirater setUsesUntilPrompt:3];
    [Appirater appLaunched:YES];

	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	[self.mainNavController popToRootViewControllerAnimated:FALSE];
	self.enteredBackground = [NSDate date];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    [Appirater appEnteredForeground:YES];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	// If it has been more than 5 minutes, refresh
	//if ([enteredBackground timeIntervalSinceReferenceDate] < [[NSDate date] timeIntervalSinceReferenceDate] - 60 * 5) {
	if(true){
		[self.placesList reload];
	}
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}




@end
