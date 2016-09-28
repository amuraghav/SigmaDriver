//
//  LouponSericeUtils.m
//  Loupon
//
//  Created by rahul Sharma on 11/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "LouponSericeUtils.h"

@implementation LouponSericeUtils

+(NSString*)paramDictionaryToString:(NSDictionary*)params
{
    NSMutableString *request = [[NSMutableString alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request appendFormat:@"&%@=%@", key, obj];
    }];
    
    
    NSString *finalRequest = request;
    
    if ([request hasPrefix:@"&"])
    {
        finalRequest = [request substringFromIndex:1];
        
        
    }
    
    return finalRequest;
}

@end
