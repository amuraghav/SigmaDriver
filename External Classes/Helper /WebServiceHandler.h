//
//  WebServiceHandler.h
//  Loupon
//
//  Created by rahul Sharma on 10/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import <Foundation/Foundation.h>

enum RequestType
{
    eLogin=1,
    eSignUp,
    eParsekey,
    eUploadImage,
    eLatLongparser
};

@interface WebServiceHandler : NSObject {
	NSMutableData *responseData;
    
	NSURLConnection *urlConnection;
	id target;
	SEL selector;
	NSTimer *timeOut;
    
}

- (void)placeWebserviceRequestWithString:(NSMutableURLRequest *)string Target:(id)_target Selector:(SEL)_selector;

@property (nonatomic, assign)int requestType;


@end
