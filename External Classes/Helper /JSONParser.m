//
//  JSONParser.m
//  TopBuy
//
//  Created by Rahul Sharma on 10/04/13.
//  Copyright (c) 2013 Rahul Sharma. All rights reserved.
//


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) 


#import "JSONParser.h"


//#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
@implementation JSONParser


- (NSArray *)dictionaryWithContentsOfJSONURLString:(NSData*)data{
  
    NSArray *result;
    
    
    NSString *strResponse = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding: NSASCIIStringEncoding];
    NSLog(@"JSON Response %@ ",strResponse);
    
    NSDictionary *dict =
    [NSJSONSerialization JSONObjectWithData: [strResponse dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: nil];
    
    result = [[NSArray alloc] initWithObjects:dict, nil];
    
    return result;
 
}
/*
 To get google Direction Response
 */

- (NSArray *)parseGoogleReverseGoecodingForDataForDirection1:(NSData *)data
{
	/*NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSError *error;
	SBJsonParser *json = [SBJsonParser new];
	NSDictionary *googleDirectionsResponse = (NSDictionary *)[json objectWithString:responseString error:&error];
	
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	if ([[googleDirectionsResponse objectForKey:@"status"] isEqualToString:@"OK"]) {
		
		NSArray *results = (NSArray *)[googleDirectionsResponse objectForKey:@"results"];
		for (NSDictionary *addressComponents in results) {
			NSString *formattedAddress = [addressComponents objectForKey:@"formatted_address"];
			if (formattedAddress) {
				[array addObject:formattedAddress];
			}
		}
	}
	//NSLog(@"Array:%@",array);
	return array;*/
    //**********************************************************************
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSError *error;
	SBJsonParser *json = [SBJsonParser new] ;
	NSDictionary *googleDirectionsResponse = (NSDictionary *)[json objectWithString:responseString error:&error];
	//[responseString release];
	
	NSMutableArray *array = [[NSMutableArray alloc] init] ;
	if ([[googleDirectionsResponse objectForKey:@"status"] isEqualToString:@"OK"]) {
			
		NSArray *results = (NSArray *)[googleDirectionsResponse objectForKey:@"results"];
		//NSLog(@"results :%@",results);
		for (NSDictionary *addressComponents in results) {
			NSString *formattedAddress = [addressComponents objectForKey:@"formatted_address"];
			if (formattedAddress) {
				//[array addObject:formattedAddress];
			}
			
			NSDictionary *dictAddressComponents = [addressComponents objectForKey:@"address_components"];
			//NSLog(@"dictAddressComponents :%@",dictAddressComponents);
			NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
			for (NSDictionary *dictComponent in dictAddressComponents) {
				NSArray *listType = [dictComponent objectForKey:@"types"];
				if ([[listType objectAtIndex:0] isEqualToString:@"administrative_area_level_1"]
					|| [[listType objectAtIndex:0] isEqualToString:@"administrative_area_level_2"]
					|| [[listType objectAtIndex:0] isEqualToString:@"locality"]
					|| [[listType objectAtIndex:0] isEqualToString:@"country"]) {
					[dictionary setObject:[dictComponent objectForKey:@"long_name"] forKey:[listType objectAtIndex:0]];
				}
			}
			[array addObject:dictionary];
			//[dictionary release];
			break;
		}
	}
	return array;
    
    
    
    
}

//- (NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSData*)data
//{
//    
//    NSDictionary *result;
//    
//    NSError* error = nil;
//    
//    result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    
//    return result;
//}

@end
