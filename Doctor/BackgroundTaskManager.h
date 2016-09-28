//
//  BackgroundTaskManager.h
//
//  Created by Surender Rathore
//  Copyright (c) 2013 Surender Rathore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundTaskManager : NSObject

+(instancetype)sharedBackgroundTaskManager;

-(UIBackgroundTaskIdentifier)beginNewBackgroundTask;

@end
