//
//  OPTVerificationVC.h
//  CarApp
//
//  Created by Appypie Inc on 21/07/16.
//  Copyright © 2016 ons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpDetails.h"
#import "UploadFiles.h"


@interface OPTVerificationVC : UIViewController<UploadFileDelegate>
{
    UIImage *_pickedImage;
    
   IBOutlet UITextField *OtpTextfield;
}

-(IBAction)btnPressed:(id)sender;

@property(nonatomic,strong)SignUpDetails *signUpDetails;

@end
