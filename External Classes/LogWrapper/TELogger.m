//
//  TELogger.m
//
//
//  Created by Vinay Raja on 27/04/13.
//  Copyright (c) 2014 3Embed Software Tech Pvt. Ltd. All rights reserved.
//

#import "TELogger.h"
#import "TELogFormatter.h"
#import "DDFileLogger.h"

static TELogger *sharedInstance = nil;

@interface TELogger()

@property(nonatomic, strong) DDFileLogger* fileLogger;

@end

@implementation TELogger

@synthesize fileLogger = _fileLogger;


+ (TELogger *) getInstance
{
    if(sharedInstance != nil)
        return sharedInstance;
    
    @synchronized([TELogger class]){
        if(sharedInstance == nil)
        {
            sharedInstance = [[TELogger alloc] init];
        }
    }
    return sharedInstance;
}


/*
 * To dynamically control the file loggeer log level based  on diagnostic setting
 */
- (void)updateFileLoggerLevel:(int) logLevel
{
    [DDLog setLogLevel:LOG_LEVEL_INFO forClassWithName:@"TELogFormatter"]; // disabling other log levels for production
    return;
    
    if(logLevel == LogLevelInfo)
    {
        [DDLog setLogLevel:LOG_LEVEL_INFO forClassWithName:@"TELogFormatter"];
    }
    else if(logLevel == LogLevelVerbose)
    {
        [DDLog setLogLevel:LOG_LEVEL_VERBOSE forClassWithName:@"TELogFormatter"];
    }
    else if(logLevel == LogLevelDetail)
    {
        [DDLog setLogLevel:LOG_FLAG_DEBUG forClassWithName:@"TELogFormatter"];
    }
    else
    {
        [DDLog setLogLevel:LOG_LEVEL_ERROR forClassWithName:@"TELogFormatter"];
    }
}


- (void)initiateFileLogging
{
    
//#ifdef CONFIGURATION_DEBUG
	
    //[DDLog addLogger:[DDTTYLogger sharedInstance]];
	//TELogFormatter *ddttyLoggerFormatter = [[TELogFormatter alloc] init];
	//[[DDTTYLogger sharedInstance] setLogFormatter:ddttyLoggerFormatter];
	
 	[DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    TELogFormatter *ddaslLoggerFormatter = [[TELogFormatter alloc] init];
	[[DDASLLogger sharedInstance] setLogFormatter:ddaslLoggerFormatter];
    [[DDTTYLogger sharedInstance] setLogFormatter:ddaslLoggerFormatter];
    
//#endif
    
	if (self.fileLogger == nil) {
        
        DDFileLogger *tmpFileLogger = [[DDFileLogger alloc] init];
		self.fileLogger = tmpFileLogger;
		[DDLog addLogger:self.fileLogger];
        
		TELogFormatter *fileLoggerFormatter = [[TELogFormatter alloc] init];
		[self.fileLogger setLogFormatter:fileLoggerFormatter];
        
        
        //Dynamic loggging support added to configure the loglevel @ run time.
        [self updateFileLoggerLevel:LogLevelError];
	}
}

- (NSArray *)loggedFilePaths
{
	NSArray *filePaths =  [[[self fileLogger] logFileManager] sortedLogFilePaths] ;
	return filePaths;
}

-(void)logInfo:(NSString *) msg,...
{
    va_list args;
    va_start(args, msg);
    NSString *logMsg = [[NSString alloc] initWithFormat:msg arguments:args];
    DDLogInfo(@"%@",logMsg);
    va_end(args);
    
}

-(void) logVerbose:(NSString *) msg,...
{
    va_list args;
    va_start(args, msg);
    NSString *logMsg = [[NSString alloc] initWithFormat:msg arguments:args];
    DDLogVerbose(@"%@",logMsg);
    va_end(args);
}

-(void) logDetail:(NSString *) msg,...
{
    va_list args;
    va_start(args, msg);
    NSString *logMsg = [[NSString alloc] initWithFormat:msg arguments:args];
    DDLogDebug(@"%@",logMsg);
    va_end(args);
}

-(void) logError:(NSString *) msg,...
{
    va_list args;
    va_start(args, msg);
    NSString *logMsg = [[NSString alloc] initWithFormat:msg arguments:args];
    DDLogError(@"%@",logMsg);
    va_end(args);
    
}



@end
