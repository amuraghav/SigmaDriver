//
//  PriveMdAppDelegate.h
//  Doctor
//
//  Created by Rahul Sharma on 17/04/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#define UIAppDelegate \
((AppDelegate *)[UIApplication sharedApplication].delegate)


#import <UIKit/UIKit.h>
#import"Reachability.h"
//#import<CoreData/CoreData.h>
#import<GoogleMaps/GoogleMaps.h>
#import <AudioToolbox/AudioToolbox.h>

@interface PriveMdAppDelegate : UIResponder <UIApplicationDelegate>
{
/*@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;*/
    
}

@property (strong, nonatomic) UIWindow *window;
/*@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;*/
@property (nonatomic, readonly) int networkStatus;

@property(nonatomic,assign) BOOL isNewBooking;

@property(nonatomic)NSInteger sectionIndex;
@property(nonatomic)SystemSoundID	pewPewSoundIncoming;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

/**
 *  Check for network Connection
 *
 *  @return Yes if network is available
 */
- (BOOL)isNetworkAvailable;

/*!
 *  listen to channel from server to receive booking and driver status
 */
-(void)subscribeToPubnubChannel;

/*!
 *  checks the driver status if its online or offline
 */
-(void)checkDriverStatus;



@end
