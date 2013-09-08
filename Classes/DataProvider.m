//
//  DataProvider.m
//  StillOpen
//
//  Created by Alexander Medearis on 7/2/10.
//  Copyright 2010 Alex Medearis. All rights reserved.
//

#import "DataProvider.h"

#import "BusinessModel.h"
#import "DataReceiver.h"
#

@implementation DataProvider

@synthesize connection = _connection;
@synthesize responseData = _responseData;
@synthesize delegate = _delegate;
@synthesize nextPageKey = _nextPageKey;

- (id) initWithDataDelegate:(id<DataReceiver>)delegate {
    self = [super init];
    if (self != nil) {
		self.responseData = [NSMutableData data];
		self.locationProvider = [[LocationProvider alloc] initWithLocationDelegate:self];
		self.delegate = delegate;
    }
    return self;
}

-(void) getData
{
    self.toReturn = [[NSMutableArray alloc] initWithCapacity:5];
	[self.responseData setLength:0];
	[self.locationProvider getLocation];
}

- (void) locationError {
    [self.delegate locationError];
}

- (void) locationReceived:(CLLocation *) _location
{
    [self.delegate locationReceived];
	[self sendRequestWithLat:_location.coordinate.latitude longitude:_location.coordinate.longitude];
}


- (void) sendRequestWithLat:(double)latitude longitude:(double)longitude
{
    self.lastLat = latitude;
    self.lastLong = longitude;
	NSURLRequest *request = [NSURLRequest requestWithURL:[self getURL:latitude longitude:longitude]];
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSURL*) getURL:(double)latitide longitude:(double)longitude
{
	NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=%@&location=%.4f,%.4f&sensor=true&opennow=true&rankby=distance&types=bakery%%7Ccafe%%7Cfood%%7Cgrocery_or_supermarket%%7Cliquor_store%%7Cmeal_takeaway%%7Crestaurant", API_KEY, latitide, longitude];
    NSLog(@"%@", urlString);
	return [NSURL URLWithString:urlString];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    for (id key in error.userInfo) {
    }	[self.delegate errorOccurred];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self.responseData options: NSJSONReadingMutableContainers error: &e];

    if (!jsonArray) {
        [self.delegate errorOccurred];
    } else {
		NSArray * businessesJson = jsonArray[@"results"];
		
		NSDictionary * business;
		for (business in businessesJson) {
			
            bool isOpen = false;
            if(business[@"opening_hours"]) {
                if(business[@"opening_hours"][@"open_now"]) {
                    isOpen = [business[@"opening_hours"][@"open_now"] boolValue];
                }
            }
            
			if(isOpen)
			{
				BusinessModel * newBusiness = [[BusinessModel alloc] init];
				newBusiness.name = business[@"name"] ? business[@"name"] : @"";
				newBusiness.identifier = business[@"id"] ? business[@"id"] : @"";
				newBusiness.address = business[@"vicinity"] ? business[@"vicinity"] : @"";
                
                if(business[@"geometry"]){
                    if(business[@"geometry"][@"location"]){
                        newBusiness.latitude = [business[@"geometry"][@"location"][@"lat"] doubleValue];
                        newBusiness.longitude = [business[@"geometry"][@"location"][@"lng"] doubleValue];
                        CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:self.lastLat longitude:self.lastLong];
                        CLLocation *restaurnatLoc = [[CLLocation alloc] initWithLatitude:newBusiness.latitude longitude:newBusiness.longitude];
                        CLLocationDistance meters = [restaurnatLoc distanceFromLocation:currentLoc];
                        newBusiness.distance = 0.000621371 * meters;
                    }
                }
                newBusiness.icon = business[@"icon"] ? business[@"icon"] : @"";
                newBusiness.reference = business[@"reference"] ? business[@"reference"] : @"";
                [self.toReturn addObject:newBusiness];
			}
		}
        if(jsonArray[@"next_page_token"]) {
           self.nextPageKey = jsonArray[@"next_page_token"];
        } else {
            self.nextPageKey = nil;
        }
        [self.toReturn sortUsingSelector:@selector(compareOtherBusiness:)];
        [self.delegate dataReceived:self.toReturn];
	}
}

- (void)sendNextRequest{
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=%@&pagetoken=%@&sensor=true", API_KEY, self.nextPageKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
