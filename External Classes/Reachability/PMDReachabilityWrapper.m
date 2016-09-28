//
//  PMDReachabilityWrapper.m
//  privMD
//
//  Created by Surender Rathore on 16/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "PMDReachabilityWrapper.h"
#import "Reachability.h"


@interface PMDReachabilityWrapper ()

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;
@property (nonatomic, assign) int fireSelectorOnce;
@end

@implementation PMDReachabilityWrapper
@synthesize hostReach;
@synthesize internetReach;
@synthesize wifiReach;
@synthesize target;
@synthesize selector;

static PMDReachabilityWrapper *reachabilityWrapper = nil;


+(instancetype)sharedInstance
{
    if (!reachabilityWrapper) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            reachabilityWrapper = [[self alloc] init];
        });
    }
    
    return reachabilityWrapper;
}


#pragma Reachability

- (BOOL)isNetworkAvailable {
    
    return _networkStatus != NotReachable;
}

// Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification* )note {
    

    
    Reachability *curReach = (Reachability *)[note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    _networkStatus = [curReach currentReachabilityStatus];
    
    if (_networkStatus == NotReachable) {
        NSLog(@"Network not reachable.");
        _fireSelectorOnce = 0;
    }
    else {
        NSLog(@"Network Reachable");
        if ([target respondsToSelector:selector]) {
            if (_fireSelectorOnce == 0) {
                [target performSelector:selector withObject:nil afterDelay:1];
                _fireSelectorOnce = 1;
            }
            
        }
        
    }
    
}
- (void)monitorReachability {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}

@end
