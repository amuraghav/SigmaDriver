//
//  AccountViewController.h
//  privMD
//
//  Created by Rahul Sharma on 19/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadFiles.h"
#import "RoundedImageView.h"


@interface AccountViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UploadFileDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    BOOL textFieldEditedFlag;
    NSInteger noOfrowSection0;
    NSInteger noOfrowSection1;
    NSInteger noOfrowSection2;
}



//- (IBAction)logoutButtonClicked:(id)sender;
- (IBAction)profilePicButtonClicked:(id)sender;
- (IBAction)passwordButtonClicked:(id)sender;


@end
