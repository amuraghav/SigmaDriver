//
//  User.m
//  privMD
//
//  Created by Surender Rathore on 19/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "User.h"
//#import "Database.h"
#import "PMDReachabilityWrapper.h"
#import "NetworkHandler.h"


@implementation User
@synthesize delegate;
@synthesize blurredImage;
@synthesize profileImage;
@synthesize name;
@synthesize email;
@synthesize phone;


static User  *user;

+ (id)sharedInstance {
	if (!user) {
		user  = [[self alloc] init];
	}
	
	return user;
}


- (void)logout
{
   
   
    ResKitWebService * rest = [ResKitWebService sharedInstance];
    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                   [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken],KDAcheckUserSessionToken,
                   [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPCommonDevideId,
                   [NSNumber numberWithInt:1],kSMPPassengerUserType,
                   [Helper getCurrentDateTime],kSMPCommonUpDateTime, nil];
    
    TELogInfo(@"param%@",queryParams);
    
    
    [rest composeRequestForLogOut:MethodLogout
                                   paramas:queryParams
                              onComplition:^(BOOL success, NSDictionary *response){
                                  
                                  if (success) { //handle success response
                                      [self userLogoutResponse:(NSArray*)response];
                                  }
                                  else{//error
                                      
                                  }
                              }];
    

    
}



- (void) userLogoutResponse:(NSArray *)response
{
    
   // TELogInfo(@"_response%@",response);
    Errorhandler * handler = [response objectAtIndex:0];
    
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    
    if ([[handler errFlag] intValue] ==0) {
        
        if (delegate && [delegate respondsToSelector:@selector(userDidLogoutSucessfully:)]) {
            [delegate userDidLogoutSucessfully:YES];
           
        }
        
        
    }
    else if ([[handler errFlag] intValue] ==1)
    {
        if (delegate && [delegate respondsToSelector:@selector(userDidLogoutSucessfully:)]) {
            [delegate userDidLogoutSucessfully:YES];
        }
        
    }

    else
    {
        [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
    }
    

    
   }


-(void)deleteUserSavedData{
    
    //delete all saved cards
    //[Database deleteAllCard];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KDAcheckUserSessionToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
