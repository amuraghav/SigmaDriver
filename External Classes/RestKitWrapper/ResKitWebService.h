//
//  ResKitWebService.h
//  Roadyo
//
//  Created by Rahul Sharma on 05/05/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

//@protocol RestKitResponseDelegate;
@interface ResKitWebService : NSObject

{
    NSArray * response;
}
+(id)sharedInstance;
//@property(nonatomic,weak)id <RestKitResponseDelegate> delegate;
-(AFHTTPClient*)getBaseUrlStringWithHttpClient;
-(void)notifyForSuccessResponse;
-(void)notifyForfailResponse;
//parser

-(void)composeRequestForcarTypeWithMethod:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary  *response))completionBlock;
-(void)composeRequestForLoginWithMethod:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary  *response))completionBlock;

-(void)composeRequestForSignUpWithMethod:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary  *response))completionBlock;
-(void)composeRequestForAccept:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock;
-(void)composeRequestForUpload:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock;
-(void)composeRequestForProfile:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock;
-(void)composeRequestForEditProfile:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock;
-(void)composeRequestForUpdateStatus:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock;
-(void)composeRequestForLogOut:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock;
-(void)composeRequestForPassengerDetail:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock;
-(void)composeRequestForAppointments:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary *response))completionBlock;

//-(void)parseCarType :(NSDictionary *)params :(NSString*)methodName;
//-(void)parseLogin :(NSDictionary *)params :(NSString*)methodName;
//-(void)parseSignUp :(NSDictionary *)params :(NSString*)methodName;
@end


//@protocol RestKitResponseDelegate <NSObject>
//
//-(void)RestKit:(ResKitWebService*)sucess didGetResponseSuccess:(NSArray*)response;
//-(void)RestKit:(ResKitWebService*)Error didFailedWithError:(NSError*)error;

//@end


