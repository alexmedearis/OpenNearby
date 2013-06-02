//
//  LocationReceiver.h
//  StillOpen
//
//  Created by Alexander Medearis on 7/4/10.
//  Copyright 2010 Alex Medearis. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LocationReceiver
- (void) locationReceived:(CLLocation *) _location;
- (void) locationError;
@end
