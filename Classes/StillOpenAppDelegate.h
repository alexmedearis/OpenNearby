//
//  StillOpenAppDelegate.h
//  StillOpen
//
//  Created by Alexander Medearis on 6/26/10.
//  Copyright 2010 Alex Medearis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlacesListViewController.h"

@interface StillOpenAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow * window;
	UINavigationController * mainNavController;
	PlacesListViewController * placesList;
	NSDate * enteredBackground;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@end

