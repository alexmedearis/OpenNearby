//
//  PlacesListViewController.h
//  StillOpen
//
//  Created by Alexander Medearis on 6/26/10.
//  Copyright 2010 Alex Medearis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "DataProvider.h"
#import "DataReceiver.h"
#import "MBProgressHUD.h"
#import "PullToRefreshView.h"

@interface PlacesListViewController : UIViewController<DataReceiver, PullToRefreshViewDelegate, ADBannerViewDelegate> {

}

@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;
@property (weak, nonatomic) IBOutlet UITableView * tView;
@property (weak, nonatomic) IBOutlet UIButton * reloadButton;
@property (nonatomic) BOOL haveReceivedData;

@property (strong) DataProvider * dataProvider;
@property (strong) NSMutableArray * openBusinesses;
@property (strong) MBProgressHUD * HUD;
@property (strong) PullToRefreshView * pull;

- (void) dataReceived:(NSMutableArray *) _openBusinesses;
- (void) locationReceived;
- (void) reload;


@end
