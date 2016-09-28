//
//  Errorhandler.m
//  Roadyo
//
//  Created by Rahul Sharma on 01/05/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "Errorhandler.h"

@implementation Errorhandler
@synthesize errFlag;
@synthesize errMsg;
@synthesize errNum;
@synthesize test;
@synthesize objects;


-(void)description{
    
    TELogInfo(@"descritpin : errNum:%@ , errFlag : %@ , errMsg : %@",errNum,errFlag,errMsg);
}
@end
