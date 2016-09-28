//
//  TELogFormatter.h
//
//
//  Created by Vinay Raja on 27/04/13.
//  Copyright (c) 2014 3Embed Software Tech Pvt. Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

//Set the logging level only at one place

#ifdef CONFIGURATION_DEBUG
#define AS_LOG_LEVEL LOG_LEVEL_VERBOSE
#else
#define AS_LOG_LEVEL LOG_LEVEL_INFO
#endif

extern int ddLogLevel;

@interface TELogFormatter : NSObject <DDLogFormatter>
{
	NSDateFormatter *dateFormatter;
}

+(void) changeLogLevelTo:(int)cllt;

@end
