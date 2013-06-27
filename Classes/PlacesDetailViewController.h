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

}

@property (weak, nonatomic) IBOutlet UILabel *disclosureView;
@property (weak, nonatomic) IBOutlet MKMapView * mView;
@property (weak, nonatomic) IBOutlet UILabel * name;
@property (weak, nonatomic) IBOutlet UILabel * address;
@property (weak, nonatomic) IBOutlet UILabel * category;
@property (weak, nonatomic) IBOutlet UIImageView * locationImg;
@property (weak, nonatomic) IBOutlet DYRateView *starRatings;
@property (weak, nonatomic) IBOutlet UILabel *hours;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton * main;
@property (weak, nonatomic) IBOutlet UIButton * call;
@property (weak, nonatomic) IBOutlet UIButton * directions;

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
