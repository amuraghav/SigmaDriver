//
//  Login.h
//  Roadyo
//
//  Created by Rahul Sharma on 05/05/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Login : NSObject
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *expiryLocal;
@property (nonatomic, strong) NSString *expiryGMT;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *joined;
@property (nonatomic, strong) NSString *chn;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *mFlg;
@property (nonatomic, strong) NSString *susbChn;
@property (nonatomic, strong) NSString *listner;

@property (nonatomic, strong) NSDictionary *status;
@property (nonatomic, strong) NSString *car_type_name;

@end
