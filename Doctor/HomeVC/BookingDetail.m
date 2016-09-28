//
//  BookingDetail.m
//  Roadyo
//
//  Created by Surender Rathore on 12/07/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "BookingDetail.h"
#import "passDetail.h"

@interface BookingDetail(){
   
}
@property(nonatomic,strong)NSMutableDictionary *bookingDetail;
@end
@implementation BookingDetail


static BookingDetail  *bookingDetail;
@synthesize callback;
+ (id)sharedInstance {
	if (!bookingDetail) {
		bookingDetail  = [[self alloc] init];
	}
	
	return bookingDetail;
}



-(void)sendBookingDetailRequest
{
    ResKitWebService * rest = [ResKitWebService sharedInstance];
    NSDictionary *queryParams= nil;
    NSDictionary * dictP = [[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH"];
   // NSDictionary * dictP = [dict objectForKey:@"aps"];
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                   [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken],KDAcheckUserSessionToken,
                   [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPCommonDevideId,
                   [dictP objectForKey:@"e"],kSMPSignUpEmail,
                   [dictP objectForKey:@"dt"], kSMPRespondBookingDateTime,
                   [dictP objectForKey:@"bid"],kSMPRespondDocbid,
                   constkNotificationTypeBookingType,kSMPPassengerUserType,
                   [Helper getCurrentDateTime],kSMPCommonUpDateTime, nil];
    
    TELogInfo(@"param%@",queryParams);
    [rest composeRequestForPassengerDetail:MethodAppointmentDetail
                                   paramas:queryParams
                              onComplition:^(BOOL success, NSDictionary *response){
                                  if (success) { //handle success response
                                      [self passengerDetailResponse:(NSArray*)response];
                                  }
                                  else{//error
                                      if (callback) {
                                          callback(nil,NO,nil);
                                      }
                                  }
                              }];
    
    
    
}

-(void)passengerDetailResponse:(NSArray*)response
{
    Errorhandler * handler = [response objectAtIndex:0];
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    
    if ([[handler errFlag] intValue] ==0)
    {
        passDetail * profile = handler.objects;
        
        
        _bookingDetail = [[NSMutableDictionary alloc]init];
        [_bookingDetail setObject:profile.fName forKey:@"fName"];
        [_bookingDetail setObject:profile.lName forKey:@"lName"];
        [_bookingDetail setObject:profile.mobile forKey:@"mobile"];
        [_bookingDetail setObject:profile.addr1 forKey:@"addr1"];
        [_bookingDetail setObject:profile.addr2 forKey:@"addr2"];
        [_bookingDetail setObject:profile.amount forKey:@"amount"];
        [_bookingDetail setObject:profile.fare forKey:@"fare"];
        [_bookingDetail setObject:profile.dis forKey:@"dis"];
        [_bookingDetail setObject:profile.dur forKey:@"dur"];
        [_bookingDetail setObject:profile.pPic  forKey:@"pPic"];
        [_bookingDetail setObject:profile.dropAddr1 forKey:@"dropAddr1"];
        [_bookingDetail setObject:profile.dropAddr2 forKey:@"dropAddr2"];
        [_bookingDetail setObject:profile.pickLat forKey:@"pickLat"];
        [_bookingDetail setObject:profile.pickLong forKey:@"pickLong"];
        [_bookingDetail setObject:profile.dropLat forKey:@"dropLat"];
        [_bookingDetail setObject:profile.dropLong forKey:@"dropLong"];
        [_bookingDetail setObject:profile.apptDis forKey:@"apptDis"];
        [_bookingDetail setObject:profile.apptDt forKey:@"apptDt"];
        [_bookingDetail setObject:profile.email forKey:@"email"];
        [_bookingDetail setObject:profile.bid forKey:@"bid"];
        [_bookingDetail setObject:profile.pasChn forKey:@"pasChn"];
        
        if (callback)
        {
            callback(_bookingDetail,YES,handler);
        }
    }
    else
    {
        
        if (callback)
        {
            callback(nil,NO,handler);
        }
        
    }
    
}
-(NSDictionary*)getBookingDetail{
    return [_bookingDetail copy];
}

@end
