//
//  HomeViewController.h
//  Doctor
//
//  Created by Rahul Sharma on 17/04/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAPageIndicatorView.h"
#import <GoogleMaps/GoogleMaps.h>
#import "ViewPagerController.h"
#import "PICircularProgressView.h"
#import "DCRoundSwitch.h"


@interface HomeViewController : UIViewController<UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,UIGestureRecognizerDelegate,GMSMapViewDelegate>
{
    IBOutlet UIButton *btnAccept;
    IBOutlet UIButton *btnReject;
    IBOutlet UILabel *labelPickupTitle;
    IBOutlet UILabel *labelDropOffTitle;
    IBOutlet UILabel *labelPickeup;
    IBOutlet UILabel *labelDropOff;
    IBOutlet UILabel *labelPickUpdistance;
    IBOutlet UILabel *labelDropOffdistance;
    IBOutlet UILabel *labelDropOffMile;
    IBOutlet UILabel *labelPickUpMile;
    IBOutlet UILabel *labelStatus;
    NSMutableDictionary * dictpassDetail;

    
    UIButton *bookButton;
    UIView *bookviewoff;
    UIView *bgview;
    UILabel *titlelbl;
    
    
    
    
    UILabel *titllstatusOnOff;
    UILabel *labelcarNumber;
    
    


    IBOutlet UIView *viewPushPopUp;
    ViewPagerController *viewPage;
    BOOL isPassangeBookDriver;
    
    NSString *carName;
    NSString *carNumber;
    
    
    NSString *addressStr;
    NSString *strcurrentAddress;
    
    
    
}
@property (nonatomic) CLLocationCoordinate2D myLastLocation;


@property (nonatomic, retain)DCRoundSwitch *switchOnOff;
@property(nonatomic,assign)DriverStatus driverStatus;
@property(strong,nonatomic)NSDictionary * dictPush;
@property(strong,nonatomic)NSTimer * timer;
@property(assign,nonatomic)int counter;
@property (strong, nonatomic) IBOutlet PICircularProgressView *progressView;
-(IBAction)doctorAvalabilityClicked:(id)sender;

@end
