//
//  CheckBookingStatus.m
//  Roadyo
//
//  Created by Surender Rathore on 27/06/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "CheckBookingStatus.h"

@implementation CheckBookingStatus
@synthesize callblock;
static CheckBookingStatus  *bookingStatus;

+ (id)sharedInstance {
	if (!bookingStatus) {
		bookingStatus  = [[self alloc] init];
	}
	
	return bookingStatus;
}


-(void)checkOngoingAppointmentStatus:(NSString *)appDate {
    
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    NSString *deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    NSString *appointmntDate; //= appDate;
    NSString *appointmntId;
    if (appDate == nil) {
        appointmntDate = @"";
        appointmntId=@"";
    }
    
    
    
    NSLog(@"%@%@%@",sessionToken,deviceID,appointmntDate);
    NSString *currentDate = [Helper getCurrentDateTime];
    // NSString *appointmentId = passDetail[@"bid"];
   //
    NSDictionary *params = @{@"ent_sess_token":sessionToken,
                        @"ent_dev_id":deviceID,
                             @"ent_user_type":@"1",
                             @"ent_appnt_dt":appointmntDate,
                             @"ent_date_time":currentDate,
                             @"ent_appnt_id":appointmntId,
                             };
    NSLog(@"%@",params);
    //getApptStatus
    TELogInfo(@"kSMGetAppointmentDetial %@",params);
    //setup request
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    
    [networHandler cancelRequest];
    
    [networHandler composeRequestWithMethod:@"getApptStatus"
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   
                                   if (success) { //handle success response
                                       TELogInfo(@"response %@",response);
                                       [self parsepollingResponse:response];
                                       
                                   }
                                   else{
                                       self.callblock(0,nil);
                                   }
                               }];
    
}
-(void)parsepollingResponse:(NSDictionary *)responseDict{
    
    NSLog(@"dictionary%@",responseDict);
   
    if (responseDict == nil) {
        return;
    }
    else if ([responseDict objectForKey:@"Error"])
    {
        [Helper showAlertWithTitle:@"Error" Message:[responseDict objectForKey:@"Error"]];
    }
    else
    {
        if ([[responseDict objectForKey:@"errFlag"] integerValue] == 0)
        {
            //if ([responseDict[@"status"] integerValue]) {
            //    int status = [responseDict[@"data"][@"status"]integerValue];
            NSDictionary *response = responseDict[@"data"][0];
            int status = [response[@"status"] intValue];
                self.callblock(status,response);
            //}
        }
        else
        {
            self.callblock(0,nil);
        }
    }
}

@end
