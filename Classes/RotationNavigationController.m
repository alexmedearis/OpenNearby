//
//  RotationNavigationController.m
//  StillOpen
//
//  Created by Andy Dufresne on 9/11/13.
//
//

#import "RotationNavigationController.h"

@interface RotationNavigationController ()

@end

@implementation RotationNavigationController

-(BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
