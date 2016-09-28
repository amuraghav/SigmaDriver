//
//  SignInViewController.h
//  privMD
//
//  Created by Rahul Sharma on 13/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
    NSDictionary *itemList;
    BOOL checkLoginCredentials;
    NSString *emailstr;
    
}
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *caridTextField;

@property (strong, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (strong, nonatomic) IBOutlet UIView *containEmailnPass;
@property (weak, nonatomic) IBOutlet UILabel *fNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;

@property (strong, nonatomic)  UIButton *navDoneButton;
@property (strong, nonatomic)  UIButton *navCancelButton;
@property (strong, nonatomic) UIImageView *emailImageView;

- (IBAction)forgotPasswordButtonClicked:(id)sender;
- (IBAction)signInButtonClicked:(id)sender;


@end
