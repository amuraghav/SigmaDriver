//
//  UpdateBookingStatus.h
//  Roadyo
//
//  Created by Surender Rathore on 07/08/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateBookingStatus : NSObject
@property(strong,nonatomic) NSTimer *statusUpdateTimer; // will call updateToPassengerForDriverState in every 5 seconds
@property(assign,nonatomic) int iterations;                 // number of times a status should send.
@property(nonatomic,assign) PubNubStreamAction driverState; // set value for driver state i.e on the way/reached/completed
@property(nonatomic,assign) CancelBookingReasons cancelBookingReason;

/*!
 *  Shared instance
 *
 *  @return object of UpdateBookingStatus
 */
+ (id)sharedInstance;

/*!
 *  stop updating status of booking to pubnub
 */
-(void)stopUpdatingStatus;
/*!
 *  start updating current booking sttus to pubnub
 */
-(void)startUpdatingStatus;

/*!
 *  compose message to send on pubnub also send message to pubnub
 */
-(void)updateToPassengerForDriverState;
@end


/*
 
 How to use
 
 UpdateBookingStatus *updateBookingStatus = [UpdateBookingStatus sharedInstance];
 updateBookingStatus.driverState = state;
 [updateBookingStatus updateToPassengerForDriverState];
 [updateBookingStatus startUpdatingStatus];
 
 */