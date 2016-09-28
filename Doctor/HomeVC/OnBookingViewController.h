//
//  OnBookingViewController.h
//  Roadyo
//
//  Created by Rahul Sharma on 01/05/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnBookingViewController : UIViewController
{
    IBOutlet UILabel *lblNameTitle;
    IBOutlet UILabel *lblMobileTitle;
    IBOutlet UILabel *lblPickupTitle;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblMobile;
    IBOutlet UILabel *lblPickUp;
    IBOutlet UILabel *lblETATitle;
    IBOutlet UILabel *lblETA;
    IBOutlet UILabel *lblDistanceTitle;
    IBOutlet UILabel *lblDistance;
    IBOutlet UIButton *btnArrival;
    IBOutlet UIImageView *imgPass;
    IBOutlet UIView *viewPassDetail;
    IBOutlet UIView *viewStatus;
    
    NSString *IsPopLock;
}
-(IBAction)buttonAction:(id)sender;
@property(strong,nonatomic)NSMutableDictionary *passDetail;
@property(nonatomic,assign)BookingNotificationType bookingStatus;
@end
