//
//  AppointmentDates.h
//  Roadyo
//
//  Created by Surender Rathore on 26/06/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Appointments.h"
@interface AppointmentDates : NSObject
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)Appointments *appt;
@end
