//
//  LocationTracker.h
//  Location
//
//  Created by Surender Rathore
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"


typedef void(^LocationTrackerDistanceChangeCallback) (float totalDistance);
@interface LocationTracker : NSObject <CLLocationManagerDelegate>

@property(nonatomic,copy)LocationTrackerDistanceChangeCallback distanceCallback;

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;
@property(nonatomic,strong)CLLocation *lastLocaiton;
@property (strong,nonatomic) NSString * accountStatus;
@property (strong,nonatomic) NSString * authKey;
@property (strong,nonatomic) NSString * device;
@property (strong,nonatomic) NSString * name;
@property (strong,nonatomic) NSString * profilePicURL;
@property (strong,nonatomic) NSNumber * userid;
@property (assign,nonatomic) float distance;

@property (strong,nonatomic) LocationShareModel * shareModel;

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationTracking;
- (void)stopLocationTracking;
- (void)updateLocationToServer;
+ (id)sharedInstance;


@end
