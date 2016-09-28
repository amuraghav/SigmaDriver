//
//  ResetPwdViewController.h
//  CarApp
//
//  Created by Appypie Inc on 12/04/16.
//  Copyright © 2016 ons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPwdViewController : UIViewController
{
    
}

@property (strong, nonatomic) IBOutlet UITextField *OldpasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *NewpasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *ConfirmpasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *resetPasswordButton;


-(IBAction)resetpassword_Action:(id)sender;

@end
