//
//  ResetPwdViewController.m
//  CarApp
//
//  Created by Appypie Inc on 12/04/16.
//  Copyright © 2016 ons. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "XDKAirMenuController.h"
#import "CustomNavigationBar.h"

@interface ResetPwdViewController ()  <CustomNavigationBarDelegate>


@end

@implementation ResetPwdViewController
@synthesize OldpasswordTextField,NewpasswordTextField,ConfirmpasswordTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_Color;
    [self addCustomNavigationBar];
}

#pragma mark Custom Methods -

- (void) addCustomNavigationBar{
    
    
    
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"RESET PASSWORD"];
    [customNavigationBarView setBackgroundColor:NavBarTint_Color];
    [self.view addSubview:customNavigationBarView];
    
    
    [OldpasswordTextField setValue:[UIColor blackColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [NewpasswordTextField setValue:[UIColor blackColor]
     
                     forKeyPath:@"_placeholderLabel.textColor"];
    [ConfirmpasswordTextField setValue:[UIColor blackColor]
                   forKeyPath:@"_placeholderLabel.textColor"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
}
-(void)leftBarButtonClicked:(UIButton *)sender{
    [self menuButtonPressedAccount];
}

- (void)menuButtonPressedAccount
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}

-(void)dismissKeyboard
{
    [OldpasswordTextField resignFirstResponder];
    [NewpasswordTextField resignFirstResponder];
    [ConfirmpasswordTextField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)resetPassworduser
{
    
    
    NSString *Oldpassword = OldpasswordTextField.text;
    NSString *newpasswordT = NewpasswordTextField.text;
    NSString *confirmpassword = ConfirmpasswordTextField.text;
    
    if((unsigned long)Oldpassword.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Please Enter  Old Password"];
        [OldpasswordTextField becomeFirstResponder];
    }
    else if((unsigned long)newpasswordT.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Password"];
        [NewpasswordTextField becomeFirstResponder];
    }
    else if((unsigned long)confirmpassword.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Confirm Password"];
        [ConfirmpasswordTextField becomeFirstResponder];
    }
    else if ([newpasswordT isEqualToString:confirmpassword] == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Password Mismatched"];
        
    }

    else
    {
        [self.view endEditing:YES];
        [self retrievePassword];
        
    }
    
}



-(IBAction)resetpassword_Action:(id)sender;
{
    [self resetPassworduser];
}



- (void)retrievePassword
{
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Loading.."];
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    
    
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
    
    
    
    
    
    NSString *parameters = [NSString stringWithFormat:@"ent_user_type=%@&ent_old_password=%@&ent_password=%@&ent_sess_token=%@&ent_dev_id=%@",@"1", OldpasswordTextField.text,NewpasswordTextField.text,[[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken],[[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey]];
    
   
    
    NSString *removeSpaceFromParameter=[Helper removeWhiteSpaceFromURL:parameters];
    NSLog(@"request doctor around you :%@",parameters);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@changePassword",BASE_URL]];
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
            OldpasswordTextField.text=@"";
            NewpasswordTextField.text =@"";
            ConfirmpasswordTextField.text =@"";
           [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
        }
        else
        {
             OldpasswordTextField.text=@"";
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
        }
    }
}














/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
