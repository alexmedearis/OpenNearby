//
//  PlacesListViewController.h
//  StillOpen
//
//  Created by Alexander Medearis on 6/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "DataProvider.h"
#import "DataReceiver.h"
#import "MBProgressHUD.h"
#import "PullToRefreshView.h"

@interface PlacesListViewController : UIViewController<DataReceiver, PullToRefreshViewDelegate, ADBannerViewDelegate> {
	IBOutlet UITableView * tView;
	IBOutlet UIButton * reloadButton;
    BOOL haveReceivedData;
}

@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;
@property (strong) DataProvider * dataProvider;
@property (strong) NSMutableArray * openBusinesses;
@property (strong) MBProgressHUD * HUD;
@property (strong) PullToRefreshView * pull;

- (void) dataReceived:(NSMutableArray *) _openBusinesses;
- (void) locationReceived;
- (void) reload;


@end
