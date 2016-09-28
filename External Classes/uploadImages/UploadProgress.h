//
//  UploadProgress.h
//  InsightApp
//
//  Created by Surender Rathore on 14/01/14.
//
//

#import <UIKit/UIKit.h>
enum ShowViewFrom {
	Top,
    Bottom
};
@interface UploadProgress : UIView
@property(nonatomic,strong)UILabel *lblMessage;
@property(nonatomic,strong)UIProgressView *progressBar;
@property(nonatomic,assign)int showViewFrom;
-(void)setMessage:(NSString*)message;
-(void)hide;
+ (id)sharedInstance;
-(void)updateProgress:(float)progress;

@end
