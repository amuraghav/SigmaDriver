//
//  Service.m
//  Tinder
//
//  Created by Rahul Sharma on 04/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "Service.h"
#import "AppConstants.h"
#import "LouponSericeUtils.h"

@implementation Service

+(NSURL*)getURLForMethod:(NSString*)method
{
    NSLog(@"bse %@",[NSString stringWithFormat:@"%@%@", BASE_URL, method]);
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, method]];
}

+(NSMutableURLRequest*)createURLRequestFor:(NSString*)method withData:(NSData*)postData
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSLog(@"url new %@",[self getURLForMethod:method]);
    [request setURL:[self getURLForMethod:method]];
     
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];



        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
  
    
    return request;
}

+(NSMutableURLRequest *)parseLogin :(NSDictionary *)params
{
    NSString *strRequestParm = [LouponSericeUtils paramDictionaryToString:params];

    
    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodPatientLogin withData:postData];

    
    return request;

  
}

+(NSMutableURLRequest *)parseSignUp :(NSDictionary *)params
{
    NSString *strRequestParm = [LouponSericeUtils paramDictionaryToString:params];
    
    
    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodPatientSignUp withData:postData];
    
    
    return request;
    
    
}

+(NSMutableURLRequest *)parseDoctorAvalabilty :(NSDictionary *)params
{
    NSString *strRequestParm = [LouponSericeUtils paramDictionaryToString:params];
    
    
    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    NSMutableURLRequest *request =[self createURLRequestFor:MethodAppointments withData:postData];
    
    
    return request;
    
    
}

+(NSMutableURLRequest *)parseGetAppointment :(NSDictionary *)params
{
    NSString *strRequestParm = [LouponSericeUtils paramDictionaryToString:params];
    
    
    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodAppointments withData:postData];
    
    
    return request;
    
    
}



+(NSMutableURLRequest *)parseDoctorActiveOrInactive :(NSDictionary *)params
{
    NSString *strRequestParm = [LouponSericeUtils paramDictionaryToString:params];
    
    
    
    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodPatientSignUp withData:postData];
    //NSLog(@"request : %@",request);
    
    return request;
}


+(NSMutableURLRequest *)parseUploadImage :(NSDictionary *)params
{
    NSString *strRequestParm = [LouponSericeUtils paramDictionaryToString:params];
    
    
    
    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodDoctorUploadImage withData:postData];
    //NSLog(@"request : %@",request);
    
    return request;

    
}

@end
