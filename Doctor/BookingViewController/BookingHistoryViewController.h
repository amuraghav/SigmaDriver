//
//  BookingHistoryViewController.h
//  Roadyo
//
//  Created by Rahul Sharma on 07/05/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingHistoryViewController : UIViewController
{
    IBOutlet UIButton *btnComplete;
    IBOutlet UILabel *lblCurrentDateTime;
    IBOutlet UILabel *lbljournyTitle;
    IBOutlet UILabel *passngerName;
    IBOutlet UIImageView *imgPassnegr;
    IBOutlet UILabel *lblPickUpTitle;
    IBOutlet UILabel *lblDropTitle;
    IBOutlet UILabel *lblPickUp;
    IBOutlet UILabel *lblDropOff;
    IBOutlet UILabel * LblDistancetitle;
    IBOutlet UILabel * LblDistance;
    IBOutlet UILabel *lblpickUpTimeTtl;
    IBOutlet UILabel *lblDropOffTimeTtl;
    IBOutlet UILabel *lblPickUpTime;
    IBOutlet UILabel *lblDropOffTime;
    IBOutlet UILabel *lblTotalTimeTitle;
    IBOutlet UILabel *lblTotalTime;
    IBOutlet UILabel *lblRateYourRide;
    IBOutlet UILabel *lblAmount;
    IBOutlet UIView *bottomView;

  
}
@property(nonatomic,strong)NSString *IspopLock;
@property(nonatomic,strong)NSString *dropLocation;
@property(nonatomic,strong)NSString *dropArea;
@property(nonatomic,strong)NSString *approxPrice;
@property(nonatomic,assign) CLLocationCoordinate2D destinationCoordinates;
@property(strong,nonatomic)NSMutableDictionary *passDetail;
-(IBAction)buttonAction:(id)sender;
-(IBAction)buttonActionForRation:(id)sender;


@end
