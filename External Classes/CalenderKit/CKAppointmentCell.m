//
//  CKAppointmentCell.m
//  privMD
//
//  Created by Rahul Sharma on 27/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "CKAppointmentCell.h"
#define imageOffset 2.5
@implementation CKAppointmentCell
@synthesize docApptImage;
@synthesize docApptName;
@synthesize docApptAddr;
@synthesize docApptDropAddr;
@synthesize  appDateTime;
@synthesize distance;
@synthesize totalAmount;
@synthesize imgDistance;
@synthesize imgDropLocation;
@synthesize imgPickLocation;
@synthesize imgTime;
@synthesize activityIndicator;
@synthesize status;
@synthesize paymentStatus;
@synthesize separator;
//@synthesize paymentBy;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {// Initialization code
        if(!docApptImage)
        {
            docApptImage = [[RoundedImageView alloc]initWithFrame:CGRectMake(10,10,60,60)];
            [self.contentView addSubview:docApptImage];
        }
        
        if(!totalAmount) //total amount field
        {
            totalAmount = [[UILabel alloc]initWithFrame:CGRectMake(10,80,60,30)];
            [Helper setToLabel:totalAmount Text:@"$" WithFont:Robot_Regular FSize:14 Color:UIColorFromRGB(0x000000)];
            [self.contentView addSubview:totalAmount];
        }
        if (!paymentStatus) {
            
            paymentStatus = [[UILabel alloc]initWithFrame:CGRectMake(10,130,60,30)];
            [Helper setToLabel:paymentStatus Text:@"" WithFont:Robot_Bold FSize:12 Color:[UIColor colorWithRed:0.097 green:0.655 blue:0.178 alpha:1.000]];
            [self.contentView addSubview:paymentStatus];
            
        }
        
//        if (!paymentBy) {
//            
//            paymentBy = [[UILabel alloc]initWithFrame:CGRectMake(10,130,60,30)];
//            [Helper setToLabel:paymentBy Text:@"" WithFont:Robot_Bold FSize:12 Color:[UIColor colorWithRed:0.741 green:0.066 blue:0.064 alpha:1.000]];
//            [self.contentView addSubview:paymentBy];
//            
//        }
        if(!docApptName) //driver name
        {
            docApptName = [[UILabel alloc]initWithFrame:CGRectMake(80, 4, 200, 20)];
            [Helper setToLabel:docApptName Text:@"" WithFont:Robot_Regular FSize:15 Color:UIColorFromRGB(0x000000)];
            [self.contentView addSubview:docApptName];
        }
        if(!appDateTime)
        {
                        appDateTime = [[UILabel alloc]initWithFrame:CGRectMake(80,docApptName.frame.origin.y+docApptName.frame.size.height, 60, 20)];
                        [Helper setToLabel:appDateTime Text:@"" WithFont:Robot_Regular FSize:12 Color:UIColorFromRGB(0x000000)];
                        [self.contentView addSubview:appDateTime];
        }
        if(!separator)
        {
            separator = [[UILabel alloc]initWithFrame:CGRectMake(140,docApptName.frame.origin.y+docApptName.frame.size.height, 3, 20)];
            [Helper setToLabel:separator Text:@"|" WithFont:Robot_Regular FSize:12 Color:UIColorFromRGB(0x000000)];
            [self.contentView addSubview:separator];
        }
        
        if(!distance) //distance
        {
                        distance = [[UILabel alloc]initWithFrame:CGRectMake(160,docApptName.frame.origin.y+docApptName.frame.size.height, 50, 20)];
                        [Helper setToLabel:distance Text:@"" WithFont:Robot_Regular FSize:12 Color:UIColorFromRGB(0x000000)];
            
                        [self.contentView addSubview:distance];
        }
        if(!imgPickLocation) //pick
        {
            imgPickLocation = [[UILabel alloc]initWithFrame:CGRectMake(80, appDateTime.frame.origin.y+appDateTime.frame.size.height, 200, 20)];
            [Helper setToLabel:imgPickLocation Text:@"Pickup Location" WithFont:Robot_Regular FSize:15 Color:UIColorFromRGB(0x000000)];
            [self.contentView addSubview:imgPickLocation];
        }
     
        if(!docApptAddr)//pick
        {
            docApptAddr = [[UILabel alloc]initWithFrame:CGRectMake(80,imgPickLocation.frame.origin.y+imgPickLocation.frame.size.height, 200,40)];
            [Helper setToLabel:docApptAddr Text:@"" WithFont:Robot_Regular FSize:12 Color:UIColorFromRGB(0x000000)];
            docApptAddr.numberOfLines = 2;
            
            [self.contentView addSubview:docApptAddr];
        }
        if(!imgDropLocation)//drop
        {
            imgDropLocation = [[UILabel alloc]initWithFrame:CGRectMake(80, docApptAddr.frame.origin.y+docApptAddr.frame.size.height, 200, 20)];
            [Helper setToLabel:imgDropLocation Text:@"Dropoff Location" WithFont:Robot_Regular FSize:15 Color:UIColorFromRGB(0x000000)];
            [self.contentView addSubview:imgDropLocation];
        }
        if(!docApptDropAddr)//drop
        {
            docApptDropAddr = [[UILabel alloc]initWithFrame:CGRectMake(80,imgDropLocation.frame.origin.y+imgDropLocation.frame.size.height-5, 200,40)];
            [Helper setToLabel:docApptDropAddr Text:@"" WithFont:Robot_Regular FSize:12 Color:UIColorFromRGB(0x000000)];
            docApptDropAddr.numberOfLines = 2;
            
            [self.contentView addSubview:docApptDropAddr];
        }
        
        if(!imgDistance)
        {
//            UIImage *img = [UIImage imageNamed:@"calender_miles_icon"];
//            imgDistance = [[UIImageView alloc]initWithFrame:CGRectMake(80,docApptDropAddr.frame.origin.y+docApptDropAddr.frame.size.height+imageOffset,15, 15)];
//            imgDistance.image = img;
//            [self.contentView addSubview:imgDistance];
        }
        

        
        if(!imgTime)
        {
//            UIImage *img = [UIImage imageNamed:@"calender_time_icon"];
//            imgTime = [[UIImageView alloc]initWithFrame:CGRectMake(80,distance.frame.origin.y+distance.frame.size.height+imageOffset,15, 15)];
//            imgTime.image = img;
//            [self.contentView addSubview:imgTime];
        }

        if(!status)
        {
            status = [[UILabel alloc]initWithFrame:CGRectMake(80,docApptDropAddr.frame.origin.y+docApptDropAddr.frame.size.height, 200, 20)];
            [Helper setToLabel:status Text:@"" WithFont:Robot_Bold FSize:14 Color:UIColorFromRGB(0x000000)];
            [self.contentView addSubview:status];
        }
        
        activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(60/2-20/2, 60/2-20/2, 20, 20)];
        [self.docApptImage addSubview:activityIndicator];
        // activityIndicator.backgroundColor=[UIColor greenColor];
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
