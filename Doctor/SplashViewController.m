//
//  PatientViewController.m
//  privMD
//
//  Created by Rahul Sharma on 11/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "SplashViewController.h"
#import "HelpViewController.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface SplashViewController ()
@property(nonatomic,strong)MPMoviePlayerController *moviePlayer;
@end

@implementation SplashViewController
@synthesize moviePlayer;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
   // [Helper getCurrentDateTime];
    self.view.backgroundColor = [UIColor blackColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-568h"]];
}
-(void)viewWillAppear:(BOOL)animated{
  //  [self createMoviePlayer];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    
    NSString *deviceId;
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        deviceId = [oNSUUID UUIDString];
    } else
    {
        deviceId = [oNSUUID UUIDString];
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:kPMDDeviceIdKey];

    
    [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(removeSplash) userInfo:Nil repeats:NO];
    
    //CLLocation *location = [[CLLocation alloc] initWithLatitude:13.028899 longitude:77.589616];
    //[self getAddressFromLatLon:location];
}


-(void)removeSplash
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken])
    {
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:[NSBundle mainBundle]];
        
        //[(NSMutableArray*)self.navigationController.viewControllers removeAllObjects];
        MenuViewController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"home"];
        self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];
    }
    else
    {
        // [self performSegueWithIdentifier:@"Help" sender:self];
        HelpViewController *help = [self.storyboard instantiateViewControllerWithIdentifier:@"helpVC"];
        [[self navigationController ] pushViewController:help animated:NO];
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"HomeView"])
    {
        
        MenuViewController *MPC = [[MenuViewController alloc]init];
        
        MPC =[segue destinationViewController];

        
    }
    else
    {
        HelpViewController *HVC = [[HelpViewController alloc]init];
    
        HVC =[segue destinationViewController];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getDirection
{
    
}

- (void)createMoviePlayer {
    
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"TimelapseHamburg" withExtension:@"mov"];
    
    // video player
    MPMoviePlayerController *playerViewController = [[MPMoviePlayerController alloc] init];
    playerViewController.contentURL = url;
    playerViewController.view.frame = CGRectMake(0, 0, 320, 568);
    
    [self.view addSubview:playerViewController.view];
    
    float size = [[UIScreen mainScreen] bounds].size.height;
    CGRect frm = moviePlayer.view.frame;
    frm.size.height = size;
    moviePlayer.view.frame = frm;
    [moviePlayer setControlStyle:MPMovieControlStyleNone];
    [moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
    
    moviePlayer = playerViewController;
    moviePlayer.view.userInteractionEnabled = NO;
    moviePlayer.initialPlaybackTime = -1;
    moviePlayer.shouldAutoplay=NO;
    [moviePlayer prepareToPlay];
    [moviePlayer play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSplash) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];//moviePlayerFinishedPlaying
    
	
}
-(void)getAddressFromLatLon:(CLLocation*) location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         
         NSString *_destinationLocation = [[NSString alloc] init];
         NSString *_destinationArea;//
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             // address defined in .h file
             
            /* _destinationLocation  = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",
                                                           placemark.subThoroughfare, placemark.thoroughfare,
                                                           placemark.postalCode, placemark.locality,
                                                           placemark.administrativeArea,
                                                           placemark.country];*/
             
             if (placemark.subThoroughfare != nil) {
                 _destinationLocation = [_destinationLocation stringByAppendingString:[NSString stringWithFormat:@"%@,",placemark.subThoroughfare]];

             }
             if (placemark.thoroughfare != nil) {
                 _destinationLocation = [_destinationLocation stringByAppendingString:[NSString stringWithFormat:@"%@,",placemark.thoroughfare]];
                 
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
             NSLog(@"address %@",_destinationLocation);
             
             
             //[_destinationLocation stringByReplacingOccurrencesOfString:@"(null)," withString:@""];
             
//             
//             if ([[placemark thoroughfare] length] != 0 || [placemark thoroughfare] != nil) {
//                 
//                 
//                 _destinationLocation = [NSString stringWithFormat:@"%@,",[placemark thoroughfare]];
//                 
//                 if ([[placemark subThoroughfare] length] != 0 || [placemark subThoroughfare] != nil) {
//                     
//                     _destinationLocation = [NSString stringWithFormat:@"%@,",[placemark subThoroughfare]];
//                 }
//                 
//                 
//             }
//             if ([[placemark locality] length] != 0 || [placemark locality] != nil) {
//                 _destinationArea = [placemark locality];
//                 _destinationLocation = [NSString stringWithFormat:@"%@,",[placemark locality]];
//             }
//             if ([[placemark administrativeArea] length] != 0 || [placemark administrativeArea] != nil) {
//                 _destinationLocation = [NSString stringWithFormat:@"%@",[placemark administrativeArea]];
//             }
             
             ProgressIndicator *pi = [ProgressIndicator sharedInstance];
             [pi hideProgressIndicator];
             
             //_destinationCoordinates = location.coordinate;
             [self performSegueWithIdentifier:@"GoToBookingHistory" sender:self];
             
         }
     }];
}

@end
