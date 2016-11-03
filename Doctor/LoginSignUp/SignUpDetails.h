//
//  SignUpDetails.h
//  Roadyo
//
//  Created by Surender Rathore on 03/07/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUpDetails : NSObject
@property(nonatomic,strong)NSString *firstName;
@property(nonatomic,strong)NSString *lastName;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *confirmPassword;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *postCode;
@property(nonatomic,strong)NSString *compneyId;
@property(nonatomic,strong)NSString *compneyName;
@property(nonatomic,strong)NSString *otherCompneyName;
@property(nonatomic,strong)NSString *taxNumber;
@property(nonatomic,strong)UIImage *profileImage;
@property(nonatomic,strong)NSString *Poplock;
@property (nonatomic,strong)NSString *driverFeature;

+ (id)sharedInstance;
-(void)clear;
@end
