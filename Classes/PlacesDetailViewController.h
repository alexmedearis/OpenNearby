//
//  PlacesDetailViewController.h
//  StillOpen
//
//  Created by Alexander Medearis on 7/5/10.
//  Copyright 2010 Alex Medearis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusinessModel.h"
#import "LocationProvider.h"
#import "DYRateView.h"
#import "MBProgressHUD.h"


@interface PlacesDetailViewController : UIViewController<MKMapViewDelegate> {
	IBOutlet MKMapView * mView;
	IBOutlet UILabel * name;
	IBOutlet UILabel * address;
	IBOutlet UILabel * category;
	IBOutlet UIImageView * locationImg;
    IBOutlet DYRateView *starRatings;
    IBOutlet UILabel *hours;
    IBOutlet UILabel *price;
	IBOutlet UIButton * main;
	IBOutlet UIButton * call;
}

@property (strong) LocationProvider * locationProvider;
@property (strong) BusinessModel * business;
@property (strong) NSURLConnection * connection;
@property (strong) NSMutableData * responseData;
@property (strong) MBProgressHUD * HUD;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
			 business:(BusinessModel *)_business locationProvider:(LocationProvider *)_locationProvider;
- (IBAction) callClicked: (id)sender;
- (IBAction) mainClicked: (id)sender;
- (IBAction) directionsClicked: (id)sender;

@end
