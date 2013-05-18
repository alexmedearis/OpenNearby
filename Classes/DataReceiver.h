//
//  DataReceiver.h
//  StillOpen
//
//  Created by Alexander Medearis on 7/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DataReceiver
- (void) locationReceived;
- (void) locationError;
- (void) errorOccurred;
- (void) dataReceived:(NSMutableArray *) _openBusinesses;
@end
