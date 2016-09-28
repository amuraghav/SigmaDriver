//
//  PassangerDroppedViewController.h
//  Roadyo
//
//  Created by Rahul Sharma on 07/05/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassangerDroppedViewController : UIViewController
{
    IBOutlet UILabel *lblNameTitle;
    IBOutlet UILabel *lblMobileTitle;
    IBOutlet UILabel *lblPickupTitle;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblMobile;
    IBOutlet UILabel *lblPickUp;
    IBOutlet UIButton *btnArrival;
    IBOutlet UIImageView *imgPass;
    IBOutlet UIView *viewPassDetail;
    IBOutlet UIView *viewStatus;
    IBOutlet UILabel *lblETATitle;
    IBOutlet UILabel *lblETA;
    IBOutlet UILabel *lblDistanceTitle;
    IBOutlet UILabel *lblDistance;


}
-(IBAction)buttonAction:(id)sender;
@property(strong,nonatomic)NSMutableDictionary *passDetail;
@end
