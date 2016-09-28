//
//  WindowOverlayButton.h
//  MyAlbum
//
//  Created by Surender Rathore on 28/02/14.
//
//

#import <UIKit/UIKit.h>
typedef void (^ButtonActionCallback)();
@interface DoctorDetailView : UIView
@property(nonatomic,copy)ButtonActionCallback callback;
-(id)initWithButtonTitle:(NSString*)title;
-(void)updateDistance:(NSString*)distane estimateTime:(NSString*)eta;
-(void)updateStatus:(NSString*)status;
+ (id)sharedInstance ;
-(void)hide;
-(void)show;
@end
