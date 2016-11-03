//
//  OPTVerificationVC.m
//  CarApp
//
//  Created by Appypie Inc on 21/07/16.
//  Copyright © 2016 ons. All rights reserved.
//

#import "OPTVerificationVC.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "HomeViewController.h"
#import "PMDReachabilityWrapper.h"
#import "DoneCancelNumberPadToolbar.h"
#import "Cartype.h"
#import "MenuViewController.h"
#import "Errorhandler.h"
#import "ResKitWebService.h"
#import "Fonts.h"
#import "Helper.h"
#import "ProgressIndicator.h"
#import "CustomNavigationBar.h"
#import "SignUp.h"
#import "UploadFiles.h"
#import "SignUpDetails.h"
#import "AppConstants.h"

@interface OPTVerificationVC ()

@end

@implementation OPTVerificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BG_Color;
    self.navigationItem.title = @"PIN CONFIRMATION";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
    self.navigationController.navigationBar.barTintColor= NavBarTint_Color;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:Oswald_Light size:17]}];
    self.navigationController.navigationBar.translucent = NO;
    [self createNavLeftButton];
    _signUpDetails = [SignUpDetails sharedInstance];
    
}

-(void) createNavLeftButton
{
    // UIView *navView = [[UIView new]initWithFrame:CGRectMake(0, 0,50, 44)];
    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    UIButton *navCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [navCancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [navCancelButton setFrame:CGRectMake(0.0f,0.0f,buttonImage.size.width,buttonImage.size.height)];
    
    
    [Helper setButton:navCancelButton Text:@"BACK" WithFont:Oswald_Light FSize:11 TitleColor:[UIColor blueColor] ShadowColor:nil];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateNormal];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateSelected];
    [navCancelButton setShowsTouchWhenHighlighted:YES];
    [navCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    navCancelButton.titleLabel.font = [UIFont fontWithName:Oswald_Light size:11];
    
    //Adding Button onto View
    // [navView addSubview:navCancelButton];
    
    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navCancelButton];
    // UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithCustomView:segmentView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
    
    
  }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnPressed:(id)sender{
    
    [self signUp];
}

-(void)signUp
{
    NSString *signupFirstName = _signUpDetails.firstName;
    NSString *lastName = _signUpDetails.lastName;
    NSString *signupEmail = _signUpDetails.email;
    NSString *signupPassword = _signUpDetails.password;
    NSString *signupConfirmPassword = _signUpDetails.confirmPassword;
    NSString *signupPhoneno = _signUpDetails.mobile;
    NSString *taxNumber = @"";
    NSString *postCode = _signUpDetails.postCode;
    NSInteger cartype = 1;//[_selectedCarType.company_id integerValue];
    NSString*  isPopLockstr = _signUpDetails.Poplock ;
    //NSInteger carSeatingCapacity = _selectedCapacity;
    
    NSString *optCode = OtpTextfield.text;
    
    if ((unsigned long)optCode.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Please enter your OTP"];
      
    }
    else
    {
        
        NSString * pushToken;
        if([[NSUserDefaults standardUserDefaults]objectForKey:kSMPgetPushToken])
        {
            pushToken =[[NSUserDefaults standardUserDefaults]objectForKey:kSMPgetPushToken];
            
        }
        else
        {
            pushToken =@"dgfhfghr765998ghghj";
            
        }
        
        
        ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
        [progressIndicator showPIOnView:self.view withMessage:@"Signing in"];
        ResKitWebService * restKit = [ResKitWebService sharedInstance];
        NSDictionary * stripeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"StripeData"];
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:stripeData options:0 error:nil];
        NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                     signupFirstName,kSMPSignUpFirstName,
                                     lastName,kSMPSignUpLastName,
                                     signupEmail,kSMPSignUpEmail,
                                     signupPassword, kSMPSignUpPassword,
                                     signupPhoneno,kSMPSignUpMobile,
                                     taxNumber,kSMPSignupTaxNumber,
                                     postCode,kSMPSignUpZipCode,
                                     _signUpDetails.driverFeature,kSMPSignupDriverFeature,
                                     [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPSignUpDeviceId,
                                     [NSNumber numberWithInt:cartype],kSMPSignupCompneyId,
                                     pushToken,kSMPgetPushToken,
                                     @"1",kSMPSignUpDeviceType,
                                     [Helper getCurrentDateTime],kSMPSignUpDateTime,isPopLockstr,kSMPoplock,optCode,kSMOtp,[stripeData objectForKey:@"stripe_user_id"],kSMStripeAccount,myString,kSMentStripeJson, nil];
        
        TELogInfo(@"param%@",queryParams);
        [restKit composeRequestForSignUpWithMethod:MethodPatientSignUp
                                           paramas:queryParams
                                      onComplition:^(BOOL success, NSDictionary *response){
                                          
                                          if (success) { //handle success response
                                              [self signupResponse:(NSArray*)response];
                                          }
                                          else{//error
                                              ProgressIndicator *pi = [ProgressIndicator sharedInstance];
                                              [pi hideProgressIndicator];
                                              [Helper showAlertWithTitle:@"Error" Message:@"Error occured please try again later"];
                                          }
                                      }];
        
    }
}


-(void)signupResponse :(NSArray *)dictionary
{
    ProgressIndicator * progress = [ProgressIndicator sharedInstance];
    //[progress hideProgressIndicator];
    
    Errorhandler * handler = [dictionary objectAtIndex:0];
    
    if ([[handler errFlag] intValue] ==0) {
        
    //    SignUp  * signup = handler.objects;
        
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:signup.token forKey:KDAcheckUserSessionToken];
//        [ud setObject:signup.chn forKey:kNSURoadyoPubNubChannelkey];
//        [ud setObject:signup.email forKey:kNSUPatientEmailAddressKey];
        
      _pickedImage = _signUpDetails.profileImage;
          [_signUpDetails clear];
        
        if (_pickedImage != nil) {
            
            [self uploadImage];
        }
        else {
            
            [progress hideProgressIndicator];
            [self gotoHomeScreen];
        }
        
    }
    else{
        
        [progress hideProgressIndicator];
        [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
    }
    
}
-(void)gotoHomeScreen{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Thank you for your request.In next 24 hours one of our staff will contact you for further process." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)uploadImage{
    
    UploadFiles * upload = [[UploadFiles alloc]init];
    upload.delegate = self;
    [upload uploadImageFile:_pickedImage];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==200) {
        
        [self cancelButtonClicked];
        // [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        
        OtpTextfield.text=@"";
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:0] animated:YES];
    }
    
}


#pragma UploadFileDelegate

-(void)uploadFile:(UploadFiles *)uploadfile didUploadSuccessfullyWithUrl:(NSArray *)imageUrls
{
   ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
   [progressIndicator hideProgressIndicator];
   [self gotoHomeScreen];
}
-(void)uploadFile:(UploadFiles *)uploadfile didFailedWithError:(NSError *)error{
    NSLog(@"upload file  error %@",[error localizedDescription]);
    [self gotoHomeScreen];
}

@end
