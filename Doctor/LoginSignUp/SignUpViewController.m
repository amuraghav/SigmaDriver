//
//  SignUpViewController.m
//  privMD
//
//  Created by Rahul Sharma on 13/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "SignUpViewController.h"
//#import "MapViewController.h"
#import "TermsnConditionViewController.h"
#import "SignInViewController.h"
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



#define REGEX_PASSWORD_ONE_UPPERCASE @"^(?=.*[A-Z]).*$"  //Should contains one or more uppercase letters
#define REGEX_PASSWORD_ONE_LOWERCASE @"^(?=.*[a-z]).*$"  //Should contains one or more lowercase letters
#define REGEX_PASSWORD_ONE_NUMBER @"^(?=.*[0-9]).*$"  //Should contains one or more number
#define REGEX_PASSWORD_ONE_SYMBOL @"^(?=.*[!@#$%&_]).*$"  //Should contains one or more symbol


@interface SignUpViewController ()<DoneCancelNumberPadToolbarDelegate,CustomNavigationBarDelegate,CLLocationManagerDelegate,UploadFileDelegate,UIAlertViewDelegate>
{
       NSArray * arrPracticenor;
       int practicenortype;
       NSMutableArray * arrCartype;
       NSMutableArray * arrSeat;
       NSString *pickerTitle;
    UIButton *stripeConnect;
}
@property (assign,nonatomic) BOOL isImageNeedsToUpload;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,assign)float currentLatitude;
@property(nonatomic,assign)float currentLongitude;
@property(nonatomic,strong)Cartype *selectedCarType;
@property(nonatomic,assign)NSInteger selectedCapacity;
@property(nonatomic,strong)UITextField *activeTextField;
@property(nonatomic,assign)BOOL isKeyboardIsShown;
@property(nonatomic,strong)SignUpDetails *signUpDetails;
@property(nonatomic,strong)UIImageView *profileImage;
@property(nonatomic,weak) IBOutlet UITableView *tableView;




//-(PasswordStrengthType)checkPasswordStrength:(NSString *)password;
-(int)checkPasswordStrength:(NSString *)password;

@end

@implementation SignUpViewController

@synthesize mainView;
@synthesize mainScrollView;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize conPasswordTextField;
@synthesize phoneNoTextField;
@synthesize carRegistrationNumberTextField;
@synthesize helperCountry;
@synthesize helperCity;
@synthesize saveSignUpDetails;
@synthesize profileButton;
@synthesize profileImageView;
@synthesize tncButton;
@synthesize tncCheckButton;
@synthesize creatingLabel;
@synthesize btnpracticenorType;
@synthesize carTypeLabel;
@synthesize SeatingCapacityLabel;
@synthesize activeTextField;
@synthesize licenceNumberTextField;


#pragma mark -init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -view life cycle

- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = BG_Color;
    self.navigationItem.title = @"REGISTER";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
    
    self.navigationController.navigationBar.barTintColor= NavBarTint_Color;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:Oswald_Light size:17]}];
    self.navigationController.navigationBar.translucent = NO;
    
   
//
//    self.navigationController.navigationBarHidden = NO;
//    self.navigationItem.hidesBackButton = NO;
//
//    self.title = @"CREATE ACCOUNT";
    [self createNavLeftButton];
    [self createNavRightButton];
   

    _signUpDetails = [SignUpDetails sharedInstance];
    

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
   
    
    
    // ProfileImageView
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(115, 0, 90, 95)];
    _profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    _profileImage.image = [UIImage imageNamed:@"signup_profile_image"];
    [_profileImage setBackgroundColor:[UIColor whiteColor]];
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width / 2;
    _profileImage.clipsToBounds = YES;
    [view addSubview:_profileImage];
    
    UIButton *buttonSelectPicture = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSelectPicture.frame = CGRectMake(0, 0, 70, 70);
    [buttonSelectPicture addTarget:self action:@selector(profileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonSelectPicture];
    self.tableView.backgroundColor=[UIColor clearColor];
   // self.tableView.backgroundColor=BG_Color;
    [self.tableView addSubview:view];
    
    
    
    //table bottom view
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 200)];
    UIButton *buttonCheckBox = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCheckBox.frame = CGRectMake(25, 50, 34, 34);
    [buttonCheckBox setImage:[UIImage imageNamed:@"signup_btn_checkbox_off"] forState:UIControlStateNormal];
    [buttonCheckBox setImage:[UIImage imageNamed:@"signup_btn_checkbox_on"] forState:UIControlStateSelected];
    [buttonCheckBox addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //Add new check box for pop lock
    UIButton *buttonCheckBoxPoplock = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCheckBoxPoplock.frame = CGRectMake(25, 5, 34, 34);
    [buttonCheckBoxPoplock setImage:[UIImage imageNamed:@"signup_btn_checkbox_off"] forState:UIControlStateNormal];
    [buttonCheckBoxPoplock setImage:[UIImage imageNamed:@"signup_btn_checkbox_on"] forState:UIControlStateSelected];
    [buttonCheckBoxPoplock addTarget:self action:@selector(checkPopButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    stripeConnect = [UIButton buttonWithType:UIButtonTypeCustom];
    stripeConnect.frame = CGRectMake(30, 95, 260, 35);
    [stripeConnect addTarget:self action:@selector(stripeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [stripeConnect setTitle:@"Stripe Connect" forState:UIControlStateNormal];
    
    stripeConnect.layer.borderWidth = 1;
    stripeConnect.layer.borderColor = [UIColor whiteColor].CGColor;
    [stripeConnect setBackgroundColor:[UIColor blueColor]];
    
    [stripeConnect.titleLabel setFont:[UIFont fontWithName:Trebuchet_MS size:15]];
    [stripeConnect setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [stripeConnect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    stripeConnect.titleLabel.font = [UIFont systemFontOfSize:15];
    stripeConnect.layer.cornerRadius = 1;

    
    
    
    
    
    
    
    UIButton *buttonSignUp = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSignUp.frame = CGRectMake(30, 150, 260, 35);
    [buttonSignUp addTarget:self action:@selector(NextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [buttonSignUp setTitle:@"REGISTER NOW" forState:UIControlStateNormal];
    
    buttonSignUp.layer.borderWidth = 1;
    buttonSignUp.layer.borderColor = [UIColor whiteColor].CGColor;
    [buttonSignUp setBackgroundColor:BUTTON_Color];
    
    [buttonSignUp.titleLabel setFont:[UIFont fontWithName:Trebuchet_MS size:15]];
    [buttonSignUp setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [buttonSignUp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     buttonSignUp.titleLabel.font = [UIFont systemFontOfSize:15];
     buttonSignUp.layer.cornerRadius = 1;
   
    [bottomView addSubview:buttonCheckBoxPoplock];
    [bottomView addSubview:buttonCheckBox];
    [bottomView addSubview:buttonSignUp];
    [bottomView addSubview:stripeConnect];
 
    UILabel *lblPopLock = [[UILabel alloc]init];
    lblPopLock.numberOfLines = 2;
    lblPopLock.frame = CGRectMake(70, 5, 220, 40);
    [Helper setToLabel:lblPopLock Text:@"Do you want work on PopLock" WithFont:Robot_CondensedLight FSize:14 Color:[UIColor blackColor]];
    [bottomView addSubview:lblPopLock];

    UIButton *buttonTermsAndCondition = [UIButton buttonWithType:UIButtonTypeCustom];
     buttonTermsAndCondition.titleLabel.numberOfLines = 2;
    buttonTermsAndCondition.frame = CGRectMake(70, 50, 220, 40);
    [Helper setButton:buttonTermsAndCondition Text:@"By creating account you agree to the terms and conditions" WithFont:Robot_CondensedLight FSize:14 TitleColor:[UIColor blackColor] ShadowColor:nil];
    [buttonTermsAndCondition addTarget:self action:@selector(TermsNconButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonTermsAndCondition.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bottomView addSubview:buttonTermsAndCondition];
    self.tableView.tableFooterView = bottomView;
    
    
  
    

    
    //[self addCustomNavigationBar];
    
    arrSeat = [[NSMutableArray alloc]initWithObjects:@"4",@"6",@"8", nil];
    
    [self GetCarType];
    
    isTnCButtonSelected = NO;
     _signUpDetails.Poplock  = @"0";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    
    // Register notification when the keyboard will be show
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Register notification when the keyboard will be hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStripeButton)
                                                 name:@"StripeConnected"
                                               object:nil];
    

    
    _isKeyboardIsShown = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:@"StripeConnected"];
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
    
    
    //  self.navigationItem.leftBarButtonItem = containingcancelButton;
}

-(void)createNavRightButton
{
    //TODO::this code comment for signup method calling........
    
//    UIButton *navNextButton =  [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
//    [navNextButton setFrame:CGRectMake(0,0,buttonImage.size.width,buttonImage.size.height)];
//    
//    [navNextButton addTarget:self action:@selector(NextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    [Helper setButton:navNextButton Text:@"NEXT" WithFont:Robot_Light FSize:11 TitleColor:[UIColor blueColor] ShadowColor:nil];
//    [navNextButton setTitle:@"NEXT" forState:UIControlStateNormal];
//    [navNextButton setTitle:@"NEXT" forState:UIControlStateSelected];
//    [navNextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [navNextButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [navNextButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
//    
//    // Create a container bar button
//    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navNextButton];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
    
}


-(void)getCurrentLocation{
    
    //check location services is enabled
    if ([CLLocationManager locationServicesEnabled]) {
        
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


#pragma mark -CLLocation manager deleagte method
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_6, __MAC_NA, __IPHONE_2_0, __IPHONE_6_0){
    
    _currentLatitude= newLocation.coordinate.latitude;
    _currentLongitude= newLocation.coordinate.longitude;
    [_locationManager stopUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
}






-(void)GetCarType
{
    ProgressIndicator * progress = [ProgressIndicator sharedInstance];
    [progress showPIOnView:self.view withMessage:@"loading.."];
    ResKitWebService * service = [ResKitWebService sharedInstance];
    [service composeRequestForcarTypeWithMethod:MethodGetCarType
                                        paramas:nil
                                   onComplition:^(BOOL succeeded, NSDictionary *response){
     if (succeeded) { //handle success response
                                       [self carResponse:(NSArray*)response];
                                   }
                 else{//error
         ProgressIndicator *pi = [ProgressIndicator sharedInstance];
         [pi hideProgressIndicator];
         
          }
     }];

    

}

-(void)carResponse :(NSArray*)Response
{
    ProgressIndicator * progress = [ProgressIndicator sharedInstance];
    [progress hideProgressIndicator];
    
    Errorhandler * handler = [Response objectAtIndex:0];
    
    if ([[handler errFlag] intValue] ==0) {
     
        arrCartype = [handler objects];
    }
    else{
        [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
    }
    
    
    
}





#pragma mark -leftbar and righbar action

-(void)rightBarButtonClicked:(UIButton *)sender{
    
    [self NextButtonClicked];
}

-(void)leftBarButtonClicked:(UIButton *)sender{
    [self cancelButtonClicked];
}

//-(void)createNavLeftButton
//{
//    ///////////
//    navCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [navCancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    
//    [navCancelButton setFrame:CGRectMake(0.0f,0.0f, 60,30)];
//    
//    [navCancelButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    [navCancelButton setTitleColor:UIColorFromRGB(0xffcc00) forState:UIControlStateHighlighted];
//    [navCancelButton setTitle:@"Back" forState:UIControlStateNormal];
//    navCancelButton.titleLabel.font = [UIFont fontWithName:Robot_Light size:14];
//    
//    // Create a container bar button
//    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navCancelButton];
//    
//    self.navigationItem.leftBarButtonItem = containingcancelButton;
//    
//    
//}
//
//-(void)createNavRightButton
//{
//    
//    navNextButton =  [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [navNextButton addTarget:self action:@selector(NextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    
//    [navNextButton setFrame:CGRectMake(0.0f,0.0f, 60,30)];
//    
//    [navNextButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    [navNextButton setTitleColor:UIColorFromRGB(0xffcc00) forState:UIControlStateHighlighted];
//    
//    [navCancelButton setTitle:@"Next" forState:UIControlStateNormal];
//    navCancelButton.titleLabel.font = [UIFont fontWithName:Robot_Light size:14];
//    
//    // Create a container bar button
//    UIBarButtonItem *containingnextButton = [[UIBarButtonItem alloc] initWithCustomView:navNextButton];
//    
//    self.navigationItem.rightBarButtonItem = containingnextButton;
//
//}
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    [firstNameTextField resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [conPasswordTextField resignFirstResponder];
    [phoneNoTextField resignFirstResponder];
    [carRegistrationNumberTextField resignFirstResponder];
    [licenceNumberTextField resignFirstResponder];
    [newSheet dismissWithClickedButtonIndex:1 animated:YES];
    [self moveViewDown];
}


#pragma TODO:: New webservice generateOtp

#pragma mark - WebService call
-(void)sendServiceForGenerateOtp
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
    isPopLockstr = _signUpDetails.Poplock ;
    
    //NSInteger carSeatingCapacity = _selectedCapacity;
    
    if ((unsigned long)signupFirstName.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter First Name"];
        //[firstNameTextField becomeFirstResponder];
    }
    //    else if (cartype == 0)
    //    {
    //        [Helper showAlertWithTitle:@"Message" Message:@"Choose a compney"];
    //        //[licenceNumberTextField becomeFirstResponder];
    //    }
    //    else if ((unsigned long)taxNumber.length == 0)
    //    {
    //        [Helper showAlertWithTitle:@"Message" Message:@"Enter tax number"];
    //    }
    
    else if ((unsigned long)signupEmail.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Email ID"];
        
    }
    else if ((unsigned long)signupPhoneno.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter contact number"];
        
    }
    else if ((unsigned long)signupPassword.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Password"];
    }
    else if ((unsigned long)signupConfirmPassword.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Password to Confirm"];
    }
    else if ([Helper emailValidationCheck:signupEmail] == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Invalid Email Id"];
    }
    
    else if ([signupPassword isEqualToString:signupConfirmPassword] == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Password Mismatched"];
        
    }
    else if (!isTnCButtonSelected)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Please select our Terms and Conditions"];
    }
    else
    {
        
        
        [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Register.."];
        WebServiceHandler *handler = [[WebServiceHandler alloc] init];
        //  NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
        
        NSString *signupPhoneno = _signUpDetails.mobile;
        NSString *userType = @"2";
        
        NSString *parameters = [NSString stringWithFormat:@"ent_mobile=%@&ent_user_type=%@",signupPhoneno,userType];
        
        NSString *removeSpaceFromParameter = [Helper removeWhiteSpaceFromURL:parameters];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@generateOtp",BASE_URL]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        
        [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                                 dataUsingEncoding:NSUTF8StringEncoding
                                 allowLossyConversion:YES]];
        
        [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(updateProfileResponse:)];
        
    }
    
}

-(void)updateProfileResponse:(NSDictionary *)response
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
          
            
            [self performSegueWithIdentifier:@"OTPVC" sender:self];
            
        }
        else{
            
             [Helper showAlertWithTitle:@"Error" Message:[dictResponse objectForKey:@"errMsg"]];
        }
    }
    
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
    isPopLockstr = _signUpDetails.Poplock ;
    
    //NSInteger carSeatingCapacity = _selectedCapacity;
    
    if ((unsigned long)signupFirstName.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter First Name"];
        //[firstNameTextField becomeFirstResponder];
    }
//    else if (cartype == 0)
//    {
//        [Helper showAlertWithTitle:@"Message" Message:@"Choose a compney"];
//        //[licenceNumberTextField becomeFirstResponder];
//    }
//    else if ((unsigned long)taxNumber.length == 0)
//    {
//        [Helper showAlertWithTitle:@"Message" Message:@"Enter tax number"];
//    }
    
    else if ((unsigned long)signupEmail.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Email ID"];
    }
    else if ((unsigned long)signupPhoneno.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter contact number"];
    }
    else if ((unsigned long)signupPassword.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Password"];
    }
    else if ((unsigned long)signupConfirmPassword.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Password to Confirm"];
    }
    else if ([Helper emailValidationCheck:signupEmail] == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Invalid Email Id"];
    }
   
    else if ([signupPassword isEqualToString:signupConfirmPassword] == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Password Mismatched"];
       
    }
    else if (!isTnCButtonSelected)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Please select our Terms and Conditions"];
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
    
     //   NSString * lattitude =[NSString stringWithFormat:@"%f",_currentLatitude];
     //   NSString * logitude =[NSString stringWithFormat:@"%f",_currentLongitude];
    
        
        NSDictionary *queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                     
                       signupFirstName,kSMPSignUpFirstName,
                       lastName,kSMPSignUpLastName,
                       signupEmail,kSMPSignUpEmail,
                       signupPassword, kSMPSignUpPassword,
                       signupPhoneno,kSMPSignUpMobile,
                       taxNumber,kSMPSignupTaxNumber,
                        postCode,kSMPSignUpZipCode,
                       [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPSignUpDeviceId,
                       [NSNumber numberWithInt:cartype],kSMPSignupCompneyId,
                       pushToken,kSMPgetPushToken,
                        @"1",kSMPSignUpDeviceType,
                       [Helper getCurrentDateTime],kSMPSignUpDateTime,isPopLockstr,kSMPoplock, nil];
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - MainView Up/Down
-(void)moveViewUpToPoint:(int)point
{
    CGRect rect = mainScrollView.frame;
    rect.origin.y = point;
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         mainScrollView.frame = rect;
                     }
                     completion:^(BOOL finished){
                     }];
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:.2];
    //    [mainScrollSignUp setFrame:rect];
    //    [UIView commitAnimations];
    
}

-(void)moveViewDown
{
    CGRect rect = mainScrollView.frame;
    rect.origin.y = 0;
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:.2];
    //    [mainScrollSignUp setFrame:rect];
    //    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         mainScrollView.frame = rect;
                     }
                     completion:^(BOOL finished){
                     }];
    
}

//- (void) validateEmailAndPostalCode
//{
//    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Loading.."];
//    
//    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
//    
//    NSString *parameters = [NSString stringWithFormat:@"ent_email=%@&zip_code=%@&ent_user_type=%@&ent_date_time=%@",emailTextField.text,carRegistrationNumberTextField.text,@"2",[Helper getCurrentDateTime]];
//    
//    NSString *removeSpaceFromParameter=[Helper removeWhiteSpaceFromURL:parameters];
//    NSLog(@"request doctor around you :%@",parameters);
//    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@validateEmailZip",BASE_URL]];
//    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
//    
//    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [theRequest setHTTPMethod:@"POST"];
//    [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
//                             dataUsingEncoding:NSUTF8StringEncoding
//                             allowLossyConversion:YES]];
//    
//    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(validateEmailResponse:)];
//    
//}
//


//-(void)validateEmailResponse :(NSDictionary *)response
//{
//        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
//        [pi hideProgressIndicator];
//        
//        NSLog(@"response:%@",response);
//        if (!response)
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alertView show];
//            
//        }
//        else if ([response objectForKey:@"Error"])
//        {
//            [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
//
//        }
//        else
//        {
//            
//            
//            NSDictionary *dictResponse=[response objectForKey:@"ItemsList"];
//            if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
//            {
//               // [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
//               //                saveSignUpDetails = [[NSArray alloc]initWithObjects:firstNameTextField.text,lastNameTextField.text,emailTextField.text,phoneNoTextField.text,carRegistrationNumberTextField.text,passwordTextField.text,conPasswordTextField.text, nil];
//                NSString *deviceId;
//  
//                if (IS_SIMULATOR) {
//                    deviceId = kPMDTestDeviceidKey;
//                }
//                else {
//                    deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
//                }
//                
//                
//                NSMutableDictionary *signUp1Dict = [[NSMutableDictionary alloc]init];
//                
//                
//                NSString *patientEmail = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPatientEmailAddressKey];
//                [signUp1Dict setObject:firstNameTextField.text forKey:kSMPSignUpFirstName];
//                [signUp1Dict setObject:lastNameTextField.text forKey:kSMPSignUpLastName];
//                [signUp1Dict setObject:emailTextField.text forKey:kSMPSignUpEmail];
//                [signUp1Dict setObject:passwordTextField.text forKey:kSMPSignUpPassword];
//                [signUp1Dict setObject:phoneNoTextField.text forKey:kSMPSignUpMobile];
//                [signUp1Dict setObject:carRegistrationNumberTextField.text forKey:kSMPSignUpZipCode];
//                [signUp1Dict setObject:@"13.4500" forKey:kSMPSignUpLattitude];
//                [signUp1Dict setObject:@"77.07656" forKey:kSMPSignUpLongitude];
//                [signUp1Dict setObject:@"1" forKey:kSMPSignUpDeviceType];
//                [signUp1Dict setObject:[NSString stringWithFormat:@"%d",practicenortype] forKey:kSMPSignUpDoctorType];
//                [signUp1Dict setObject:deviceId forKey:kSMPSignUpDeviceId];
//                [signUp1Dict setObject:[Helper getCurrentDateTime] forKey:kSMPCommonUpDateTime];
//                
//                
//                
//                
//                if([[NSUserDefaults standardUserDefaults]objectForKey:KDAgetPushToken])
//                {
//                    [signUp1Dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:KDAgetPushToken] forKey:kSMPSignUpPushToken];
//                }
//                else
//                {
//                    [signUp1Dict setObject:@"123" forKey:kSMPSignUpPushToken];
//                }
//                
//                NSLog(@"signup User dict detials %@ ",signUp1Dict);
//                
//                NSMutableURLRequest *request = [Service parseSignUp:signUp1Dict];
//                
//                NSLog(@"Request : %@",request);
//                
//                WebServiceHandler *handler = [[WebServiceHandler alloc]init];
//                handler.requestType = eSignUp;
//                
//                [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(signupResponse:)];
//                
//               
////
////            HomeVieHomeViewController *viewcontrolelr = [UIStoryboard instantiateViewControllerWithIdentifier:@"GotoHome"];
////            self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];
//
//                
//                
//            }
//            else
//            {
//                [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
//                
//            }
//        }
//}

-(void)signupResponse :(NSArray *)dictionary
{
    ProgressIndicator * progress = [ProgressIndicator sharedInstance];
    //[progress hideProgressIndicator];
    
    Errorhandler * handler = [dictionary objectAtIndex:0];
    
    if ([[handler errFlag] intValue] ==0) {
        
         SignUp  * signup = handler.objects;
      
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:signup.token forKey:KDAcheckUserSessionToken];
        [ud setObject:signup.chn forKey:kNSURoadyoPubNubChannelkey];
        [ud setObject:signup.email forKey:kNSUPatientEmailAddressKey];
        
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
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
//                                @"Main" bundle:[NSBundle mainBundle]];
//    
//    MenuViewController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"home"];
//    self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];
    
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
        [self cancelButtonClicked];
    }
    
}

#pragma mark -ButtonAction


- (void)showDatePickerWithTitle:(UITextField*)textFeild
{
	
    pickerTitle = @"Choose compney";
    newSheet=[[UIActionSheet alloc]initWithTitle:pickerTitle
                                        delegate:nil
                               cancelButtonTitle:nil
                          destructiveButtonTitle:nil
                               otherButtonTitles:nil];
       newSheet.backgroundColor = [UIColor whiteColor];
    
        
        //[self moveViewupwordto:300];
        pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
        pickerview.delegate = self;
        pickerview.dataSource = self;
        pickerview.showsSelectionIndicator = YES;
        pickerview.opaque = NO;
        pickerview.tag = 100;
        [self.view addSubview:pickerview];
        [newSheet addSubview:pickerview];
        UIButton *closeButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setTitle:@"Done" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
        closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
        
        [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventTouchUpInside];
        
        [newSheet addSubview:closeButton];
        
        UIButton *cancelButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(10, 7.0f, 70.0f, 30.0f);
        
        
        cancelButton.tintColor = [UIColor greenColor];
        [cancelButton addTarget:self action:@selector(dismissActionSheet1) forControlEvents:UIControlEventTouchUpInside];
        [newSheet addSubview:cancelButton];
        
        
        [newSheet showInView:[[UIApplication sharedApplication] keyWindow]];
        [newSheet setBounds:CGRectMake(0, 0, 320, 480)];
        
        
        
   
    
    
}

#pragma mark -
#pragma mark UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView.tag == 100) {
         return [arrCartype count];
    }
   
    return 0;
   
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
   
    NSString * strCar;
    if (pickerView.tag == 100) {
//        if (row == arrCartype.count) {
//            
//            strCar = @"Other";
//        }
//        else {
        
            Cartype * type = [arrCartype objectAtIndex:row];
            strCar = type.companyname;
     //   }
        
    }
   
    
     return strCar;

   
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    
//
//    if (pickerView.tag == 100)
//    {
//          Cartype *type = [arrCartype objectAtIndex:row];
//          //[Helper setToLabel:lblCarType Text:type.type_name WithFont:Robot_Light FSize:11 Color:UIColorFromRGB(0x000000)];
//        
//    }
    
}

- (void)dismissActionSheet//save
{
    [newSheet dismissWithClickedButtonIndex:1 animated:YES];
    NSInteger selectedIndex = [pickerview selectedRowInComponent:0];
    if (pickerview.tag == 100) { //cartype
        
//        if (selectedIndex == arrCartype.count) {
//            _selectedCarType = 0;
//            self.activeTextField.text = @"Other";
//            _signUpDetails.compneyName = @"Other";
//            _signUpDetails.compneyId = @"0";
//        }
//        else{
        
             _selectedCarType = arrCartype[selectedIndex];
             self.activeTextField.text = _selectedCarType.companyname;
            _signUpDetails.compneyName = _selectedCarType.companyname;
            _signUpDetails.compneyId = _selectedCarType.company_id;
       // }
       

       
        [self findNextResponder:self.activeTextField];
        
    }
    else if (pickerview.tag == 200) { //Capacity
        
        _seaterTextFeild.text = arrSeat[selectedIndex];
        _selectedCapacity = [arrSeat[selectedIndex] integerValue];
         [carRegistrationNumberTextField becomeFirstResponder];
        
    }
	
    
   
    //[lastNameTextField resignFirstResponder];
   
    [self moveViewDown];
}

- (void)dismissActionSheet1
{

   [newSheet dismissWithClickedButtonIndex:1 animated:YES];
    if (pickerview.tag == 100) {
        [self findNextResponder:self.activeTextField];
    }
    else {
        [carRegistrationNumberTextField becomeFirstResponder];
    }
    //[lastNameTextField resignFirstResponder];
}


#pragma mark - Done delegate method
-(void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller didClickDone:(UITextField *)textField
{
    if (textField.tag == kTagMobileNumber) {
       
        [self findNextResponder:textField];
        
    }
 
    
}

-(void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller didClickCancel:(UITextField *)textField
{
    if (textField.tag == kTagMobileNumber) {
        
        [self findNextResponder:textField];
        
    }

    
}
#pragma mark - TextFields
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   

    
    self.activeTextField = textField;

//    if (textField.tag == kTagCompneyID) {
//        
//        [self showDatePickerWithTitle:textField];
//        
//        return NO;
//    }
    
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == conPasswordTextField)
    {
        int strength = [self checkPasswordStrength:passwordTextField.text];
        if(strength == 0)
        {

            [passwordTextField becomeFirstResponder];
        }
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == kTagFirstName) {
        _signUpDetails.firstName = textField.text;
    }
    else if (textField.tag == kTagLastName) {
        _signUpDetails.lastName = textField.text;
    }
    else if (textField.tag == kTagEmail) {
        _signUpDetails.email = textField.text;
    }
//    else if (textField.tag == kTagTaxNumber) {
//       // _signUpDetails.taxNumber = textField.text;
//    }
    else if (textField.tag == kTagMobileNumber) {
        _signUpDetails.mobile = textField.text;
    }
    else if (textField.tag == kTagPasscode) {
        _signUpDetails.postCode = textField.text;
    }
    else if (textField.tag == kTagPassword) {
        _signUpDetails.password = textField.text;
    }
    else if(textField.tag == kTagConfirmPassword){
        
        _signUpDetails.confirmPassword = textField.text;
      
    }
//    else if (textField.tag == kTagCompneyID) {
//        
//        _signUpDetails.compneyId = textField.text;
//    }
//    else if (textField.tag == kTagCompneyName) {
//        _signUpDetails.compneyName = textField.text;
//    }
}


- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self findNextResponder:textField];
    return YES;
    
}
-(void)findNextResponder:(UITextField*)textField{
    
    CGPoint pnt = [self.tableView convertPoint:textField.bounds.origin fromView:textField];
    NSIndexPath* path = [self.tableView indexPathForRowAtPoint:pnt];
    
    NSIndexPath *nextIndexPath = [self nextIndexPath:path];
    UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:nextIndexPath];
    
    if (nextCell == nil) {
        [textField resignFirstResponder];
    }
    else {
        
        for(id view in nextCell.contentView.subviews){
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *nextTextField = (UITextField*)view;
                [nextTextField becomeFirstResponder];
            }
        }
    }
}
- (NSIndexPath *) nextIndexPath:(NSIndexPath *) indexPath {
    
    int numOfSections = [self numberOfSectionsInTableView:self.tableView];
    int nextSection = ((indexPath.section + 1) % numOfSections);
    
    if ((indexPath.row +1) == [self tableView:self.tableView numberOfRowsInSection:indexPath.section]) {
        return [NSIndexPath indexPathForRow:0 inSection:nextSection];
    } else {
        return [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
    }
}
- (void)NextButtonClicked
{
   // [self signUp];
     NSDictionary *stripeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"StripeData"];
    if(stripeData.count > 0){
    

    [self sendServiceForGenerateOtp];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message: @"Please Connect Stripe" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([[segue identifier] isEqualToString:@"CardController"])
//    {
//      //  CardLoginViewController *CLVC = [[CardLoginViewController alloc]init];
////        CardLoginViewController *CLVC = (CardLoginViewController*)[segue destinationViewController];
////
////        CLVC.getSignupDetails = saveSignUpDetails;
////        CLVC.pickedImage = _pickedImage;
//        for(int i=0;i< saveSignUpDetails.count;i++)
//            NSLog(@"contents of array %@ ",[saveSignUpDetails objectAtIndex:i]);
//        
//      //  CLVC =[segue destinationViewController];
//        
//    }
//    else if ([[segue identifier] isEqualToString:@"gotoTerms"])
//    {
//        TermsnConditionViewController *TNCVC = (TermsnConditionViewController*)[segue destinationViewController];
//        NSLog(@"enabledTypes %@",TNCVC);
//
//    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [firstNameTextField becomeFirstResponder];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton = NO;
}
-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationItem.titleView  = nil;
}

- (void)cancelButtonClicked
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"StripeData"];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (IBAction)TermsNconButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"gotoTerms" sender:self];
}

- (IBAction)checkButtonClicked:(id)sender
{
    UIButton *mBut = (UIButton *)sender;
    
    if(mBut.isSelected)
    {
        isTnCButtonSelected = NO;
        [mBut setSelected:NO];
        

    }
    else
    {
        isTnCButtonSelected = YES;
        [mBut setSelected:YES];
        
        
    }
}


- (IBAction)checkPopButtonClicked:(id)sender
{
    UIButton *mBut = (UIButton *)sender;
    
    if(mBut.isSelected)
    {
       _signUpDetails.Poplock = @"0";
        [mBut setSelected:NO];
        
        
    }
    else
    {
        _signUpDetails.Poplock = @"1";
        [mBut setSelected:YES];
        
        
    }
}


- (IBAction)profileButtonClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose From Library", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                [self cameraButtonClicked:nil];
                break;
            }
            case 1:
            {
                [self libraryButtonClicked:nil];
                break;
            }
            default:
                break;
        }
    }
}


-(void)cameraButtonClicked:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate =self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message: @"Camera is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}
-(void)libraryButtonClicked:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate =self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = YES;
    // picker.contentSizeForViewInPopover = CGSizeMake(400, 800);
    //    [self presentViewController:picker animated:YES completion:nil];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        
        
        
        //[popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Image Info : %@",info);
    
    _pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSLog(@"pickedImage : %@",_pickedImage);
    
    //  [_signUpPhotoButton setImage:pickedImage forState:UIControlStateNormal];
    
    _profileImage.image = _pickedImage;
    _signUpDetails.profileImage = _pickedImage;
    

    
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


//-(NSURL *) getImagePathWithURL
//{
//    NSString *strPath= [NSString stringWithFormat:@"NexPanama.png"];
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:strPath];
//    NSURL *targetURL = [NSURL fileURLWithPath:path];
//    //    NSData *returnData=[NSData dataWithContentsOfURL:targetURL];
//    //    UIImage *imagemain=[UIImage returnData];
//    return targetURL;
//}

#pragma mark - Password Checking

-(int)checkPasswordStrength:(NSString *)password
{
    unsigned long int  len = password.length;
    //will contains password strength
    int strength = 0;
    
    if (len == 0) {
        [Helper showAlertWithTitle:@"Message" Message:@"Please enter password first"];

        return 0;//PasswordStrengthTypeWeak;
    } else if (len <= 5) {
        strength++;
    } else if (len <= 10) {
        strength += 2;
    } else{
        strength += 3;
    }
    int kp = strength;
    strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_UPPERCASE caseSensitive:YES];
    if (kp >= strength)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Please enter atleast one Uppercase alphabet"];
        return 0;
    }
    else
    {
        kp++;
    }
    strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_LOWERCASE caseSensitive:YES];
    if (kp >= strength)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Please enter atleast one Lowercase alphabet"];
        return 0;
    }
    else
    {
        kp++;
    }
    strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_NUMBER caseSensitive:YES];
    if (kp >= strength) {
        [Helper showAlertWithTitle:@"Message" Message:@"Please enter atleast  one Number"];
       // [passwordTextField becomeFirstResponder];
        return 0;
    }
    return 1;
  //  strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_SYMBOL caseSensitive:YES];
   // if (kp >= strength) {
        //[Helper showAlertWithTitle:@"Message" Message:@"Please enter atleast one special symbol"];
        //[passwordTextField becomeFirstResponder];
       // return 0;
   // }
   
    
//    if(strength <= 3){
//        return PasswordStrengthTypeWeak;
//    }else if(3 < strength && strength < 6){
//        return PasswordStrengthTypeModerate;
//    }else{
//        return PasswordStrengthTypeStrong;
//    }
}

// Validate the input string with the given pattern and
// return the result as a boolean
- (int)validateString:(NSString *)string withPattern:(NSString *)pattern caseSensitive:(BOOL)caseSensitive
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:((caseSensitive) ? 0 : NSRegularExpressionCaseInsensitive) error:&error];
    
    NSAssert(regex, @"Unable to create regular expression");
    
    NSRange textRange = NSMakeRange(0, string.length);
    //NSLog(@"test range %ld",textRange);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];
    
    BOOL didValidate = 0;
    
    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = 1;
   
    return didValidate;
}

#pragma mark - UIKeyBoardNotification Methods
-(void) keyboardWillHide:(NSNotification *)note
{
   // NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:0.1 animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(64, 0, 0, 0);
        [[self tableView] setContentInset:edgeInsets];
        [[self tableView] setScrollIndicatorInsets:edgeInsets];
    }];
    
}
-(void) keyboardWillShow:(NSNotification *)note
{
    CGSize kbSize = CGSizeMake(320, 216);//[[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
   // NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat height = UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]) ? kbSize.height : kbSize.width;
    
    [UIView animateWithDuration:0.1 animations:^{
        UIEdgeInsets edgeInsets = [[self tableView] contentInset];
        edgeInsets.bottom = height;
        [[self tableView] setContentInset:edgeInsets];
        edgeInsets = [[self tableView] scrollIndicatorInsets];
        edgeInsets.bottom = height;
        [[self tableView] setScrollIndicatorInsets:edgeInsets];
    }];    _isKeyboardIsShown = YES;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 2;
    }
    else if(section == 1){
        return 5;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        UIImageView *line=nil;
        if (indexPath.section == 0) {
            line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 50, 260,40)];
        }
        
        else if(indexPath.section == 1){
            
            line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 35, 260, 40)];
        }
        
        cell.backgroundColor=[UIColor clearColor];
        line.image = [UIImage imageNamed:@"login_textbox@2x"];
        line.tag = 200;
        [cell.contentView addSubview:line];
       
    }
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(35, 35, 256, 40)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont fontWithName:Robot_CondensedRegular size:14];
    textField.placeholder = @"";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyNext;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [textField setTintColor:[UIColor whiteColor]];
    [textField setValue:[UIColor whiteColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    
    
    [cell.contentView addSubview:textField];
    

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
         //UIImageView *lineImageView = (UIImageView*)[cell.contentView viewWithTag:200];
        //lineImageView.frame = CGRectMake(100, 49, 220, 1);
            textField.frame = CGRectMake(35, 50, 256, 40);
            textField.text = _signUpDetails.firstName;
            textField.tag = kTagFirstName;
            textField.placeholder = @"First Name";
            textField.textColor =[UIColor blackColor];
            [textField setValue:[UIColor blackColor]
                           forKeyPath:@"_placeholderLabel.textColor"];

        
        }
        if (indexPath.row == 1) {
            
            textField.tag = kTagLastName;
            textField.text = _signUpDetails.lastName;
            textField.placeholder = @"Last Name";
            textField.frame = CGRectMake(35, 50, 256, 40);
            textField.textColor =[UIColor blackColor];
            [textField setValue:[UIColor blackColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
        }
        
    }
    else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            textField.placeholder = @"Email ID";
            textField.text = _signUpDetails.email;
            textField.tag = kTagEmail;
            textField.textColor =[UIColor blackColor];
            [textField setValue:[UIColor blackColor]
                     forKeyPath:@"_placeholderLabel.textColor"];

        }
        if (indexPath.row == 1) {
           
            textField.placeholder = @"Mobile No. (Please enter with country code)";
            textField.tag = kTagMobileNumber;
            textField.text = _signUpDetails.mobile;
            textField.textColor =[UIColor blackColor];
            [textField setValue:[UIColor blackColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
            
            DoneCancelNumberPadToolbar *toolbar = [[DoneCancelNumberPadToolbar alloc] initWithTextField:textField];
            toolbar.delegate = self;
            carRegistrationNumberTextField.inputAccessoryView = toolbar;
            
        }
        if (indexPath.row == 2) {
           
            textField.placeholder = @"Zip code";
            textField.tag = kTagPasscode;
            textField.text = _signUpDetails.postCode;
            textField.textColor =[UIColor blackColor];
            [textField setValue:[UIColor blackColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
        }
//        if (indexPath.row == 3) {
//
//            textField.placeholder = @"COMPANY NAME";
//            textField.tag = kTagCompneyID;
//            textField.text = _signUpDetails.compneyName;
//        }
//        if (indexPath.row == 3) {
//           
//            textField.placeholder = @"Taxi No.";
//            textField.tag = kTagTaxNumber;
//            textField.text = _signUpDetails.taxNumber;
//        }
        if (indexPath.row == 3) {
            
            textField.placeholder = @"Password";
            textField.tag = kTagPassword;
            textField.text = _signUpDetails.password;
            textField.secureTextEntry = YES;
            textField.textColor =[UIColor blackColor];
            [textField setValue:[UIColor blackColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
        }
        if (indexPath.row == 4) {
            
            textField.placeholder = @"Confirm Password";
            textField.tag = kTagConfirmPassword;
            textField.text = _signUpDetails.confirmPassword;
            textField.secureTextEntry = YES;
            textField.returnKeyType = UIReturnKeyDone;
            textField.textColor =[UIColor blackColor];
            [textField setValue:[UIColor blackColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
        }
       

        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


#pragma mark - UITableViewDataSource Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
	[tableViewCell setSelected:NO animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)stripeButtonClicked{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_976GG71vP52gkpAqwg4ZjswqOV5sfOWn&scope=read_write"]];
}
-(void)updateStripeButton{
    NSDictionary *stripeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"StripeData"];
    
    [ stripeConnect setTitle:(stripeData.count > 0)?@"Stripe Connected":@"Stripe Connect" forState:UIControlStateNormal];
}

@end
