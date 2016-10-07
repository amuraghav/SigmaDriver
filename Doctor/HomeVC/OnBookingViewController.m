//
//  OnBookingViewController.m
//  Roadyo
//
//  Created by Rahul Sharma on 01/05/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "OnBookingViewController.h"
#import "CustomNavigationBar.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "BookingHistoryViewController.h"
#import "DirectionService.h"
#import "BookingDetail.h"
#import "LocationTracker.h"
#import "PatientPubNubWrapper.h"
#import "UpdateBookingStatus.h"
#import "MathController.h"


@interface OnBookingViewController ()<CustomNavigationBarDelegate,GMSMapViewDelegate,CLLocationManagerDelegate,UIActionSheetDelegate>
{
    GMSMapView *mapView_;
    GMSGeocoder *geocoder_;
    NSMutableArray *waypoints_;
   
}
@property(nonatomic,strong) NSMutableArray *waypointStrings_;
@property(assign,nonatomic) int statusButtonTag;
@property(nonatomic,assign) BOOL isUpdatedLocation;
@property(nonatomic,assign) float currentLatitude;
@property(nonatomic,assign) float currentLongitude;
@property(nonatomic,assign) BOOL isDriverArrived;
@property(nonatomic,assign) BOOL isPathPlotted;

@property(nonatomic,assign) CLLocationCoordinate2D destinationCoordinates;
@property(nonatomic,assign) CLLocationCoordinate2D pickupCoordinates;
@property(nonatomic,assign) CLLocationCoordinate2D previouCoord;
@property(nonatomic,strong) GMSMarker *currentLocationMarker;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) GMSMarker *destinationMarker;
@property(nonatomic,strong) NSMutableDictionary *allMarkers;
@property(nonatomic,strong) NSString *destinationLocation;
@property(nonatomic,strong) NSString *destinationArea;
@property(nonatomic,strong) NSString *startLocation;
@property(strong,nonatomic) IBOutlet UIView *bottomView;
@property(strong,nonatomic) IBOutlet UIView *customMapView;
@property(strong,nonatomic) IBOutlet UIView *topView;
@property(strong,nonatomic) NSString *statusButtonTitle;
@property(strong,nonatomic) NSString *approxPrice;
@property(strong,nonatomic) NSTimer *statusUpdateTimer;
@property(nonatomic,assign) PubNubStreamAction driverState;
@end

@implementation OnBookingViewController
@synthesize customMapView;
@synthesize passDetail;
@synthesize waypointStrings_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView {
    
    [self inilizeMap];
    
}
-(void)inilizeMap{
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]initWithCapacity:2];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.778376
                                                            longitude:-122.409853
                                                                 zoom:13];
    //UIView *map = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 300)];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    
    self.view = mapView_;
}

#pragma mark-view Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    //self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:Robot_Bold size:19]}];
    
    
    if (IS_IPHONE_5) {
    
    }
    else if(IS_IPHONE_6)
    {
        
    }
    else if(IS_IPHONE_6_Plus)
    {
        
    }
    else{
        
        customMapView.frame =CGRectMake(0, 161, 320, 300);
        viewStatus.frame = CGRectMake(0, 141+300, 320, 300);
        
    }
   

    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",baseUrlForXXHDPIImage,passDetail[@"pPic"]];
    
    [imgPass setImageWithURL:[NSURL URLWithString:strImageUrl]
                    placeholderImage:[UIImage imageNamed:@"signup_profile_image"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                           }];
    
    
   
    
   // [self getCurrentLocation];
    
    [self createTopView];
    
    if (passDetail.count == 0) {
        
        
        [self getBookingInfo];
        
    }
    else{
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LocationTracker *tracker = [LocationTracker sharedInstance];
            [self setStartLocationCoordinates:tracker.lastLocaiton.coordinate.latitude Longitude:tracker.lastLocaiton.coordinate.longitude];
        });
      
    }

    
    
    //check for booking status
    if (_bookingStatus == kNotificationTypeBookingOnTheWay) {
        
        _statusButtonTitle = @"I HAVE ARRIVED";
        self.title = @"ON THE WAY";
        _statusButtonTag = 500;
        [self changePickUpAddressOnUI];
    }
    else if (_bookingStatus == kNotificationTypeBookingArrived) {
        
        _statusButtonTitle = @"BEGIN TRIP";
        self.title = @"I HAVE ARRIVED";
        _statusButtonTag = 600;
        [self changeDropAddressOnUI];
        _isDriverArrived = YES;
        
    }
    else if (_bookingStatus == kNotificationTypeBookingBeginTrip) {
        
        _statusButtonTitle = @"PASSENGER DROPPED";
        self.title = @"I HAVE ARRIVED";
        _statusButtonTag = 700;
        [self changeDropAddressOnUI];
        _isDriverArrived = YES;
    }
	
    [self createBottomView];
    
    
    
    if (passDetail.count == 0) {
        
        [self getBookingInfo];
        
    }
    
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 100, 44);
    [cancelButton setTitle:@"CANCEL BOOKING" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont fontWithName:Robot_Regular size:12];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"signup_btn_back_bg_on"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelBookingClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookingCancelledByPassenger) name:@"bookingCancelled" object:nil];
    
    
}




-(void)bookingCancelledByPassenger
{
    UpdateBookingStatus *updateBookingStatus = [UpdateBookingStatus sharedInstance];
    [updateBookingStatus stopUpdatingStatus];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBooked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getBookingInfo{
    
    BookingDetail *bookingDetail = [BookingDetail sharedInstance];
    bookingDetail.callback = ^(NSDictionary *bookingDetail,BOOL sucess,Errorhandler *handler){
        
        if (sucess) {
            
            passDetail = [[NSMutableDictionary alloc] initWithDictionary:bookingDetail];
            [self updateBookingDetailview];
            
            LocationTracker *tracker = [LocationTracker sharedInstance];
            [self setStartLocationCoordinates:tracker.lastLocaiton.coordinate.latitude Longitude:tracker.lastLocaiton.coordinate.longitude];
            
        }
        else {
            [self getBookingInfo];
            
        }
    };
    
    [bookingDetail sendBookingDetailRequest];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    if ([self.navigationController isNavigationBarHidden]) {
        NSLog(@"navigation is hidden");
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    
    //re-initilize distance to 0
    LocationTracker *tracker = [LocationTracker sharedInstance];
    tracker.distance = 0;
    
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];

    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bookingCancelled" object:nil];
    
    [_allMarkers removeAllObjects];
    
    _isUpdatedLocation = NO;
    //[self stopPubNubStream];
    //self.navigationController.navigationBarHidden = YES;
    @try {
        [mapView_ removeObserver:self
                      forKeyPath:@"myLocation"
                         context:NULL];
    }
    @catch (NSException *exception) {
        
    }
   
}
- (void)viewDidDisappear:(BOOL)animated{
    
    UpdateBookingStatus *updateBookingStatus = [UpdateBookingStatus sharedInstance];
    [updateBookingStatus stopUpdatingStatus];
}

- (void) viewDidAppear:(BOOL)animated{
    
    
    // [self addgestureToMap];
    
    if (IS_SIMULATOR) {
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
    else {
        
        NSLog(@"latitude %f",[mapView_.myLocation coordinate].latitude);
        [self.view bringSubviewToFront:viewPassDetail];
        //[self.view bringSubviewToFront:_bottomView];
    }
    
    
    /*
     //test
     AppointedDoctor *appointedDoctor = [[AppointedDoctor alloc] init];
     appointedDoctor.doctorName      =   @"Surender";
     appointedDoctor.estimatedTime   =   @"12:00";
     appointedDoctor.appoinmentDate  =   @"11/11/11";
     appointedDoctor.distance        =   @"12 m";
     appointedDoctor.contactNumber   =   @"8050023645";
     appointedDoctor.profilePicURL   =   @"";
     appointedDoctor.email           =   @"surender1101@gmail.com";
     appointedDoctor.status          =   @"I am on the way";
     
     NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:appointedDoctor];
     [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kNSUAppoinmentDoctorDetialKey];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     DoctorDetailView *docDetailView = [[DoctorDetailView alloc] initWithButtonTitle:@"hello"];
     //[docDetailView initWithButtonTitle:@"hello"];
     [docDetailView show];
     
     [docDetailView updateStatus:@"reached"]; */
    
}

#pragma mark- Custom Methods

- (void) addCustomNavigationBar{
    
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"Pick Up"];
    [customNavigationBarView setLeftBarButtonTitle:@"Back"];
    [self.view addSubview:customNavigationBarView];
    
}
/**
 *  create a bottom button
 */
-(void)createBottomView {
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, 320, 40)];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bottomView];
    
    UIButton *buttonDriverState = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonDriverState.frame = CGRectMake(0, 0, 320, 40);
    buttonDriverState.tag = _statusButtonTag;
    [buttonDriverState setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [buttonDriverState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[buttonDriverState setBackgroundImage:[UIImage imageNamed:@"arrive_status_bg"] forState:UIControlStateNormal];
   // [buttonDriverState setBackgroundImage:[UIImage imageNamed:@"arrive_status_bg_selected.png"] forState:UIControlStateHighlighted];
    [buttonDriverState setBackgroundColor:BUTTON_Color];
    [buttonDriverState addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonDriverState setTitle:_statusButtonTitle forState:UIControlStateNormal];
    [_bottomView addSubview:buttonDriverState];
}

/**
 *  create a view with all the booking details
 */
-(void)createTopView {
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, 320, 115)];
    [_topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_topView];
    
    
    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 100)];
    profileImageView.image = [UIImage imageNamed:@"signup_profile_image"];
    profileImageView.tag = 100;
    [_topView addSubview:profileImageView];
    
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",baseUrlForXXHDPIImage,passDetail[@"pPic"]];
    
    [profileImageView setImageWithURL:[NSURL URLWithString:strImageUrl]
                placeholderImage:[UIImage imageNamed:@"signup_profile_image"]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                       }];
    
    //Name
    UILabel *labelPassengerName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(profileImageView.frame)+5, 5,40,20)];
    [Helper setToLabel:labelPassengerName Text:@"Name :" WithFont:Robot_Bold FSize:10 Color:UIColorFromRGB(0x333333)];
   // [_topView addSubview:labelPassengerName];
    
    
    UILabel *labelPassengerNameValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(profileImageView.frame)+5, 5, 200, 20)];
    labelPassengerNameValue.tag = 101;
    labelPassengerNameValue.backgroundColor = [UIColor blueColor];
    [Helper setToLabel:labelPassengerNameValue Text:[NSString stringWithFormat:@"%@ %@",passDetail[@"fName"],passDetail[@"lName"]].uppercaseString WithFont:Robot_CondensedRegular FSize:13 Color:UIColorFromRGB(0x333333)];
    [_topView addSubview:labelPassengerNameValue];
    
    
    //Mobile
    UILabel *labelMobile = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(profileImageView.frame)+5, CGRectGetMaxY(labelPassengerName.frame)+ 5,30, 20)];
    [Helper setToLabel:labelMobile Text:@"Mob :" WithFont:Robot_Bold FSize:10 Color:UIColorFromRGB(0x333333)];
   // [_topView addSubview:labelMobile];
    
    
    UIButton *buttonMobileValue = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMobileValue.frame = CGRectMake(CGRectGetMaxX(profileImageView.frame)+5, CGRectGetMaxY(labelPassengerNameValue.frame), 80, 20);
    buttonMobileValue.tag = 102;
    buttonMobileValue.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [Helper setButton:buttonMobileValue Text:passDetail[@"mobile"] WithFont:Robot_CondensedRegular FSize:13 TitleColor:UIColorFromRGB(0x333333) ShadowColor:nil];
    [buttonMobileValue setTitleColor:[UIColor colorWithRed:0.162 green:0.554 blue:0.839 alpha:1.000] forState:UIControlStateNormal];
    [buttonMobileValue setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];
    [buttonMobileValue addTarget:self action:@selector(contactButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:buttonMobileValue];
    
    //Address
    UILabel *labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(profileImageView.frame)+5,CGRectGetMaxY(labelMobile.frame)-5,48, 13)];
    [Helper setToLabel:labelAddress  Text:@"PICK UP :"WithFont:Robot_Bold FSize:10 Color:UIColorFromRGB(0x333333)];
    labelAddress.tag = 210;
    [_topView addSubview:labelAddress];
    
    
    UILabel *labelAddressValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(profileImageView.frame)+5, CGRectGetMaxY(labelAddress.frame)-5, 200, 55)];
    labelAddressValue.numberOfLines = 3;
    labelAddressValue.tag = 211;
    [Helper setToLabel:labelAddressValue Text:passDetail[@"addr1"] WithFont:Robot_CondensedRegular FSize:13 Color:UIColorFromRGB(0x333333)];
    [_topView addSubview:labelAddressValue];
    
    
    //distance strip view
    UIView *distanceTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 320, 20)];
    distanceTimeView.tag = 212;
    distanceTimeView.backgroundColor = [UIColor grayColor];
    [_topView addSubview:distanceTimeView];
    
    //distance
    UILabel *labelDistance = [[UILabel alloc] initWithFrame:CGRectMake(5,0, 100, 20)];
    labelDistance.tag = 300;
    [Helper setToLabel:labelDistance Text:[NSString stringWithFormat:@"BID :  %@",passDetail[@"bid"]] WithFont:Robot_Regular FSize:12 Color:UIColorFromRGB(0xffffff)];
    
    [distanceTimeView addSubview:labelDistance];
    
    

    UILabel *labelDistanceValue = [[UILabel alloc] initWithFrame:CGRectMake(110,0, 80, 20)];
    [Helper setToLabel:labelDistanceValue Text:[NSString stringWithFormat:@"%@ mi",passDetail[@"dis"]] WithFont:Robot_Regular FSize:12 Color:UIColorFromRGB(0xffffff)];
    [distanceTimeView addSubview:labelDistanceValue];
    
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    LocationTracker *tracker = [LocationTracker sharedInstance];
    if ([ud objectForKey:kNSUDriverDistanceTravalled]) {
        tracker.distance = [[ud objectForKey:kNSUDriverDistanceTravalled] floatValue];
    }
    
   
    tracker.distanceCallback = ^(float totalDistance){
        
        labelDistanceValue.text = [MathController stringifyDistance:totalDistance];
        [ud setObject:[NSNumber numberWithFloat:totalDistance] forKey:kNSUDriverDistanceTravalled];
        [ud synchronize];
    };
    
    
//
//    
//    //time
//    UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(160, 0,80, 20)];
//    [Helper setToLabel:labelTime Text:@"ETA:" WithFont:Robot_Light FSize:12 Color:UIColorFromRGB(0xffffff)];
//    [distanceTimeView addSubview:labelTime];
//    
//    
//
//    UILabel *labeTimeValue = [[UILabel alloc] initWithFrame:CGRectMake(240,0, 80, 20)];
//    [Helper setToLabel:labeTimeValue Text:[NSString stringWithFormat:@"%@ min",passDetail[@"dur"]] WithFont:Robot_Regular FSize:12 Color:UIColorFromRGB(0xffffff)];
//    [distanceTimeView addSubview:labeTimeValue];


}

-(void)updateBookingDetailview{
    
   UIImageView *profileImageView =    (UIImageView*)[_topView viewWithTag:100];
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",baseUrlForXXHDPIImage,passDetail[@"pPic"]];
    
    [profileImageView setImageWithURL:[NSURL URLWithString:strImageUrl]
                     placeholderImage:[UIImage imageNamed:@"signup_profile_image"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                            }];
    
    UILabel *labelPassengerName = (UILabel*)[_topView viewWithTag:101];
    labelPassengerName.text = [NSString stringWithFormat:@"%@ %@",passDetail[@"fName"],passDetail[@"lName"]].uppercaseString;
    
    UIButton *buttonMobile = (UIButton*)[_topView viewWithTag:102];
    [buttonMobile setTitle:passDetail[@"mobile"] forState:UIControlStateNormal];
    
    
    UILabel *labelAddress = (UILabel*)[_topView viewWithTag:211];
    labelAddress.text = passDetail[@"addr1"];
    
    UIView *bookingIdView = [_topView viewWithTag:212];
    UILabel *labelbookingId = (UILabel*)[bookingIdView viewWithTag:300];
    labelbookingId.text = [NSString stringWithFormat:@"Booking Id :  %@",passDetail[@"bid"]];
}




/**
 *  changes address when drivers reached at pickup location and shows drop location
 */
-(void)changeDropAddressOnUI{
    
    UILabel *labelAddress = (UILabel*)[_topView viewWithTag:210];
    UILabel *labelAddressValue = (UILabel*)[_topView viewWithTag:211];
      self.title = @"I HAVE ARRIVED";
    labelAddress.text = @"DROP :";
    labelAddressValue.text = passDetail[@"dropAddr1"];//[NSString stringWithContentsOfFile:passDetail[@"dropAddr1"] encoding:NSUTF32StringEncoding error:nil];
}

-(void)changePickUpAddressOnUI{
    
    UILabel *labelAddress = (UILabel*)[_topView viewWithTag:210];
    UILabel *labelAddressValue = (UILabel*)[_topView viewWithTag:211];
    self.title = @"ON THE WAY";
    labelAddress.text = @"PICK UP :";
    labelAddressValue.text = passDetail[@"addr1"];
    NSLog(@"Address%@",labelAddressValue.text);
}

#pragma mark - ButtonActions
-(IBAction)buttonAction:(id)sender
{
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Status Upadating.."];
    
    [self sendRequestForUpdateStatus:sender];
    
}
-(void)contactButtonClicked:(id)sender{
    TELogInfo(@"DETAILS contactButtonClicked CLICKED");
    
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = button.currentTitle;
    
    TELogInfo(@"PhnNo. :%@",buttonTitle);
    NSString *number = [NSString stringWithFormat:@"%@",buttonTitle];
    TELogInfo(@"PhnNo. :%@",number);
    NSURL* callUrl=[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]];
    
    //check  Call Function available only in iphone
    if([[UIApplication sharedApplication] canOpenURL:callUrl])
    {
        [[UIApplication sharedApplication] openURL:callUrl];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ALERT" message:@"This function is only available on the iPhone"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)cancelBookingClicked:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Why are you canceling?" delegate:self cancelButtonTitle:@"No don't cancel booking" destructiveButtonTitle:nil otherButtonTitles:@"Do not charge client",@"Client no-show",@"Client requested cancel",@"Wrong address shown",@"other" ,nil];
    //[actionSheet showInView:self.view];
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    if ([window.subviews containsObject:self.view]) {
        [actionSheet showInView:self.view];
    } else {
        [actionSheet showInView:window];
    }
}


#pragma mark - ActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        switch (buttonIndex) {
            case 0:  // do not charge client
            {
                [self sendRequestForCancelBookingWithReason:kCBRDoNotChargeClient];
                break;
            }
            case 1: // client no - show
            {
                [self sendRequestForCancelBookingWithReason:kCBRPassengerDoNotShow];
                break;
            }
            case 2: // client request to cancel
            {
                [self sendRequestForCancelBookingWithReason:kCBRDPassengerRequestedCancel];
                break;
            }
            case 3: // wrong address shown
            {
                [self sendRequestForCancelBookingWithReason:kCBRWrongAddressShown];
                break;
            }
            case 4: // other
            {
                [self sendRequestForCancelBookingWithReason:kCBOhterReasons];
                break;
            }
            default:
                break;
        }
    }
}
#pragma mark - Map direction

-(void)getCurrentLocation{
    
    //check location services is enabled
    if ([CLLocationManager locationServicesEnabled]) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
        
    }
    else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Service" message:@"Unable to find your location,Please enable location services." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}


/**
 *  adds direction on Map
 *
 *  @param json representaion of pathpoints
 */
- (void)addDirections:(NSDictionary *)json {
    NSLog(@"%@",json);
    if ([json[@"routes"] count]>0) {
        NSDictionary *routes = [json objectForKey:@"routes"][0];
        
        NSDictionary *route = [routes objectForKey:@"overview_polyline"];
        NSString *overview_route = [route objectForKey:@"points"];
        GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.map = mapView_;
    }
    
    
}

/**
 *  Sets the start location of Path
 *
 *  @param latitude  start point latitude
 *  @param longitude start point longitude
 */
-(void)setStartLocationCoordinates:(float)latitude Longitude:(float)longitude{
    //change map camera postion to current location

   
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:15 ];
    [mapView_ setCamera:camera];
    
    
    //add marker at current location
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
    
    _currentLocationMarker  = [[GMSMarker alloc] init];
    _currentLocationMarker.map = mapView_;
    _currentLocationMarker.flat = YES;
    _currentLocationMarker.position = position;
    _currentLocationMarker.icon = [UIImage imageNamed:@"car.png"];
    [waypoints_ addObject:_currentLocationMarker];
    
    GMSCameraUpdate *locationUpdate = [GMSCameraUpdate setTarget:position];
    [mapView_ animateWithCameraUpdate:locationUpdate];
    
    
    //save current location to plot direciton on map
    _startLocation = [NSString stringWithFormat:@"%.6f,%.6f",latitude, longitude];
    [waypointStrings_ insertObject:_startLocation atIndex:0];
    
    
    if (_isDriverArrived) {
        
        [self changeDropAddressOnUI];
        if (waypoints_.count > 1) {
            [waypointStrings_ removeObjectsInRange:NSMakeRange(1, waypointStrings_.count-1)];
            [waypoints_ removeLastObject];
    
        
        }
        
        _isPathPlotted = NO;
        
//        CLLocationCoordinate2D destination;
//        destination.latitude = [passDetail[@"dropLat"] doubleValue];
//        destination.longitude = [passDetail[@"dropLong"] doubleValue];
//        CLLocationCoordinate2D destination = [self geoCodeUsingAddress:passDetail[@"dropAddr1"]];
        
        [self updateDestinationLocationWithLatitude:[passDetail[@"dropLat"] doubleValue]Longitude:[passDetail[@"dropLong"] doubleValue]];
    }
    else {

       // CLLocationCoordinate2D destination = [self geoCodeUsingAddress:passDetail[@"addr1"]];
        
        [self updateDestinationLocationWithLatitude:[passDetail[@"pickLat"] doubleValue]Longitude:[passDetail[@"pickLong"] doubleValue]];
    }
    
   
    
    
}

/**
 * sets destination point of path
 *
 *  @param latitude  destination point latitude
 *  @param longitude destination point longitude
 */
-(void)updateDestinationLocationWithLatitude:(float)latitude Longitude:(float)longitude{
    
    
    if (!_isPathPlotted) {
        
        
        
        NSLog(@"pathplotted");
        _isPathPlotted = YES;
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude,longitude);
        
        _previouCoord = position;
        
        _destinationMarker = [GMSMarker markerWithPosition:position];
        _destinationMarker.map = mapView_;
        _destinationMarker.flat = YES;
      //  _destinationMarker.groundAnchor = CGPointMake(0.5f, 0.5f);
        //_destinationMarker.icon = [UIImage imageNamed:@"car.png"];
        
        [waypoints_ addObject:_destinationMarker];
        NSLog(@"check%@",waypointStrings_);
        NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                    latitude,longitude];
        
        [waypointStrings_ addObject:positionString];
         NSLog(@"checkmain%@",waypointStrings_);
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
        GMSCameraUpdate *locationUpdate = [GMSCameraUpdate setTarget:position];
        [mapView_ animateWithCameraUpdate:locationUpdate];
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


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    
    if (!_isUpdatedLocation) {
        
        [_locationManager stopUpdatingLocation];
        
        //change flag that we have updated location once and we don't need it again
        _isUpdatedLocation = YES;
        
        [self setStartLocationCoordinates:newLocation.coordinate.latitude Longitude:newLocation.coordinate.longitude];
        
        
        
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locationManager failed to update location : %@",[error localizedDescription]);
}


/**
 *  To get the coordinated of string address
 *
 *  @param address location address
 *
 *  @return address coordinates
 */
- (CLLocationCoordinate2D)geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
   // _destinationCoordinates = center;
    
    //[self requestForDoctorAroundYou:_appointmentType];
    //return center;
}


-(void)getAddressFromLatLon:(CLLocation*) location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         _destinationLocation = [[NSString alloc] init];
         _destinationArea = [[NSString alloc] init];
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             // address defined in .h file
             
             
             if (placemark.subThoroughfare != nil) {
                 _destinationLocation = [_destinationLocation stringByAppendingString:[NSString stringWithFormat:@"%@,",placemark.subThoroughfare]];
                 
             }
             if (placemark.thoroughfare != nil) {
                 _destinationLocation = [_destinationLocation stringByAppendingString:[NSString stringWithFormat:@"%@,",placemark.thoroughfare]];
                 
             }
             if (placemark.locality != nil) {
                 
                 _destinationArea = placemark.locality;
                 _destinationLocation = [_destinationLocation stringByAppendingString:[NSString stringWithFormat:@"%@,",placemark.locality]];
                 
             }
             if (placemark.postalCode != nil) {
                 _destinationLocation = [_destinationLocation stringByAppendingString:[NSString stringWithFormat:@"%@,",placemark.postalCode]];
                 
             }
             if (placemark.administrativeArea != nil) {
                 _destinationLocation = [_destinationLocation stringByAppendingString:[NSString stringWithFormat:@"%@,",placemark.administrativeArea]];
                 
             }
             if (placemark.country != nil) {
                 _destinationLocation = [_destinationLocation stringByAppendingString:[NSString stringWithFormat:@"%@",placemark.country]];
                 
             }
             
             ProgressIndicator *pi = [ProgressIndicator sharedInstance];
             [pi hideProgressIndicator];
             
             _destinationCoordinates = location.coordinate;
            // [self performSegueWithIdentifier:@"GoToBookingHistory" sender:self];
             
           // [self updateAppointmentDetail:nil];   //auto booking
             [self sendRequestToUpdateDestinationDetails]; //manual booking
             
         }
     }];
}


#pragma mark- GMSMapviewDelegate


- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    
}
- (void) mapView:(GMSMapView *) mapView willMove:(BOOL)gesture{
    
}

- (void) mapView:(GMSMapView *) mapView didChangeCameraPosition:(GMSCameraPosition *) position{
    
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    
    NSLog(@"idleAtCameraPosition");
}
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
    [self performSegueWithIdentifier:@"doctorDetails" sender:marker];
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    NSLog(@"marker userData %@",marker.userData);
    return nil;
    
}
//- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker{
//    NSLog(@"didBeginDraggingMarker");
//     _isUpdatedLocation = YES;
//}
//- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker{
//    NSLog(@"didEndDraggingMarker");
//}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (!_isUpdatedLocation) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        _isUpdatedLocation = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        //[GMSMarker markerWithPosition:position];
        _currentLocationMarker.position = position;
        _currentLocationMarker.flat = YES;

        _currentLocationMarker.groundAnchor = CGPointMake(0.5f, 0.5f);
        _currentLocationMarker.icon = [UIImage imageNamed:@"arrive_caricon"];
        _currentLocationMarker.map = mapView_;
    }
    else {
        
        
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        //_currentLocationMarker.position = position;
        
        
        //TODO: ADD NEW CODE FOR CENTRE MOVEMENT
        GMSCameraUpdate *locationUpdate = [GMSCameraUpdate setTarget:position];
        [mapView_ animateWithCameraUpdate:locationUpdate];
        //.......................................
        
        CLLocationDirection heading = GMSGeometryHeading(_previouCoord, position);
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0];
        _currentLocationMarker.position = position;
        [CATransaction commit];
        if (_currentLocationMarker.flat) {
            _currentLocationMarker.rotation = heading;
        }
        _previouCoord = position;
    }

    
}

#pragma mark -leftbar and righbar action

-(void)rightBarButtonClicked:(UIButton *)sender{
    
    //[self gotolistViewController];
}

-(void)leftBarButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebRequests And Response

-(void)sendRequestForUpdateStatus:(UIButton*)sender
{
    UpdateBookingStatus *updateBookingStatus = [UpdateBookingStatus sharedInstance];
    [updateBookingStatus stopUpdatingStatus];
    
    if (![sender isKindOfClass:[UIButton class]])
    return;
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    NSString *title = [(UIButton *)sender currentTitle];
    NSLog(@"ttle%@",title);
    ResKitWebService * restkit = [ResKitWebService sharedInstance];
    NSString *email = passDetail[@"email"];
    NSString *appointmentDate = passDetail[@"apptDt"];
    NSString *appointmentId = passDetail[@"bid"];
    NSDictionary *queryParams;
    
    LocationTracker *tracker = [LocationTracker sharedInstance];
    float _distance = tracker.distance;
    NSLog(@"_distance%f",_distance);
    
  NSString *ent_amount =@"";
    
    if(sender.tag == 500)
    {
        
   
         queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                   [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken],KDAcheckUserSessionToken,
                   [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPCommonDevideId,
                   email,kSMPRespondPassengerEmail,
                   appointmentDate, kSMPRespondBookingDateTime,
                   appointmentId, kSMPRespondDocbid,
                   constkNotificationTypeBookingArrived,kSMPRespondResponse,
                   @"testing",kSMPRespondDocNotes,
                   [NSNumber numberWithFloat:_distance],@"ent_distance",
                    ent_amount,@"ent_amount",
                   [Helper getCurrentDateTime],kSMPCommonUpDateTime, nil];
        
        NSLog(@"queryParams i have arrived:: %@",queryParams);

    
    }
    else if(sender.tag == 600) {
        
        
        
        queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                       [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken],KDAcheckUserSessionToken,
                       [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPCommonDevideId,
                       email,kSMPRespondPassengerEmail,
                       appointmentDate, kSMPRespondBookingDateTime,
                       appointmentId, kSMPRespondDocbid,
                       constkNotificationTypeBookingBeginTrip,kSMPRespondResponse,
                       @"testing",kSMPRespondDocNotes,
                       [Helper getCurrentDateTime],kSMPCommonUpDateTime, nil];
    }
    else{
     
        [pi showPIOnView:self.view withMessage:@"Please wait.."];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBooked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
       
        LocationTracker *locaitontraker = [LocationTracker sharedInstance];
        
        
        [self getAddressFromLatLon:locaitontraker.lastLocaiton];
        
        return;
    }
    
    [restkit composeRequestForUpdateStatus:MethodupdateApptStatus
                             paramas:queryParams
                        onComplition:^(BOOL success, NSDictionary *response){
                            
                            if (success) { //handle success response
                                //[self updateStstusResponse:(NSArray*)response];
                                
                                Errorhandler * handler = [(NSArray*)response objectAtIndex:0];
                                ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
                                [progressIndicator hideProgressIndicator];
                                
                                if ([[handler errFlag] intValue] ==0)
                                {
                                    if(sender.tag == 500) //driver reached responese
                                    {
                                        IsPopLock=@"NO";
                                        [sender setTitle:@"BEGIN TRIP" forState:UIControlStateNormal];
                                        [pi hideProgressIndicator];
                                        sender.tag = 600;
                                        _isPathPlotted = NO;
                                        _isUpdatedLocation = NO;
                                        _isDriverArrived = YES;
                                        [mapView_ clear];
                                        [self getCurrentLocation];
                                        [self updateToPassengerForDriverState:kPubNubDriverReachedPickupLocation withIteration:-1];
                    
                                        if ([[handler errNum] intValue]  == 83) {
                                            
                                            IsPopLock=@"Yes";
                                            [self performSegueWithIdentifier:@"GoToBookingHistory" sender:self];
                                        }

                                    }
                                    else if (sender.tag == 600){
                                
                                        self.title = @"JOURNEY STARTED";
                                        LocationTracker *tracker = [LocationTracker sharedInstance];
                                        tracker.distance = 0;
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kNSUDriverDistanceTravalled];
                                        //self.navigationItem.leftBarButtonItem = nil;
                                        [sender setTitle:@"PASSENGER DROPPED" forState:UIControlStateNormal];
                                        [pi hideProgressIndicator];
                                        sender.tag = 700;
                                        
                                        
                                        //_driverState = kPubNubDriverReachedPickupLocation;
                                        [self updateToPassengerForDriverState:kPubNubDriverBeginTrp withIteration:-1];
                                    }
                                    else if (sender.tag == 700){
                                        
                                        //_driverState = kPubNubDriverReachedDestinationLoation;
                                        [self updateToPassengerForDriverState:kPubNubDriverReachedDestinationLoation withIteration:-1];
                                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBooked"];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                         [pi hideProgressIndicator];
                                         [self performSegueWithIdentifier:@"GoToBookingHistory" sender:self];
                                    }
                                   
                                }
                                else{
                                    
                                    if ([handler.errNum intValue] == 41) {
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                    }
                                    
                                    [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
                                  
                                }

                                
                                
                            }
                            else{//error
                                
                            }
                        }];
    
}

-(void)sendRequestForCancelBookingWithReason:(CancelBookingReasons)reason{
    
    
    UpdateBookingStatus *updateBookingStatus = [UpdateBookingStatus sharedInstance];
    [updateBookingStatus stopUpdatingStatus];
    
    PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
    if ( [reachability isNetworkAvailable]) {
        
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi showPIOnView:self.view withMessage:@"cancelling.."];
        
        NSString *email = passDetail[@"email"];
        NSString *appointmentDate = passDetail[@"apptDt"];
        NSString *appointmentId = passDetail[@"bid"];

        
        NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
        
        NSString *deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
        
        NSString *currentDate = [Helper getCurrentDateTime];
        NSLog(@"%@%@",email,appointmentDate);
        NSDictionary *params = @{ @"ent_sess_token":sessionToken,
                                 @"ent_dev_id":deviceID,
                                 @"ent_pas_email":email,
                                 @"ent_appnt_dt":appointmentDate,
                                 @"ent_date_time":currentDate,
                                 @"ent_cancel_type":[NSNumber numberWithInt:reason],
                                 @"ent_appnt_id":appointmentId,
                                 };
        
        NetworkHandler *networHandler = [NetworkHandler sharedInstance];
        [networHandler composeRequestWithMethod:MethodCancelBooking
                                        paramas:params
                                   onComplition:^(BOOL success, NSDictionary *response){
                                       
                                       if (success) { //handle success response
                                           //[self cancelBookingResponse:response];
                                           if ([response[@"errFlag"] intValue] == 0 ) { //success
                                               
                                               [self updateForForCancelBooking:reason];
                                               
                                               
                                               [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBooked"];
                                               [[NSUserDefaults standardUserDefaults] synchronize];
                                               [self.navigationController popToRootViewControllerAnimated:YES];
                                               
                                               
                                               
                                           }
                                           else {
                                               
                                               [self updateForForCancelBooking:reason];
                                               
                                               
                                               [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBooked"];
                                               [[NSUserDefaults standardUserDefaults] synchronize];
                                               [self.navigationController popToRootViewControllerAnimated:YES];
                                               [Helper showAlertWithTitle:@"Message" Message:response[@"errMsg"]];
                                           }
                                       }
                                       else {
                                           
                                           [pi hideProgressIndicator];
                                       }
                                   }];
    }
    else {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi showMessage:kNetworkErrormessage On:self.view];
    }
}


-(void)cancelBookingResponse:(NSDictionary*)response{
    
    if (response == nil) {
        return;
    }
    else {
        if ([response[@"errFlag"] intValue] == 0) { //success
            
            
            [self updateToPassengerForDriverState:kPubNubDriverCancelBooking withIteration:5];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBooked"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }
        else {
            [Helper showAlertWithTitle:@"Message" Message:response[@"errMsg"]];
        }
    }
}


-(IBAction)updateAppointmentDetail:(id)sender
{
    
    
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Updating details.."];
   
    ResKitWebService * restkit = [ResKitWebService sharedInstance];
    NSString *email = passDetail[@"email"];
    NSString *appointmentDate = passDetail[@"apptDt"];
     NSString *appointmentId = passDetail[@"bid"];
    
    LocationTracker *tracker = [LocationTracker sharedInstance];
    float _distance = tracker.distance;
    
    NSDictionary *queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken],KDAcheckUserSessionToken,
                                 [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPCommonDevideId,
                                 email,kSMPRespondPassengerEmail,
                                 appointmentDate, kSMPRespondBookingDateTime,
                                 constkNotificationTypeBookingComplete,kSMPRespondResponse,
                                  appointmentId, kSMPRespondDocbid,
                                 [Helper getCurrentDateTime],kSMPCommonUpDateTime,
                                 @"notes",@"ent_doc_remarks",
                                 _destinationLocation,@"ent_drop_addr_line1",
                                 _destinationArea,@"ent_drop_addr_line2",
                                 [NSNumber numberWithDouble:_destinationCoordinates.latitude],@"ent_drop_lat",
                                 [NSNumber numberWithDouble:_destinationCoordinates.longitude],@"ent_drop_long",
                                 [NSNumber numberWithFloat:_distance],@"ent_distance",
                                 nil];
    
    [restkit composeRequestForUpdateStatus:MethodupdateApptStatus
                                   paramas:queryParams
                              onComplition:^(BOOL success, NSDictionary *response){
                                  
                                  if (success) { //handle success response
                                      //[self updateStstusResponse:(NSArray*)response];
                                      
                                      Errorhandler * handler = [(NSArray*)response objectAtIndex:0];
                                      
                                      [pi hideProgressIndicator];
                                      
                                      if ([[handler errFlag] intValue] ==0)
                                      {
                                           [self updateToPassengerForDriverState:kPubNubDriverReachedDestinationLoation withIteration:-1];
                                           [self performSegueWithIdentifier:@"GoToBookingHistory" sender:self];
                                      }
                                      else {
                                          
                                           [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
                                      }
                                  }
                              }];
    
    
}

-(void)sendRequestToUpdateDestinationDetails{
    
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Updating details.."];
    
   // ResKitWebService * restkit = [ResKitWebService sharedInstance];
   // NSString *email = passDetail[@"email"];
   // NSString *appointmentDate = passDetail[@"apptDt"];
    
   
     LocationTracker *tracker = [LocationTracker sharedInstance];
     float _distance = tracker.distance;
     NSLog(@"_distancedrop%f",_distance);

    
     NSInteger bid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bid"] integerValue];
     NSString *sessionToken =    [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken];
     NSString *deviceid = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:sessionToken forKey:KDAcheckUserSessionToken];
    [params setObject:deviceid forKey:kSMPCommonDevideId];
    [params setObject:[Helper getCurrentDateTime] forKey:kSMPCommonUpDateTime];
    [params setObject:[NSNumber numberWithInteger:bid] forKey:@"ent_appnt_id"];
    [params setObject:_destinationLocation forKey:@"ent_drop_addr_line1"];
    [params setObject:_destinationArea forKey:@"ent_drop_addr_line2"];
    [params setObject:[NSNumber numberWithDouble:_destinationCoordinates.latitude] forKey:@"ent_drop_lat"];
    [params setObject:[NSNumber numberWithDouble:_destinationCoordinates.longitude] forKey:@"ent_drop_long"];
    [params setObject:[NSNumber numberWithFloat:_distance] forKey:@"ent_distance"];
    
    NetworkHandler *handler = [NetworkHandler sharedInstance];
    [handler composeRequestWithMethod:MethodUpdateAppointmentDetail
                              paramas:params
                         onComplition:^(BOOL success , NSDictionary *response){
                             if (success) {
                                 
                                 NSDictionary *dict  =    response[@"data"];
                                 if ([[dict objectForKey:@"errFlag"] integerValue] == 0)
                                 {
                                     [self performSegueWithIdentifier:@"GoToBookingHistory" sender:self];
                                 }
                                 else
                                 {
                                     [Helper showAlertWithTitle:@"Message" Message:dict[@"errMsg"]];
                                 }
                                 
                             }
                            
                         }];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GoToBookingHistory"])
    {
        BookingHistoryViewController *booking = (BookingHistoryViewController*)[segue destinationViewController];
        booking.passDetail=passDetail;
        booking.destinationCoordinates = _destinationCoordinates;
        booking.dropLocation = _destinationLocation;
        booking.IspopLock=IsPopLock;
    }
}

-(void)updateForForCancelBooking:(CancelBookingReasons)reason{
    UpdateBookingStatus *updateBookingStatus = [UpdateBookingStatus sharedInstance];
    updateBookingStatus.cancelBookingReason = reason;
    [self updateToPassengerForDriverState:kPubNubDriverCancelBooking withIteration:-1];
}

-(void)updateToPassengerForDriverState:(PubNubStreamAction)state withIteration:(int)iteration{
    
    UpdateBookingStatus *updateBookingStatus = [UpdateBookingStatus sharedInstance];
    updateBookingStatus.driverState = state;
    updateBookingStatus.iterations = iteration;
    [updateBookingStatus updateToPassengerForDriverState];
    [updateBookingStatus startUpdatingStatus];
}

@end
