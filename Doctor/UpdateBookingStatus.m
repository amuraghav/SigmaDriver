//
//  UpdateBookingStatus.m
//  Roadyo
//
//  Created by Surender Rathore on 07/08/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "UpdateBookingStatus.h"
#import "PatientPubNubWrapper.h"
#import "LocationTracker.m"


@interface UpdateBookingStatus()
@property(nonatomic,strong)NSMutableDictionary *message;
@end
static UpdateBookingStatus *updateBookingStatus;

@implementation UpdateBookingStatus
@synthesize statusUpdateTimer;
@synthesize driverState;

+ (id)sharedInstance {
	if (!updateBookingStatus) {
    
		updateBookingStatus  = [[self alloc] init];
        [updateBookingStatus initlize];
	}
    
    
    
	return updateBookingStatus;
}
-(void)initlize{
    //_iterations = -1;
    _message = [[NSMutableDictionary alloc] init];
}
-(void)startUpdatingStatus{
    if(![statusUpdateTimer isValid]){
        statusUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateToPassengerForDriverState) userInfo:nil repeats:YES];
    }
}
-(void)stopUpdatingStatus{
    
    if (_iterations < 0) {
//        [mes]
        if ([statusUpdateTimer isValid]) {
            [statusUpdateTimer invalidate];
        }
    }
    
    
}
-(void)updateToPassengerForDriverState{
    
    if (_iterations == 0) {
        
       // _message = nil;
        if ([statusUpdateTimer isValid]) {
            [statusUpdateTimer invalidate];
        }
        return;
    }
    
    _iterations --;
    
    
    
    NSLog(@"updateToPassengerForDriverState :%d",driverState);
    
    
    PatientPubNubWrapper *pubNub = [PatientPubNubWrapper sharedInstance];
    
    NSString *passengerChannel = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPassengerChannelKey];
    
    NSString *bid = [[NSUserDefaults standardUserDefaults] objectForKey:@"bid"];
    
    NSDictionary * dictP = [[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH"];
    
    NSString *driverChannel = [[NSUserDefaults standardUserDefaults] objectForKey:kNSURoadyoSubscribeChanelKey];
    NSString *driverEmail = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPatientEmailAddressKey];
    
    
    LocationTracker *locaitontraker = [LocationTracker sharedInstance];
    
    float latitude = locaitontraker.lastLocaiton.coordinate.latitude;
    float longitude = locaitontraker.lastLocaiton.coordinate.longitude;
    
    
   // if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isBooked"]) {
        
        
        [_message setObject:[NSNumber numberWithInt:driverState] forKey:@"a"];
        [_message setObject:driverEmail forKey:@"e_id"];
        [_message setObject:[NSNumber numberWithDouble:latitude] forKey:@"lt"];
        [_message setObject:[NSNumber numberWithDouble:longitude] forKey:@"lg"];
        [_message setObject:driverChannel forKey:@"chn"];
    if(dictP){
        [_message setObject:dictP[@"dt"] forKey:@"dt"];
        
    }
        [_message setObject:bid forKey:@"bid"];
    if (driverState == kPubNubDriverCancelBooking) {
        [_message setObject:[NSNumber numberWithInt:_cancelBookingReason] forKey:@"r"];
    }
        
       
        
   // }
    
    [pubNub sendMessageAsDictionary:_message toChannel:passengerChannel];
    
}
@end
