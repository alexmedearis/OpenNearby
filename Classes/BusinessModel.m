//
//  BusinessModel.m
//  StillOpen
//
//  Created by Alexander Medearis on 6/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusinessModel.h"
#import <MapKit/MapKit.h>

@implementation BusinessModel

@synthesize name = _name;
@synthesize identifier = _identifier;
@synthesize address = _address;
@synthesize distance = _distance;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize icon = _icon;
@synthesize reference = _reference;
@synthesize phone = _phone;
@synthesize categories = _categories;
@synthesize mobileUrl = _mobileUrl;
@synthesize rating = _rating;
@synthesize hours = _hours;
@synthesize price = _price;

- (CLLocationCoordinate2D) coordinate {
	CLLocationCoordinate2D coord = {self.latitude, self.longitude};
	return coord;
}
- (NSString *) title {
	return self.name;
}
- (NSString *) subtitle {
	return self.address;
}

- (NSComparisonResult) compareOtherBusiness:(BusinessModel *)otherObject {
	return [[NSNumber numberWithFloat:self.distance] compare:[NSNumber numberWithFloat:otherObject.distance]];
}


@end
