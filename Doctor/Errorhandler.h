//
//  Errorhandler.h
//  Roadyo
//
//  Created by Rahul Sharma on 01/05/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Errorhandler : NSObject
@property(strong,nonatomic)NSString *errNum;
@property(strong,nonatomic)NSString *errFlag;
@property(strong,nonatomic)NSString *errMsg;
@property(strong,nonatomic)NSString *test;
@property(strong,nonatomic)id objects;

-(void)description;
@end
