//
//  PMDReachabilityWrapper.h
//  privMD
//
//  Created by Surender Rathore on 16/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMDReachabilityWrapper : NSObject

+(instancetype)sharedInstance;
/**
 *  set target as controller object reference for which you want to trigger method when network is available
 */
@property(nonatomic,assign) id target;
/**
 *  set selector as controller's method which you want to tirgger
 */
@property(nonatomic,assign) SEL selector;
/**
 *  network status variable
 */
@property (nonatomic, assign) int networkStatus;

/**
 *  constantly monitor network
 */
- (void)monitorReachability;
/**
 *  Check for network Connection
 *
 *  @return Yes if network is available
 */
- (BOOL)isNetworkAvailable;
@end
