//
//  UploadFile.m
//  CSA
//
//  Created by 3Embed on 07/09/12.
//
//

#import "UploadFiles.h"

//#import <AFNetworking/AFHTTPRequestOperationManager.h>
//#import <AFHTTPRequestOperationManager.h>
#import "UploadProgress.h"
#import "Service.h"
#import "WebServiceHandler.h"
#import "Errorhandler.h"
#import <RestKit/RestKit.h>
#import "Upload.h"

@interface UploadFiles() {
    NSUInteger chunkSize;
	NSUInteger offset;
	NSUInteger thisChunkSize;
	NSUInteger length;
	NSData* myBlob;
    NSString *imageName;
    
}
@property(nonatomic,strong)NSMutableArray *imagesToUpload;
@property(nonatomic,strong)NSMutableArray *imagesUploadedUrls;
@property(nonatomic,assign)BOOL isUploadingMultipleImages;
@end

@implementation UploadFiles
@synthesize imagesToUpload;
@synthesize imagesUploadedUrls;
@synthesize delegate;
@synthesize isUploadingMultipleImages;


//#define uploadServerMethod @"http://108.166.190.172:81/doctor_app/process.php/uploadImage"

//#define uploadServerMethod  BASE_IP @"process.php/uploadImage"

-(void)uploadMultipleImages:(NSArray*)images
{
    isUploadingMultipleImages = YES;
    imagesToUpload = [[NSMutableArray alloc] initWithArray:images];
    [self selectImageForUpload];
}
-(void)uploadImageFile:(UIImage*)image{
    
    [self calcImagelength:image];
}
-(void)selectImageForUpload
{
    
    if (imagesToUpload.count > 0) {
        [self uploadImageFile:imagesToUpload[0]];
    }
    
}
-(void)uploadData:(NSData*)data {
    
    myBlob =  data;
	length = [myBlob length];
	chunkSize = 1024 * 1024;
	offset = 0;
    imageName = [NSString stringWithFormat:@"%@.xml",[self getCurrentTime]];
    
    //start uploading image
    [self uploadImage];
}
-(NSString*)getCurrentTime
{
    NSDate *currentDateTime = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"EEEMMddyyyyHHmmss"];
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
    return dateInStringFormated;
    
}
-(void)calcImagelength:(UIImage*)image
{
	
    myBlob =  UIImageJPEGRepresentation(image, 1);
	length = [myBlob length];
	chunkSize = 1024 * 1024;
	offset = 0;
    imageName = [NSString stringWithFormat:@"%@%@.jpeg",@"image",[self getCurrentTime]];
    
    //start uploading image
    [self uploadImage];
	
}
-(void)uploadImage
{
    //	do {
	//NSLog(@"uploadImage");
    //    UploadProgress *up = [UploadProgress sharedInstance];
    //    [up updateProgress:(float)offset/length];
    
    NSLog(@"%f",(float)offset/length);
    
    thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
    NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[myBlob bytes] + offset
                                         length:thisChunkSize
                                   freeWhenDone:NO];
    
    
	NSString *binaryString = [chunk base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    
    [self sendRequestToUploadImageWithChunk:binaryString];
    
}

-(void)sendRequestToUploadImageWithChunk:(NSString*)binaryString {
    

 
 
    static int valueNumberofChunks = 1;
    NSMutableDictionary *requestForUploadSnap= [[NSMutableDictionary alloc] init];
    [requestForUploadSnap setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kSMPcheckUserSessionToken] forKey:KDAcheckUserSessionToken];
    NSString *deviceId;
   // if (IS_SIMULATOR) {
   //     deviceId = kPMDTestDeviceidKey;
   // }
   // else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
   // }
    [requestForUploadSnap setObject:deviceId forKey:kSMPUploadDeviceId];
    [requestForUploadSnap setObject:imageName forKey:kSMPUploadImageName];
    [requestForUploadSnap setObject:binaryString forKey:kSMPUploadImageChunck];
    [requestForUploadSnap setObject:[NSNumber numberWithInt:1] forKey:kSMPUploadfrom];
    
    [requestForUploadSnap setObject:[NSNumber numberWithInt:1] forKey:kSMPUploadtype];
     NSString *inStr = [NSString stringWithFormat: @"%d",valueNumberofChunks];
    
    [requestForUploadSnap setObject:inStr forKey:kSMPUploadOffset];
    [requestForUploadSnap setObject:[Helper getCurrentDateTime] forKey:kSMPUploadDateTime];
    
    
    
   
    
   
    
    
     ResKitWebService * restKit = [ResKitWebService sharedInstance];
    [restKit composeRequestForUpload:MethodUploadImage
                                       paramas:requestForUploadSnap
                                  onComplition:^(BOOL success, NSDictionary *response){
                                      
                                      if (success)
                                      { //handle success response
                                          
                                        Errorhandler * handler = [(NSArray*)response objectAtIndex:0];

                                          
                                          if ([[handler errFlag] intValue] ==0) {
                                              Upload  * upload = handler.objects;
                                              
                                              
                                              
                                              offset += thisChunkSize;
                                              if(offset < length) {
                                                  valueNumberofChunks++;
                                                  [self uploadImage];
                                              }
                                              else
                                              {
                                                  
                                                  //                UploadProgress *up = [UploadProgress sharedInstance];
                                                  //                [up hide];
                                                  
                                                  if (!imagesUploadedUrls) {
                                                      imagesUploadedUrls = [[NSMutableArray alloc] init];
                                                  }
                                                  
                                                  // collect the uploaded image urls
                                                  if ([imagesUploadedUrls indexOfObject:upload.picURL] == NSNotFound) {
                                                      [imagesUploadedUrls addObject:upload.picURL];
                                                  }
                                                  
                                                  //check if user is uploading multiple images
                                                  if (isUploadingMultipleImages) {
                                                      
                                                      [imagesToUpload removeObjectAtIndex:0];
                                                      if (imagesToUpload.count > 0) {
                                                          
                                                          [self selectImageForUpload];
                                                          myBlob = nil;
                                                      }
                                                      else {
                                                          [self notifyForSuccessfullUpload];
                                                      }
                                                  }
                                                  else {
                                                      [self notifyForSuccessfullUpload];
                                                  }
                                              }
                                          }

                                          
                                      
                                      }
                                      else{//error
                                          if (delegate && [delegate respondsToSelector:@selector(uploadFile:didFailedWithError:)]) {
                                                         [delegate uploadFile:self didFailedWithError:nil];
                                                     }
                                      }
                                  }];

    
//    [manager POST:baseUrlForUploadImage parameters:requestForUploadSnap success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"JSON: %@", responseObject);
//        if ([responseObject[@"errFlag"] integerValue] == 0)
//        {
//            offset += thisChunkSize;
//            if(offset < length) {
//                valueNumberofChunks++;
//                [self uploadImage];
//            }
//            else
//            {
//                
//                //                UploadProgress *up = [UploadProgress sharedInstance];
//                //                [up hide];
//                
//                if (!imagesUploadedUrls) {
//                    imagesUploadedUrls = [[NSMutableArray alloc] init];
//                }
//                
//                // collect the uploaded image urls
//                if ([imagesUploadedUrls indexOfObject:responseObject[@"picURL"]] == NSNotFound) {
//                    [imagesUploadedUrls addObject:responseObject[@"picURL"]];
//                }
//                
//                //check if user is uploading multiple images
//                if (isUploadingMultipleImages) {
//                    
//                    [imagesToUpload removeObjectAtIndex:0];
//                    if (imagesToUpload.count > 0) {
//                        
//                        [self selectImageForUpload];
//                        myBlob = nil;
//                    }
//                    else {
//                        [self notifyForSuccessfullUpload];
//                    }
//                }
//                else {
//                    [self notifyForSuccessfullUpload];
//                }
//            }
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        if (delegate && [delegate respondsToSelector:@selector(uploadFile:didFailedWithError:)]) {
//            [delegate uploadFile:self didFailedWithError:error];
//        }
//    }];
 
    
}

-(void)notifyForSuccessfullUpload {
    if (delegate && [delegate respondsToSelector:@selector(uploadFile:didUploadSuccessfullyWithUrl:)]) {
        [delegate uploadFile:self didUploadSuccessfullyWithUrl:imagesUploadedUrls];
    }
}

@end


