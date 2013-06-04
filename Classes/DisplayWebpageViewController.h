//
//  DisplayWebpageViewController.h
//  StillOpen
//
//  Created by Andy Dufresne on 6/4/13.
//
//

#import <UIKit/UIKit.h>

@interface DisplayWebpageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong) NSString * url;
@end
