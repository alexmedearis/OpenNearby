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

@implementation StillOpenAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    [Appirater setAppId:@"604952162"];
    
	// Create the nav controller
	mainNavController = [[UINavigationController alloc] init];
	mainNavController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.2 blue:0.4 alpha:0];
												 
	// Create the place list and start it loading
	placesList = [[PlacesListViewController alloc] initWithNibName:@"PlacesList" bundle:[NSBundle mainBundle]];
	[mainNavController pushViewController:placesList animated:NO];
    
    [self.window setRootViewController:mainNavController];

	
	// Display
    [window makeKeyAndVisible];
	
    [Appirater appLaunched:YES];
    
    // List all fonts on iPhone
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }

    
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
	[mainNavController popToRootViewControllerAnimated:FALSE];
	enteredBackground = [NSDate date];
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
		[placesList reload];
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
