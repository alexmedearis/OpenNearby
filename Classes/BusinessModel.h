//
//  BusinessModel.h
//  StillOpen
//
//  Created by Alexander Medearis on 6/28/10.
//  Copyright 2010 Alex Medearis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface BusinessModel : NSObject<MKAnnotation> {
	
}

@property (strong) NSString *  name;
@property (strong) NSString *  identifier;
@property (strong) NSString *  reference;
@property (strong) NSString *  address;
@property double latitude;
@property double longitude;
@property (strong) NSString * icon;
@property (strong) NSString * phone;
@property (strong) NSString * categories;
@property (strong) NSString * mobileUrl;
@property double distance;
@property double rating;
@property (strong) NSString * hours;
@property (strong) NSString * image;
@property (strong) NSString * price;


@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (NSComparisonResult) compareOtherBusiness:(BusinessModel *)otherObject;
@end
