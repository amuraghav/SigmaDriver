//
//  AppointedDoctor.h
//  privMD
//
//  Created by Surender Rathore on 26/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointedDoctor : NSObject
@property(nonatomic,strong)NSString *doctorName;
@property(nonatomic,strong)NSString *appoinmentDate;
@property(nonatomic,strong)NSString *contactNumber;
@property(nonatomic,strong)NSString *profilePicURL;
@property(nonatomic,strong)NSString *distance;
@property(nonatomic,strong)NSString *estimatedTime;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *status;
@end
