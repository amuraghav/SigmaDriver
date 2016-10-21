
//  HomeViewController.m
//  Doctor
//
//  Created by Rahul Sharma on 17/04/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "HomeViewController.h"
#import "DAPagesContainer.h"
#import "CustomNavigationBar.h"
#import "CustomMarkerView.h"
#import "XDKAirMenuController.h"
#import "PMDReachabilityWrapper.h"
#import "SliderViewController.h"
#import "WildcardGestureRecognizer.h"
#import "ContentViewController.h"
#import "ProgressIndicator.h"
#import "Helper.h"
#import "WebServiceConstants.h"
#import "AppConstants.h"
#import "passDetail.h"
#import "OnBookingViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "DirectionService.h"
#import <CoreLocation/CoreLocation.h>
#import "DoctorDetailView.h"
#import "AppointedDoctor.h"
#import "HelpViewController.h"
#import "PatientPubNubWrapper.h"
#import "LocationTracker.h"
#import "UploadFiles.h"
#import "BookingHistoryViewController.h"
#import "CheckBookingStatus.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BookingDetail.h"
#import "UpdateBookingStatus.h"
#import "MathController.h"
#import "PriveMdAppDelegate.h"


#define mapZoomLevel 13


@interface HomeViewController ()<CustomNavigationBarDelegate,XDKAirMenuDelegate,CLLocationManagerDelegate,ViewPagerDelegate,PatientPubNubWrapperDelegate,UploadFileDelegate>
{
    
    GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    GMSGeocoder *geocoder_;
    IBOutlet  UIView *customMapView;
   // RoadyoPubNubWrapper *pubNub;
  
}

@property(nonatomic,strong)NSString *startLocation;
@property(nonatomic,strong)NSString *destinationLocation;
@property(nonatomic,strong)NSString *pubnubChannelName;
@property(nonatomic,strong)NSString *patientPubNubChannel;

@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,assign)CLLocationCoordinate2D previouCoord;

@property(nonatomic,strong)GMSMutablePath *mutablePath;
@property(nonatomic,strong)GMSMarker *destinationMarker;
@property(nonatomic,strong)GMSMarker *currentLocationMarker;


@property(nonatomic,assign)BOOL isPathPlotted;
@property(nonatomic,assign)BOOL isUpdatedLocation;
@property(nonatomic,assign)BOOL isNewBookingInProcess;


@property (nonatomic, strong) NSMutableArray *arrBooking;
@property(nonatomic,strong)NSMutableDictionary *allMarkers;
@property(nonatomic,strong)WildcardGestureRecognizer * tapInterceptor;

@property(nonatomic,assign) float currentLatitude;
@property(nonatomic,assign) float currentLongitude;


@property (strong,nonatomic)IBOutlet  UIView *acceptRejectBtnView;
@property (strong,nonatomic)IBOutlet  UIView *PickUpAndDropView;
@property (strong,nonatomic)IBOutlet  UILabel *labelBookingId;

@property (nonatomic) NSUInteger numberOfTabs;
@property(nonatomic,assign) BookingNotificationType bookingStatus;
@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

@property (nonatomic,strong) CustomNavigationBar *customNavigationBarView;


-(IBAction)btnAcceptRejectClicked:(id)sender;

@end
static float latitudeChange = 0.01234;
static float longitdeChange = 0.00234;


@implementation HomeViewController
@synthesize arrBooking;
@synthesize acceptRejectBtnView;
@synthesize PickUpAndDropView;
@synthesize dictPush;
@synthesize timer;
@synthesize counter;
@synthesize switchOnOff;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark-view life cycle

- (void)viewDidLoad
{
    counter = 0;
[[ UIApplication sharedApplication ] setIdleTimerDisabled: YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]initWithCapacity:2];
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isBooked"];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.778376 longitude:-122.409853 zoom:mapZoomLevel];
    
    customMapView.backgroundColor = [UIColor clearColor];
    CGRect rectMap = CGRectMake(0, 0, 320, self.view.bounds.size.height);
    mapView_ = [GMSMapView mapWithFrame:rectMap camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
  //mapView_.settings.compassButton = YES;
    
    
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    customMapView = mapView_;
    [self.view addSubview:customMapView];
    [self.view bringSubviewToFront:PickUpAndDropView];
    [self.view bringSubviewToFront:acceptRejectBtnView];
    
    
    [Helper setToLabel:labelPickupTitle Text:@"Pickup Location" WithFont:Robot_CondensedRegular FSize:11 Color:UIColorFromRGB(0x6e6e6e)];
    [Helper setToLabel:labelDropOffTitle Text:@"DropOff Loaction" WithFont:Robot_CondensedRegular FSize:11 Color:UIColorFromRGB(0x6e6e6e)];
    [Helper setToLabel:labelPickeup  Text:nil WithFont:Robot_Regular FSize:13 Color:UIColorFromRGB(0x000000)];
    [Helper setToLabel:labelDropOff Text:nil WithFont:Robot_Regular FSize:13 Color:UIColorFromRGB(0x000000)];
    [Helper setToLabel:labelPickUpdistance Text:@"" WithFont:Robot_CondensedRegular FSize:16 Color:UIColorFromRGB(0x333333)];
    [Helper setToLabel:labelDropOffdistance Text:@"" WithFont:Robot_CondensedRegular FSize:16 Color:UIColorFromRGB(0x333333)];
    [Helper setToLabel:labelPickUpMile Text:@"mi" WithFont:Robot_Regular FSize:11 Color:UIColorFromRGB(0x000000)];
    [Helper setToLabel:labelDropOffMile Text:@"mi" WithFont:Robot_Regular FSize:11 Color:UIColorFromRGB(0x000000)];
    [Helper setButton:btnAccept Text:@"ACCEPT" WithFont:Robot_CondensedLight FSize:15 TitleColor:UIColorFromRGB(0x24ff00) ShadowColor:nil];
    [Helper setButton:btnReject Text:@"REJECT" WithFont:Robot_CondensedLight FSize:15 TitleColor:UIColorFromRGB(0xff0000) ShadowColor:nil];
    [self addCustomNavigationBar];
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        if( [[UIScreen mainScreen] bounds].size.height >= 568 || [[UIScreen mainScreen] bounds].size.width >= 568 )
        {
            bgview =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-510, self.view.frame.size.width, 60)];        }
        else
        {
           bgview =[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 60)];
        }
    }
    
    
    bgview.backgroundColor=[UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:139.0/255.0 alpha:1] ;
    self.switchOnOff =[[DCRoundSwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-35,17,70,29)];
    self.switchOnOff.onTintColor = [UIColor colorWithRed:131.0/255.0 green:195.0/255.0 blue:70.0/255.0 alpha:1];
    self.switchOnOff.onText = NSLocalizedString(@"ON", @"");
    self.switchOnOff.offText = NSLocalizedString(@"OFF", @"");
    self.switchOnOff.on = YES;
    [self performSelector:@selector(callSwitch) withObject:nil afterDelay:2];
    titlelbl =[[UILabel alloc]initWithFrame:CGRectMake(70, 17, 120, 30)];
    titlelbl.text=@"Availability";
    titlelbl.textColor = [UIColor whiteColor];
    // [bgview addSubview:titlelbl];
    [bgview addSubview:switchOnOff];
    [self.view addSubview:bgview];
    
    
    
   // [self driverStateChanges];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newBookingCame:) name:@"NewBooking" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(driverStateChanges) name:@"DriverState" object:nil];

    
    _currentLatitude = 13.028866;
    _currentLongitude = 77.589760;
    //[self startPubNubSream];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBooked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //......TODO:: ADD CUSTOMEVIEW IN MAP
    
     carName = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPatientCarNameKey];
     NSDictionary *statusDict = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPatientCarIDKey];
    
    carNumber =statusDict[@"license_plate_no"];
    
     //set the local currency symbol
     [[Helper sharedInstance] setCurrencyUnit];
    
}
-(void)callSwitch
{
    [self.switchOnOff addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged] ;
}
-(void)navigateToBookingScreen{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    
    OnBookingViewController *booking = [storyboard instantiateViewControllerWithIdentifier:@"OnBookingViewControllerID"];
    booking.bookingStatus = _bookingStatus;
    booking.passDetail = dictpassDetail;
    
    
    [self.navigationController pushViewController:booking animated:YES];
}

- (void) viewDidAppear:(BOOL)animated{
    
    // [self addgestureToMap];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    PriveMdAppDelegate *appDelegate = (PriveMdAppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (IS_SIMULATOR)
    {
        _currentLatitude = 13.028866;
        _currentLongitude = 77.589760;
        CLLocationCoordinate2D locationCord = CLLocationCoordinate2DMake(_currentLatitude,_currentLongitude);
        mapView_.camera = [GMSCameraPosition cameraWithTarget:locationCord
                                                         zoom:14];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(_currentLatitude, _currentLongitude);
        marker.title = @"It's Me";
        marker.snippet = @"Current Location";
        marker.map = mapView_;
        
        //subscribe to pubnub to get stream of doctors location
        //[self startPubNubStream];
        
    }
    else
    {
        
        NSLog(@"latitude %f",_currentLatitude);
        NSLog(@"logitude %f",_currentLatitude);
        

        
    }
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [appDelegate subscribeToPubnubChannel];
        [self startUpdatingLocationToServer];
    });
    
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    
    
    if (!appDelegate.isNewBooking) {
        BOOL res=!appDelegate.isNewBooking;
        NSLog(@"bool%i",res);
        
        
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi showPIOnView:self.view withMessage:@"Checking booking status.."];
        CheckBookingStatus *status = [CheckBookingStatus sharedInstance];
        status.callblock = ^(int status,NSDictionary *dictionary){
            
            ProgressIndicator *pi = [ProgressIndicator sharedInstance];
            [pi hideProgressIndicator];
            NSLog(@"remvoed check booking status");
            if (status == kNotificationTypeBookingOnTheWay || status == kNotificationTypeBookingArrived || status == kNotificationTypeBookingBeginTrip) {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isBooked"];
                [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"bid"] forKey:@"bid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                _bookingStatus = status;
                [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"pasChn"] forKey:kNSUPassengerChannelKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                dictpassDetail = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
                [self performSegueWithIdentifier:@"GotoDriverDetailController" sender:self];
                
                
                //[self performSelectorOnMainThread:@selector(navigateToBookingScreen) withObject:nil waitUntilDone:YES];
                
            }
            
            
        };
        [status checkOngoingAppointmentStatus:nil];
    }
    else {
        appDelegate.isNewBooking  = NO;
    }
    
//check driver status
//  [appDelegate checkDriverStatus];
//    LocationTracker *tracker = [LocationTracker sharedInstance];
//    tracker.distanceCallback = ^(float totalDistance){
//        
//        NSLog(@"distance : %f",totalDistance);
//    };
//    UpdateBookingStatus *st = [UpdateBookingStatus sharedInstance];
//    st.iterations = 5;
//    st.driverState = kPubNubDriverCancelBooking;
//    [st startUpdatingStatus];
//    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[self gotoBookingInfo];
    });
    
//    UploadFiles * upload = [[UploadFiles alloc]init];
//    upload.delegate = self;
//    //  [upload calcImageSetting1length:_pickedImage];
//    [upload uploadImageFile:[UIImage imageNamed:@"arrive_status_bg_selected"]];
}

-(void)gotoBookingInfo{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    BookingHistoryViewController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"history"];
    [self.navigationController pushViewController:viewcontrolelr animated:YES];
}

-(void)uploadFile:(UploadFiles *)uploadfile didUploadSuccessfullyWithUrl:(NSArray *)imageUrls{
    NSLog(@"image url %@",imageUrls);
}


- (void)viewWillAppear:(BOOL)animated
{
    
    
    
    self.navigationController.navigationBar.barTintColor= NavBarTint_Color;
    self.navigationController.navigationBarHidden = YES;
    
    [self startLocationTrackingforLatlong];
}

- (void)startLocationTrackingforLatlong {
    
    //check location services is enabled
    if ([CLLocationManager locationServicesEnabled]) {
        
        //LOCATION CODE
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
        
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //_locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.distanceFilter = 50; // meters
        [_locationManager startUpdatingLocation];
        
    }}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    _currentLatitude = newLocation.coordinate.longitude;
    _currentLongitude =newLocation.coordinate.latitude;
    [self getaddressFromlatlon:newLocation.coordinate.latitude Longitude:newLocation.coordinate.longitude];
    
}





-(void)startUpdatingLocationToServer{
    
    self.locationTracker = [LocationTracker sharedInstance];
    
//    self.locationTracker.distanceCallback = ^(float totalDistance){
//   labelDistanceValue.text = [MathController stringifyDistance:totalDistance];
//        NSLog(@"distance %@",[MathController stringifyDistance:totalDistance]);
//    };
    [self.locationTracker startLocationTracking];
    
    //Send the best location to server every 60 seconds
    //You may adjust the time interval depends on the need of your app.
    NSTimeInterval time = 2.0;
	self.locationUpdateTimer =
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(updateLocation)
                                   userInfo:nil
                                    repeats:YES];
}
-(void)updateLocation {
    NSLog(@"updateLocation");
    
    [self.locationTracker updateLocationToServer];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    
    
    
    [_allMarkers removeAllObjects];
    _isUpdatedLocation = NO;
    
    @try {
        [mapView_ removeObserver:self
                      forKeyPath:@"myLocation"
                         context:NULL];
    }
    @catch (NSException *exception) {
        NSLog(@"exceptio : %@",exception.description);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark PUBNUB
//
//-(void)startPubNubSream{
//    
//    //_currentLatitude = _currentLatitude + 0.02;
//    //_currentLongitude = _currentLongitude + 0.01;
//    
//    PatientPubNubWrapper *pubNub = [PatientPubNubWrapper sharedInstance];
//    
//     _patientPubNubChannel = [[NSUserDefaults standardUserDefaults] objectForKey:kNSURoadyoPubNubChannelkey];
//    
//    [pubNub subscribeOnChannels:@[_patientPubNubChannel]];
//    
//    [pubNub setDelegate:self];
//    
//    NSString *driverEmail = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPatientEmailAddressKey];
//    
//    NSDictionary *message = @{@"a":[NSNumber numberWithInt:kPubNubStartUploadLocation],
//                              @"e_id": driverEmail,
//                              @"lt": [NSNumber numberWithFloat:_currentLatitude],
//                              @"lg": [NSNumber numberWithFloat:_currentLongitude],
//                             };
//    
//    
//    
//    [pubNub sendMessageAsDictionary:message toChannel:_patientPubNubChannel];
//}
//#pragma mark - PubNubWrapperDelegate
//
//-(void)recievedMessage:(NSDictionary*)messageDict onChannel:(NSString*)channelName;
//{
//     NSLog(@"Message : %@", messageDict);
//    if ([channelName isEqualToString:_patientPubNubChannel] ) {
//        
//       
//        
//        
//    }
//}
//-(void)didFailedToConnectPubNub:(NSError *)error{
//    
//    // ProgressIndicator *pi = [ProgressIndicator sharedInstance];
//    
//}

#pragma mark NSNotification Mehods
-(void)newBookingCame:(NSNotification*)notification{
    NSLog(@"userinfo : %@",notification.userInfo);
    
    
    bgview.hidden=YES;
   
    //app should not take action for new booking notificaiton if driver is alreay booked
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isBooked"]) {
        
        
        //check if driver is alreay in process of accepting/rejecting booking
        if (!_isNewBookingInProcess) {
            
            _isNewBookingInProcess = YES;
            NSLog(@"Got Booking");
            NSDictionary *bookingInfo = notification.userInfo;
            [[NSUserDefaults standardUserDefaults] setObject:bookingInfo forKey:@"PUSH"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            

            
            
           // [self getpassengerDeatil];
            
            BookingDetail *bookingDetail = [BookingDetail sharedInstance];
            bookingDetail.callback = ^(NSDictionary *bookingDetail,BOOL sucess,Errorhandler *handler){
                if (sucess) {
                    
                    
                    
                    
                    labelPickeup.text = bookingDetail[@"addr1"];
                    labelDropOff.text = bookingDetail[@"dropAddr1"];
                    labelPickUpdistance.text = bookingDetail[@"apptDis"];
                    labelDropOffdistance.text = bookingDetail[@"dis"];
                    dictpassDetail = [[NSMutableDictionary alloc] initWithDictionary:bookingDetail];
                    _labelBookingId.text   = [NSString stringWithFormat:@"Bookin Id :%@",bookingDetail[@"bid"]];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:bookingDetail[@"bid"] forKey:@"bid"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    if ([labelDropOff.text length] == 0) {
                        //[self performSelectorOnMainThread:@selector(hideDropAddressView) withObject:nil waitUntilDone:YES];
                    }
                    
      
                    
                    [[NSUserDefaults standardUserDefaults] setObject:bookingDetail[@"pasChn"] forKey:kNSUPassengerChannelKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
                else {
                    [self hideBookingInfoViews];
                    [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
                }
            };
            
            [bookingDetail sendBookingDetailRequest];
            
            
            
            [self showBookingInfoView];
            
        }
        
    }
    
    
}




#pragma mark BookingInfoView Animation

-(void)hideBookingInfoViews{
    
    _isNewBookingInProcess = NO;
    
    
    [self startAnimationDownForBottom];
    [self startAnimationDownForTop];
    
    [_progressView removeFromSuperview];
    if (timer) {
        [timer invalidate];
    }
}
-(void)showBookingInfoView{
    
    
    _isNewBookingInProcess = YES;
    [self startCoundownTimer];
    [self startAnimationUpForBottom];
    [self startAnimationUpForTop];
}
-(void)startAnimationDownForBottom
{
    
    CGRect frame = acceptRejectBtnView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    frame.origin.x = 0;
    
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^
     {
         
         
         acceptRejectBtnView.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         [acceptRejectBtnView setHidden:YES];
         
     }];
}

-(void)startAnimationDownForTop
{
    CGRect frame = PickUpAndDropView.frame;
    frame.origin.y = -99;
    frame.origin.x = 0;
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^(){
                         
                         PickUpAndDropView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Completed");
                         [PickUpAndDropView setHidden:YES];
                         
                     }];
}


-(void)startAnimationUpForBottom
{
    
    
    [acceptRejectBtnView setHidden:NO];
    
    
    CGRect frame = acceptRejectBtnView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - 79;
    frame.origin.x = 0;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^(){
                         
                         
                         acceptRejectBtnView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Completed");
                         
                     }];
    
    
}

-(void)startAnimationUpForTop
{
    [PickUpAndDropView setHidden:NO];
    
    //   PickUpAndDropView.frame = CGRectMake(0, -64-91, 320, 91);
    //   PickUpAndDropView.frame = CGRectMake(0, 0, 320, 89);
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         CGRect frame = PickUpAndDropView.frame;
         frame.origin.y = 64;
         frame.origin.x = 0;
         PickUpAndDropView.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
    
    
    
    
}






-(void)addgestureToMap
{
    _tapInterceptor = [[WildcardGestureRecognizer alloc] init];
    //  CLLocation *location = mapView_.myLocation;
    
    __weak typeof(self) weakSelf = self;
    _tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event , int touchtype)
	{
        if (touchtype == 1)
        {
       //[weakSelf startAnimation];
        }
        else {
           // [weakSelf endAnimation];
        }
        
	};
	[mapView_  addGestureRecognizer:_tapInterceptor];
    
    
}


#pragma Circula Progress View

-(void)startCoundownTimer{
    
    _progressView = [[PICircularProgressView alloc]initWithFrame:CGRectMake(320/2-50, 240, 100, 100)];
    [self.view addSubview:_progressView];
    self.progressView.thicknessRatio=0.5;
    self.progressView.progress = 1;
    self.progressView.showText =YES;
    self.progressView.roundedHead = YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}


- (void)timerTick
{
 // float Newvalue = _progressView.progress - (0.016666666);
    float Newvalue = _progressView.progress - (0.022222222);

    _progressView.progress = Newvalue;
    NSLog(@"Newvalue==== %.1f",Newvalue);
    if (Newvalue <= 0.0) {
        
        NSLog(@"Newvalue1111==== %.1f",Newvalue);
        [timer invalidate];
        [_progressView removeFromSuperview];
        [self hideBookingInfoViews];
    }
    
}



-(void)getpassengerDeatil
{
    ResKitWebService * rest = [ResKitWebService sharedInstance];
    NSDictionary *queryParams= nil;
    NSDictionary * dictP = [[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH"];
   // NSDictionary * dictP = [dict objectForKey:@"aps"];
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                   [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken],KDAcheckUserSessionToken,
                   [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPCommonDevideId,
                   [dictP objectForKey:@"e"],kSMPSignUpEmail,
                   [dictP objectForKey:@"dt"], kSMPRespondBookingDateTime,
                   constkNotificationTypeBookingType,kSMPPassengerUserType,
                   [Helper getCurrentDateTime],kSMPCommonUpDateTime, nil];
    
    TELogInfo(@"param%@",queryParams);
    [rest composeRequestForPassengerDetail:MethodAppointmentDetail
                                   paramas:queryParams
                              onComplition:^(BOOL success, NSDictionary *response){
                                  if (success) { //handle success response
                                      [self passengerDetailResponse:(NSArray*)response];
                                  }
                                  else{//error
                                      
                                  }
                              }];
    
  
    
}

-(void)passengerDetailResponse:(NSArray*)response
{
    Errorhandler * handler = [response objectAtIndex:0];
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    
    if ([[handler errFlag] intValue] ==0)
    {
         passDetail * profile = handler.objects;
        [Helper setToLabel:labelPickeup  Text:profile.addr1 WithFont:Robot_Regular FSize:13 Color:UIColorFromRGB(0x000000)];
        [Helper setToLabel:labelDropOff Text:profile.dropAddr1 WithFont:Robot_Regular FSize:13 Color:UIColorFromRGB(0x000000)];
        [Helper setToLabel:labelPickUpdistance Text:profile.apptDis WithFont:Robot_CondensedRegular FSize:16 Color:UIColorFromRGB(0x333333)];
        [Helper setToLabel:labelDropOffdistance Text:profile.dis WithFont:Robot_CondensedRegular FSize:16 Color:UIColorFromRGB(0x333333)];
        
        dictpassDetail = [[NSMutableDictionary alloc]init];
        [dictpassDetail setObject:profile.fName forKey:@"fName"];
        [dictpassDetail setObject:profile.lName forKey:@"lName"];
        [dictpassDetail setObject:profile.mobile forKey:@"mobile"];
        [dictpassDetail setObject:profile.addr1 forKey:@"addr1"];
        [dictpassDetail setObject:profile.addr2 forKey:@"addr2"];
        [dictpassDetail setObject:profile.amount forKey:@"amount"];
        [dictpassDetail setObject:profile.fare forKey:@"fare"];
        [dictpassDetail setObject:profile.dis forKey:@"dis"];
        [dictpassDetail setObject:profile.dur forKey:@"dur"];
        [dictpassDetail setObject:profile.pPic  forKey:@"pPic"];
        [dictpassDetail setObject:profile.dropAddr1 forKey:@"dropAddr1"];
        [dictpassDetail setObject:profile.dropAddr2 forKey:@"dropAddr2"];
        [dictpassDetail setObject:profile.pickLat forKey:@"pickLat"];
        [dictpassDetail setObject:profile.pickLong forKey:@"pickLong"];
        [dictpassDetail setObject:profile.dropLat forKey:@"dropLat"];
        [dictpassDetail setObject:profile.dropLong forKey:@"dropLong"];
        [dictpassDetail setObject:profile.apptDis forKey:@"apptDis"];
        [dictpassDetail setObject:profile.apptDt forKey:@"apptDt"];
        [dictpassDetail setObject:profile.email forKey:@"email"];
        [dictpassDetail setObject:profile.bid forKey:@"bid"];
        
        _labelBookingId.text   = [NSString stringWithFormat:@"Bookin Id :%@",profile.bid];
     
        //[self startCoundownTimer];
        
        //[self updateDestinationOnMapWithLocation];
               
    }
    else
    {
        [self hideBookingInfoViews];
        
        if ([[handler errNum] integerValue] == 7 || [[handler errNum] integerValue] == 6) {
            
            [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                        @"Main" bundle:[NSBundle mainBundle]];
            
            HelpViewController *help = [storyboard instantiateViewControllerWithIdentifier:@"helpVC"];
            
            self.navigationController.viewControllers = [NSArray arrayWithObjects:help, nil];
        }
        else
        {
           [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
            
            
        }
    

    }
    
}

-(void)updateDestinationOnMapWithLocation {
    
    [_mutablePath removeAllCoordinates];
    
  //  for (int i = 0; i<6; i++) {
//float latitude = 12.9128118;//[dictpassDetail[@"pickLat"] floatValue];
   // float longitude = 77.6092188;//[dictpassDetail[@"pickLong"] floatValue];
    
    float latitude = [dictpassDetail[@"dropLat"] floatValue];
    float longitude = [dictpassDetail[@"dropLong"] floatValue];
        
        latitudeChange =  latitudeChange +  0.12334;
        longitdeChange = longitdeChange +  0.12334;
        
        latitude = latitude + latitudeChange;
        longitude = longitude + longitdeChange;
        
        [self updateDestinationLocationWithLatitude:latitude Longitude:longitude];
  //  }
    //[waypointStrings_ insertObject:destinationLocation atIndex:1];
    
}

-(void)getCurrentLocation{
    
    //check location services is enabled
    if ([CLLocationManager locationServicesEnabled]) {
        
        _isUpdatedLocation = NO;
        
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.distanceFilter = kCLDistanceFilterNone;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
        }
        [_locationManager startUpdatingLocation];
        
        
    }
    else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Service" message:@"Unable to find your location,Please enable location services." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    
}



#pragma mark- GMSMapviewDelegate


- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    
}
- (void) mapView:(GMSMapView *) mapView willMove:(BOOL)gesture{
    
    NSLog(@"willMove");
    
}

- (void) mapView:(GMSMapView *) mapView didChangeCameraPosition:(GMSCameraPosition *) position{
    
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    
    NSLog(@"idleAtCameraPosition");
    
    /**
     *  don't update location and pubnub stream
     */
    
//    if (_isMarkerClicked) {
//        _isMarkerClicked = NO;
//        return;
//        
//    }
//    
//    if (_isUpdatedLocation) {
//        
//        CGPoint point1 = mapView_.center;
//        CLLocationCoordinate2D coor = [mapView_.projection coordinateForPoint:point1];
//        NSLog(@"center Coordinate idleAtCameraPosition :%f %f",coor.latitude,coor.longitude);
//        
//        _currentLatitude = coor.latitude;
//        _currentLongitude = coor.longitude;
//        
//        if (!_isCurrentLocationLocked) {
//            [self changePubNubStream];
//            
//            if (_isLocaitonChangedManually) {
//                _isLocaitonChangedManually = NO;
//            }
//            else {
//                [self getAddress:coor];
//            }
//            
//        }
//        
//        
//    }
//    
}
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
    [self performSegueWithIdentifier:@"doctorDetails" sender:marker];
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    NSLog(@"marker userData %@",marker.userData);
    
    
    //[self stopPubNubStream];
//    _isMarkerClicked = YES;
//    
//    NSDictionary *dictionary = _medicalSpecialistDetail[marker.userData];
//    
//    CustomMarkerView *customMarkerView = [CustomMarkerView sharedInstance];
//    [customMarkerView updateTitle:dictionary[@"name"]];
//    
//    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",baseUrlForThumbnailImage,dictionary[@"image"]];
//    [customMarkerView.profileImage setImageWithURL:[NSURL URLWithString:strImageUrl]
//                                  placeholderImage:[UIImage imageNamed:@"signup_image_user.png"]
//                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                                             
//                                         }];
//    
//    [customMarkerView updateRating:[dictionary[@"rating"] floatValue]];
//    
//    
//    return customMarkerView;
    return nil;
}
- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker{
    NSLog(@"didBeginDraggingMarker");
}
- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker{
    NSLog(@"didEndDraggingMarker");
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    
    
    
    if (!_isUpdatedLocation) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        _isUpdatedLocation = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        NSLog(@"%f %f",location.coordinate.latitude,location.coordinate.longitude);
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        _currentLocationMarker  = [[GMSMarker alloc] init];//[GMSMarker markerWithPosition:position];
        _currentLocationMarker.position = position;
        //_currentLocationMarker.flat = YES;
        //_currentLocationMarker.groundAnchor = CGPointMake(0.5f, 0.5f);
        _currentLocationMarker.icon = [UIImage imageNamed:@"arrive_caricon"];
        _currentLocationMarker.map = mapView_;
        
        [self createCenterView];
        
        
        
        
    }
    else {
//        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
//        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
//        _currentLocationMarker.position = position;
    }
    
}

-(void)createCenterView{
    
        
        UIView *customMarkerview = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-205/2,(self.view.frame.size.height/2)-98,231,43)];
        customMarkerview.tag = 111;
        [customMarkerview setUserInteractionEnabled:NO];
        [customMarkerview setHidden:NO];
        UIButton *customMarkerTopBottom = [UIButton buttonWithType:UIButtonTypeCustom];
        customMarkerTopBottom.frame = CGRectMake(0, 0, 200, 50);
        UIImage *selImage = [UIImage imageNamed:@"home_pickuplocation_bg_on.png"];
        UIImage *norImage = [UIImage imageNamed:@"home_pickuplocation_bg.png"];
        [customMarkerTopBottom setBackgroundImage:selImage forState:UIControlStateHighlighted];
        [customMarkerTopBottom setBackgroundImage:norImage forState:UIControlStateNormal];
        customMarkerTopBottom.userInteractionEnabled = YES;
        [customMarkerview addSubview:customMarkerTopBottom];
    
        [Helper setButton:customMarkerTopBottom Text:carName WithFont:Trebuchet_MS FSize:13 TitleColor:UIColorFromRGB(0xffffff) ShadowColor:nil];
        [customMarkerTopBottom setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [customMarkerTopBottom setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateHighlighted];
        customMarkerTopBottom.titleLabel.textAlignment = NSTextAlignmentLeft;
        customMarkerTopBottom.titleEdgeInsets = UIEdgeInsetsMake(-14,9,0,0);
    
    
         labelcarNumber =[[UILabel alloc]initWithFrame:CGRectMake(66, 27, 100, 10)];
         [Helper setToLabel:labelcarNumber Text:carNumber WithFont:Trebuchet_MS FSize:13 Color:UIColorFromRGB(0xffffff)];
         [customMarkerTopBottom addSubview:labelcarNumber];

        customMarkerview.backgroundColor = CLEAR_COLOR;
        [self.view bringSubviewToFront:acceptRejectBtnView];
        [self.view addSubview:customMarkerview];
    
 
}

-(void)getaddressFromlatlon:(double)latitude Longitude:(double)longitude{
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         //NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
         if (error == nil && [placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks lastObject];
             
             // strAdd -> take bydefault value nil
             strcurrentAddress = nil;
             
             if ([placemark.subThoroughfare length] != 0)
                 strcurrentAddress = placemark.subThoroughfare;
             
             if ([placemark.thoroughfare length] != 0)
             {
                 // strAdd -> store value of current location
                 if ([strcurrentAddress length] != 0)
                     strcurrentAddress = [NSString stringWithFormat:@"%@, %@",[placemark thoroughfare],strcurrentAddress];
                 else
                 {
                     // strAdd -> store only this value,which is not null
                     strcurrentAddress = placemark.thoroughfare;
                 }
             }
             
             if ([placemark.postalCode length] != 0)
             {
                 if ([strcurrentAddress length] != 0)
                     strcurrentAddress = [NSString stringWithFormat:@"%@, %@",[placemark postalCode],strcurrentAddress];
                 else
                     strcurrentAddress = placemark.postalCode;
             }
             
             if ([placemark.locality length] != 0)
             {
                 if ([strcurrentAddress length] != 0)
                     strcurrentAddress = [NSString stringWithFormat:@"%@, %@",[placemark locality],strcurrentAddress];
                 else
                     strcurrentAddress = placemark.locality;
                 
                 //[[NSUserDefaults standardUserDefaults]setObject:placemark.locality forKey:KNUserCurrentCity];
             }
             
             if ([placemark.administrativeArea length] != 0)
             {
                 if ([strcurrentAddress length] != 0)
                     strcurrentAddress = [NSString stringWithFormat:@"%@, %@",[placemark administrativeArea],strcurrentAddress];
                 else
                     strcurrentAddress = placemark.administrativeArea;
                 
                 //[[NSUserDefaults standardUserDefaults]setObject:placemark.administrativeArea forKey:KNUserCurrentState];
             }
             
             if ([placemark.country length] != 0)
             {
                 if ([strcurrentAddress length] != 0)
                     strcurrentAddress = [NSString stringWithFormat:@"%@, %@",[placemark country],strcurrentAddress];
                 else
                     strcurrentAddress = placemark.country;
                 
                 //  [[NSUserDefaults standardUserDefaults]setObject:placemark.country forKey:KNUserCurrentCity];
             }
             
             if ([placemark.subLocality length] != 0)
             {
                 if ([strcurrentAddress length] != 0)
                     strcurrentAddress = [NSString stringWithFormat:@"%@, %@",[placemark subLocality],strcurrentAddress];
                 else
                     strcurrentAddress = placemark.country;
                 
                 
             }
             
             
             
             NSLog(@"%@",strcurrentAddress);
             
             [[NSUserDefaults standardUserDefaults] setObject:strcurrentAddress forKey:@"myAddress"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             addressStr =strcurrentAddress;
             
             
             
    
             
             
             if (([placemark.locality length] != 0) && ([placemark.administrativeArea length] != 0) && ([placemark.country length] != 0)){
                 
             }
             
         }
     }];
    
    
    
}




- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"locationManager failed to update location : %@",[error localizedDescription]);
}

- (void)addDirections:(NSDictionary *)json {
    
    if ([json[@"routes"] count]>0) {
        NSDictionary *routes = [json objectForKey:@"routes"][0];
        
        NSDictionary *route = [routes objectForKey:@"overview_polyline"];
        NSString *overview_route = [route objectForKey:@"points"];
        GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.map = mapView_;
    }
    
    
}

-(void)updateDestinationLocationWithLatitude:(float)latitude Longitude:(float)longitude{
    
    if (!_isPathPlotted) {
        
        NSLog(@"pathplotted");
        _isPathPlotted = YES;
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                                                     latitude,
                                                                     longitude);
        
        _previouCoord = position;
        
        _destinationMarker = [GMSMarker markerWithPosition:position];
        _destinationMarker.map = mapView_;
        _destinationMarker.flat = YES;
        _destinationMarker.groundAnchor = CGPointMake(0.5f, 0.5f);
//        _destinationMarker.icon = [UIImage imageNamed:@"arrive_caricon.png"];
        _destinationMarker.icon = [UIImage imageNamed:@"car"];
        [waypoints_ addObject:_destinationMarker];
        NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                    latitude,longitude];
        
        [waypointStrings_ addObject:positionString];
        
        if([waypoints_ count]>1){
            NSString *sensor = @"false";
            NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                                   nil];
            NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
            NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                              forKeys:keys];
            DirectionService *mds=[[DirectionService alloc] init];
            SEL selector = @selector(addDirections:);
            [mds setDirectionsQuery:query
                       withSelector:selector
                       withDelegate:self];
        }
        
    }
    else {
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude,longitude);
        CLLocationDirection heading = GMSGeometryHeading(_previouCoord, position);
        _previouCoord = position;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:2.0];
        _destinationMarker.position = position;
        [CATransaction commit];
        if (_destinationMarker.flat) {
            _destinationMarker.rotation = heading;
        }
        
    }
    
    
    
}

//- (void)animateToNextCoord:(GMSMarker *)marker {
//    
//    CoordsList *coords = marker.userData;
//    CLLocationCoordinate2D coord = [coords next];
//    CLLocationCoordinate2D previous = marker.position;
//    
//    CLLocationDirection heading = GMSGeometryHeading(previous, coord);
//    CLLocationDistance distance = GMSGeometryDistance(previous, coord);
//    
//    // Use CATransaction to set a custom duration for this animation. By default, changes to the
//    // position are already animated, but with a very short default duration. When the animation is
//    // complete, trigger another animation step.
//    
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:(distance / (1 * 1000))];  // custom duration, 50km/sec
//    
//    __weak HomeViewController *weakSelf = self;
//    [CATransaction setCompletionBlock:^{
//        [weakSelf animateToNextCoord:marker];
//    }];
//    
//    marker.position = coord;
//    
//    [CATransaction commit];
//    
//    // If this marker is flat, implicitly trigger a change in rotation, which will finish quickly.
//    if (marker.flat) {
//        marker.rotation = heading;
//    }
//}

#pragma mark -button accept and reject action;

-(IBAction)btnAcceptRejectClicked:(id)sender
{
  
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH"];
    NSDictionary * dictP = [dict objectForKey:@"aps"];
    UIButton * button = (UIButton*)sender;
   
    ResKitWebService * restKit = [ResKitWebService sharedInstance];
    switch (button.tag) {
        case 10://accept
        {
            [self stopSound];
            
               bgview.hidden=NO;
            ProgressIndicator *pi = [ProgressIndicator sharedInstance];
            [pi showPIOnView:self.view withMessage:@"Please wait.."];
            [self sendRequestForUpdateStatus];
         
            
    
            
  
            break;
        }
        case 11://reject
        {
            [self stopSound];
            bgview.hidden=NO;
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Are you sure you want to reject this booking?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            [alert show];
            alert.tag =200;
            
          
            
           
            break;
        }
            
            
        default:
            break;
    }
    
}
-(void)stopSound{
    PriveMdAppDelegate * deligate =(PriveMdAppDelegate *) [ UIApplication sharedApplication ].delegate;
    AudioServicesDisposeSystemSoundID(deligate.pewPewSoundIncoming);

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
   
    
    if (alertView.tag==200)
    {
        
        if (buttonIndex==0) {
            
            ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
            [progressIndicator showPIOnView:self.view withMessage:@"Please wait.."];
            
            ResKitWebService * restKit = [ResKitWebService sharedInstance];
            
            NSDictionary * dictP = [[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH"];
            //NSDictionary * dictP = [dict objectForKey:@"aps"];
            
            NSDictionary *queryParams;
            queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                           [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken],KDAcheckUserSessionToken,
                           [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPCommonDevideId,
                           [dictP objectForKey:@"e"],kSMPRespondPassengerEmail,
                           [dictP objectForKey:@"dt"], kSMPRespondBookingDateTime,
                           [dictP objectForKey:@"bid"], kSMPRespondDocbid,
                           constkNotificationTypeBookingReject,kSMPRespondResponse,
                           constkNotificationTypeBookingType,kSMPRespondBookingType,
                           [Helper getCurrentDateTime],kSMPCommonUpDateTime, nil];
            
            //TELogInfo(@"param%@",queryParams);
            [restKit composeRequestForAccept:MethodRespondToAppointMent
                                     paramas:queryParams
                                onComplition:^(BOOL success, NSDictionary *response){
                                    
                                    if (success) { //handle success response
                                        [self RejectResponse:(NSArray*)response];
                                    }
                                    else{//error
                                        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
                                        [pi hideProgressIndicator];
                                    }
                                }];
        }
        
       
        
    }
    
    
    
}

#pragma mark -AcceptReject Response
-(void)RejectResponse :(NSArray*)array
{
    //TELogInfo(@"_response%@",array);
    Errorhandler * handler = [array objectAtIndex:0];
    
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    
    [self hideBookingInfoViews];
    
    if ([[handler errFlag] intValue] ==0)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBooked"];
        isPassangeBookDriver = NO;
        mapView_ .frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
       
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBooked"];
         mapView_ .frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
        [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
    }
    
    
}
-(void)acceptResponse :(NSArray*)array
{
    //[self performSegueWithIdentifier:@"GotoDriverDetailController" sender:self];
    
    Errorhandler * handler = [array objectAtIndex:0];
    [handler description];
    
    if ([[handler errFlag] intValue] == 0) {
        
        [self sendRequestForUpdateStatus];
      
       
    }
    else
    {
        ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
        [progressIndicator hideProgressIndicator];

        [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
        
        [self hideBookingInfoViews];
        
      
    }
 
}

#pragma mark - Web Servies Request

-(void)sendRequestForUpdateStatus
{
    
    NSDictionary * dictP = [[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH"];
    //NSDictionary * dictP = [dict objectForKey:@"aps"];
    
    //addressStr
    // _currentLatitude
    // _currentLongitude
    
   
    
    NSString *currentLat = [NSString stringWithFormat:@"%f",_currentLatitude];
    NSString *currentLongi = [NSString stringWithFormat:@"%f",_currentLongitude];
    NSLog(@"addressStr:: %@",addressStr);
    NSLog(@"currentLat:: %@",currentLat);
    NSLog(@"currentLongi:: %@",currentLongi);
    
    ResKitWebService * restkit = [ResKitWebService sharedInstance];
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                   [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken],KDAcheckUserSessionToken,
                   [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPCommonDevideId,
                   dictP[@"e"],kSMPRespondPassengerEmail,
                   dictP[@"dt"], kSMPRespondBookingDateTime,
                   dictP[@"bid"], kSMPRespondDocbid,
                   addressStr,kSMPRespondcurrentAddress,
                   currentLat, kSMPRespondcurrentLatitude,
                   currentLongi, kSMPRespondcurrentLongitude,
                   constkNotificationTypeBookingOnTheWay,kSMPRespondResponse,
                   @"testing",kSMPRespondDocNotes,
                   [Helper getCurrentDateTime],kSMPCommonUpDateTime, nil];
    
                   TELogInfo(@"param%@",queryParams);
                   NSLog(@"qerrry%@",queryParams);
    
    [restkit composeRequestForUpdateStatus:MethodupdateApptStatus
                                   paramas:queryParams
                              onComplition:^(BOOL success, NSDictionary *response){
                                  
                                  if (success) { //handle success response
                                      [self updateStstusResponse:(NSArray*)response];
                                  }
                                  else{//error
                                      ProgressIndicator *pi = [ProgressIndicator sharedInstance];
                                      [pi hideProgressIndicator];
                                  }
                              }];
    
    
    
}

-(void)sendRequestToChagneDriverStatus:(DriverStatus)driverStatus{
    
    PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
    if ( [reachability isNetworkAvailable]) {
        
       
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi showPIOnView:self.view withMessage:@"Please wait.."];
        
        NSString *sesstionToken = [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken];
        NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
       //
        NSDictionary *queryParams = @{
                                      kSMPCommonDevideId:deviceId,
                                      KDAcheckUserSessionToken: sesstionToken,
                                      @"ent_status":[NSNumber numberWithInt:driverStatus],
                                      kSMPCommonUpDateTime:[Helper getCurrentDateTime],
                                      };
        
        
        NetworkHandler *networHandler = [NetworkHandler sharedInstance];
        [networHandler composeRequestWithMethod:MethodUpdateMasterStatus
                                        paramas:queryParams
                                   onComplition:^(BOOL success, NSDictionary *response){
                                       
                                       if (success) { //handle success response
                                           NSLog(@" %@",response);
 
                                           [pi hideProgressIndicator];
                                           
                                           [self updateDriverStstusResponse:response];
                                           
                                           //chagne status
                                           if (_driverStatus == KDriverStatusOnline) {
                                               
                                               _driverStatus = kDriverStatusOffline;
                                            
                                           }
                                           else {
                                               
                                               _driverStatus = KDriverStatusOnline;
                                               
                                           }
                                           
                                           [[NSUserDefaults standardUserDefaults] setInteger:_driverStatus forKey:kNSUDriverStatekey];
                                           [[NSUserDefaults standardUserDefaults] synchronize];
                                           
                                       }
                                       else {
                                           
                                       }
                                   }];
        
    }
    else {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi showMessage:kNetworkErrormessage On:self.view];
    }
}
-(void)updateStstusResponse :(NSArray*)response
{
    
    Errorhandler * handler = [response objectAtIndex:0];
    
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    
    [self hideBookingInfoViews];

    
    if ([[handler errFlag] intValue] == kResponseFlagSuccess)
    {
        //start updating for on the way status
        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isBooked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self updateToPassengerForBookingConfirmation];
        
        _bookingStatus = kNotificationTypeBookingOnTheWay;
        [self performSegueWithIdentifier:@"GotoDriverDetailController" sender:self];
        
        
        
        
    }
    else{
       // [self performSegueWithIdentifier:@"GotoDriverDetailController" sender:self];
        [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
       //[self performSegueWithIdentifier:@"GotoDriverDetailController" sender:self];
    }
    
}
-(void)updateDriverStstusResponse:(NSDictionary*)response{
    if (response == nil) {
        return;
    }
    else {
        NSLog(@"response %@",response);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GotoDriverDetailController"])
    {
        OnBookingViewController *booking = (OnBookingViewController*)[segue destinationViewController];
        booking.bookingStatus = _bookingStatus;
        booking.passDetail = dictpassDetail;
//        booking.passDetail = [NSDictionary dictionary];
        
        
    }
}
-(void)updateToPassengerForBookingConfirmation{
    
      if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isBooked"]) {

        UpdateBookingStatus *updateBookingStatus = [UpdateBookingStatus sharedInstance];
        updateBookingStatus.driverState = kPubNubStartDoctorLocationStreamAction;
        updateBookingStatus.iterations = 5;
        [updateBookingStatus updateToPassengerForDriverState];
        [updateBookingStatus startUpdatingStatus];
        
    }
    
    

}
#pragma mark- Custom Methods

- (void) addCustomNavigationBar{
    
    _customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    _customNavigationBarView.tag = 78;
    _customNavigationBarView.delegate = self;
    [_customNavigationBarView setTitle:@"HOME"];
    
   [_customNavigationBarView setBackgroundColor:NavBarTint_Color];

    [_customNavigationBarView setLeftBarButtonTitle:@""];
    [self.view addSubview:_customNavigationBarView];
    
}

-(void)onOffswitchButtonClicked:(UIButton *)sender{
    
    
    if (_driverStatus == KDriverStatusOnline) {
        
                [bookButton setFrame:CGRectMake(39,0,29,29)];
                [ titllstatusOnOff setFrame:CGRectMake(5,0,30,30)];
        
        
                [self sendRequestToChagneDriverStatus:KDriverStatusOnline];
        
                [Helper setToLabel:titlelbl Text:@"Availability" WithFont:@"Helvetica" FSize:15 Color:[UIColor whiteColor]];
                [Helper setToLabel:titllstatusOnOff Text:@"ON" WithFont:@"Helvetica" FSize:12 Color:[UIColor blackColor]];
        
        
            }
            else {
        
                [bookButton setFrame:CGRectMake(1,0,29,29)];
                [titllstatusOnOff setFrame:CGRectMake(37,0,30,29)];
                [self sendRequestToChagneDriverStatus:kDriverStatusOffline];
                
                [Helper setToLabel:titlelbl Text:@"Unavailability" WithFont:@"Helvetica" FSize:15 Color:[UIColor whiteColor]];
                [Helper setToLabel:titllstatusOnOff Text:@"OFF" WithFont:@"Helvetica" FSize:12 Color:[UIColor blackColor]];
            }

    
}


- (void)switchToggled:(id)sender{
    
    
    
    if (_driverStatus == KDriverStatusOnline) {
        
        
        [self sendRequestToChagneDriverStatus:KDriverStatusOnline];
        [Helper setToLabel:titlelbl Text:@"Availability" WithFont:@"Helvetica" FSize:15 Color:[UIColor whiteColor]];
        
        
    }
    else {
        
       
        [self sendRequestToChagneDriverStatus:kDriverStatusOffline];
        [Helper setToLabel:titlelbl Text:@"Unavailability" WithFont:@"Helvetica" FSize:15 Color:[UIColor whiteColor]];
       
    }
    
    
}


-(void)leftBarButtonClicked:(UIButton *)sender{
    
    if (_isNewBookingInProcess) {
        
    }
    else {
        [self menuButtonPressed:sender];
    }
    
}

#pragma mark - menu slider method

- (IBAction)menuButtonPressed:(id)sender
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
   
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}



@end
