
//
//  PassangerDroppedViewController.m
//  Roadyo
//
//  Created by Rahul Sharma on 07/05/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "PassangerDroppedViewController.h"
#import "CustomNavigationBar.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "BookingHistoryViewController.h"

@interface PassangerDroppedViewController ()<CustomNavigationBarDelegate,GMSMapViewDelegate>
{
    GMSMapView *mapView_;
    GMSGeocoder *geocoder_;
}
@property(strong,nonatomic) IBOutlet UIView *customMapView;
@property(nonatomic,assign) float currentLatitude;
@property(nonatomic,assign) float currentLongitude;
@property(nonatomic,assign) BOOL isUpdatedLocation;
@property(nonatomic,strong)NSMutableDictionary *allMarkers;
@end



@implementation PassangerDroppedViewController
@synthesize customMapView;
@synthesize passDetail;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    [Helper setToLabel:lblNameTitle Text:@"Name :" WithFont:Robot_CondensedLight FSize:13 Color:UIColorFromRGB(0x333333)];
    [Helper setToLabel:lblMobileTitle Text:@"Mob :" WithFont:Robot_CondensedLight FSize:13 Color:UIColorFromRGB(0x333333)];
    [Helper setToLabel:lblPickupTitle  Text:@"Dropoff :"WithFont:Robot_CondensedLight FSize:13 Color:UIColorFromRGB(0x333333)];
    [Helper setToLabel:lblName Text:[NSString stringWithFormat:@"%@ %@",passDetail[@"fName"],passDetail[@"lName"]] WithFont:Robot_CondensedRegular FSize:13 Color:UIColorFromRGB(0x333333)];
    [Helper setToLabel:lblMobile Text:passDetail[@"mobile"] WithFont:Robot_CondensedRegular FSize:13 Color:UIColorFromRGB(0x333333)];
    [Helper setToLabel:lblPickUp Text:passDetail[@"dropAddr1"] WithFont:Robot_CondensedRegular FSize:13 Color:UIColorFromRGB(0x333333)];
  
    [Helper setButton:btnArrival Text:@"I HAVE DROPPED" WithFont:Robot_Bold FSize:15 TitleColor:UIColorFromRGB(0x333333) ShadowColor:nil];
    [btnArrival setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
   
   /* [Helper setToLabel:lblETA Text:@"ETA :" WithFont:Robot_Light FSize:12 Color:UIColorFromRGB(0xffffff)];
    [Helper setToLabel:lblETATitle Text:[NSString stringWithFormat:@"%@ minutes",passDetail[@"dur"]] WithFont:Robot_Regular FSize:12 Color:UIColorFromRGB(0xffffff)];
    [Helper setToLabel:lblDistanceTitle Text:@"Distance :" WithFont:Robot_Light FSize:12 Color:UIColorFromRGB(0xffffff)];
    [Helper setToLabel:lblDistance Text:[NSString stringWithFormat:@"%@,mi",passDetail[@"dis"]] WithFont:Robot_Regular FSize:12 Color:UIColorFromRGB(0xffffff)];
*/

    
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",baseUrlForXXHDPIImage,passDetail[@"pPic"]];
    
    [imgPass setImageWithURL:[NSURL URLWithString:strImageUrl]
            placeholderImage:[UIImage imageNamed:@"doctor_image_thumbnail.png"]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                   }];

    if (IS_IPHONE_5) {
        
    }
    else if (IS_IPHONE_6) {
        
    }
    else if (IS_IPHONE_6_Plus) {
        
    }
    else{
        customMapView.frame =CGRectMake(0, 141, 320, 300);
        viewStatus.frame = CGRectMake(0, 141+300, 320, 300);
        
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
    
    
    CGRect rectMap = customMapView.frame;
    mapView_ = [GMSMapView mapWithFrame:rectMap camera:camera];
    //mapView_.settings.compassButton = YES;
    mapView_.delegate = self;
    // mapView_.settings.myLocationButton = YES;
    mapView_.myLocationEnabled = YES;
    customMapView = mapView_;
    geocoder_ = [[GMSGeocoder alloc] init];
    mapView_.indoorEnabled = NO;
    [self.view addSubview:customMapView];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addCustomNavigationBar];

	// Do any additional setup after loading the view.
}



- (void)viewWillDisappear:(BOOL)animated{
    
    
    [_allMarkers removeAllObjects];
    _isUpdatedLocation = NO;
    //[self stopPubNubStream];
    //self.navigationController.navigationBarHidden = YES;
    //    [mapView_ removeObserver:self
    //                  forKeyPath:@"myLocation"
    //                     context:NULL];
    
    
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
- (void) addCustomNavigationBar
{
    
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    //customNavigationBarView.backgroundColor = [UIColor redColor];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"Booking Detail"];
    [customNavigationBarView setLeftBarButtonTitle:@"Back"];
    
    [self.view addSubview:customNavigationBarView];
    
    
    //--------------****-----------***********-------------*******--------------*****--------------------//
    
    
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
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }
}

-(void)sendRequestForUpdateStatus
{
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH"];
    NSDictionary * dictP = [dict objectForKey:@"aps"];

    ResKitWebService * restkit = [ResKitWebService sharedInstance];
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                   [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken],KDAcheckUserSessionToken,
                   [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPCommonDevideId,
                   dictP[@"e"],kSMPRespondPassengerEmail,
                   dictP[@"dt"], kSMPRespondBookingDateTime,
                   dictP[@"bid"],kSMPRespondDocbid,
                   constkNotificationTypeBookingComplete,kSMPRespondResponse,
                   @"testing",kSMPRespondDocNotes,
                   [Helper getCurrentDateTime],kSMPCommonUpDateTime, nil];
    
    TELogInfo(@"param%@",queryParams);
    [restkit composeRequestForUpdateStatus:MethodupdateApptStatus
                                   paramas:queryParams
                              onComplition:^(BOOL success, NSDictionary *response){
                                  
                                  if (success) { //handle success response
                                      [self updateStstusResponse:(NSArray*)response];
                                  }
                                  else{//error
                                      
                                  }
                              }];
    
    
    
}

-(void)updateStstusResponse :(NSArray*)response
{
    Errorhandler * handler = [response objectAtIndex:0];
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    
    if ([[handler errFlag] intValue] ==0)
    {
        
        //
          [self performSegueWithIdentifier:@"GoToBookingHistory" sender:self];
        
        

    }
    else{
        
        [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GoToBookingHistory"])
    {
        BookingHistoryViewController *booking = (BookingHistoryViewController*)[segue destinationViewController];
        booking.passDetail=passDetail;
        
        
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

-(IBAction)buttonAction:(id)sender{
    [self sendRequestForUpdateStatus];
  }

@end
