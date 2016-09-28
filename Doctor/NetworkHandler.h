//
//  NetworkHandler.h
//  privMD
//
//  Created by Surender Rathore on 29/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHandler : NSObject
+(id)sharedInstance;
-(void)composeRequestWithMethod:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, NSDictionary  *response))completionBlock;
-(void)cancelRequest;
@end
