//
//  SignUpViewController.h
//  privMD
//
//  Created by Rahul Sharma on 13/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    
    kTagFirstName = 200,
    kTagLastName = 201,
    kTagEmail = 202,
    kTagMobileNumber = 203,
    kTagPasscode = 204,
    kTagTaxNumber = 205,
    kTagCompneyID = 206,
    kTagCompneyName = 207,
    kTagPassword = 208,
    kTagConfirmPassword = 209
    
}SignUpFormTags;

typedef enum {
    PasswordStrengthTypeWeak,
    PasswordStrengthTypeModerate,
    PasswordStrengthTypeStrong
}PasswordStrengthType;

@interface SignUpViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,CLLocationManagerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *array;
    BOOL checkSignupCredentials;
    BOOL isTnCButtonSelected;
    
    NSString *isPopLockstr;
    UIPickerView *pickerview;
    UIActionSheet *newSheet;
    IBOutlet UIView * viewCarType;
    IBOutlet UIView * ViewSeatingCapacity;
    IBOutlet UILabel * lblCarType;
    IBOutlet UILabel * lblSeatingCapacity;
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *conPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNoTextField;
@property (strong, nonatomic) IBOutlet UITextField *carRegistrationNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *licenceNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *carTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *seaterTextFeild;
@property (strong, nonatomic) IBOutlet UIButton *profileButton;
@property (strong, nonatomic) IBOutlet UIButton *btnpracticenorType;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *SeatingCapacityLabel;
@property (strong, nonatomic) IBOutlet UILabel *creatingLabel;
@property (strong, nonatomic) IBOutlet UIButton *tncCheckButton;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;



@property (strong, nonatomic) IBOutlet UIButton *tncButton;

@property(nonatomic, strong) NSMutableArray *helperCountry;
@property(nonatomic, strong) NSMutableArray *helperCity;

@property (strong, nonatomic) UIImage *pickedImage;

@property (strong, nonatomic) NSArray *saveSignUpDetails;
- (IBAction)profileButtonClicked:(id)sender;
- (IBAction)TermsNconButtonClicked:(id)sender;
- (IBAction)checkButtonClicked:(id)sender;
-(IBAction)buttonAction:(id)sender;


@end
