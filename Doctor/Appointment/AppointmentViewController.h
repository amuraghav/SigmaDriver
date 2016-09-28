//
//  AppointmentViewController.h
//  privMD
//
//  Created by Rahul Sharma on 10/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarKit.h"

@interface AppointmentViewController : UIViewController<CKCalendarViewDataSource,CKCalendarViewDelegate>

@property (nonatomic, strong) CKCalendarView *calendar;


@end
