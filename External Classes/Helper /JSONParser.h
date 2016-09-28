//
//  JSONParser.h
//  TopBuy
//
//  Created by Rahul Sharma on 10/04/13.
//  Copyright (c) 2013 Rahul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
@interface JSONParser : NSObject

- (NSArray *)dictionaryWithContentsOfJSONURLString:(NSData*)data;
// to get location
-(NSArray *)parseGoogleReverseGoecodingForDataForDirection1:(NSData *)data;

@end
