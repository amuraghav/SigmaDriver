//
//  PatientPubNubWrapper.h
//  privMD
//
//  Created by Vinay Raja on 08/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNDelegate.h"
#import "PNConfiguration.h"

@protocol PatientPubNubWrapperDelegate <NSObject>

@required
-(void)recievedMessage:(NSDictionary*)messageDict onChannel:(NSString*)channelName;
-(void)didFailedToConnectPubNub:(NSError*)error;

@end

@interface PatientPubNubWrapper : NSObject <PNDelegate>

@property (nonatomic, assign) id<PatientPubNubWrapperDelegate> delegate;

+(instancetype) sharedInstance;

-(void)setConfiguration:(PNConfiguration*)configuration;

-(void)connect;

-(void)subscribeOnChannels:(NSArray*)pnChannelNames;

-(void)unSubscribeOnChannel:(NSString*)pnChannel;

-(void)sendMessageAsDictionary:(NSDictionary*)messageDictionary toChannel:(NSString*)channelName;

-(void)sendMessage:(NSString*)message toChannel:(NSString*)channelName;

@end
