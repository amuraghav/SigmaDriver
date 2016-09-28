//
//  NetworkHandler.m
//  privMD
//
//  Created by Surender Rathore on 29/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "NetworkHandler.h"

//#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "Errorhandler.h"
#import "Cartype.h"


@interface NetworkHandler()
@property(nonatomic,strong)  AFHTTPClient *httpClient;
@end
@implementation NetworkHandler

static NetworkHandler *networkHandler;

+ (id)sharedInstance {
	if (!networkHandler) {
		networkHandler  = [[self alloc] init];
	}
	
	return networkHandler;
}

//-(AFHTTPClient*)GetBaseUrl
//{
//    NSURL *baseURL = [NSURL URLWithString:@"http://www.privemd.com/test/"];
//    AFHTTPClient * client = [AFHTTPClient clientWithBaseURL:baseURL];
//    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
//    return client;
//    
//}


-(void)composeRequestWithMethod:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary  *response))completionBlock
{
    
    
    NSURL *url = [NSURL URLWithString:BASE_URL];
    _httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [_httpClient postPath:method parameters:paramas success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //[self getPatientAppointmentResponse:operation.responseString.JSONValue];
        // NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"Request Successful, response '%@'", responseStr);
        NSDictionary *dictionary = operation.responseString.JSONValue;
        completionBlock(YES,dictionary);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
         completionBlock(NO,nil);
    }];
    


}

-(NSString*)getBaseStringWithMethod:(NSString*)method
{
    return [NSString stringWithFormat:@"%@%@", BASE_URL, method];
}

-(NSString*)getBaseUrlString
{
    return [NSString stringWithFormat:@"%@", BASE_URL_RESTKIT];
}


-(NSString*)paramDictionaryToString:(NSDictionary*)params
{
    NSMutableString *request = [[NSMutableString alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request appendFormat:@"&%@=%@", key, obj];
    }];
    
    NSString *finalRequest = request;
    if ([request hasPrefix:@"&"]) {
        finalRequest = [request substringFromIndex:1];
    }
    
    return finalRequest;
}
-(void)cancelRequest{
    
    [[_httpClient operationQueue] cancelAllOperations];
}

@end
