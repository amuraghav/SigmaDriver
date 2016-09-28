//
//  UploadFile.h
//  CSA
//
//  Created by 3Embed on 07/09/12.
//
//

#import <Foundation/Foundation.h>
@protocol UploadFileDelegate;
@interface UploadFiles : NSObject
{
}
@property(nonatomic,weak)id <UploadFileDelegate> delegate;
-(void)calcImagelength:(UIImage*)image;
-(void)uploadImageFile:(UIImage*)image;
-(void)uploadMultipleImages:(NSArray*)images;
-(void)uploadData:(NSData*)data;

@end

@protocol UploadFileDelegate <NSObject>
-(void)uploadFile:(UploadFiles*)uploadfile didUploadSuccessfullyWithUrl:(NSArray*)imageUrls;
-(void)uploadFile:(UploadFiles*)uploadfile didFailedWithError:(NSError*)error;
@end