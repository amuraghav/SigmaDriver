//
//  TELogger.h
//
//
//  Created by Vinay Raja on 27/04/13.
//  Copyright (c) 2014 3Embed Software Tech Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TELogInfo(frmt, ...) [[TELogger getInstance] logInfo:frmt,##__VA_ARGS__];
#define TELogVerbose(frmt, ...) [[TELogger getInstance] logVerbose:frmt,##__VA_ARGS__];
#define TELogDetail(frmt, ...) [[TELogger getInstance] logDetail:frmt,##__VA_ARGS__];
#define TELogError(frmt, ...) [[TELogger getInstance] logError:frmt,##__VA_ARGS__];

//
// Log levels
//
typedef  enum {
    LogLevelError,
    LogLevelInfo,
    LogLevelVerbose,
    LogLevelDetail
} TELogLevel;


@class DDFileLogger;

@interface TELogger : NSObject
{

@private
    DDFileLogger* _fileLogger;

}


- (NSArray *)loggedFilePaths;
- (void) initiateFileLogging;
- (void) updateFileLoggerLevel:(int) logLevel;

+ (TELogger *) getInstance;

-(void) logInfo:(NSString *) msg,...;
-(void) logVerbose:(NSString *) msg,...;
-(void) logDetail:(NSString *) msg,...;
-(void) logError:(NSString *) msg,...;


@end