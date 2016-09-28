//
//  AppointedDoctor.m
//  privMD
//
//  Created by Surender Rathore on 26/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "AppointedDoctor.h"

@implementation AppointedDoctor
@synthesize doctorName;
@synthesize appoinmentDate;
@synthesize contactNumber;
@synthesize profilePicURL;
@synthesize distance;
@synthesize estimatedTime;
@synthesize email;
@synthesize status;



- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init])
    {
        self.doctorName = [aDecoder decodeObjectForKey:@"doctorName"];
        self.appoinmentDate = [aDecoder decodeObjectForKey:@"appoinmentDate"];
        self.contactNumber = [aDecoder decodeObjectForKey:@"contactNumber"];
        self.profilePicURL = [aDecoder decodeObjectForKey:@"picUrl"];
        self.distance = [aDecoder decodeObjectForKey:@"distance"];
        self.estimatedTime = [aDecoder decodeObjectForKey:@"estimatedTime"];
        self.email = [aDecoder decodeObjectForKey:@"emai"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:doctorName forKey:@"doctorName"];
    [aCoder encodeObject:appoinmentDate forKey:@"appoinmentDate"];
    [aCoder encodeObject:contactNumber forKey:@"contactNumber"];
    [aCoder encodeObject:profilePicURL forKey:@"picUrl"];
    [aCoder encodeObject:distance forKey:@"distance"];
    [aCoder encodeObject:estimatedTime forKey:@"estimatedTime"];
    [aCoder encodeObject:email forKey:@"emai"];
    [aCoder encodeObject:status forKey:@"status"];
    

}


@end
