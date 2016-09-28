//
//  CKCalendarEvent.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKCalendarEvent : NSObject


@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *title;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *appDate;
@property (nonatomic,strong)NSString *notes;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *pickAdd;
@property (nonatomic,strong)NSString *desAdd;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *distance;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, assign) BOOL isAvailable;
@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *status;



+(CKCalendarEvent *)eventWithTitle:(NSString *)title andDate:(NSDate *)date andInfo:(NSDictionary *)info;

+(CKCalendarEvent *)eventWithTitle:(NSString *)title;

@end
