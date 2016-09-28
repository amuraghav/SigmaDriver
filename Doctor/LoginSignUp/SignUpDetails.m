//
//  SignUpDetails.m
//  Roadyo
//
//  Created by Surender Rathore on 03/07/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "SignUpDetails.h"

@implementation SignUpDetails
@synthesize firstName;
@synthesize lastName;
@synthesize email;
@synthesize password;
@synthesize confirmPassword;
@synthesize mobile;
@synthesize postCode;
@synthesize compneyId;
@synthesize compneyName;
@synthesize otherCompneyName;
@synthesize taxNumber;
@synthesize profileImage;
@synthesize Poplock;



static SignUpDetails  *signupdetails;

+ (id)sharedInstance {
	if (!signupdetails) {
		signupdetails  = [[self alloc] init];
	}
	
	return signupdetails;
}

-(void)clear {
    self.firstName = @"";
    self.lastName = @"";
    self.email = @"";
    self.password = @"";
    self.mobile = @"";
    self.postCode = @"";
    self.compneyId = @"";
    self.compneyName = @"";
    self.otherCompneyName = @"";
    self.taxNumber = @"";
    self.profileImage = nil;
    self.confirmPassword = @"";
    self.Poplock=@"";
}

@end
