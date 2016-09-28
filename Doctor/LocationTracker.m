//
//  LocationTracker.m
//  Location
//
//  Created by Surender Rathore
//  Copyright (c) 2014 Location All rights reserved.
//

#import "LocationTracker.h"
#import "PatientPubNubWrapper.h"

#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"

@interface LocationTracker()<PatientPubNubWrapperDelegate>
@property(nonatomic,strong)NSString *pubNubChannel;

@end
static LocationTracker *locationtracker;
static int packedId = 0;
@implementation LocationTracker

+ (id)sharedInstance {
	if (!locationtracker) {
		locationtracker  = [[self alloc] init];
	}
	
	return locationtracker;
}


+ (CLLocationManager *)sharedLocationManager {
	static CLLocationManager *_locationManager;
	
	@synchronized(self) {
		if (_locationManager == nil) {
			_locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                
                [_locationManager requestAlwaysAuthorization];
            }
		}
	}
	return _locationManager;
}

- (id)init {
	if (self==[super init]) {
        //Get the share model and also initialize myLocationArray
        self.shareModel = [LocationShareModel sharedModel];
        self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
	}
	return self;
}

-(void)applicationEnterBackground{
    
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    //Use the BackgroundTaskManager to manage all the background Task
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
}

- (void) restartLocationUpdates
{
    //NSLog(@"restartLocationUpdates");
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
}


- (void)startLocationTracking {
   // NSLog(@"startLocationTracking");

	if ([CLLocationManager locationServicesEnabled] == NO) {
       // NSLog(@"locationServicesEnabled false");
		UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[servicesDisabledAlert show];
	} else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
           // NSLog(@"authorizationStatus failed");
        } else {
            NSLog(@"authorizationStatus authorized");
            CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            [locationManager startUpdatingLocation];
        }
	}
}


- (void)stopLocationTracking {
   // NSLog(@"stopLocationTracking");
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
	CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
	[locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate Methods
/*
-(void) locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    
  
    CLLocationCoordinate2D theLocation = newLocation.coordinate;
    CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
    
    //if(!(theLocation.latitude == 0.0 && theLocation.longitude == 0.0)){
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[NSNumber numberWithDouble:theLocation.latitude] forKey:@"latitude"];
        [dict setObject:[NSNumber numberWithDouble:theLocation.longitude] forKey:@"longitude"];
        [dict setObject:[NSNumber numberWithDouble:theAccuracy] forKey:@"theAccuracy"];
        
        //Add the vallid location with good accuracy into an array
        //Every 1 minute, I will select the best location based on accuracy and send to server
        [self.shareModel.myLocationArray addObject:dict];
   // }
   
    
    //If the timer still valid, return it (Will not run the code below)
    if (self.shareModel.timer) {
        return;
    }
    
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
    
    //Restart the locationMaanger after 1 minute
//    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
//                                                           selector:@selector(restartLocationUpdates)
//                                                           userInfo:nil
//                                                            repeats:NO];
    
    //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
    //The location manager will only operate for 10 seconds to save battery
//    NSTimer * delay10Seconds;
//    delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:10 target:self
//                                                    selector:@selector(stopLocationDelayBy10Seconds)
//                                                    userInfo:nil
//                                                     repeats:NO];
}
*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
   
    
    for(int i=0;i<locations.count;i++) {
        
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        
        float distanceChange = [newLocation distanceFromLocation:_lastLocaiton];
//        if (distanceChange < 2) {
//            _lastLocaiton = newLocation;
//            return;
//        }
        
        self.distance += distanceChange;
        
        if (self.distanceCallback) {
            self.distanceCallback(self.distance);
        }
         _lastLocaiton = newLocation;
        
        
        //TELogInfo(@"latitiude %f longitude %f",theLocation.longitude,theLocation.longitude);
        
        
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        
        if (locationAge > 30.0)
        {
            continue;
        }
        //NSLog(@"the accuaracy %f",theAccuracy);
        
        //Select only valid location and also location with good accuracy
        if(newLocation!=nil && theAccuracy>0
           &&theAccuracy<2000
           &&(!(theLocation.latitude==0.0&&theLocation.longitude==0.0))){
            
            self.myLastLocation = theLocation;
            self.myLastLocationAccuracy= theAccuracy;
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
            [dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
            [dict setObject:[NSNumber numberWithFloat:theAccuracy] forKey:@"theAccuracy"];
            
            //Add the vallid location with good accuracy into an array
            //Every 1 minute, I will select the best location based on accuracy and send to server
            [self.shareModel.myLocationArray addObject:dict];
        }
    }
    
    //If the timer still valid, return it (Will not run the code below)
    if (self.shareModel.timer) {
        return;
    }
    
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
    
//    //Restart the locationMaanger after 1 minute
//    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
//                                                           selector:@selector(restartLocationUpdates)
//                                                           userInfo:nil
//                                                            repeats:NO];
//    
//    //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
//    //The location manager will only operate for 10 seconds to save battery
//    NSTimer * delay10Seconds;
//    delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:10 target:self
//                                                    selector:@selector(stopLocationDelayBy10Seconds)
//                                                    userInfo:nil
//                                                     repeats:NO];

}


//Stop the locationManager
-(void)stopLocationDelayBy10Seconds{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
    
    //NSLog(@"locationManager stop Updating after 10 seconds");
}


- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
   // NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Service" message:@"You have to enable the Location Service to use this App. To enable, please go to Settings->Privacy->Location Services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
}


//Send the location to Server
- (void)updateLocationToServer {
    
    NSLog(@"updateLocationToServer 2");
    
    // Find the best location from the array based on accuracy
    NSMutableDictionary * myBestLocation = [[NSMutableDictionary alloc]init];
    NSLog(@"%lu",(unsigned long)self.shareModel.myLocationArray.count);
    for(int i=0;i<self.shareModel.myLocationArray.count;i++)
    {
        
       // TELogInfo(@"array %@",self.shareModel.myLocationArray);
        NSMutableDictionary * currentLocation = [self.shareModel.myLocationArray objectAtIndex:i];
        
        if(i==0)
            myBestLocation = currentLocation;
        else
        {
            if([[currentLocation objectForKey:ACCURACY]floatValue]<=[[myBestLocation objectForKey:ACCURACY]floatValue])
            {
                myBestLocation = currentLocation;
             }
         }
      }
    
   
    
    //If the array is 0, get the last location
    //Sometimes due to network issue or unknown reason, you could not get the location during that  period, the best you can do is sending the last known location to the server
    if(self.shareModel.myLocationArray.count==0)
    {
       // NSLog(@"Unable to get location, use the last known location");

        self.myLocation=self.myLastLocation;
        self.myLocationAccuracy=self.myLastLocationAccuracy;
        
    }else{
        
        CLLocationCoordinate2D theBestLocation;
        theBestLocation.latitude =[[myBestLocation objectForKey:LATITUDE]floatValue];
        theBestLocation.longitude =[[myBestLocation objectForKey:LONGITUDE]floatValue];
        self.myLocation=theBestLocation;
        self.myLocationAccuracy =[[myBestLocation objectForKey:ACCURACY]floatValue];
        
        
       // NSLog(@"Send to Server: Latitude(%f) Longitude(%f) Accuracy(%f)",self.myLocation.latitude, self.myLocation.longitude,self.myLocationAccuracy);
        
        [self startPubNubSream:self.myLocation.latitude Longitude:self.myLocation.longitude];
        
        
        
        //TODO: Your code to send the self.myLocation and self.myLocationAccuracy to your server
        
        //After sending the location to the server successful, remember to clear the current array with the following code. It is to make sure that you clear up old location in the array and add the new locations from locationManager
        [self.shareModel.myLocationArray removeAllObjects];
        self.shareModel.myLocationArray = nil;
        self.shareModel.myLocationArray = [[NSMutableArray alloc]init];

    }
    
}
#pragma mark PUBNUB

-(void)startPubNubSream:(double)latitude Longitude:(double)longitude{
    
    //_currentLatitude = _currentLatitude + 0.02;
    //_currentLongitude = _currentLongitude + 0.01;
    NSLog(@"ji");
    PatientPubNubWrapper *pubNub = [PatientPubNubWrapper sharedInstance];
    
    _pubNubChannel = [[NSUserDefaults standardUserDefaults] objectForKey:kNSURoadyoPubNubChannelkey];
    
    //[pubNub subscribeOnChannels:@[_pubNubChannel]];
    
    //[pubNub setDelegate:self];
    NSLog(@"pubnub channel%@",_pubNubChannel);
    NSString *driverChannel = [[NSUserDefaults standardUserDefaults] objectForKey:kNSURoadyoSubscribeChanelKey];
    NSString *driverEmail = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPatientEmailAddressKey];
    NSLog(@"driver channel %@",driverChannel);
    
    NSDateFormatter *df = [self formatter];
    NSString *dateStirng = [df stringFromDate:[NSDate date]];
    NSLog(@"upload location to xyz%d",kPubNubStartUploadLocation);
     NSDictionary *message =  @{@"a":[NSNumber numberWithInt:kPubNubStartUploadLocation],
                     @"e_id": driverEmail,
                     @"lt": [NSNumber numberWithDouble:latitude],
                     @"lg": [NSNumber numberWithDouble:longitude],
                     @"chn":driverChannel,
                     @"id":[NSNumber numberWithInt:packedId],
                     @"t":dateStirng,
                                
                     };
    
    NSLog(@"packid : %d , date %@",packedId,dateStirng);
    packedId++;
    

    
    [pubNub sendMessageAsDictionary:message toChannel:_pubNubChannel];
    [pubNub sendMessageAsDictionary:message toChannel:driverChannel];
    
    //    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isBooked"]) {
    //
    //        NSString *passengerChannel = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPassengerChannelKey];
    //        [pubNub sendMessageAsDictionary:message toChannel:passengerChannel];
    //
    //    }
    //    else {
    //            [pubNub sendMessageAsDictionary:message toChannel:driverChannel];
    //    }
}
#pragma mark - PubNubWrapperDelegate

-(void)recievedMessage:(NSDictionary*)messageDict onChannel:(NSString*)channelName;
{
    //NSLog(@"Message : %@", messageDict);
    if ([channelName isEqualToString:_pubNubChannel] ) {
        
        
        
        
    }
}
-(void)didFailedToConnectPubNub:(NSError *)error{
    
    // ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    
}
- (NSDateFormatter *)formatter {
    
    //EEE - day(eg: Thu)
    //MMM - month (eg: Nov)
    // dd - date (eg 01)
    // z - timeZone
    
    //eg : @"EEE MMM dd HH:mm:ss z yyyy"
    
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd-yyyy hh:MM:ss";
    });
    return formatter;
}



@end
