//
//  SignUp.h
//  Roadyo
//
//  Created by Rahul Sharma on 05/05/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUp : NSObject
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *expiryLocal;
@property (nonatomic, strong) NSString *expiryGMT;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *joined;
@property (nonatomic, strong) NSString *chn;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *mFlg;

@end
