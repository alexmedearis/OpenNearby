//
//  PlacesDetailViewController.m
//  StillOpen
//
//  Created by Alexander Medearis on 7/5/10.
//  Copyright 2010 Alex Medearis. All rights reserved.
//

#import "PlacesDetailViewController.h"
#import "DataProvider.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DisplayWebpageViewController.h"

@implementation PlacesDetailViewController

@synthesize connection = _connection;
@synthesize business = _business;
@synthesize locationProvider = _locationProvider;
@synthesize HUD = _HUD;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
			 business:(BusinessModel *)business locationProvider:(LocationProvider *)locationProvider{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.business = business;
		self.locationProvider = locationProvider;
        self.responseData = [NSMutableData data];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [call.titleLabel setFont:[UIFont fontWithName:@"LifeSavers-Regular" size:call.titleLabel.font.pointSize]];
    [directions.titleLabel setFont:[UIFont fontWithName:@"LifeSavers-Regular" size:directions.titleLabel.font.pointSize]];
    
    // Initialize HUD
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    
	// Map Setup
	CLLocationCoordinate2D location = self.locationProvider.coordinate;
	
	// 30% buffer for showing this + the other location
	MKCoordinateSpan span;
	span.latitudeDelta = .05 + fabs(2.0 * (self.business.latitude - location.latitude));
	span.longitudeDelta = .01 + fabs(2.0 * (self.business.longitude - location.longitude));
	
	MKCoordinateRegion region;
	region.span = span;
	region.center = location;
	
	[mView setRegion:region animated:YES];
	[mView setDelegate:self];
	
	[mView addAnnotation:self.business];
	//[mView addAnnotation:self.locationProvider];
	[mView selectAnnotation:self.business animated:YES];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[self getUrl:self.business]];
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.HUD show:YES];
}

- (void)updateUI{
	// Set Title and Background
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
	[label setFont:[UIFont fontWithName:@"LifeSavers-Regular" size:20.0]];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:[UIColor whiteColor]];
	[label setText:self.business.name];
	[label setTextAlignment:NSTextAlignmentCenter];
    
	self.navigationItem.titleView = label;
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
	[name setText:self.business.name];
	[address setText:self.business.address];
    [hours setText:self.business.hours];
    [price setText:self.business.price];
	
    NSString * callText = [NSString stringWithFormat:@"Call: %@", self.business.phone];
	[call setTitle:callText forState:UIControlStateNormal];
	[call setTitle:callText forState:UIControlStateHighlighted];
	
	starRatings.rate = self.business.rating;
    
    [locationImg setImageWithURL:[NSURL URLWithString:self.business.image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

- (NSURL *)getUrl:(BusinessModel *)business {
    NSString * toReturn = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?key=%@&reference=%@&sensor=true", API_KEY, business.reference];
    NSLog(@"%@", toReturn);
    return [NSURL URLWithString:toReturn];
}

- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation:(id) annotation {
	MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
	if(annotation == self.business){
		customPinView.pinColor = MKPinAnnotationColorRed;
		customPinView.canShowCallout = YES;
	} else {
		customPinView.pinColor = MKPinAnnotationColorGreen;
	}
	customPinView.animatesDrop = YES;
	return customPinView;
}

- (IBAction) callClicked: (id)sender
{
	NSURL * phoneNumberURL = [NSURL URLWithString:self.business.phone];
	[[UIApplication sharedApplication] openURL:phoneNumberURL];
}

- (IBAction) mainClicked: (id)sender
{
    if(self.business.mobileUrl && self.business.mobileUrl.length > 0){
        DisplayWebpageViewController * display = [[DisplayWebpageViewController alloc] init];
        display.url = self.business.mobileUrl;
        [self.navigationController pushViewController:display animated:YES];
    }
}

- (IBAction) directionsClicked: (id)sender
{
	// Map Setup
	CLLocationCoordinate2D myLocation = self.locationProvider.coordinate;
	NSString* urlString = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f", myLocation.latitude, myLocation.longitude, self.business.latitude, self.business.longitude];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlString]];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.HUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Error"
                          message: @"A network error occurred!  Check your connection and try again"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.HUD hide:YES];
	NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self.responseData options: NSJSONReadingMutableContainers error: &e];
    
    if (!jsonArray) {
        UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Error"
							  message: @"A network error occurred!  Check your connection and try again"
							  delegate: nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
    } else {
        NSDictionary * business = jsonArray[@"result"];
        self.business.phone = business[@"formatted_phone_number"] ? business[@"formatted_phone_number"] : @"";

        NSArray * categoryArr = business[@"types"];
        NSMutableString * categories = [[NSMutableString alloc] init];
        for(NSString * categoryStr in categoryArr)
        {
            [categories appendString:categoryStr];
            if(category != [categoryArr lastObject])
            {
                [categories appendString:@", "];
            }
        }
        self.business.categories = categories;
        self.business.rating = business[@"rating"] ? [business[@"rating"] doubleValue ]: 0;
        
        NSMutableString * priceStr = [[NSMutableString alloc] init];
        if(business[@"price_level"]){
            int priceLevel = [business[@"price_level"] intValue];
            for(int i = 0; i < priceLevel; i++){
                [priceStr appendString:@"$"];
            }
        }
        self.business.price = priceStr;
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
        int weekday = [comps weekday] - 1;
        
        if(business[@"opening_hours"]) {
            if(business[@"opening_hours"][@"periods"]){
                NSArray * periods = business[@"opening_hours"][@"periods"];
                if(periods.count >= weekday) {
                    int open = -1;
                    int close = -1;
                    if(periods[weekday][@"open"]){
                        if(periods[weekday][@"open"][@"time"]){
                            open = [periods[weekday][@"open"][@"time"] intValue];
                        }
                    }
                    if(periods[weekday][@"close"]){
                        if(periods[weekday][@"close"][@"time"]){
                            close = [periods[weekday][@"close"][@"time"] intValue];
                        }
                    }
                    if(open != -1 && close != -1) {
                        self.business.hours = [NSString stringWithFormat:@"Hours: %@ - %@", [self getTimeString:open], [self getTimeString:close]];
                    }
                }
            }
        }
        if(business[@"photos"]) {
            NSArray * photosArr = business[@"photos"];
            if(photosArr.count > 0){
                self.business.image = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=true&key=%@", photosArr[0][@"photo_reference"], API_KEY];
            }
        
        }
        if(business[@"url"]){
            self.business.mobileUrl = business[@"url"];
            self.disclosureView.hidden = NO;
        } else {
            self.disclosureView.hidden = YES;
        }
        [self updateUI];
    }
}

- (NSString * )getTimeString:(int)time {
    if (time > 1200) {
        time = time - 1200;
        return [NSString stringWithFormat:@"%d:%.2d %@", time / 100, time - ((time / 100) * 100), @"PM"];
    } else { 
        return [NSString stringWithFormat:@"%d:%.2d %@", time / 100, time - ((time / 100) * 100), @"AM"];
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    starRatings = nil;
    hours = nil;
    price = nil;
    directions = nil;
    [self setDisclosureView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
     return YES;
 }
 

@end
