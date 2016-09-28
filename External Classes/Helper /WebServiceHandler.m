//
//  WebServiceHandler.m
//  Loupon
//
//  Created by rahul Sharma on 10/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "WebServiceHandler.h"
#import "JSONParser.h"

@implementation WebServiceHandler
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
	[responseData appendData:data];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSArray *resArr;
    //id result;
    timeOut = nil;
	JSONParser *parser = [[JSONParser alloc] init];
	
    //###################################################################
    
    
    if ((self.requestType == eLogin) ||(self.requestType == eSignUp) || (self.requestType == eUploadImage||self.requestType==eParsekey))
	{
		resArr = [parser dictionaryWithContentsOfJSONURLString:responseData];
		
	}
    else if(self.requestType == eLatLongparser)
    {
        resArr = [parser parseGoogleReverseGoecodingForDataForDirection1:responseData];

    }else{
        resArr = [parser dictionaryWithContentsOfJSONURLString:responseData];
    }
    
    //###################################################################    
	if ([resArr count] == 0)
    {
		[target performSelectorOnMainThread:selector withObject:nil waitUntilDone:YES];
	}
	else {
        NSDictionary *loc =[[NSDictionary alloc]init];
        
        loc= [resArr objectAtIndex:0];
		[target performSelectorOnMainThread:selector withObject:[NSDictionary dictionaryWithObject:loc forKey:@"ItemsList"] waitUntilDone:YES];
	}
    
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    timeOut = nil;
	
	[target performSelectorOnMainThread:selector withObject:[NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"Error"] waitUntilDone:NO];
}

#pragma mark -
#pragma mark Other Methods
- (void)placeWebserviceRequestWithString:(NSMutableURLRequest *)string Target:(id)_target Selector:(SEL)_selector {
    
   // NSLog(@"url %@",string);
    
	
    urlConnection = [[NSURLConnection alloc] initWithRequest:string delegate:self];
	timeOut = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(cancelDownload) userInfo:nil repeats:NO];
	responseData = [[NSMutableData alloc] init];
	target = _target;
	selector = _selector;
}




- (void) cancelDownload
{
	if (timeOut == nil) {
		return;
	}
	else {
		[urlConnection cancel];
		[target performSelectorOnMainThread:selector withObject:[NSDictionary dictionaryWithObject:@"Connection Timed-out" forKey:@"Error"] waitUntilDone:NO];
		timeOut = nil;
	}
	
}
@end
