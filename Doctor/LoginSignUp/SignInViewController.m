//
//  SignInViewController.m
//  privMD
//
//  Created by Rahul Sharma on 13/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "SignInViewController.h"
#import "UploadFiles.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "Helper.h"
#import "AppConstants.h"
#import "Service.h"
#import "WebServiceConstants.h"
#import "ProgressIndicator.h"
#import "Fonts.h"
#import "CustomNavigationBar.h"
#import "Login.h"
#import "Errorhandler.h"
@interface SignInViewController ()<CustomNavigationBarDelegate,CLLocationManagerDelegate>
@property(nonatomic,assign)double currentLatitude;
@property(nonatomic,assign)double currentLongitude;
@property(nonatomic,strong)CLLocationManager *locationManager;
@end

@implementation SignInViewController

@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize navCancelButton;
@synthesize navDoneButton;
@synthesize emailImageView;
@synthesize signinButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)getCurrentLocation{
    
    //check location services is enabled
    if ([CLLocationManager locationServicesEnabled]) {
        
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.distanceFilter = kCLDistanceFilterNone;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                
                [_locationManager requestAlwaysAuthorization];
            }
            
        }
        [_locationManager startUpdatingLocation];
        
        
    }
    else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Service" message:@"Unable to find your location,Please enable location services." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
    self.view.backgroundColor = BG_Color;
    self.navigationItem.title = @"LOG IN";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
    
    self.navigationController.navigationBar.barTintColor= NavBarTint_Color;
//    [self.navigationController.navigationBar
//     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:Robot_Regular size:17]}];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:Oswald_Light size:17]}];
    self.navigationController.navigationBar.translucent = NO;
    [self createNavLeftButton];
    
    [emailTextField becomeFirstResponder];
    _fNameLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_textfield.png"]];
    
    _passwordLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_textfield.png"]];
    
    
//
//    [Helper setButton:signinButton Text:@"SIGN IN" WithFont:Robot_Regular FSize:15 TitleColor:UIColorFromRGB(0x333333) ShadowColor:nil];
//    [signinButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];
//    [signinButton setTitleColor:UIColorFromRGB(0xf6ce12) forState:UIControlStateNormal];
//    [signinButton setBackgroundImage:[UIImage imageNamed:@"login.jpg"] forState:UIControlStateNormal];
    
    [signinButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    [signinButton.titleLabel setFont:[UIFont fontWithName:Trebuchet_MS size:15]];
    [signinButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [signinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    signinButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
     signinButton.layer.cornerRadius = 2;
     signinButton.layer.borderWidth = 1;
     signinButton.layer.borderColor = [UIColor whiteColor].CGColor;
    // signinButton.clipsToBounds = true;

 
    
    [Helper setButton:_forgotPasswordButton Text:@"Forgot Password?" WithFont:Robot_Regular FSize:15 TitleColor:UIColorFromRGB(0x333333) ShadowColor:nil];
    [_forgotPasswordButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [_forgotPasswordButton setTitleColor:BLACK_COLOR forState:UIControlStateHighlighted];


    [emailTextField setValue:[UIColor blackColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [passwordTextField setValue:[UIColor blackColor]
     
                     forKeyPath:@"_placeholderLabel.textColor"];
    [_caridTextField setValue:[UIColor blackColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
        
    emailTextField.font = [UIFont fontWithName:Robot_CondensedRegular size:15];
    emailTextField.textColor =[UIColor blackColor];
    passwordTextField.font = [UIFont fontWithName:Robot_CondensedRegular size:15];
    passwordTextField.textColor =[UIColor blackColor];
    _caridTextField.font = [UIFont fontWithName:Robot_CondensedRegular size:15];
    _caridTextField.textColor =[UIColor whiteColor];
    
    
    

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
   // [self addCustomNavigationBar];

    _currentLongitude = 0.0;
    _currentLatitude = 0.0;
   
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self getCurrentLocation];
}

-(void)viewDidDisappear:(BOOL)animated
{
   // self.navigationController.navigationBarHidden = YES;
}

-(void) createNavLeftButton
{
    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setFrame:CGRectMake(0.0f,0.0f,buttonImage.size.width,buttonImage.size.height)];
    
    [Helper setButton:cancelButton Text:@"BACK" WithFont:Oswald_Light FSize:11 TitleColor:[UIColor blueColor] ShadowColor:nil];
    [cancelButton setTitle:@"BACK" forState:UIControlStateNormal];
    [cancelButton setShowsTouchWhenHighlighted:YES];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont fontWithName:Oswald_Light size:11];
   // [cancelButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    
    //Adding Button onto View
    // [navView addSubview:navCancelButton];
    
    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    // UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithCustomView:segmentView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
    
    
    
}
-(void)createnavRightButton
{
    navDoneButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [navDoneButton addTarget:self action:@selector(DoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [navDoneButton setFrame:CGRectMake(0.0f,0.0f, 60,30)];
    [Helper setButton:navDoneButton Text:@"Done" WithFont:@"HelveticaNeue" FSize:17 TitleColor:[UIColor blueColor] ShadowColor:nil];
    [navDoneButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    // Create a container bar button
    UIBarButtonItem *containingnextButton = [[UIBarButtonItem alloc] initWithCustomView:navDoneButton];
    self.navigationItem.rightBarButtonItem = containingnextButton;
}

- (void) addCustomNavigationBar{
    
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"SIGN IN"];
    [customNavigationBarView setLeftBarButtonTitle:@"Back"];
    [self.view addSubview:customNavigationBarView];
}

-(void)leftBarButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissKeyboard
{
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

-(void)cancelButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self callPop];
}


-(void)callPop
{
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)signInUser
{
    
    
    NSString *email = emailTextField.text;
    NSString *carid = _caridTextField.text;
    NSString *password = passwordTextField.text;
    
    if((unsigned long)email.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Email ID"];
        [emailTextField becomeFirstResponder];
    }
//    else if((unsigned long)carid.length == 0)
//    {
//        [Helper showAlertWithTitle:@"Message" Message:@"Enter your id"];
//        [_caridTextField becomeFirstResponder];
//    }
    else if((unsigned long)password.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Password"];
        [passwordTextField becomeFirstResponder];
    }
    else if([self emailValidationCheck:email] == 0)
    {
        //email is not valid
        [Helper showAlertWithTitle:@"Message" Message:@"Invalid Email ID"];
        emailTextField.text = @"";
        [emailTextField becomeFirstResponder];
        
    }
    else
    {
        [self.view endEditing:YES];
        checkLoginCredentials = YES;
        [self sendServiceForLogin];
        
    }
    
}



-(void)DoneButtonClicked
{
    [self signInUser];
}

-(void)sendServiceForLogin
{
    
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator showPIOnView:self.view withMessage:@"Signing in"];
    ResKitWebService * restKit = [ResKitWebService sharedInstance];
    
    NSString * pushToken;
    if([[NSUserDefaults standardUserDefaults]objectForKey:kSMPgetPushToken])
    {
        pushToken =[[NSUserDefaults standardUserDefaults]objectForKey:kSMPgetPushToken];
        
    }
    else
    {
        pushToken =@"dgfhfghr765998ghghj";
        
    }
    NSLog(@"pushtoken%@",pushToken);
    
  
    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys: emailTextField.text, kSMPLoginEmail,
                   passwordTextField.text, kSMPLoginPassword,
                   @"",kSMPLoginCarId,
                   [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPLoginDevideId,
                   pushToken,kSMPLoginPushToken,
                   @"1",kSMPLoginDeviceType,
                   [NSNumber numberWithDouble:_currentLatitude],kSMPSignUpLattitude,
                   [NSNumber numberWithDouble:_currentLongitude],kSMPSignUpLongitude,
                   [Helper getCurrentDateTime], kSMPCommonUpDateTime,
                   nil];
    
    [restKit composeRequestForLoginWithMethod:MethodPatientLogin
                                                paramas:queryParams
                                                onComplition:^(BOOL success, NSDictionary *response){
    
                                               if (success) { //handle success response
                                                 
                                                   [self loginResponse:(NSArray*)response];
                                               }
                                               else{//error
    
                                               }
                                           }];
 
  

   
}


-(void)loginResponse:(NSArray *)array
{

    Errorhandler * handler = [array objectAtIndex:0];
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    
    if ([[handler errFlag] intValue] ==0) {
        
        Login  *login = handler.objects;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:login.token forKey:KDAcheckUserSessionToken];
        [ud setObject:login.chn forKey:kNSURoadyoPubNubChannelkey];
        [ud setObject:login.email forKey:kNSUPatientEmailAddressKey];
        [ud setObject:login.susbChn forKey:kNSURoadyoSubscribeChanelKey];
        [ud setObject:login.listner forKey:kNSUDriverListnerChannelKey];
        
        [ud setObject:login.status forKey:kNSUPatientCarIDKey];
        [ud setObject:login.car_type_name forKey:kNSUPatientCarNameKey];
        
        [ud synchronize];
        
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                        @"Main" bundle:[NSBundle mainBundle]];
        
           UINavigationController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"home"];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
           self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];

    }
    else{
        [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
        NSLog(@"%@",handler.errMsg);
    }

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
//     MapViewController *MPC = [[MapViewController alloc]init];
//      MPC =[segue destinationViewController];
  
        
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField == emailTextField)
    {
        [passwordTextField becomeFirstResponder];
    }
    else if(textField == passwordTextField){
        [_caridTextField becomeFirstResponder];
    }
    else  {
        
        [_caridTextField resignFirstResponder];
        [self DoneButtonClicked];
        
    }
    return YES;
}


- (IBAction)forgotPasswordButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    UIAlertView *forgotPasswordAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Can't sign in? "
                                        message:@"Enter your email address below,we will send your OTP to the registered mobile no."
                                        delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Submit", nil];
    
    UITextField *emailForgot = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, 225, 30)];
    emailForgot.delegate =self;
    
    emailForgot.placeholder = @"Email ID";
    
    emailImageView.frame = CGRectMake(220,110,18,18);
    
    [forgotPasswordAlert addSubview:emailForgot];
    [forgotPasswordAlert addSubview:emailImageView];
    
    forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [forgotPasswordAlert show];
    
    //forgotView.hidden=NO;
     NSLog(@"password recovery to be done here");
    
}


- (IBAction)signInButtonClicked:(id)sender {
     [self signInUser];
}
- (void) forgotPaswordAlertviewTextField
{
    UIAlertView *forgotPasswordAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Invalid Email ID"
                                        message:@"Re-enter your email ID "
                                        delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Submit", nil];
    forgotPasswordAlert.tag = 1;
    UITextField *emailForgot = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, 225, 30)];
    [forgotPasswordAlert addSubview:emailForgot];
    forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [forgotPasswordAlert show];
    
}

- (void)OTPAlertviewTextField
{
    UIAlertView *forgotPasswordAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Invalid OTP"
                                        message:@"Reenter your OTP"
                                        delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Submit", nil];
    forgotPasswordAlert.tag = 101;
    UITextField *emailForgot = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, 225, 30)];
    [forgotPasswordAlert addSubview:emailForgot];
    forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [forgotPasswordAlert show];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 101) {
        
        if(buttonIndex == 1)
        {
            UITextField *forgotEmailtext = [alertView textFieldAtIndex:0];
            TELogInfo(@"Email Name: %@", forgotEmailtext.text);
            
            if (((unsigned long)forgotEmailtext.text.length ==0))
            {
                [self OTPAlertviewTextField];
            }
            else
            {
                [self retrievePasswordFromOtp:forgotEmailtext.text];
            }
        }
        else
        {
            TELogInfo(@"cancel");
        }
        
    }
    else{
        
        if(buttonIndex == 1)
        {
            UITextField *forgotEmailtext = [alertView textFieldAtIndex:0];
            NSLog(@"Email Name: %@", forgotEmailtext.text);
            
            if (((unsigned long)forgotEmailtext.text.length ==0) || [Helper emailValidationCheck:forgotEmailtext.text] == 0)
            {
                [self forgotPaswordAlertviewTextField];
            }
            else
            {
                [self retrievePassword:forgotEmailtext.text];
            }
        }
        
        else
        {
            NSLog(@"cancel");
         
        }
        
    }

}

- (void)retrievePassword:(NSString *)text
{
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Loading.."];
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    emailstr=text;
    NSString *parameters = [NSString stringWithFormat:@"ent_email=%@&ent_user_type=%@",text,@"1"];
    NSString *removeSpaceFromParameter=[Helper removeWhiteSpaceFromURL:parameters];
    NSLog(@"request doctor around you :%@",parameters);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@generateforgotpasswordOtp",BASE_URL]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                             dataUsingEncoding:NSUTF8StringEncoding
                             allowLossyConversion:YES]];
    
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(retrievePasswordResponse:)];
    
}

-(void)retrievePasswordResponse :(NSDictionary *)response
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    
    NSLog(@"response:%@",response);
    if (!response)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([response objectForKey:@"Error"])
    {
        [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
    }
    else
    {
        NSDictionary *dictResponse=[response objectForKey:@"ItemsList"];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
        {
            [self otpAlertviewTextField];
        }
        else
        {
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
        }
    }
}


//TODO:: Add Alert for OTP

- (void)otpAlertviewTextField
{
    [self.view endEditing:YES];
    UIAlertView *forgotPasswordAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Can't sign in?"
                                        message:@"Please enter your OTP"
                                        delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Submit", nil];
    UITextField *emailForgot = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, 225, 30)];
    emailForgot.delegate =self;
    emailForgot.placeholder = @"OTP";
    emailImageView.frame = CGRectMake(220,110,18,18);
    [forgotPasswordAlert addSubview:emailForgot];
    [forgotPasswordAlert addSubview:emailImageView];
    forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    forgotPasswordAlert.tag=101;
    [forgotPasswordAlert show];
    
}

- (void)retrievePasswordFromOtp:(NSString *)text
{
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Loading.."];
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    NSString *parameters = [NSString stringWithFormat:@"ent_otp=%@&ent_user_type=%@&ent_email=%@",text,@"1",emailstr];
    NSString *removeSpaceFromParameter=[Helper removeWhiteSpaceFromURL:parameters];
    TELogInfo(@"request doctor around you :%@",parameters);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@forgotPassword",BASE_URL]];
    NSLog(@"%@",url);
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                             dataUsingEncoding:NSUTF8StringEncoding
                             allowLossyConversion:YES]];
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(retrieveOtpResponse:)];
    
}

-(void)retrieveOtpResponse :(NSDictionary *)response
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    TELogInfo(@"response:%@",response);
    if (!response)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([response objectForKey:@"Error"])
    {
        [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
        
    }
    else
    {
        NSDictionary *dictResponse=[response objectForKey:@"ItemsList"];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
        {
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
        }
        else
        {
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
            [self otpAlertviewTextField];
        }
    }
}

- (BOOL) emailValidationCheck: (NSString *) emailToValidate
{
    NSString *regexForEmailAddress = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexForEmailAddress];
    return [emailValidation evaluateWithObject:emailToValidate];
}
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
    
    [_locationManager stopUpdatingLocation];
    _currentLatitude = newLocation.coordinate.latitude;
    _currentLongitude = newLocation.coordinate.longitude;
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
}

@end
