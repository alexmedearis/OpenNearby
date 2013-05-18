//
//  LocationProvider.h
//  StillOpen
//
//  Created by Alexander Medearis on 7/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "LocationReceiver.h"


@interface LocationProvider : NSObject <CLLocationManagerDelegate, MKAnnotation> {
	CLLocationManager *locationManager;
	id<LocationReceiver> delegate;
	CLLocation * lastLocation;
	bool hasReturnedLocation;
}

@property (nonatomic, strong) CLLocationManager *locationManager;  
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id) initWithLocationDelegate:(id<LocationReceiver>)_delegate;
- (void) getLocation;
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

@end

