//
//  User.h
//  privMD
//
//  Created by Surender Rathore on 19/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserDelegate;
@interface User : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)UIImage *blurredImage;
@property(nonatomic,strong)UIImage *profileImage;
@property(nonatomic,weak)id <UserDelegate> delegate;

+ (id)sharedInstance;
- (void)logout;
@end

@protocol UserDelegate <NSObject>
-(void)userDidLogoutSucessfully:(BOOL)sucess;
@optional
-(void)userDidFailedToLogout:(NSError*)error;
@end