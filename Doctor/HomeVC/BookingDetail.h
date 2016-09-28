//
//  BookingDetail.h
//  Roadyo
//
//  Created by Surender Rathore on 12/07/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BookingDetailCallback) (NSDictionary *bookingDetail,BOOL success ,Errorhandler *errorHandler);

@interface BookingDetail : NSObject


@property(nonatomic,copy)BookingDetailCallback callback;

+ (id)sharedInstance;

-(NSDictionary*)getBookingDetail;

-(void)sendBookingDetailRequest;

@end
