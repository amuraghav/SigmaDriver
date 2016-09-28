//
//  BookingHistoryViewController.m
//  Roadyo
//
//  Created by Rahul Sharma on 07/05/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "BookingHistoryViewController.h"
#import "CustomNavigationBar.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import <AXRatingView/AXRatingView.h>
#import <Canvas/CSAnimationView.h>
#import "UpdateBookingStatus.h"
#import "LocationTracker.h"
#import "MathController.h"
#import "NSCalendar+Ranges.h"

@interface BookingHistoryViewController ()<CustomNavigationBarDelegate,UITextFieldDelegate>
@property(nonatomic,strong)AXRatingView *ratingViewStars;
@property(nonatomic,strong)IBOutlet UIView *ratingView;
@property(nonatomic,strong)IBOutlet UITextField *textFeildBillAmount;

@property(nonatomic,strong)IBOutlet UITextField *textFeildDiscountAmount;
@property(nonatomic,strong)IBOutlet CSAnimationView *billAmoutView;
@property(nonatomic,assign) float rating;
@property(nonatomic,assign) float distance;
@end

@implementation BookingHistoryViewController
@synthesize passDetail,IspopLock;

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
    
    [super viewDidLoad];
    
    self.title = @"REVIEW";
    self.navigationItem.hidesBackButton = YES;
    
    self.view.backgroundColor = UIColorFromRGB(0xe9e9e8);
    [Helper setToLabel:passngerName Text:[NSString stringWithFormat:@"%@ %@",passDetail[@"fName"],passDetail[@"lName"]] WithFont:Robot_CondensedLight FSize:15 Color:UIColorFromRGB(0x333333)];
    [Helper setToLabel:lblPickUpTitle Text:@"Pickup Location" WithFont:Robot_CondensedRegular FSize:11 Color:UIColorFromRGB(0x6e6e6e)];
    [Helper setToLabel:lblDropTitle Text:@"DropOff Loaction" WithFont:Robot_CondensedRegular FSize:11 Color:UIColorFromRGB(0x6e6e6e)];
    [Helper setToLabel:lblPickUp Text:passDetail[@"addr1"] WithFont:Robot_Regular FSize:13 Color:UIColorFromRGB(0x333333)];
    [Helper setToLabel:lblDropOff Text:_dropLocation WithFont:Robot_Regular FSize:13 Color:UIColorFromRGB(0x333333)];
    [Helper setToLabel:LblDistancetitle Text:@"Distance" WithFont:Robot_CondensedRegular FSize:11 Color:UIColorFromRGB(0x6e6e6e)];
    [Helper setToLabel:LblDistance Text:passDetail[@"dis"] WithFont:Robot_Regular FSize:13 Color:UIColorFromRGB(0x333333)];
    [Helper setToLabel:lblpickUpTimeTtl Text:@"Time" WithFont:Robot_CondensedRegular FSize:11 Color:UIColorFromRGB(0x6e6e6e)];
    [Helper setToLabel:lblDropOffTimeTtl Text:@"Time" WithFont:Robot_CondensedRegular FSize:11 Color:UIColorFromRGB(0x6e6e6e)];
    [Helper setToLabel:lblTotalTimeTitle Text:@"Duration" WithFont:Robot_CondensedRegular FSize:11 Color:UIColorFromRGB(0x6e6e6e)];
    [Helper setToLabel:lblRateYourRide Text:@"RATE YOUR RIDE" WithFont:Robot_Regular FSize:13 Color:UIColorFromRGB(0x333333)];
    [Helper setToLabel:lbljournyTitle Text:@"JOURNEY DETAILS" WithFont:Robot_Regular FSize:15 Color:UIColorFromRGB(0x333333)];
    [Helper setButton:btnComplete Text:@"FINISHED" WithFont:Robot_Bold FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    [btnComplete setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btnComplete setBackgroundColor:BUTTON_Color];
    
    if ([IspopLock isEqualToString:@"Yes"]) {
        
        lblDropTitle.hidden=YES;
        lblDropOff.hidden=YES;
        lblDropOffTimeTtl.hidden=YES;
    }

    

    
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",baseUrlForXXHDPIImage,passDetail[@"pPic"]];
    [imgPassnegr setImageWithURL:[NSURL URLWithString:strImageUrl]
    placeholderImage:[UIImage imageNamed:@"signup_profile_image"]
    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    _rating = 5.0;
    _ratingViewStars = [[AXRatingView alloc] initWithFrame:CGRectMake(70, 0,CGRectGetWidth(_ratingView.frame), CGRectGetHeight(_ratingView.frame))];
    // _ratingViewStars.markImage = [UIImage imageNamed:@"Icon"];
    _ratingViewStars.stepInterval = 0.0;
    _ratingViewStars.highlightColor = [UIColor colorWithRed:0.044 green:0.741 blue:1.000 alpha:1.000];
    _ratingViewStars.value = _rating;
    _ratingViewStars.userInteractionEnabled = YES;
    [_ratingViewStars addTarget:self action:@selector(ratingChanged:) forControlEvents:UIControlEventValueChanged];
    //[_ratingViewStars sizeToFit];
    [_ratingView addSubview:_ratingViewStars];
    
    UITapGestureRecognizer *reconiger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    reconiger.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:reconiger];
    
 
    
   
}

-(void)viewDidDisappear:(BOOL)animated{
    //[self.view removeGestureRecognizer:<#(UIGestureRecognizer *)#>]
}
-(void)viewDidAppear:(BOOL)animated{
    
    [self sendRequestForAppointmentInvoice];
    
    _distance = [[LocationTracker sharedInstance] distance];
    
    LblDistance.text = [MathController stringifyDistance:_distance];
}

- (void) addCustomNavigationBar{
    
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    //customNavigationBarView.backgroundColor = [UIColor redColor];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"REVIEW"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    [customNavigationBarView setLeftBarButtonTitle:@"Back"];
    
    [self.view addSubview:customNavigationBarView];
    
    
    //--------------****-----------***********-------------*******--------------*****--------------------//
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -leftbar and righbar action

-(void)rightBarButtonClicked:(UIButton *)sender{
    
    //[self gotolistViewController];
}

-(void)leftBarButtonClicked:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)buttonAction:(id)sender
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
  [self sendRequestToFinishBooking]; //manual booking
  // [self sendRequestToUpdateRating];  //auto booking
     

}

-(void)sendRequestToFinishBooking{
    NSLog(@"%f%f%f%f",_textFeildBillAmount.frame.origin.x,_textFeildBillAmount.frame.origin.y,_textFeildBillAmount.frame.size.width,_textFeildBillAmount.frame.size.height);
    if (_textFeildBillAmount.text.length == 0 || [_textFeildBillAmount.text isEqualToString:@"$ 0"]) {
        [Helper showAlertWithTitle:@"Alert" Message:@"You forget to raise bill. Please enter the bill amount."];
        return;
    }
    
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Please wait.."];
   
    ResKitWebService * restkit = [ResKitWebService sharedInstance];
    NSString *email = passDetail[@"email"];
    NSString *appointmentDate = passDetail[@"apptDt"];
    NSString *appointmentId = passDetail[@"bid"];
    //NSDictionary *queryParams;
    
  //  NSString *currency = [NSString stringWithFormat:@"%@ ",[Helper getCurrencyUnit]];
        NSString *currency = @"$";
    NSString *amountString = [_textFeildBillAmount.text stringByReplacingOccurrencesOfString:currency withString:@""];
    
    float amount = [amountString floatValue];
    
   // NSString *current =  [Helper getCurrentDateTime];
 //   float tot=amount+amount*25/100;
    
    if (_dropArea == nil) {
        _dropArea = @"";
    }
    
    NSDictionary *queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken],KDAcheckUserSessionToken,
                                 [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPCommonDevideId,
                                 email,kSMPRespondPassengerEmail,
                                 appointmentDate, kSMPRespondBookingDateTime,
                                  appointmentId, kSMPRespondDocbid,
                                 constkNotificationTypeBookingComplete,kSMPRespondResponse,
                                 @"testing",kSMPRespondDocNotes,
                                 [Helper getCurrentDateTime],kSMPCommonUpDateTime,
                                 [NSNumber numberWithFloat:amount] ,@"ent_amount",
                                 
                                 [NSNumber numberWithInt:_rating],@"ent_rating",
                                 
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
                                          [self updateToPassengerForDriverState:kPubNubDriverReachedDestinationLoation];
                                          
                                          [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBooked"];
                                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:kNSUDriverDistanceTravalled];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                      }
                                  }
                              }];
}
-(void)sendRequestToUpdateRating {
    
    
    
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Please wait.."];
   
    //ResKitWebService * restkit = [ResKitWebService sharedInstance];
    //NSString *email = passDetail[@"email"];
    //NSString *appointmentDate = passDetail[@"apptDt"];
    //NSDictionary *queryParams;
    NSInteger bid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bid"] integerValue];
  
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken] forKey:KDAcheckUserSessionToken];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey] forKey:kSMPCommonDevideId];
    [params setObject:[NSNumber numberWithInteger:bid] forKey:@"ent_appnt_id"];
    [params setObject:[Helper getCurrentDateTime] forKey:kSMPCommonUpDateTime];
    [params setObject:[NSNumber numberWithInt:_rating] forKey:@"ent_rating"];
    
    
    
    NetworkHandler *handler = [NetworkHandler sharedInstance];
    [handler composeRequestWithMethod:MethodUpdateAppointmentDetail
                              paramas:params
                         onComplition:^(BOOL success , NSDictionary *dicttionary){
                             if (success) {
                                 
                                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBooked"];
                                 [[NSUserDefaults standardUserDefaults] removeObjectForKey:kNSUDriverDistanceTravalled];
                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                 [self.navigationController popToRootViewControllerAnimated:YES];
                             }
                         }];
    
   
    
}
-(IBAction)buttonActionForRation:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    
    if (btn.tag == 100) {
        if ([btn isSelected])//yes
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"summary_btn_ratingstar_on.png"] forState:UIControlStateSelected];
        }
        else{//no
            
        }
    }
    
}
- (void)ratingChanged:(AXRatingView *)sender
{
    _rating = sender.value;
    
}

#pragma mark - WebRequest
-(void)sendRequestForAppointmentInvoice {
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Please wait.."];
    
    //setup parameters
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
   
    NSString  *deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    NSString *email = passDetail[@"email"];
    NSString *appointmentDate = passDetail[@"apptDt"];

      NSString *appointmentId = passDetail[@"bid"];
   // NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH"];
   // NSDictionary * dictP = [dict objectForKey:@"aps"];
   // NSString *docEmail = dictP[@"e"];
   // NSString *appointmntDate = dictP[@"dt"];
    NSString *currentDate = [Helper getCurrentDateTime];
    //
    NSDictionary *params = @{@"ent_sess_token":sessionToken,
                             @"ent_dev_id":deviceID,
                             @"ent_email":email,
                             @"ent_user_type":@"1",
                             @"ent_appnt_dt":appointmentDate,
                             @"ent_date_time":currentDate,
                             @"ent_appnt_id":appointmentId,
                             };
    
    TELogInfo(@"kSMGetAppointmentDetialINVOICE %@",params);
    //setup request
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    [networHandler composeRequestWithMethod:kSMGetAppointmentDetial
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   
                                   if (success) { //handle success response
                                       //TELogInfo(@"response %@",response);
                                       [self parseAppointmentDetailResponse:response];
                                   }
                                   else {
                                       
                                       [pi hideProgressIndicator];
                                   }
                               }];
}
-(void)parseAppointmentDetailResponse:(NSDictionary*)response{
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    if (response == nil) {
        return;
    }
    else if ([response objectForKey:@"Error"])
    {
        [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
    }
    else
    {
        response  =    response[@"data"];
        if ([[response objectForKey:@"errFlag"] integerValue] == 0)
        {
            TELogInfo(@"parseAppointmentDetailResponse %@",response);
            
            [[self.view viewWithTag:10] setHidden:NO];
            [[self.view viewWithTag:11] setHidden:NO];
            [[self.view viewWithTag:12] setHidden:NO];
            //[[self.view viewWithTag:13] setHidden:NO];
            [btnComplete setHidden:NO];
            NSString *symbol=@"$";
            if (response[@"fare"]) {
                [Helper setToLabel:lblAmount Text:[NSString stringWithFormat:@"%@ %@",symbol,response[@"fare"]] WithFont:Robot_Bold FSize:30 Color:UIColorFromRGB(0x000000)];
                
                  _textFeildBillAmount.text=[NSString stringWithFormat:@"%@%@",symbol,response[@"fare"]];
                
                  _textFeildDiscountAmount.text=[NSString stringWithFormat:@"%@%@",symbol,response[@"discount"]];
//                [Helper setToLabel:lblAmount Text:[NSString stringWithFormat:@"%@ %@",[Helper getCurrencyUnit],response[@"fare"]] WithFont:Robot_Bold FSize:30 Color:UIColorFromRGB(0x000000)];
            }
            else {
                  [Helper setToLabel:lblAmount Text:[NSString stringWithFormat:@"%@ 0",symbol] WithFont:Robot_Bold FSize:30 Color:UIColorFromRGB(0x000000)];
               // [Helper setToLabel:lblAmount Text:[NSString stringWithFormat:@"%@ 0",[Helper getCurrencyUnit]] WithFont:Robot_Bold FSize:30 Color:UIColorFromRGB(0x000000)];
            }
            
            
//            NSInteger mint = [response[@"dur"]integerValue];
//            NSInteger durations = 0;
//            if (mint >= 60) {
//                durations = mint / 60;
//                mint = mint % 60;
//            }
//            [Helper setToLabel:lblTotalTime Text:[NSString stringWithFormat:@"%ldH : %ldM ",durations,mint] WithFont:Robot_Regular FSize:13 Color:UIColorFromRGB(0x000000)];
            
             _textFeildBillAmount.text=[NSString stringWithFormat:@"%@%@",symbol,response[@"fare"]];
            
             _textFeildDiscountAmount.text=[NSString stringWithFormat:@"%@%@",symbol,response[@"discount"]];
            //pickuptime
            NSDateFormatter *df = [self serverDateFormatter];
            NSDate *pickupTime = [df dateFromString:response[@"pickupDt"]];
            df = [self formatter];
            NSString *time = [df stringFromDate:pickupTime];
            //NSString *time = [pickupTime description];
            
            [Helper setToLabel:lblPickUpTime Text:time WithFont:Robot_Regular FSize:13 Color:UIColorFromRGB(0x333333)];
            
            
            //pickupdate
            df = [self bookingDateFormat];
            time = [df stringFromDate:pickupTime];
            [Helper setToLabel:lblCurrentDateTime Text:time WithFont:Robot_Regular FSize:15 Color:UIColorFromRGB(0x333333)];
            
            
            df = [self serverDateFormatter];
            NSDate *dropOffTime = [df dateFromString:response[@"dropDt"]];
            df = [self formatter];
            time = [df stringFromDate:[NSDate date]];
            
            
            [Helper setToLabel:lblDropOffTime Text:time WithFont:Robot_Regular FSize:13 Color:UIColorFromRGB(0x333333)];
            
           //[Helper setToLabel:LblDistance Text:passDetail[@"dis"] WithFont:Robot_Regular FSize:13 Color:UIColorFromRGB(0x333333)];
            
            
            NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSInteger totalseconds  =  [calender secondsFromDate:pickupTime toDate:[NSDate date]];
            lblTotalTime.text = [MathController stringifySecondCount:(int)totalseconds usingLongFormat:YES];
            
               _billAmoutView.hidden=NO;
            [self.view startCanvasAnimation];
           
           
        }
        else
        {
            [Helper showAlertWithTitle:@"Message" Message:response[@"errmsg"]];
        }
        
    }
}
- (NSDateFormatter *)serverDateFormatter {
    
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
        formatter.dateFormat = @"hh:mm a";
    });
    return formatter;
}

- (NSDateFormatter *)bookingDateFormat {
    
    //EEE - day(eg: Thu)
    //MMM - month (eg: Nov)
    // dd - date (eg 01)
    // z - timeZone
    
    //eg : @"EEE MMM dd HH:mm:ss z yyyy"
    
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd MMM yyyy";
    });
    return formatter;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y - 100;
    
    [UIView animateWithDuration:.7 animations:^{
        self.view.frame = frame;
    }];
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:.4 animations:^{
        self.view.frame = frame;
    }];
    
    
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{

   
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString *currency = [Helper getCurrencyUnit];
    NSString *currency=@"$";
    if ([textField.text rangeOfString:currency].location == NSNotFound) {
        textField.text = [NSString stringWithFormat:@"%@ %@",currency,textField.text];
    }
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer*)reconiger{
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:.4 animations:^{
        self.view.frame = frame;
    }];

    
    [self.view endEditing:YES];
}
-(void)updateToPassengerForDriverState:(PubNubStreamAction)state{
    
    UpdateBookingStatus *updateBookingStatus = [UpdateBookingStatus sharedInstance];
    updateBookingStatus.driverState = state;
    updateBookingStatus.iterations = 5;
    [updateBookingStatus updateToPassengerForDriverState];
    [updateBookingStatus startUpdatingStatus];
}


@end
