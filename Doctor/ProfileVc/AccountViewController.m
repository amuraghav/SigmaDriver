//
//  AccountViewController.m
//  privMD
//
//  Created by Rahul Sharma on 19/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "AccountViewController.h"
#import "XDKAirMenuController.h"
//#import "RoadyoPubNubWrapper.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "ANBlurredImageView.h"
#import "CustomNavigationBar.h"
#import "SplashViewController.h"
#import "profile.h"
#import "HomeViewController.h"


@interface AccountViewController () <CustomNavigationBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong) IBOutlet ANBlurredImageView *imageView;
@property(nonatomic,strong)profile *user;
@property(nonatomic,weak) IBOutlet UITableView *tableView;
@property(nonatomic,strong) UIImageView *profileImage;
@property(nonatomic,strong) UIImage *pickedImage;
@property(nonatomic,assign)BOOL isEditingModeOn;
@end




@implementation AccountViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - ViewController LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // self.view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
     UIView *view = [[UIView alloc] initWithFrame:CGRectMake(3, 32, 75, 75)];
   
    _profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 66, 66)];
    _profileImage.image = [UIImage imageNamed:@"signup_profile_image"];
     [view addSubview:_profileImage];
     UIButton *buttonSelectPicture = [UIButton buttonWithType:UIButtonTypeCustom];
     buttonSelectPicture.frame = CGRectMake(0, 0, 75, 75);
     [buttonSelectPicture addTarget:self action:@selector(profilePicButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
     PriveMdAppDelegate *appDelegate = (PriveMdAppDelegate *)[[UIApplication sharedApplication] delegate];
     NSLog(@"%ld",appDelegate.sectionIndex);
    
    switch (appDelegate.sectionIndex) {
        case 0:
            NSLog(@"Button Tag is : %li",(long)appDelegate.sectionIndex);
            
            noOfrowSection0=6;
            noOfrowSection1=0;
            noOfrowSection2=0;
           
            [view addSubview:buttonSelectPicture];
            break;
        case 1:
            NSLog(@"Button Tag is : %li",(long)appDelegate.sectionIndex);
            noOfrowSection0=0;
            noOfrowSection1=6;
            noOfrowSection2=0;
            
            break;
        case 2:
            NSLog(@"Button Tag is : %li",(long)appDelegate.sectionIndex);
            
            noOfrowSection0=0;
            noOfrowSection1=0;
            noOfrowSection2=7;
            
            break;
        default:
            NSLog(@"Default Message here");
            break;
    }

    self.navigationController.navigationBarHidden = YES;
    _tableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    // ProfileImageView
    [self.tableView addSubview:view];
    [self addCustomNavigationBar];
    [self sendServiceForegetProfileData];
    [[TELogger getInstance] initiateFileLogging];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    
}
-(void)viewDidDisappear:(BOOL)animated
{
   //self.navigationController.navigationBarHidden = YES;
}


#pragma mark - WebService call
-(void)sendServiceForUpdateProfile
{
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Saving.."];
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
   
    NSString *fName = _user.fName;
    NSString *lName = _user.lName;
    NSString *eMail = _user.email;
    NSString *phone = _user.mobile;

    NSString *parameters = [NSString stringWithFormat:@"ent_sess_token=%@&ent_dev_id=%@&ent_first_name=%@&ent_last_name=%@&ent_email=%@&ent_phone=%@&ent_date_time=%@",[[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken],deviceId,fName,lName,eMail,phone,[Helper getCurrentDateTime]];
    
    NSString *removeSpaceFromParameter = [Helper removeWhiteSpaceFromURL:parameters];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@updateProfile",BASE_URL]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                             dataUsingEncoding:NSUTF8StringEncoding
                             allowLossyConversion:YES]];
    
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(updateProfileResponse:)];
    
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
            [[NSUserDefaults standardUserDefaults] setObject:_user.fName forKey:KDAFirstName];
            [[NSUserDefaults standardUserDefaults] setObject:_user.lName forKey:KDALastName];
            [[NSUserDefaults standardUserDefaults] setObject:_user.email forKey:KDAEmail];
            [[NSUserDefaults standardUserDefaults] setObject:_user.mobile forKey:KDAPhoneNo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    }
    
}

-(void)sendServiceForegetProfileData
{
    
  
    ResKitWebService * restkit = [ResKitWebService sharedInstance];
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                   [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken],KDAcheckUserSessionToken,
                   [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],kSMPCommonDevideId,
                   [Helper getCurrentDateTime],kSMPCommonUpDateTime, nil];
    
    TELogInfo(@"param%@",queryParams);
    [restkit composeRequestForProfile:MethodGetMasterProfile
                             paramas:queryParams
                        onComplition:^(BOOL success, NSDictionary *response){
                            
                            if (success) { //handle success response
                                
                                //TELogInfo(@"info%@",response);
                                [self getProfileResponse:(NSArray*)response];
                            }
                            else{//error
                                
                            }
                        }];

    }

-(void)getProfileResponse:(NSArray *)response
{
    
    Errorhandler * handler = [response objectAtIndex:0];
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    
    if ([[handler errFlag] intValue] ==0) {

        _user = handler.objects;
        [_tableView reloadData];
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",baseUrlForXXHDPIImage,_user.pPic];
        [_profileImage setImageWithURL:[NSURL URLWithString:strImageUrl]
                    placeholderImage:[UIImage imageNamed:@"signup_profile_image"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                           }];

     }
    else if ([[handler errFlag] intValue] == 1)
    {
        [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
        
    }

    else{
        [Helper showAlertWithTitle:@"Message" Message:handler.errMsg];
    }


}



-(void)dismissKeyboard
{
    //[resignFirstResponder];
    //[passwordloginText resignFirstResponder];
    
    [self.view endEditing:YES];
    
    
}
//#pragma mark ButtonAction Methods -
//
//- (void)menuButtonPressedAccount
//{
//    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
//    
//    if (menu.isMenuOpened)
//        [menu closeMenuAnimated];
//    else
//        [menu openMenuAnimated];
//}


- (void)setSelectedButtonByIndex:(NSInteger)index {
    
 
}
#pragma mark Custom Methods -



- (void) addCustomNavigationBar
{
    UIView *customNavigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
  
   
    
    [customNavigationBarView setBackgroundColor:NavBarTint_Color];
    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    
    
    
    
  
    
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setFrame:CGRectMake(0.0f,10.0f,buttonImage.size.width,buttonImage.size.height)];
    
    [Helper setButton:cancelButton Text:@"BACK" WithFont:Robot_Regular FSize:11 TitleColor:[UIColor blueColor] ShadowColor:nil];
    [cancelButton setTitle:@"BACK" forState:UIControlStateNormal];
    [cancelButton setTitle:@"BACK" forState:UIControlStateSelected];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont fontWithName:Robot_Regular size:11];
    
    
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 64)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    
    PriveMdAppDelegate *appDelegate = (PriveMdAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%ld",appDelegate.sectionIndex);
    
    NSString *titleStr=@"";
    
    switch (appDelegate.sectionIndex) {
        case 0:
            NSLog(@"Button Tag is : %li",(long)appDelegate.sectionIndex);
          titleStr=@"DRIVER DETAILS";
            
            break;
        case 1:
            NSLog(@"Button Tag is : %li",(long)appDelegate.sectionIndex);
            titleStr=@"CAR DETAILS";

            
            break;
        case 2:
            NSLog(@"Button Tag is : %li",(long)appDelegate.sectionIndex);
           
            titleStr=@"STATISTICS";

            break;
        default:
            NSLog(@"Default Message here");
            break;
    }

    
    [Helper setToLabel:titleLable Text:titleStr WithFont:Robot_Regular FSize:15 Color:[UIColor whiteColor]];
    [customNavigationBarView addSubview:titleLable];
    
    [customNavigationBarView addSubview:cancelButton];
    
  
    

    [self.view addSubview:customNavigationBarView];
    
}

-(void)cancelButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)rightBarButtonClicked:(UIButton *)sender{
//    
//    if ([sender tag] == 200) {
//        _isEditingModeOn = NO;
//        sender.tag = 100;
//        
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        [self sendServiceForUpdateProfile];
//        
//    }
//    else{
//        _isEditingModeOn = YES;
//        sender.tag = 200;
//        [sender setTitle:@"Update" forState:UIControlStateNormal];
//    }
//    
//}
//-(void)leftBarButtonClicked:(UIButton *)sender{
//    _isEditingModeOn = YES;
//    sender.tag = 200;
//    [sender setTitle:@"Update" forState:UIControlStateNormal];
//    [self menuButtonPressedAccount];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //SplashViewController *SVC = [segue destinationViewController];

 
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KDAcheckUserSessionToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
 

}
- (IBAction)profilePicButtonClicked:(id)sender
{
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Edit Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose From Library", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

- (IBAction)passwordButtonClicked:(id)sender
{
    [Helper showAlertWithTitle:@"Message" Message:@"Please visit our website appypie.com to change your password."];

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
    
    [picker.navigationBar setBackgroundColor:VIEW_Color];

      if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        
        
        
        //[popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator showPIOnView:self.view withMessage:@"Uploading Profile Pic..."];
    //  _flagCheckSnap = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Image Info : %@",info);
    
    _pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    UploadFiles *upload = [[UploadFiles alloc] init];
    upload.delegate = self;
    [upload uploadImageFile:_pickedImage];
    
    
}

#pragma UploadFileDelegate

-(void)uploadFile:(UploadFiles *)uploadfile didUploadSuccessfullyWithUrl:(NSArray *)imageUrls
{
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    _profileImage.image = _pickedImage;
   
}
-(void)uploadFile:(UploadFiles *)uploadfile didFailedWithError:(NSError *)error{
    NSLog(@"upload file  error %@",[error localizedDescription]);
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
}


#pragma mark - UITextFeildDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_isEditingModeOn) {
        if (textField.tag >= 200 && textField.tag < 204) {
            return YES;
        }
        return NO;
    }
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 200) {
        _user.fName = textField.text;
    }
    else if (textField.tag == 201) {
        _user.lName = textField.text;
        
    }
    else if (textField.tag == 202) {
        _user.email = textField.text;
    }
    else if (textField.tag == 203) {
        _user.mobile = textField.text;
    }
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
-(void)moveViewUpToPoint:(int)point
{
    CGRect rect = self.view.frame;
    rect.origin.y = point;
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         self.view.frame = rect;
                     }
                     completion:^(BOOL finished){
                     }];
    
    
    
}

-(void)moveViewDown
{
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    
    
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         self.view.frame = rect;
                     }
                     completion:^(BOOL finished){
                     }];
    
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return noOfrowSection0;
    }
    else if(section == 1){
        return noOfrowSection1;
    }
    else if (section == 2){
        return noOfrowSection2;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
        line.image = [UIImage imageNamed:@"signup_bg_namedetails_divider"];
        line.tag = 200;
        [cell.contentView addSubview:line];
        
    }
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(105, 5, 200, 30)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont fontWithName:Robot_CondensedRegular size:15];
    //textField.placeholder = @"enter text";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [textField setTintColor:[UIColor blueColor]];
    [cell.contentView addSubview:textField];
    
    
    
    UILabel *labelHelperText = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 30)];
    [Helper setToLabel:labelHelperText Text:@"" WithFont:Robot_CondensedLight FSize:13 Color:BLACK_COLOR];
    [cell.contentView addSubview:labelHelperText];
    
    
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            UIImageView *lineImageView = (UIImageView*)[cell.contentView viewWithTag:200];
            lineImageView.frame = CGRectMake(100, 39, 220, 1);
            textField.text = _user.fName;
            textField.tag = 200;
        }
        if (indexPath.row == 1) {
            
           
           textField.tag = 201;
            textField.text = _user.lName;
        }
        if (indexPath.row == 2) {
            
            textField.tag = 202;
            labelHelperText.text = @"Email:";
            textField.text = _user.email;
            
        }
        if (indexPath.row == 3) {
            
            textField.tag = 203;
            labelHelperText.text = @"Mobile:";
            textField.text = _user.mobile;
        }
        if (indexPath.row == 4) {
            
            labelHelperText.text = @"Driver Licence:";
            textField.text = _user.licNo;
        }
        if (indexPath.row == 5) {
            labelHelperText.text = @"Expiry Date:";
            textField.text = _user.licExp;
        }
    }
    else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            labelHelperText.text = @"Car Make:";
            textField.text = _user.vehMake;
        }
        if (indexPath.row == 1) {
            labelHelperText.text = @"Car Type:";
            
            textField.text = _user.vehicleType;
        }
        if (indexPath.row == 2) {
            labelHelperText.text = @"Seating Capacity:";
           
            textField.text = _user.seatCapacity;
        }
        if (indexPath.row == 3) {
            labelHelperText.text = @"Licance Plate:";
            textField.text = _user.licPlateNum;
        }
        if (indexPath.row == 4) {
            labelHelperText.text = @"Insurance";
            textField.text = _user.vehicleInsuranceNum;
        }
        if (indexPath.row == 5) {
            labelHelperText.text = @"Expiry Date:";
            textField.text = _user.vehicleInsuranceExp;
        }
        
    }
    else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            labelHelperText.text = @"Total Earning:";
            textField.text = [NSString stringWithFormat:@"$%@",_user.totalAmt] ;
        }
        if (indexPath.row == 1) {
            labelHelperText.text = @"Month's Earning:";
            
            textField.text = [NSString stringWithFormat:@"$%@",_user.monthAmt] ;
        }
        if (indexPath.row == 2) {
            labelHelperText.text = @"Week's Earning:";
            
            textField.text = [NSString stringWithFormat:@"$%@",_user.weekAmt] ;
        }
        if (indexPath.row == 3) {
            labelHelperText.text = @"Today's Earning:";
            textField.text = [NSString stringWithFormat:@"$%@",_user.todayAmt] ;
        }
        if (indexPath.row == 4) {
            labelHelperText.text = @"Last Bill:";
            textField.text = [NSString stringWithFormat:@"$%@",_user.lastBilledAmt] ;
        }
        if (indexPath.row == 5) {
            labelHelperText.text = @"Total Bookings:";
            textField.text = _user.cmpltApts;
        }
        if (indexPath.row == 6) {
            labelHelperText.text = @"Rating:";
            textField.text = _user.avgRate;
        }

        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}



#pragma mark - UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
	[tableViewCell setSelected:NO animated:YES];
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7.5, 15, 15)];
    
    [headerView addSubview:icon];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 200, 30)];
    [Helper setToLabel:labelTitle Text:@"" WithFont:Robot_Regular FSize:13 Color:BLACK_COLOR];
    [headerView addSubview:labelTitle];
    
    if (section == 0) {
        
        if (noOfrowSection0 != 0) {
            icon.image = [UIImage imageNamed:@"Car_profile.png"];
           labelTitle.textColor=[UIColor  colorWithRed:36.0/255.0 green:195.0/255.0 blue:155.0/255.0 alpha:1];
            
        }else{
            
        }
        
       
    }
    else if(section == 1){
        
         if (noOfrowSection1 != 0) {
        _profileImage.image = [UIImage imageNamed:@""];
        icon.image = [UIImage imageNamed:@"Driver@2x.png"];
         labelTitle.textColor=[UIColor colorWithRed:36.0/255.0 green:195.0/255.0 blue:155.0/255.0 alpha:1];
         }else{
             
         }
    }
    else if(section == 2){
        
        if (noOfrowSection2 != 0) {
        _profileImage.image = [UIImage imageNamed:@""];
        icon.image = [UIImage imageNamed:@"statistics@2x.png"];
         labelTitle.textColor=[UIColor colorWithRed:36.0/255.0 green:195.0/255.0 blue:155.0/255.0 alpha:1];
        }else{
            
        }
    }
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

@end
