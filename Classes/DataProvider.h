//
//  DataProvider.h
//  StillOpen
//
//  Created by Alexander Medearis on 7/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataReceiver.h"
#import "LocationProvider.h"
#import "LocationReceiver.h"
#define API_KEY @"AIzaSyCewbDIEth-Dp5lLsRw752F1G8LUs1ZnL4"
#define RADIUS @"10000"


@interface DataProvider : NSObject<LocationReceiver> {

}

@property (strong) LocationProvider * locationProvider;
@property (strong) NSURLConnection * connection;
@property (strong) NSMutableData * responseData;
@property (strong) id<DataReceiver> delegate;
@property (assign) double lastLat;
@property (assign) double lastLong;
@property (strong) NSMutableArray * toReturn;
@property (strong) NSString *nextPageKey;


- (id) initWithDataDelegate:(id<DataReceiver>)_delegate;
- (void) locationReceived:(CLLocation *) _location;
- (void) getData;
- (void) sendNextRequest;


@end
