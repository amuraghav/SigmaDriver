//
//  PriveMdAppDelegate.m
//  Doctor
//
//  Created by Rahul Sharma on 17/04/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "PriveMdAppDelegate.h"
#import "HelpViewController.h"
#import "SplashViewController.h"
//#import "MapViewController.h"
#import "Reachability.h"
#import <Crashlytics/Crashlytics.h>
#import "MenuViewController.h"
#import "HomeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NSCalendar+Ranges.h"
#import "PatientPubNubWrapper.h"
#import "CheckBookingStatus.h"
#import "PMDReachabilityWrapper.h"
#import "OnBookingViewController.h"
#import "UpdateBookingStatus.h"
#import <Pushwoosh/PushNotificationManager.h>


@interface PriveMdAppDelegate()<PatientPubNubWrapperDelegate,PushNotificationDelegate>

@property (nonatomic,strong) HelpViewController *helpViewController;
@property (nonatomic,strong) SplashViewController *splashViewController;
//@property (nonatomic,strong) MapViewController *mapViewContoller;

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;

@end

@implementation PriveMdAppDelegate
/*@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;*/
@synthesize hostReach;
@synthesize internetReach;
@synthesize wifiReach;
@synthesize sectionIndex;


-(void)customizeNavigationBar {
    
    
    
   [[UINavigationBar appearance] setBarTintColor:NavBarTint_Color];
 
    
     //[[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:246/255.0 green:206/255.0 blue:18/255.0 alpha:1.0]];

    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor blackColor],UITextAttributeTextColor,
                                               [UIColor clearColor], UITextAttributeTextShadowColor,
                                               [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    

}

void uncaughtExceptionHandler(NSException *exception) {
    //[Flurry startSession:@"VX2Q9RPNNFQGCD5KDP86"];
    //[Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
    NSLog(@"The app has encountered an unhandled exception: %@", [exception debugDescription]);
    NSLog(@"Stack trace: %@", [exception callStackSymbols]);
    NSLog(@"desc: %@", [exception description]);
    NSLog(@"name: %@", [exception name]);
    NSLog(@"user info: %@", [exception userInfo]);
}
//use NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    [application setStatusBarHidden:YES];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //LumberJack init
    [[TELogger getInstance] initiateFileLogging];
    
    
    [GMSServices provideAPIKey:kPMDGoogleMapsAPIKey];
     //RKClient* client = [RKClient clientWithBaseURL:@"http://restkit.org"];
    // Override point for customization after application launch.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

   
    // set custom delegate for push handling, in our case - view controller
    PushNotificationManager * pushManager = [PushNotificationManager pushManager];
    pushManager.delegate = self;
    
    // handling push on app start
    [[PushNotificationManager pushManager] handlePushReceived:launchOptions];
    
    // make sure we count app open in Pushwoosh stats
    [[PushNotificationManager pushManager] sendAppOpen];
    
    // register for push notifications!
    [[PushNotificationManager pushManager] registerForPushNotifications];

    
   [[Crashlytics sharedInstance] setDebugMode:NO];
   [Crashlytics startWithAPIKey:@"8da08759dea61805618fb4ee86b3d72576162460"];
    
   
    
    [self customizeNavigationBar];
    
    [self handlePushNotificationWithLaunchOption:launchOptions];
    
   
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[ UIApplication sharedApplication ] setIdleTimerDisabled: YES];
    
    PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
    [reachability monitorReachability];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken]) {
        
        CheckBookingStatus *status = [CheckBookingStatus sharedInstance];
        status.callblock = ^(int status,NSDictionary *dictionary){
            
            [[ProgressIndicator sharedInstance] hideProgressIndicator];
            if (status == 1) {
                
                NSString *email = dictionary[@"email"];
                NSString *appointmentDate = dictionary[@"apptDt"];
                NSString *appointmentid = dictionary[@"bid"];
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:email forKey:@"e"];
                [dict setObject:appointmentDate forKey:@"dt"];
                 [dict setObject:appointmentid forKey:@"bid"];
                [ud setObject:dict forKey:@"PUSH"];
                [ud synchronize];
                
                XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
                
                if (![menu.currentViewController isKindOfClass:[UINavigationController class]]) {
                    
                    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
                    
                    [menu openMenuAnimated];
                    
                    dispatch_after(0.2, dispatch_get_main_queue(), ^(void){
                         [menu openViewControllerAtIndexPath:indexpath];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewBooking" object:nil userInfo:dict];
                    });
                   
                }
                else {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewBooking" object:nil userInfo:dict];
                }
                
                
            }
            
            
        };
        
        [status checkOngoingAppointmentStatus:nil];
    }
    
    

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    NSLog(@"applicationWillTerminate");
//    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"user Info %@",userInfo);
    application.applicationIconBadgeNumber = 0;
    NSString *string = [[PushNotificationManager pushManager] getCustomPushData:userInfo];
    NSString *jsonString = [userInfo objectForKey:@"u"];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
    [dict setObject:userInfo[@"aps"][@"alert"] forKeyedSubscript:@"alert"];
    
    
    
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:dict,@"aps", nil];
    
    
    [self handleNotificationForUserInfo:info];
     //[[PushNotificationManager pushManager] handlePushReceived:userInfo];
    
    
    
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:
                    [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"My token is: %@", dt);
    
    NSString *model = [[UIDevice currentDevice] model];
    if ([model isEqualToString:@"iPhone Simulator"]) {
        //device is simulator
        [[NSUserDefaults standardUserDefaults]setObject:@"123" forKey:KDAgetPushToken];
    }
    else {
        [[NSUserDefaults standardUserDefaults]setObject:dt forKey:KDAgetPushToken];
    }
    
    [[PushNotificationManager pushManager] handlePushRegistration:deviceToken];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    NSString *model = [[UIDevice currentDevice] model];
    if ([model isEqualToString:@"iPhone Simulator"])
    {
        //device is simulator
        [[NSUserDefaults standardUserDefaults]setObject:@"123" forKey:KDAgetPushToken];
    }
    
    [[PushNotificationManager pushManager] handlePushRegistrationFailure:error];
}


- (void) onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification {
    NSLog(@"Push notification received");
}


#pragma mark -
#pragma mark Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
/*- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}*/

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma Reachability

- (BOOL)isNetworkAvailable {
    
    return self.networkStatus != NotReachable;
}

// Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification* )note {
    
    Reachability *curReach = (Reachability *)[note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    _networkStatus = [curReach currentReachabilityStatus];
    
    if (_networkStatus == NotReachable) {
        NSLog(@"Network not reachable.");
    }
    
}
- (void)monitorReachability {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostName:@"http://uber.pbodev.info/"];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}
- (void)saveContext
{
    
}


#pragma mark - HandlePushNotification

-(void)playNotificationSound{
    
    //play sound
    SystemSoundID	pewPewSound;
    NSString *pewPewPath = [[NSBundle mainBundle]
                            pathForResource:@"sms-received" ofType:@"wav"];
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, & pewPewSound);
    AudioServicesPlaySystemSound(pewPewSound);
}

/**
 *  handle push if app is opened by clicking push
 *
 *  @param launchOptions pushpayload dictionary
 */
-(void)handlePushNotificationWithLaunchOption:(NSDictionary*)launchOptions {
    
    NSLog(@"handle push %@",launchOptions);
    NSDictionary *remoteNotificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationPayload) {
        
       if ([self checkIfBookingIsValid:remoteNotificationPayload[@"aps"][@"dt"]]) {
           
           NSDictionary *dict = remoteNotificationPayload[@"aps"];
           [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"PUSH"];
           [[NSUserDefaults standardUserDefaults] synchronize];
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(postNotificationForBooking:) userInfo:dict repeats:NO];
       }
       
        
        
    }
}
-(void)handleNotificationForUserInfo:(NSDictionary*)userInfo{
    
    [self playNotificationSound];
    
   
    
    //handle notification
    //[[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"PUSH"];
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isBooked"];
    
    int type = [userInfo[@"aps"][@"nt"] intValue];
    if (type == 7) {
        
        self.isNewBooking = YES;
        
       // if ([self checkIfBookingIsValid:userInfo[@"aps"][@"dt"]]) {
            //booking expired
            XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
        
      
            
            if (![menu.currentViewController isKindOfClass:[UINavigationController class]]) {
                
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
                [menu openMenuAnimated];
                
                dispatch_after(0.2, dispatch_get_main_queue(), ^(void){
                    [menu openViewControllerAtIndexPath:indexpath];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewBooking" object:nil userInfo:userInfo[@"aps"]];
                    });
                    
                });
            }
            else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewBooking" object:nil userInfo:userInfo[@"aps"]];
            }
        
        

//        }
//        else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Your booking is expired" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//        }
        
        
    }
    else if(type == 10){
        
        UpdateBookingStatus *updateBookingStatus = [UpdateBookingStatus sharedInstance];
        [updateBookingStatus stopUpdatingStatus];
        
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *bookingDirectionVC = [mainstoryboard instantiateViewControllerWithIdentifier:@"ViewController1"];
        //bookingCancelled
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"bookingCancelled" object:nil userInfo:nil];
        
       // OnBookingViewController *bookinVC = [[bookingDirectionVC viewControllers] lastObject];
       
//        UINavigationController *naviVC =(UINavigationController*) self.window.rootViewController;
//        
//        if ([[bookingDirectionVC.viewControllers lastObject] isKindOfClass:[OnBookingViewController class]]) {
//            //[naviVC popToViewController:bookingDirectionVC animated:YES];
//            [bookingDirectionVC popToRootViewControllerAnimated:YES];
//            
//        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)postNotificationForBooking:(NSTimer*)timer{
    
    NSLog(@"userinfo %@",timer.userInfo);
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"Match" object:timer.userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewBooking" object:nil userInfo:timer.userInfo];
}
-(BOOL)checkIfBookingIsValid:(NSString*)apptDate{
    
    NSDateFormatter *df = [self formatter];
    NSDate *notificationDate = [df dateFromString:apptDate];
    NSDate *currentDate = [NSDate date];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger seconds  =  [calender secondsFromDate:notificationDate toDate:currentDate];
    
    if (seconds < 30) {
        return YES;
    }
    return NO;
}
- (NSDateFormatter *)formatter {
    //2014-07-08 13:00:27
    //EEE - day(eg: Thu)
    //MMM - month (eg: Nov)
    // dd - date (eg 01)
    // z - timeZone
    
    //eg : @"EEE MMM dd HH:mm:ss z yyyy"
    
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return formatter;
}
-(void)subscribeToPubnubChannel{
    
    PatientPubNubWrapper *pubNub = [PatientPubNubWrapper sharedInstance];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kNSUDriverListnerChannelKey]) {
        
        NSString  *_pubNubChannel = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUDriverListnerChannelKey];
        
        [pubNub subscribeOnChannels:@[_pubNubChannel]];
        
        [pubNub setDelegate:self];

    }
    
   
    
//    NSString *driverEmail = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPatientEmailAddressKey];
//    
//    NSDictionary *message = @{@"a":[NSNumber numberWithInt:kPubNubStartUploadLocation],
//                              @"e_id": driverEmail,
//                              @"lt": [NSNumber numberWithDouble:latitude],
//                              @"lg": [NSNumber numberWithDouble:longitude],
//                              };
//    
//    
//    
//    [pubNub sendMessageAsDictionary:message toChannel:_pubNubChannel];
}
-(void)checkDriverStatus{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kNSURoadyoPubNubChannelkey]) {
        
        PatientPubNubWrapper *pubNub = [PatientPubNubWrapper sharedInstance];
        NSString  *_pubNubChannel = [[NSUserDefaults standardUserDefaults] objectForKey:kNSURoadyoPubNubChannelkey];
        NSString  *listnerChn = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUDriverListnerChannelKey];
        
        
        
        
        NSString *driverEmail = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPatientEmailAddressKey];
        NSString *deviceUDID = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
        
        NSDictionary *message = @{@"a":[NSNumber numberWithInt:kPubNubCheckDriverStatusAction],
                                  @"e_id": driverEmail,
                                  @"d_id":deviceUDID,
                                  @"chn":listnerChn,
                                  };
        
        
        
        [pubNub sendMessageAsDictionary:message toChannel:_pubNubChannel];
        
    }
    
   

}
#pragma mark - PubNubWrapperDelegate

-(void)recievedMessage:(NSDictionary*)messageDict onChannel:(NSString*)channelName;
{
    NSLog(@"Message : %@", messageDict);
    
    if ([messageDict[@"a"] integerValue] == 11) {
        
        
        
        NSMutableDictionary *mdict = [[NSMutableDictionary alloc] init];
        [mdict setObject:messageDict[@"e"] forKey:@"e"];
        [mdict setObject:messageDict[@"dt"] forKey:@"dt"];
        [mdict setObject:messageDict[@"bid"] forKey:@"bid"];
        
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
        {
            //Do checking here.
            
            
            NSMutableDictionary *notificationDict = [[NSMutableDictionary alloc] init];
            [notificationDict setObject:mdict forKey:@"aps"];
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
            localNotification.alertBody = @"Pubnub:Congratulations you got a new booking request";
            localNotification.userInfo = notificationDict;
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

        }
        else {
            
            self.isNewBooking = YES;
            [self playNotificationSound];
           // [[NSNotificationCenter defaultCenter] postNotificationName:@"NewBooking" object:nil userInfo:mdict];
            XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
            
            
            
            if (![menu.currentViewController isKindOfClass:[UINavigationController class]]) {
                
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
                [menu openMenuAnimated];
                
                dispatch_after(0.2, dispatch_get_main_queue(), ^(void){
                    [menu openViewControllerAtIndexPath:indexpath];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewBooking" object:nil userInfo:mdict];
                    });
                    
                });
            }
            else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewBooking" object:nil userInfo:mdict];
            }
        }
        
        

    }
    else if ([messageDict[@"a"] integerValue] == 8){
        UpdateBookingStatus *updateBookingStatus = [UpdateBookingStatus sharedInstance];
        [updateBookingStatus stopUpdatingStatus];
        
        
        //bookingCancelled
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bookingCancelled" object:nil userInfo:nil];
        
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Passenger cancelled booking" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([messageDict[@"a"] integerValue] == 2){
        
        
        [[NSUserDefaults standardUserDefaults] setInteger:[messageDict[@"s"] integerValue] forKey:kNSUDriverStatekey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DriverState" object:nil userInfo:nil];
        
        NSLog(@"message %@",messageDict);
        
    }
    else if([messageDict[@"a"]integerValue] == 3){
        
        UpdateBookingStatus *updateBookingStatus = [UpdateBookingStatus sharedInstance];
        [updateBookingStatus stopUpdatingStatus];
        
    }
    
    
   //    if ([channelName isEqualToString:_pubNubChannel] ) {
//        
//        
//        
//        
//    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    
    NSError *error;
    
    if ([[url scheme] isEqualToString:@"stripeconnecttest"]) {
        
        
        
        NSString *query = [[url query] stringByRemovingPercentEncoding];
        query = [query stringByReplacingOccurrencesOfString:@"result=" withString:@""];
        NSData *data = [query dataUsingEncoding:NSUTF8StringEncoding];
        
        
        id   json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"StripeData"];
        
        
        if(json){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StripeConnected" object:nil];
        }
        NSString *errorString = [json objectForKey:@"error"];
        NSString *accessToken = [json objectForKey:@"access_token"];
        NSString *stripePubKey = [json objectForKey:@"stripe_publishable_key"];
        NSString *stripeUserId = [json objectForKey:@"stripe_user_id"];
        
        
    }
    return YES;
}




@end
