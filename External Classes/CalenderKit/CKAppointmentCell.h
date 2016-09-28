//
//  CKAppointmentCell.h
//  privMD
//
//  Created by Rahul Sharma on 27/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedImageView.h"
#import "TQStarRatingView.h"
@interface CKAppointmentCell : UITableViewCell

@property(strong,nonatomic) RoundedImageView *docApptImage;
@property(strong,nonatomic) UILabel *docApptAddr;
@property(strong,nonatomic) UILabel *docApptName;
@property(strong,nonatomic) UILabel *appDateTime;
@property(strong,nonatomic) UILabel *docApptDropAddr;
@property(strong,nonatomic) UILabel *distance;
@property(strong,nonatomic) UILabel *totalAmount;
@property(strong,nonatomic) UILabel *imgPickLocation;
@property(strong,nonatomic) UILabel *imgDropLocation;
@property(strong,nonatomic) UILabel *separator;
@property(strong,nonatomic) UILabel *imgDistance;
@property(strong,nonatomic) UIImageView *imgTime;
@property(strong,nonatomic) UILabel *status;
@property(strong,nonatomic) UILabel *paymentStatus;
//@property(strong,nonatomic) UILabel *paymentBy;

@property(strong, nonatomic)  UIActivityIndicatorView *activityIndicator;

@end
