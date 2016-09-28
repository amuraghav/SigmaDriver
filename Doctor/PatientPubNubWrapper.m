//
//  PatientPubNubWrapper.m
//  privMD
//
//  Created by Vinay Raja on 08/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "PatientPubNubWrapper.h"
#import "PubNub.h"
#import "PNConfiguration.h"
#import "PNMessage.h"
#import "PNChannel.h"
#import <PubNub/PNMacro.h>

static PatientPubNubWrapper *shared = nil;

@implementation PatientPubNubWrapper

@synthesize delegate;

+(instancetype)sharedInstance
{
    if (!shared) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shared = [[self alloc] init];
        });
    }
    
    return shared;
}

-(instancetype)init
{
    if (self = [super init]) {
        [PubNub setDelegate:self];
        [self setConfiguration:nil];
        [self connect];

    }
    
    return self;
}

+(PNConfiguration*)getDefaultConfiguration
{
   // return [PNConfiguration configurationForOrigin:@"pubsub.pubnub.com" publishKey:kPMDPubNubPublisherKey
                                      //subscribeKey:kPMDPubNubSubcriptionKey secretKey:@""];
    return [PNConfiguration configurationWithPublishKey:kPMDPubNubPublisherKey subscribeKey:kPMDPubNubSubcriptionKey secretKey:@""];
}

+(PNConfiguration*)createConfigurationForOrigin:(NSString*)origin
                                     publishKey:(NSString*)pubKey
                                   subscribeKey:(NSString*)subKey
                                      secretKey:(NSString*)secKey
{
    return [PNConfiguration configurationForOrigin:origin publishKey:pubKey
                                      subscribeKey:subKey secretKey:secKey];

}

-(void)setConfiguration:(PNConfiguration*)configuration
{
    PNConfiguration *config = configuration;
    
    if (!configuration) {
        config = [PatientPubNubWrapper getDefaultConfiguration];
    }
    
    [PubNub setConfiguration:config];
}

-(void)connect
{
    [PubNub connect];
}

-(void)subscribeOnChannels:(NSArray*)pnChannelNames
{
    NSArray *channels = [PNChannel channelsWithNames:pnChannelNames];
    [PubNub subscribeOnChannels:channels];
}

-(void)subscribeOnChannel:(NSString*)channelName
{
    [PubNub subscribeOnChannel:[self getChannelForName:channelName]];
}
-(void)unSubscribeOnChannel:(NSString*)pnChannel{
    
    [PubNub unsubscribeFromChannel:[self getChannelForName:pnChannel]];
}
-(PNChannel*)getChannelForName:(NSString*)channelName
{
    return [PNChannel channelWithName:channelName];
}

-(void)sendMessageAsDictionary:(NSDictionary*)messageDictionary toChannel:(NSString*)channelName
{
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    //NSString *messageString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //[self sendMessage:@"hello" toChannel:channelName];
    
    [PubNub sendMessage:messageDictionary toChannel:[self getChannelForName:channelName]];
}

-(void)sendMessage:(NSString*)message toChannel:(NSString*)channelName
{
    [PubNub sendMessage:message toChannel:[self getChannelForName:channelName]];
}

#pragma mark - PubNub Delegate

- (void)pubnubClient:(PubNub *)client didReceiveMessage:(PNMessage *)message {
    
   // NSLog( @"%@", [NSString stringWithFormat:@"received: %@", message.message] );
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(recievedMessage:onChannel:)]) {
        [self.delegate recievedMessage:message.message onChannel:message.channel.name];
    }
    
}

- (void)pubnubClient:(PubNub *)client didFailMessageSend:(PNMessage *)message withError:(PNError *)error
{
    NSLog( @"%@", [NSString stringWithFormat:@"failed: %@ error: %@", message.message ,[error localizedDescription]] );
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFailedToConnectPubNub:)]) {
        [self.delegate didFailedToConnectPubNub:error];
    }
}

- (void)pubnubClient:(PubNub *)client didSendMessage:(PNMessage *)message
{
    //SLog( @"%@", [NSString stringWithFormat:@"send: %@", message.message] );
}

- (void)pubnubClient:(PubNub *)client error:(PNError *)error {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client report that error occurred: %@", error);
}

- (void)pubnubClient:(PubNub *)client willConnectToOrigin:(NSString *)origin {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client is about to connect to PubNub origin at: %@", origin);
}

- (void)pubnubClient:(PubNub *)client didConnectToOrigin:(NSString *)origin {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client successfully connected to PubNub origin at: %@", origin);
}

- (void)pubnubClient:(PubNub *)client connectionDidFailWithError:(PNError *)error {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client was unable to connect because of error: %@", error);
}

- (void)pubnubClient:(PubNub *)client willDisconnectWithError:(PNError *)error {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub clinet will close connection because of error: %@", error);
}

- (void)pubnubClient:(PubNub *)client didDisconnectWithError:(PNError *)error {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client closed connection because of error: %@", error);
}

- (void)pubnubClient:(PubNub *)client didDisconnectFromOrigin:(NSString *)origin {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client disconnected from PubNub origin at: %@", origin);
}

- (void)pubnubClient:(PubNub *)client didSubscribeOnChannels:(NSArray *)channels {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client successfully subscribed on channels: %@", channels);
}

- (void)pubnubClient:(PubNub *)client subscriptionDidFailWithError:(NSError *)error {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client failed to subscribe because of error: %@", error);
}

- (void)pubnubClient:(PubNub *)client didUnsubscribeOnChannels:(NSArray *)channels {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client successfully unsubscribed from channels: %@", channels);
}

- (void)pubnubClient:(PubNub *)client unsubscriptionDidFailWithError:(PNError *)error {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client failed to unsubscribe because of error: %@", error);
}

- (void)pubnubClient:(PubNub *)client didReceiveTimeToken:(NSNumber *)timeToken {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client recieved time token: %@", timeToken);
}

- (void)pubnubClient:(PubNub *)client timeTokenReceiveDidFailWithError:(PNError *)error {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client failed to receive time token because of error: %@", error);
}

- (void)pubnubClient:(PubNub *)client willSendMessage:(PNMessage *)message {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client is about to send message: %@", message);
}


- (void)pubnubClient:(PubNub *)client didReceivePresenceEvent:(PNPresenceEvent *)event {
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client received presence event: %@", event);
}



@end
