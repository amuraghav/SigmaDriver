//
//  TELogFormatter.m
//
//
//  Created by Vinay Raja on 27/04/13.
//  Copyright (c) 2014 3Embed Software Tech Pvt. Ltd. All rights reserved.
//


#import "TELogFormatter.h"

int ddLogLevel = AS_LOG_LEVEL;

// Should be able to configure it from setting properties

@implementation TELogFormatter

+ (int)ddLogLevel
{
    return ddLogLevel;
}

+ (void)ddSetLogLevel:(int)logLevel
{
    ddLogLevel = logLevel;
}


+(void) changeLogLevelTo:(int)cllt
{
    ddLogLevel=cllt;
}

- (id)init
{
    if((self = [super init]))
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
    }
    return self;
}


- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
	
	NSString *dateAndTime = [dateFormatter stringFromDate:(logMessage->timestamp)];
	NSString *fileName = [logMessage fileName];
	NSString *methodName = [logMessage methodName];
	NSString *threadId = [logMessage threadID];
	unsigned int lineNo = logMessage->lineNumber;
	
	NSString *logLevel;
	switch (logMessage->logFlag)
	{
		case LOG_FLAG_ERROR : logLevel = @"Error"; break;
		case LOG_FLAG_WARN  : logLevel = @"Warning"; break;
		case LOG_FLAG_INFO  : logLevel = @"Info"; break;
        case LOG_FLAG_DEBUG  : logLevel = @"Detail"; break;
		default             : logLevel = @"Verbose"; break;
	}
	
	NSString *logMsg = logMessage->logMsg;
	
	return [NSString stringWithFormat:@"%@|%@|%@[%@]|%d<%@>: %@", dateAndTime, fileName, methodName, threadId, lineNo, logLevel, logMsg];
}


@end
