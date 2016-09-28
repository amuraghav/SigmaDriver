//
//  CheckBookingStatus.h
//  Roadyo
//
//  Created by Surender Rathore on 27/06/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CheckBookingStatusCallback)(int status , NSDictionary *dictionary);
@interface CheckBookingStatus : NSObject
@property(nonatomic,copy)CheckBookingStatusCallback callblock;
+ (id)sharedInstance;
-(void)checkOngoingAppointmentStatus:(NSString *)appDate;
@end
