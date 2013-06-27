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

}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, weak) IBOutlet UINavigationController * mainNavController;
@property (nonatomic, weak) IBOutlet PlacesListViewController * placesList;
@property (nonatomic, strong) IBOutlet NSDate * enteredBackground;


@end

