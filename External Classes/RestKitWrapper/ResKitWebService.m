        //
//  ResKitWebService.m
//  Roadyo
//
//  Created by Rahul Sharma on 05/05/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "ResKitWebService.h"
#import <RestKit/RestKit.h>
#import "Errorhandler.h"
#import "Cartype.h"
#import "AppConstants.h"
#import "Login.h"
#import "SignUp.h"
#import "profile.h"
#import "Upload.h"
#import "Appointments.h"
#import "AppointmentDates.h"
#import "passDetail.h"
#import "AppConstants.h"

@implementation ResKitWebService
//@synthesize delegate;

static ResKitWebService *webservice;

+ (id)sharedInstance {
	if (!webservice) {
		webservice  = [[self alloc] init];
	}
	
	return webservice;
}

-(AFHTTPClient*)getBaseUrlStringWithHttpClient
{
    
    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",BASE_URL_RESTKIT]];
    AFHTTPClient * client = [AFHTTPClient clientWithBaseURL:baseURL];
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    return client;
}


-(void)composeRequestForcarTypeWithMethod:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock
{
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:[self getBaseUrlStringWithHttpClient]];
    
    RKObjectMapping *ErrorMapping = [RKObjectMapping mappingForClass:[Errorhandler class]];
    [ErrorMapping addAttributeMappingsFromDictionary:@{ @"errNum": @"errNum", @"errFlag": @"errFlag", @"errMsg": @"errMsg",@"objects":@"types"}];
    
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Cartype class]];
    
    
    [locationMapping addAttributeMappingsFromDictionary:@{ @"company_id": @"company_id", @"companyname": @"companyname"}];
    
    [ErrorMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"types" toKeyPath:@"objects" withMapping:locationMapping]];
    
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ErrorMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"%@%@",BASE_URL,method]
                         parameters:nil
                            success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         //TELogInfo (@"result%@",response);
         response = [mappingResult array];
         NSDictionary * dictResponse = (NSDictionary*)response;
         completionBlock(YES,dictResponse);
         
         
     }
    failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
        completionBlock(NO,nil);
     }];
    
    
}

-(void)composeRequestForLoginWithMethod:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary  *response))completionBlock
{
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:[self getBaseUrlStringWithHttpClient]];
    
    RKObjectMapping *ErrorMapping = [RKObjectMapping mappingForClass:[Errorhandler class]];
    [ErrorMapping addAttributeMappingsFromDictionary:@{ @"errNum": @"errNum", @"errFlag": @"errFlag", @"errMsg": @"errMsg",@"objects":@"data"}];
    
    RKObjectMapping *loginMapping = [RKObjectMapping mappingForClass:[Login class]];
    
    
    [loginMapping addAttributeMappingsFromDictionary:@{ @"token": @"token", @"expiryLocal": @"expiryLocal", @"expiryGMT": @"expiryGMT", @"flag": @"flag", @"joined": @"joined", @"chn": @"chn", @"email": @"email", @"mFlg": @"mFlg",@"susbChn":@"susbChn",@"listner":@"listner",@"status":@"status",@"car_type_name":@"car_type_name"}];
    
    [ErrorMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"objects" withMapping:loginMapping]];
    
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ErrorMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass                (RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    
    [objectManager postObject:BASE_IP path:method parameters:paramas success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
   
        response = [mappingResult array];
        NSDictionary * dictResponse = (NSDictionary*)response;
        completionBlock(YES,dictResponse);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {

         completionBlock(NO,nil);
    }];
//    
    
}
-(void)composeRequestForSignUpWithMethod:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock
{
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:[self getBaseUrlStringWithHttpClient]];
    RKObjectMapping *ErrorMapping = [RKObjectMapping mappingForClass:[Errorhandler class]];
    [ErrorMapping addAttributeMappingsFromDictionary:@{ @"errNum": @"errNum", @"errFlag": @"errFlag", @"errMsg": @"errMsg",@"objects":@"data"}];
    RKObjectMapping *signupMapping = [RKObjectMapping mappingForClass:[SignUp class]];
    [signupMapping addAttributeMappingsFromDictionary:@{ @"token": @"token", @"expiryLocal": @"expiryLocal", @"expiryGMT": @"expiryGMT", @"flag": @"flag", @"joined": @"joined", @"chn": @"chn", @"email": @"email", @"mFlg": @"mFlg"}];
    [ErrorMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"objects" withMapping:signupMapping]];
    
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ErrorMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass                (RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    [objectManager postObject:BASE_IP path:method parameters:paramas success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Create User Success");
        
        response = [mappingResult array];
        NSDictionary * dictResponse = (NSDictionary*)response;
        completionBlock(YES,dictResponse);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Create User Error: %@", error);
        completionBlock(NO,nil);
    }];
    
    
   
}

-(void)composeRequestForAccept:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock
{
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:[self getBaseUrlStringWithHttpClient]];
    
    RKObjectMapping *ErrorMapping = [RKObjectMapping mappingForClass:[Errorhandler class]];
    
    [ErrorMapping addAttributeMappingsFromDictionary:@{ @"errNum": @"errNum", @"errFlag": @"errFlag", @"errMsg": @"errMsg",@"objects":@"data"}];
    
   // RKObjectMapping *signupMapping = [RKObjectMapping mappingForClass:[SignUp class]];
    
    
    //[signupMapping addAttributeMappingsFromDictionary:@{ @"picUrl": @"picUrl", @"writeFlag": @"writeFlag"}];
    
    
    //[ErrorMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"objects" withMapping:signupMapping]];
    
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ErrorMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass                (RKStatusCodeClassSuccessful)];
    
     [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager postObject:BASE_IP path:method parameters:paramas success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        response = [mappingResult array];
       // NSLog(@"Accept Response : %@",response);
        NSDictionary * dictResponse = (NSDictionary*)response;
        completionBlock(YES,dictResponse);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        completionBlock(NO,nil);
    }];
    
    
}

-(void)composeRequestForUpload:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock{
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:[self getBaseUrlStringWithHttpClient]];
    
    RKObjectMapping *ErrorMapping = [RKObjectMapping mappingForClass:[Errorhandler class]];
    
    [ErrorMapping addAttributeMappingsFromDictionary:@{ @"errNum": @"errNum", @"errFlag": @"errFlag", @"errMsg": @"errMsg",@"objects":@"data"}];
    
    RKObjectMapping *signupMapping = [RKObjectMapping mappingForClass:[Upload class]];
    
    
    [signupMapping addAttributeMappingsFromDictionary:@{ @"picURL": @"picURL", @"writeFlag": @"writeFlag"}];
    
    
    [ErrorMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"objects" withMapping:signupMapping]];
    
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ErrorMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass                (RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager postObject:BASE_IP path:method parameters:paramas success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

        response = [mappingResult array];
       // TELogInfo(@"Upload image response %@",response);
        NSDictionary * dictResponse = (NSDictionary*)response;
        completionBlock(YES,dictResponse);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        completionBlock(NO,nil);
    }];
 
}

-(void)composeRequestForProfile:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock{
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:[self getBaseUrlStringWithHttpClient]];
    
    RKObjectMapping *ErrorMapping = [RKObjectMapping mappingForClass:[Errorhandler class]];
    
    [ErrorMapping addAttributeMappingsFromDictionary:@{ @"errNum": @"errNum", @"errFlag": @"errFlag", @"errMsg": @"errMsg",@"objects":@"data"}];
    
    RKObjectMapping *signupMapping = [RKObjectMapping mappingForClass:[profile class]];
    
    
    [signupMapping addAttributeMappingsFromDictionary:@{ @"fName": @"fName", @"lName": @"lName", @"email": @"email", @"type": @"type", @"mobile": @"mobile", @"status": @"status", @"seatCapacity": @"seatCapacity", @"zip": @"zip", @"pPic": @"pPic", @"expertise": @"expertise", @"licNo": @"licNo", @"licExp": @"licExp", @"vehicleInsuranceExp": @"vehicleInsuranceExp", @"vehicleInsuranceNum": @"vehicleInsuranceNum",@"licPlateNum":@"licPlateNum",@"vehMake":@"vehMake",@"vehicleType":@"vehicleType",@"avgRate":@"avgRate",@"totRats":@"totRats",@"cmpltApts":@"cmpltApts",@"todayAmt":@"todayAmt",@"lastBilledAmt":@"lastBilledAmt",@"weekAmt":@"weekAmt",@"monthAmt":@"monthAmt",@"totalAmt":@"totalAmt"}];
    
    
    [ErrorMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"objects" withMapping:signupMapping]];
    
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ErrorMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass                (RKStatusCodeClassSuccessful)];
    
     [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager postObject:BASE_IP path:method parameters:paramas success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        response = [mappingResult array];
        NSDictionary * dictResponse = (NSDictionary*)response;
        completionBlock(YES,dictResponse);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        completionBlock(NO,nil);
    }];
    
}
-(void)composeRequestForUpdateStatus:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock{
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:[self getBaseUrlStringWithHttpClient]];
    
    RKObjectMapping *ErrorMapping = [RKObjectMapping mappingForClass:[Errorhandler class]];
    
    [ErrorMapping addAttributeMappingsFromDictionary:@{ @"errNum": @"errNum", @"errFlag": @"errFlag", @"errMsg": @"errMsg",@"objects":@"data"}];
    
   // RKObjectMapping *signupMapping = [RKObjectMapping mappingForClass:[SignUp class]];
    
    
  //  [signupMapping addAttributeMappingsFromDictionary:@{ @"picUrl": @"picUrl", @"writeFlag": @"writeFlag"}];
    
    
   // [ErrorMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"objects" withMapping:signupMapping]];
    
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ErrorMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass                (RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager postObject:BASE_IP path:method parameters:paramas success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        response = [mappingResult array];
        NSDictionary * dictResponse = (NSDictionary*)response;
        completionBlock(YES,dictResponse);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        completionBlock(NO,nil);
    }];
    
}
-(void)composeRequestForEditProfile:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock{
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:[self getBaseUrlStringWithHttpClient]];
    
    RKObjectMapping *ErrorMapping = [RKObjectMapping mappingForClass:[Errorhandler class]];
    
    [ErrorMapping addAttributeMappingsFromDictionary:@{ @"errNum": @"errNum", @"errFlag": @"errFlag", @"errMsg": @"errMsg",@"objects":@"data"}];
    
    // RKObjectMapping *signupMapping = [RKObjectMapping mappingForClass:[SignUp class]];
    
    
    //  [signupMapping addAttributeMappingsFromDictionary:@{ @"picUrl": @"picUrl", @"writeFlag": @"writeFlag"}];
    
    
    // [ErrorMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"objects" withMapping:signupMapping]];
    
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ErrorMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass                (RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager postObject:BASE_IP path:method parameters:paramas success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        response = [mappingResult array];
        NSDictionary * dictResponse = (NSDictionary*)response;
        completionBlock(YES,dictResponse);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        completionBlock(NO,nil);
    }];
    
}

-(void)composeRequestForLogOut:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock
{
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:[self getBaseUrlStringWithHttpClient]];
    
    RKObjectMapping *ErrorMapping = [RKObjectMapping mappingForClass:[Errorhandler class]];
    
    [ErrorMapping addAttributeMappingsFromDictionary:@{ @"errNum": @"errNum", @"errFlag": @"errFlag", @"errMsg": @"errMsg",@"objects":@"data"}];
    
    // RKObjectMapping *signupMapping = [RKObjectMapping mappingForClass:[SignUp class]];
    
    
    //  [signupMapping addAttributeMappingsFromDictionary:@{ @"picUrl": @"picUrl", @"writeFlag": @"writeFlag"}];
    
    
    // [ErrorMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"objects" withMapping:signupMapping]];
    
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ErrorMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass                (RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager postObject:BASE_IP path:method parameters:paramas success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        response = [mappingResult array];
        NSDictionary * dictResponse = (NSDictionary*)response;
        completionBlock(YES,dictResponse);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        completionBlock(NO,nil);
    }];
  
}


//"apntDt":"2014-06-25 05:51:54",
//"pPic":"PAAbhi201420062025201220212040temp_photo.jpg",
//"email":"abhi1@mobifyi.com",
//"status":"8",
//"pickupDt":"",
//"dropDt":"",
//"fname":"Abhi",
//"phone":"987456321",
//"apntTime":"05:51 am",
//"apntDate":"2014-06-25",
//
//
//"apptLat":"13.0355",
//"apptLong":"77.5899",
//"addrLine1":"2\/B, Vinayakanagar, Hebbal",
//"addrLine2":"",
//"notes":"",
//"dropAddr1":"2\/B, Vinayakanagar, Hebbal",
//"dropAddr2":"",
//"dropLat":"13.035508787357",
//"dropLong":"77.589880563319",
//"duration":"0",
//"distanceMts":"",
//"amount":"10"
-(void)composeRequestForAppointments:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock
{
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:[self getBaseUrlStringWithHttpClient]];
    
    RKObjectMapping *ErrorMapping = [RKObjectMapping mappingForClass:[Errorhandler class]];
    
    [ErrorMapping addAttributeMappingsFromDictionary:@{ @"errNum": @"errNum", @"errFlag": @"errFlag", @"errMsg": @"errMsg",@"objects":@"data"}];
    
    
    //AppointMent
    RKObjectMapping *appointment = [RKObjectMapping mappingForClass:[AppointmentDates class]];
    [appointment addAttributeMappingsFromDictionary:@{@"date": @"date"}];
    
    
     RKObjectMapping *signupMapping = [RKObjectMapping mappingForClass:[Appointments class]];
    
    [signupMapping addAttributeMappingsFromDictionary:@{@"apntDt": @"apntDt", @"pPic":@"pPic",@"email":@"email",@"status":@"status",@"pickupDt":@"pickupDt",@"dropDt":@"dropDt",@"fname":@"fname",@"phone":@"phone",@"apntTime":@"apntTime",@"apntDate":@"apntDate",@"apptLat":@"apptLong",@"addrLine1":@"addrLine1",@"addrLine2":@"addrLine2",@"notes":@"notes",@"dropAddr1":@"dropAddr1",@"dropAddr2":@"dropAddr2",@"dropLat":@"dropLat",@"dropLong":@"dropLong",@"duration":@"duration",@"distanceMts":@"distanceMts",@"amount":@"amount",}];
    
    [appointment addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"appt" toKeyPath:@"appt" withMapping:signupMapping]];
    
    
     [ErrorMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"appointments" toKeyPath:@"objects" withMapping:appointment]];
    
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ErrorMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass                (RKStatusCodeClassSuccessful)];
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager postObject:BASE_IP path:method parameters:paramas success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        response = [mappingResult array];
        NSDictionary * dictResponse = (NSDictionary*)response;
        completionBlock(YES,dictResponse);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"error %@",[error localizedDescription]);
        completionBlock(NO,nil);
    }];
    
}
-(void)composeRequestForPassengerDetail:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock
{
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:[self getBaseUrlStringWithHttpClient]];
    
    RKObjectMapping *ErrorMapping = [RKObjectMapping mappingForClass:[Errorhandler class]];
    
    [ErrorMapping addAttributeMappingsFromDictionary:@{ @"errNum": @"errNum", @"errFlag": @"errFlag", @"errMsg": @"errMsg",@"objects":@"data"}];
    
    RKObjectMapping *signupMapping = [RKObjectMapping mappingForClass:[passDetail class]];
    
    
    [signupMapping addAttributeMappingsFromDictionary:@{ @"fName": @"fName", @"lName": @"lName",@"mobile": @"mobile",@"addr1": @"addr1",@"addr2": @"addr2",@"dropAddr1": @"dropAddr1",@"dropAddr2": @"dropAddr2",@"amount": @"amount",@"pPic": @"pPic",@"dis": @"dis",@"dur": @"dur",@"fare": @"fare",@"pickLat": @"pickLat",@"pickLong": @"pickLong",@"dropLat":@"dropLat", @"apptDt":@"apptDt", @"dropLong":@"dropLong",@"apptDis":@"apptDis",@"email":@"email",@"bid":@"bid",@"pasChn":@"pasChn"}];
    
    
    [ErrorMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"objects" withMapping:signupMapping]];
    
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ErrorMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass                (RKStatusCodeClassSuccessful)];
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager postObject:BASE_IP path:method parameters:paramas success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        response = [mappingResult array];
        NSDictionary * dictResponse = (NSDictionary*)response;
        completionBlock(YES,dictResponse);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        completionBlock(NO,nil);
    }];
    
}




//-(void)notifyForSuccessResponse :(NSMutableDictionary *)  {
//    if (delegate &&[ delegate respondsToSelector:@selector(RestKit:didGetResponseSuccess:) ])
//    {
//        [delegate RestKit:self didGetResponseSuccess:];
//   
//    }
//}
//-(void)notifyForfailResponse {
//   
//    NSError * error;
//    if (delegate &&[ delegate respondsToSelector:@selector(RestKit:didFailedWithError:) ])
//    {
//        [delegate RestKit:self didFailedWithError:error];
//        
//    }
//    
//}



@end
